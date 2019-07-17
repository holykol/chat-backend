defmodule Chat.Room do
   use Ecto.Schema
   import Ecto.Changeset

   schema "rooms" do
      field :title, :string
      belongs_to :owner, Chat.User, foreign_key: :owner_id

      timestamps()
   end

   @doc false
   def changeset(room, attrs) do
      room
      |> cast(attrs, [:title])
      |> validate_required([:title])
      |> Ecto.Changeset.cast_assoc(:owner, required: true)
      # |> Ecto.Changeset.cast_assoc(:members, required: false)
   end
end
