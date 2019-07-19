defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string

    belongs_to :sender, Chat.User, foreign_key: :sender_id
    belongs_to :room, Chat.Room, foreign_key: :room_id

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:text, :sender, :room])
    |> validate_required([:text])
    |> Ecto.Changeset.cast_assoc(:sender, required: true)
    |> Ecto.Changeset.cast_assoc(:room, required: true)

  end
end
