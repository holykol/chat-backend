defmodule ChatWeb.Resolvers.Users do
	alias Chat.{Repo, User}

	def login(_parent, %{username: username, password: password} = _args, _resolution) do
		user = Repo.get_by(User, username: username)

		case Bcrypt.verify_pass(password, user.password) do
			true -> {:ok, issue_token(user.id)}
			false -> {:error, "wrong password"}
		end
	end

	def register(_parent, args, _resolution) do
		password = Bcrypt.hash_pwd_salt(args.password)

		# TODO do sth about errors
		# https://hexdocs.pm/ecto/Ecto.Repo.html#c:insert/2-examples
		{:ok, user} = Repo.insert(%User{
			username: args.username,
			name: args.username,
			password: password
		})

		token = issue_token(user.id)

		{:ok, token}
	end

	def user_info(_parent, _args, %{context: %{current_user: current_user}} = _resolution) do
		case Repo.get(User, current_user) do
			nil -> {:error, "user not found"}
			user -> {:ok, user}
		end
	end

	defp issue_token(id) do
		JsonWebToken.sign(%{id: id}, %{key: ChatWeb.Endpoint.config(:secret_key_base)})
	end
end