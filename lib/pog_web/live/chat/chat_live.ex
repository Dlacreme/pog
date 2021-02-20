defmodule PogWeb.ChatLive do
  use PogWeb, :live_view
  import Ecto.Query, only: [from: 2]

  alias Pog.Chat

  @impl true
  def mount(_params, session, socket) do
    u = Pog.Accounts.get_user_by_session_token(session["user_token"])
    listen_incoming_message(u.id)
    {:ok,
     assign(socket,
       input: "",
       conv: nil,
       messages: [],
       peers: nil,
       current_user: u,
       notifications: get_notifications(u.id)
     )}
  end

  @impl true
  def handle_event("chat_with", %{"id" => user_id}, socket) do
    {:ok, conv} = Chat.get_conversation([user_id, socket.assigns.current_user.id])
    {:ok, peers} = Chat.get_peers_profile(conv.id)
    clear_notification(Enum.find(peers, fn p -> p.user_id == socket.assigns.current_user.id end).meta.peer)
    {:noreply,
     assign(socket,
       input: "",
       conv: conv,
       messages: get_messages(peers),
       peers: peers
     )}
  end

  @impl true
  def handle_event("submit", %{"m" => message}, socket) do
    {:ok, _m} = Chat.send_message(socket.assigns.current_user.id, socket.assigns.conv.id, message)
    {:noreply,
     assign(socket,
       input: "",
       messages: get_messages(socket.assigns.peers)
     )}
  end

  @impl true
  def handle_info({:new_message, %Chat.Message{} = message}, socket) do
    case is_in_peers(socket.assigns.peers, message.peer_id) do
      true -> {:noreply, assign(socket, messages: get_messages(socket.assigns.peers))}
      false -> {:noreply, assign(socket, notifications: get_notifications(socket.assigns.current_user.id))}
    end
  end

  defp get_messages(peers) do
    peer_ids = Enum.map(peers, fn p -> p.meta.peer.id end)
    Pog.Repo.all(from m in Pog.Chat.Message,
      where: m.peer_id in ^peer_ids,
      order_by: [:inserted_at])
  end

  defp listen_incoming_message(user_id) do
    Phoenix.PubSub.subscribe(Pog.PubSub, user_id)
  end

  defp get_notifications(user_id) do
    Pog.Repo.all(from p in Pog.Chat.Peer,
      where: p.user_id == ^user_id and p.nb_notif > 0,
      select: %{conversation_id: p.conversation_id, nb_notif: p.nb_notif})
  end

  defp clear_notification(peer) do
    Pog.Chat.Peer.changeset(peer, %{nb_notif: 0})
      |> Pog.Repo.update()
  end

  defp is_in_peers(peers, peer_id) when peers == nil do
    false
  end

  defp is_in_peers(peers, peer_id) do
    Enum.find(peers, fn p -> p.meta.peer.id == peer_id end) != nil
  end

end
