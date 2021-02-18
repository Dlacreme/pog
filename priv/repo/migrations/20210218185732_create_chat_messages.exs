defmodule Pog.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :peer_id, references(:chat_peers, type: :binary_id), null: false
      add :content, :string, size: 5054
      timestamps(updated_at: false)
    end

  end
end
