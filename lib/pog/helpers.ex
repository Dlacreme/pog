defmodule Pog.Helpers do
  @doc """
  Returns the :title config if present, otherwise returns "Pog"
  """
  @spec title() :: String.t()
  def title() do
    env(:title, "Pog")
  end

  defp env(key, default \\ nil) do
    Application.get_env(:pog, key, default)
  end
end
