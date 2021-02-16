defmodule PogWeb.ChatListComponent do
  use PogWeb, :live_component

  @impl true
  def render(assigns) do
    IO.puts("ASSIGNS > #{inspect assigns}")
    ~L"""
    <div class="chat-list-component opened">
      <h4>Chat</h4>
      <ul>
        <li>1</li>
      </ul>
    </div>
    """
  end
end
