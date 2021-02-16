defmodule Pog.Repo do
  use Ecto.Repo,
    otp_app: :pog,
    adapter: Ecto.Adapters.Postgres
end
