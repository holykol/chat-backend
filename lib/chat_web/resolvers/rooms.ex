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

   def room_members(parent, _, _) do
      room = Repo.get(Room, parent.id) |> Repo.preload(:members)
      members = Repo.all Ecto.assoc(room, :members)

      {:ok, members}
   end

   def user_rooms(_args, %{context: %{current_user: current_user}} = _resolution) do
      rooms = Room
      |> Ecto.Query.where(owner_id: ^current_user)
      |> Repo.all

      {:ok, rooms}
   end

   def join_room(%{chat_id: chat_id}, %{context: %{current_user: current_user}}) do
      room = Repo.get(Room, chat_id) |> Repo.preload([:members])

      if room == nil do
         {:error, "no such room"}
      else
         user = Repo.get(User, current_user)

         # Добавляем пользователя в список участников комнаты.
         # https://hexdocs.pm/ecto/Ecto.Changeset.html#put_assoc/4-example-adding-a-comment-to-a-post

         room = Ecto.Changeset.change(room)
         |> Ecto.Changeset.put_assoc(:members, [user | room.members])
         |> Repo.update!()

         {:ok, room}
      end
   end
end
