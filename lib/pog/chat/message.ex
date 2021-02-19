defmodule Pog.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chat_messages" do
    belongs_to :chat_peer, Pog.Chat.Peer, foreign_key: :peer_id
    field :content, :string
    timestamps(updated_at: false)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:peer_id, :content])
    |> validate_required([])
  end
end
