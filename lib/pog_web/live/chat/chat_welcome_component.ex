defmodule PogWeb.ChatWelcomeComponent do
  use PogWeb, :live_component


  @impl true
  def render(assigns) do
    ~L"""
      <div class="welcome h-full p-5 flex-grow">
        <h1 class="m-0 mb-10">Welcome</h1>
        <p>Welcome to our own Slack application ! It has been developped entirely with Phoenix / Elixir</p>
        <p>Your contribution is always welcomed, just reach out if you wanna hear more.</p>
        <p>
            Available feature:
            <ul>
                <li> 1-1 chat room</li>
                <li> Channel chat room</li>
                <li> Web conference </li>
            </ul>
        </p>
      </div>
    """
  end

end
