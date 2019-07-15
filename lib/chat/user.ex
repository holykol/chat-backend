defmodule Chat.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :password])
    |> validate_required([:username, :name, :password])
    |> unique_constraint(:username)
  end
end
