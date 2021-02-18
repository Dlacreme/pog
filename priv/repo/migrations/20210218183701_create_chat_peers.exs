defmodule Pog.Repo.Migrations.CreateChatPeers do
  use Ecto.Migration

  def change do
    create table(:chat_peers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :conversation_id, references(:chat_conversations, type: :binary_id), null: false
      add :user_id, references(:users, type: :binary_id), null: false
      add :nb_notif, :integer
      timestamps(updated_at: false)
    end

  end
end
