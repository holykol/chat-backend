defmodule ChatWeb.Resolvers.RoomsTest do
	use Chat.DataCase
	import Chat.Factory

	test "can query room, it's creator and members" do
		room = insert(:room)

		query = """
			{
				chat(id: #{room.id}) {
					title
					creator {
						id
					}
					members {
						id
					}
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)

		assert result["chat"]["title"] == room.title
		assert result["chat"]["creator"]["id"] == Integer.to_string(room.owner.id)
		assert length(result["chat"]["members"]) == 3
	end

	test "user can query their rooms" do
		user = insert(:user)

		insert(:room, owner: user)
		insert(:room, owner: user)

		query = """
			{
				myChats {
					id
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(
			query,
			ChatWeb.Schema,
			context: %{current_user: user.id}
		)

		assert length(result["myChats"]) == 2

	end

	test "user can join room" do
		room = insert(:room)
		user = insert(:user)

		mutation = """
			mutation {
				joinChat(chat_id: "#{room.id}") {
					id
				}
			}
		"""

		{:ok, _} = Absinthe.run(
			mutation,
			ChatWeb.Schema,
			context: %{current_user: user.id}
		)

		query = """
			{
				chat(id: "#{room.id}") {
					members {
						id
					}
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)
		members = result["chat"]["members"]

		assert length(members) == 4 # 3 + 1
		assert Enum.any?(members, fn m ->
			m["id"] == Integer.to_string(user.id)
		end)
	end

	test "user can create room" do
		user = insert(:user)

		mutation = """
			mutation {
				createChat(title: "New room") {
					id
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(
			mutation,
			ChatWeb.Schema,
			context: %{current_user: user.id}
		)

		assert Repo.get!(Chat.Room, result["createChat"]["id"]).owner_id == user.id

	end

end