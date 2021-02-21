defmodule PogWeb.NewChatInputComponent do
  use PogWeb, :live_component
  import Ecto.Query, only: [from: 2]

  @impl true
  def mount(socket) do
    {:ok, assign(socket, query: "", result: [], new_channel_peers: [], channel_name: nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="mb-20 new-chat-input">
        <%= render_new_channel_form(assigns) %>
        <h1>Start chatting with...</h1>
        <form phx-target="<%= @myself %>" phx-change="suggest" phx-submit="submit">
          <input name="q" value="<%= assigns.query %>" type="text" placeholder="Search for user..." autocomplete="off" />
          <div class="results">
            <%= for p <- assigns.result do %>
              <%= render_result_line(assigns, p) %>
            <% end %>
          </div>
        </form>
      </div>
    """
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) when query == "" do
    {:noreply, assign(socket, result: [])}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, result: search_employee(socket.assigns.current_user_id, query))}
  end

  @impl true
  def handle_event("submit", %{"q" => query}, socket) do
    {:noreply, assign(socket, query: "")}
  end

  @impl true
  def handle_event("add_channel", %{"id" => user_id}, socket) do
    case Enum.find(socket.assigns.result, fn r -> r.user_id == user_id end) do
      nil -> {:noreply, socket}
      peer -> {:noreply, assign(socket,
        result: List.delete(socket.assigns.result, peer),
        new_channel_peers: List.insert_at(socket.assigns.new_channel_peers, 0, peer))}
    end
  end

  @impl true
  def handle_event("remove_channel", %{"id" => user_id}, socket) do
    case Enum.find(socket.assigns.new_channel_peers, fn p -> p.user_id == user_id end) do
      nil -> {:noreply, socket}
      peer -> {:noreply, assign(socket,
        new_channel_peers: List.delete(socket.assigns.new_channel_peers, peer))}
    end
  end

  @impl true
  def handle_event("create_channel", %{"name" => name}, socket) do
    send(self(), {:create_channel, %{name: (if byte_size(name) == 0 do nil else name end), peers: socket.assigns.new_channel_peers}})
    {:noreply, socket}
  end

  @impl true
  def handle_event("update_channel", %{"name" => name}, socket) do
    {:noreply, assign(socket, channel_name: name)}
  end

  defp search_employee(current_user_id, query) do
    like_query = "%#{query}%"
    Pog.Repo.all(from u in Pog.Accounts.User,
      left_join: e in assoc(u, :employee),
      where: ilike(u.email, ^like_query),
      or_where: ilike(e.first_name, ^like_query),
      or_where: ilike(e.last_name, ^like_query),
      limit: 5,
      select: %{user: u, employee: e})
      |> Enum.filter(fn row -> row.user.id != current_user_id end)
      |> Enum.map(fn row -> Pog.Accounts.get_profile(row.user, row.employee, %{}) end)
  end

  defp render_result_line(assigns, p) do
    ~L"""
    <div class="flex items-center"><img src="<%= p.picture_url %>" alt="<%= p.name %> picture" />
      <span class="flex-grow"><%= p.name %></span>
      <div class="actions flex items-center">
        <button phx-target="<%= @myself %>" phx-click="add_channel" phx-value-id="<%= p.user_id %>" class="has-tooltip">
          <span class="tooltip">Add to new channel</span>
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
        </button>
        <button phx-click="chat_with" phx-value-id="<%= p.user_id %>" class="has-tooltip">
          <span class="tooltip">Direct chat</span>
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z" />
          </svg>
        </button>
      </div>
    </div>
    """
  end

  defp render_new_channel_form(assigns) when length(assigns.new_channel_peers) == 0 do
    ~L"""
    <div style="display:none"></div>
    """
  end

  defp render_new_channel_form(assigns) do
    ~L"""
      <form class="new-channel" phx-submit="create_channel" phx-change="update_channel" phx-target="<%= @myself %>">
        <div class="flex align-items">
          <input placeholder="Name your channel (keep it empty to use names)" type="text" name="name" value='<%= assigns.channel_name || "" %>' class="flex-grow" />
          <button type="submit" class="has-tooltip">
            <span class="tooltip">Create channel</span>
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </button>
        </div>
        <%= for p <- assigns.new_channel_peers do %>
          <div class="flex items-center">
            <img src="<%= p.picture_url %>" alt="<%= p.name %> picture" />
            <span class="flex-grow"><%= p.name %></span>
            <div class="actions flex items-center">
              <button phx-target="<%= @myself %>" phx-click="remove_channel" phx-value-id="<%= p.user_id %>" class="has-tooltip">
                <span class="tooltip">Remove from channel</span>
                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
              </svg>
              </button>
            </div>
          </div>
        <% end %>
      </form>
    """
  end

end
