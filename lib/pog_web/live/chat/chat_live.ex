defmodule PogWeb.ChatLive do
  use PogWeb, :live_view
  import Ecto.Query, only: [from: 2]

  alias Pog.Chat

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       input: "",
       conv: nil,
       messages: [],
       peers: nil,
       current_user: Pog.Accounts.get_user_by_session_token(session["user_token"])
     )}
  end

  @impl true
  def handle_event("chat_with", %{"id" => user_id}, socket) do
    {:ok, conv} = Chat.get_conversation([user_id, socket.assigns.current_user.id])
    {:ok, peers} = Chat.get_peers_profile(conv.id)
    {:noreply,
     assign(socket,
       input: "",
       conv: conv,
       messages: get_messages(peers),
       peers: peers
      #  peers: Enum.filter(peers, fn p -> p.user_id != socket.assigns.current_user.id end)
     )}
  end

  @impl true
  def handle_event("submit", %{"m" => message}, socket) do
    {:ok, m} = Chat.send_message(socket.assigns.current_user.id, socket.assigns.conv.id, message)
    {:noreply,
     assign(socket,
       input: "",
       messages: get_messages(socket.assigns.peers)
     )}
  end

  defp get_messages(peers) do
    peer_ids = Enum.map(peers, fn p -> p.meta.peer_id end)
    Pog.Repo.all(from m in Pog.Chat.Message,
      where: m.peer_id in ^peer_ids,
      order_by: [:inserted_at])
  end

end
