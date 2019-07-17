defmodule ChatWeb.Resolvers.Rooms do
   alias Chat.{Repo, Room, User}

   def create_room(_parent, args, resolution) do
      Repo.insert(%Room{
         title: args.title,
         owner_id: resolution.context.current_user
      })
   end

   def room_owner(parent, _, _) do
      {:ok, Repo.get(User, parent.owner_id)}
   end
end
