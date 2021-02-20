defmodule PogWeb.ChatListComponent do
  use PogWeb, :live_component
  import Ecto.Query, only: [from: 2]
  alias Pog.Accounts.User
  alias Pog.Chat.Conversation
  alias Pog.Chat.Peer

  @impl true
  def render(assigns) do
    IO.puts("NOTIFICATIONS >> #{inspect assigns.notifications}")
    ~L"""
    <div>
      <%= render_direct_messages(assigns) %>
    </div>
    """
  end

  defp render_direct_messages(assigns) do
    users = from(u in User, where: u.role_id != ^"guest", order_by: u.email)
      |> Pog.Repo.all()
      |> Enum.filter(fn u -> u.id != assigns.current_user_id end)
    # convs_ids = Pog.Repo.all(from(p in Peer, where: p.user_id == ^assigns.current_user_id,
      # select: %{conversation: }))
    # convs = Pog.Repo.all(
    #   from(c in Conversation,
    #     join: p in assoc(c, :peers),
    #     where: p.user_id == ^assigns.current_user_id,
    #     select: %{conversation: c, peer: p}
    #   ))
    convs = Pog.Chat.list_conversations(assigns.current_user_id)
    IO.puts("ALL CONVERSATION >> #{inspect convs}")
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
