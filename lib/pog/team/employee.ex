defmodule Pog.Team.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "employees" do
    field :slug, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :birthday, :naive_datetime
    field :bio, :string
    field :phone, :string
    field :location, :string
    field :picture_url, :string
    field :position, :string
    field :github, :string
    field :linkedin, :string
    field :twitter, :string
    field :joined_at, :naive_datetime
    field :left_at, :naive_datetime
    belongs_to :user, Pog.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:slug, :first_name, :last_name, :email, :phone, :position, :birthday, :location, :github, :twitter, :linkedin, :bio, :picture_url, :joined_at, :left_at, :location])
    |> validate_required([:slug, :first_name, :last_name, :email, :joined_at])
  end
end
