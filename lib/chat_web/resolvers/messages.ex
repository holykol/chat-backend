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
end