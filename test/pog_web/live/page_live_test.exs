defmodule PogWeb.PageLiveTest do
  use PogWeb.ConnCase

  test "disconnected and connected render", %{conn: conn} do
    assert conn |> get("/") |> redirected_to() == "/users/log_in"
  end
end
