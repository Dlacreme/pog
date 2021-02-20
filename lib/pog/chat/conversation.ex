defmodule Pog.Chat.Conversation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chat_conversations" do
    field :name, :string
    has_many :peers, Pog.Chat.Peer, foreign_key: :conversation_id, references: :id
    timestamps()
  end

  @doc false
  def changeset(conversation, attrs) do
    conversation
    |> cast(attrs, [:name])
    |> validate_required([])
  end
end
