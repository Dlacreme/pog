defmodule PogWeb.ChatHeaderComponent do
  use PogWeb, :live_component

  @impl true
  def render(assigns) do
    header(assigns, Enum.filter(assigns.peers, fn p -> p.user_id != assigns.current_user_id end))
  end

  defp header(assigns, peers) when length(peers) == 1 do
    p = List.first(peers)

    ~L"""
      <div class="flex w-full pr-2">
        <div class="flex flex-grow items-center pr-5">
          <h2 class="flex-grow h2"><%= p.name %></h2>
          <span><%= p.title %></span>
        </div>
        <%= call(assigns) %>
      </div>
    """
  end

  defp header(assigns, peers) do
    ~L"""
      <div class="flex w-full pr-2">
        <h2 class="h2 flex-grow items-center pr-5"><%= Enum.map(peers, fn p -> p.name end) |> Enum.join(", ") %></h2>
        <%= call(assigns) %>
      </div>
    """
  end

  defp call(assigns) do
    ~L"""
      <div class="actions">
          <button class="icon button">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
              </svg>
          </button>
      </div>
    """
  end
end
