defmodule Pog.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @derive {Phoenix.Param, key: :id}

      def first do
        __MODULE__ |> Ecto.Query.first() |> Distanciel.Repo.one()
      end

      def last do
        __MODULE__ |> Ecto.Query.last() |> Distanciel.Repo.one()
      end
    end
  end
end
