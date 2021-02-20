defmodule PogWeb.ChatMessageComponent do
  use PogWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= user(assigns, get_peer(assigns)) %>
      <%= message(assigns) %>
    </div>
    """
  end

  defp user(assigns, peer) do
    ~L"""
    <span><%= peer.name %></span>
    """
  end

  defp message(assigns) do
  ~L"""
    <p><%= assigns.message.content%></p>
  """
  end

  defp get_peer(assigns) do
    Enum.find(assigns.peers, fn p -> p.meta.peer.id == assigns.message.peer_id end)
  end
end
