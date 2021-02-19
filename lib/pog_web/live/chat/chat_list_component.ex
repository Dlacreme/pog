defmodule PogWeb.ChatListComponent do
  use PogWeb, :live_component
  import Ecto.Query, only: [from: 2]
  alias Pog.Accounts.User

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= render_direct_messages(assigns) %>
    </div>
    """
  end

  def render_direct_messages(assigns) do
    users = from(u in User, where: u.role_id != ^"guest", order_by: u.email)
      |> Pog.Repo.all()
      |> Enum.filter(fn u -> u.id != assigns.current_user_id end)
    ~L"""
    <h4>Direct messages</h4>
    <ul>
      <%= for u <- users do %>
        <li phx-click="chat_with" phx-value-id="<%= u.id %>"> <%= u.email %></li>
      <% end %>
    </ul>
    """
  end
end
