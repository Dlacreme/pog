defmodule Pog.Chat.Peer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "chat_peers" do
    field :nb_notif, :integer
    belongs_to :chat_conversation, Pog.Chat.Conversation, foreign_key: :conversation_id
    belongs_to :user, Pog.Accounts.User

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(peer, attrs) do
    peer
    |> cast(attrs, [])
    |> validate_required([])
  end
end
