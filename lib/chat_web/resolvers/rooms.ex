defmodule ChatWeb.Resolvers.Rooms do
   alias Chat.{Repo, Room, User}

   require Ecto.Query

   def create_room(_parent, args, resolution) do
      Repo.insert(%Room{
         title: args.title,
         owner_id: resolution.context.current_user
      })
   end

   def room(args, _resolution) do
      {:ok, Repo.get(Room, args.id)}
   end

   def room_owner(parent, _, _) do
      {:ok, Repo.get(User, parent.owner_id)}
   end

   def user_rooms(_args, %{context: %{current_user: current_user}} = _resolution) do
      rooms = Room
      |> Ecto.Query.where(owner_id: ^current_user)
      |> Repo.all

      {:ok, rooms}
   end
end
