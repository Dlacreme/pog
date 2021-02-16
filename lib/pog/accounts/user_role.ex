defmodule Pog.Accounts.UserRole do
  use Ecto.Schema

  @derive {Inspect, except: [:password]}
  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "user_roles" do
    field :label, :string

    timestamps()
  end
end
