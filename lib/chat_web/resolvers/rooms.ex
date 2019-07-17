defmodule ChatWeb.Resolvers.Rooms do
	alias Chat.{Repo, Room}

	def create_room(_parent, args, resolution) do
		Repo.insert(%Room{
			title: args.title,
			owner_id: resolution.context.current_user,
		})
	end
end