defmodule ChatWeb.Resolvers.Messages do

	alias Chat.{Repo, Room, User, Message}
  require Ecto.Query

	def send_message(args, resolution) do
		room = Repo.get(Room, args.chat_id)

		if room == nil do
			{:error, "room does not exists"}
		else
			Repo.insert %Message{
				text: args.text,
				room: room,
				sender_id: resolution.context.current_user
			}
		end
	end

	def message_sender(parent, _, _) do
		case Repo.get(User, parent.sender_id) do
			nil -> {:error, "user not found"}
			user -> {:ok, user}
		end
	end

	def message_room(parent, _, _) do
		{:ok, Repo.get(Room, parent.room_id)}
	end
end