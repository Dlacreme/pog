defmodule PogWeb.ChatLive do
  use PogWeb, :live_view

  alias Pog.Accounts.User

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      input: "",
      messages: [],
      peer: nil)}
  end

  @impl true
  def handle_event("chat_with", user_id, socket) do
    {:noreply, assign(socket,
      input: "",
      messages: get_messages(),
      peer: get_peer(user_id),
    )}
  end

  @impl true
  def handle_event("submit", %{"m" => message}, socket) do
    IO.puts("SOCKET > #{inspect socket.assigns.messages}")
    {:noreply, assign(socket, input: "", messages: socket.assigns.messages ++ [%{
      user_id: "aa",
      content: message,
    }])}
  end

  defp get_messages() do
    [
      %{user_id: "aa", content: "Message 1"},
      %{user_id: "aaaa", content: "Message 2221e1"},
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
