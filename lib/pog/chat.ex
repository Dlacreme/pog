defmodule Pog.Chat do
  import Ecto.Query, only: [from: 2]

  alias Pog.Chat.Conversation
  alias Pog.Chat.Peer

  @doc """
  Get the peers provide of @conversation_id
  """
  def get_peers_profile(conversation_id) do
    {:ok, Enum.map(get_peers(conversation_id), fn p -> Pog.Accounts.get_profile(p.user_id) end)}
  end

  @doc """
  Get the peers of @conversation
  """
  def get_peers(conversation_id) do
    Pog.Repo.all(from p in Peer, where: p.conversation_id == ^conversation_id)
  end

  @doc """
  Get the existing conversation with the giver user ids
  or create a new one
  """
  def get_conversation(user_ids) do
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
