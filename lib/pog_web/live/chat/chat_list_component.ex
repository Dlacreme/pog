defmodule PogWeb.ChatListComponent do
  use PogWeb, :live_component
  import Ecto.Query, only: [from: 2]
  alias Pog.Accounts.User
  alias Pog.Chat.Conversation
  alias Pog.Chat.Peer

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= render_direct_messages(assigns) %>
    </div>
    """
  end

  defp render_direct_messages(assigns) do
    convs = Pog.Chat.list_conversations(assigns.current_user_id)
    ~L"""
    <ul>
      <%= for c <- convs do %>
        <%= chat_line(assigns, c) %>
      <% end %>
    </ul>
    """
  end

  defp chat_line(assigns, conv) do
    ~L"""
    <li phx-click="open_chat" phx-value-id="<%= conv.id %>" class="flex items-center">
      <%= render_notification(assigns, Enum.find(assigns.notifications, fn nw -> nw.conversation_id == conv.id end)) %>
      <%= if conv.name != nil do %>
        <span><%= conv.name %></span>
      <% else %>
        <%= load_name(assigns, conv) %>
      <% end %>
    </li>
    """
  end

  defp load_name(assigns, conv) do
    {:ok, peers} = Pog.Chat.get_peers_profile(conv.id)
    fps = Enum.filter(peers, fn p -> p.user_id != assigns.current_user_id end)
    ~L"""
    <div class="flex items-center">
      <%= if length(fps) == 1 do %>
        <%= for p <- fps do %>
          <img height="40px" width="40px" src="<%= p.picture_url %>" alt="<%= p.name %> pic" />
          <span><%= p.name %></span>
        <% end %>
      <% else %>
        <div class="flex items-center">
          <%= for p <- fps do %>
            <img height="40px" width="40px" src="<%= p.picture_url %>" alt="<%= p.name %> pic" />
          <% end %>
        </div>
        <div class="flex items-center">
          <%= for p <- fps do %>
            <span><%= p.name %></span>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp render_notification(assigns, notif_wrapper) do
    ~L"""
    <%= if notif_wrapper != nil && notif_wrapper.nb_notif > 0 do  %>
      <span class="notif"><%= notif_wrapper.nb_notif %></span>
    <% end %>
    """
  end

end
