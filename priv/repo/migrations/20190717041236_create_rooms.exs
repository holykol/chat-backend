defmodule Chat.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :title, :string
		add :owner_id, references(:users)
      timestamps()
    end

  end
end
