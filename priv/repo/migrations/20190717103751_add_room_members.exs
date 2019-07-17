defmodule Chat.Repo.MigrationsAddRoomMembers do
  use Ecto.Migration

  def change do
	  create table(:room_members) do
	    add :room_id, references(:rooms)
	    add :user_id, references(:users)
	  end

	  create unique_index(:room_members, [:room_id, :user_id])
	end
end
