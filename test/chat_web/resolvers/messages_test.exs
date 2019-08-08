defmodule ChatWeb.Resolvers.MessagesTest do
	use Chat.DataCase
	import Chat.Factory

	test "can query message sender" do
		user = insert(:user)
		message = insert(:message, sender: user)

		query = """
			{
				chat(id: "#{message.room.id}") {
					messages(limit: 1) {
						id
						from {
							id
						}
					}
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)
		message = Enum.at(result["chat"]["messages"], 0)

		assert message["from"]["id"] == Integer.to_string(user.id)
	end

	test "can query message room" do
		room = insert(:room)
		message = insert(:message, room: room)

		query = """
			{
				chat(id: "#{message.room.id}") {
					messages(limit: 1) {
						id
						chat_id
						chat {
							id
						}
					}
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)
		message = Enum.at(result["chat"]["messages"], 0)


		assert message["chat"]["id"] == Integer.to_string(room.id)
		assert message["chat_id"] == Integer.to_string(room.id)
	end

	test "message created_at format" do
		message = insert(:message)

		query = """
			{
				chat(id: "#{message.room.id}") {
					messages(limit: 1) {
						id
						created_at
					}
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)
		msg = Enum.at(result["chat"]["messages"], 0)

		t1 = DateTime.from_unix!(msg["created_at"])
		t2 = DateTime.from_naive!(message.inserted_at, "Etc/UTC")

		assert DateTime.compare(t1, t2) == :eq
	end

end