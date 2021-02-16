defmodule Pog.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id), null: true
      add :slug, :string, size: 55, null: false
      add :first_name, :string, size: 255, null: false
      add :last_name, :string, size: 255, null: false
      add :email, :citext, null: false
      add :phone, :string, null: true
      add :position, :string, size: 524, null: true
      add :birthday, :naive_datetime, null: true
      add :location, :string, size: 255, null: true
      add :github, :string, size: 255, null: true
      add :twitter, :string, size: 255, null: true
      add :linkedin, :string, size: 255, null: true
      add :bio, :string, size: 2048, null: true
      add :picture_url, :string, size: 2048, null: true
      add :joined_at, :naive_datetime
      add :left_at, :naive_datetime, null: true

      timestamps()
    end

  end
end
