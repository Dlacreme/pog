defmodule PogWeb.ChatListComponent do
  use PogWeb, :live_component

  @impl true
  def render(assigns) do
    IO.puts("ASSIGNS > #{inspect assigns}")
    ~L"""
    <div id="chat-list-component" class="opened">
      <%= render_direct_messages(assigns) %>
    </div>
    """
  end

  def render_direct_messages(assigns) do
    ~L"""
    <h4>Direct messages</h4>
    <ul>
      <li>User 1</li>
      <li>User 2</li>
    </ul>
    """
  end
end
