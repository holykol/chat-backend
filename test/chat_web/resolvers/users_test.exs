defmodule ChatWeb.Resolvers.UsersTest do
	use Chat.DataCase
	import Chat.Factory

	test "user can login and get their token" do
		user = insert(:user)

		query = """
			{
				token(username: "#{user.username}", password: "pa$$word")
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)
		{:ok, claims} = JsonWebToken.verify(result["token"], %{key: ChatWeb.Endpoint.config(:secret_key_base)})

		assert claims.id == user.id
	end

	test "wrong password causes an error" do
		user = insert(:user)

		query = """
			{
				token(username: "#{user.username}", password: "wrong")
			}
		"""

		{:ok, %{errors: errors}} = Absinthe.run(query, ChatWeb.Schema)

		assert length(errors) == 1
		assert Enum.at(errors, 0).message == "wrong password"
	end

	test "user can register and get their token" do
		query = """
			mutation {
				register(username: "username", password: "blah")
			}
		"""
		{:ok, %{data: result}} = Absinthe.run(query, ChatWeb.Schema)
		{:ok, _} = JsonWebToken.verify(result["register"], %{key: ChatWeb.Endpoint.config(:secret_key_base)})
	end

	test "user can get their info" do
		user = insert(:user)

		query = """
		 	{
				me {
					id
					username
				}
		 	}

		"""

		{:ok, %{data: result}} = Absinthe.run(
			query,
			ChatWeb.Schema,
			context: %{current_user: user.id}
		)

		assert result["me"]["id"] == Integer.to_string(user.id)
		assert result["me"]["username"] == user.username
	end
end