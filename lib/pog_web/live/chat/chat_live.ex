defmodule PogWeb.ChatLive do
  use PogWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       input: "",
       conv: nil,
       messages: [],
       peer: nil,
       current_user: Pog.Accounts.get_user_by_session_token(session["user_token"])
     )}
  end

  @impl true
  def handle_event("chat_with", %{"id" => user_id}, socket) do
    {:ok, conv} = Pog.Chat.get_conversation([user_id, socket.assigns.current_user.id])
    {:ok, peers} = Pog.Chat.get_peers_profile(conv.id)
    {:noreply,
     assign(socket,
       input: "",
       conv: conv,
       messages: get_messages(),
       peer: get_peer(user_id),
       peers: Enum.filter(peers, fn p -> p.user_id != socket.assigns.current_user.id end)
     )}
  end

  @impl true
  def handle_event("submit", %{"m" => message}, socket) do
    {:noreply,
     assign(socket,
       input: "",
       messages:
         socket.assigns.messages ++
           [
             %{
               user_id: "aa",
               content: message
             }
           ]
     )}
  end

  defp get_messages() do
    [
      %{user_id: "aa", content: "Message 1"},
      %{user_id: "aaaa", content: "Message 2221e1"}
    ]
  end

  defp get_peer(user_id) do
    %{
      user_id: user_id,
      name: "Hello world",
      title: "Software engineer"
    }
  end
end
