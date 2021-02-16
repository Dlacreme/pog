defmodule PogWeb.ChatLive do
  use PogWeb, :live_view

  alias Pog.Accounts.User

  defmodule Chat do
    defstruct peer: %{},
              messages: []
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, chat: nil)}
  end

  @impl true
  def handle_event("chat_with", user_id, socket) do
    {:noreply, assign(socket, chat: get_chat(user_id))}
  end

  defp get_chat(user_id) do
    %Chat{
      peer: %{
        user_id: user_id,
        name: "Hello world"
      },
      messages: [
        "Message one",
        "message 2"
      ]
    }
  end

end
