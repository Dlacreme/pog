defmodule Pog.Chat do
  import Ecto.Query, only: [from: 2]

  alias Pog.Chat.Conversation
  alias Pog.Chat.Peer
  alias Pog.Chat.Message

  @doc """
  """
  def list_conversations(user_id) do
    source = Pog.Repo.all(
      from(c in Conversation,
        join: p in assoc(c, :peers),
        join: u in assoc(p, :user),
        where: p.user_id == ^user_id,
        select: %{conversation: c, peer: %{meta: p, user: u}}
      ))
    build_conversations([], source)
  end

  def build_conversations(dest, source) when length(source) == 0 do
    dest
  end

  def build_conversations(dest, source) do
    s = List.first(source)
    case Enum.find_index(dest, fn d -> d.id == s.conversation.id end) do
      nil -> build_conversations([%{
        id: s.conversation.id,
        name: s.conversation.name,
        peers: [],
      } | dest], source)
      row_index ->
        build_conversations(List.update_at(dest, row_index, fn r -> Map.put(r, :peers, [s.peer | r.peers]) end), List.delete_at(source, 0))
    end
  end

  @doc """
  Add a message to a @conversation_id
  """
  def send_message(peer = %Peer{}, content) do
    {:ok, m} = %Message{}
      |> Message.changeset(%{peer_id: peer.id, content: content})
      |> Pog.Repo.insert()
    notify_other_peers(Pog.Repo.all(from p in Peer,
      where: p.conversation_id == ^peer.conversation_id and p.id != ^peer.id), m)
    {:ok, m}
  end

  def send_message(user_id, conversation_id, content) do
    send_message Pog.Repo.get_by!(Peer, user_id: user_id, conversation_id: conversation_id), content
  end

  @doc """
  Get the peers provide of @conversation_id
  """
  def get_peers_profile(conversation_id) do
    {:ok, Enum.map(get_peers(conversation_id), fn p -> Pog.Accounts.get_profile(p.user_id, %{peer: p}) end)}
  end

  @doc """
  Get the peers of @conversation
  """
  def get_peers(conversation_id) do
    Pog.Repo.all(from p in Peer, where: p.conversation_id == ^conversation_id)
  end

  def get_conversation(id) do
    {:ok, Pog.Repo.get!(Conversation, id)}
  end

  @doc """
  Get the existing conversation with the giver user ids
  or create a new one
  """
  def get_conversation_with_user(user_ids) do
    convs = Ecto.Adapters.SQL.query!(Pog.Repo,
      "SELECT p.conversation_id FROM chat_peers p WHERE user_id IN (#{
        Enum.map(user_ids, fn uid -> "'#{uid}'" end) |> Enum.join(",")}) GROUP BY conversation_id HAVING COUNT(p.id) = #{
          length(user_ids)}")
    case convs.num_rows do
      0 -> create_conversation(user_ids)
      1 -> {:ok, Pog.Repo.get!(Conversation, Ecto.UUID.cast! List.first(List.first(convs.rows)))}
      _too_many -> merge_and_get(convs.rows)
    end
  end

  defp notify_other_peers(peers, message) do
    Enum.each(peers, fn p -> notify_peer(p, message) end)
    :ok
  end

  defp notify_peer(peer, message) do
    Peer.changeset(peer, %{nb_notif: peer.nb_notif + 1})
      |> Pog.Repo.update()
    Phoenix.PubSub.broadcast(Pog.PubSub, peer.user_id, {:new_message, message})
    :ok
  end

  defp create_conversation(user_ids) do
    {:ok, conv} = %Conversation{}
      |> Conversation.changeset(%{})
      |> Pog.Repo.insert()
    Enum.each(user_ids, fn uid -> add_peer(conv.id, uid) end)
    {:ok, conv}
  end

  defp add_peer(conversation_id, user_id) do
    %Peer{}
      |> Peer.changeset(%{user_id: user_id, conversation_id: conversation_id})
      |> Pog.Repo.insert()
  end

  defp merge_and_get(convs) do
    {:ok, Pog.Repo.get!(Conversation, Ecto.UUID.cast! List.first(List.first(convs)))}
  end

end
