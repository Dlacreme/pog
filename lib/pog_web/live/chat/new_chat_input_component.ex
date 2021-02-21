defmodule PogWeb.NewChatInputComponent do
  use PogWeb, :live_component

  @impl true
  def render(assigns) do
    IO.puts("ASSIGNS >> ", assigns)
    ~L"""
      <div>
        <input type="text" placeholder="Chat with... (ctrl+k)" disabled />
      </div>
    """
  end
end
