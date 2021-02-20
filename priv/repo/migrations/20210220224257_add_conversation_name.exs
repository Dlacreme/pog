defmodule Pog.Repo.Migrations.AddConversationName do
  use Ecto.Migration

  def change do
    alter table(:chat_conversations) do
      add :name, :string, size: 512, null: true
    end
  end
end
