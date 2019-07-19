defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :text, :string
      add :sender_id, references(:users)
      add :room_id, references(:rooms)

      timestamps()
    end

  end
end
