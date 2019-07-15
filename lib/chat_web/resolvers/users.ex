defmodule ChatWeb.Resolvers.Users do
	alias Chat.{Repo, User}

	def login(_parent, _args, _resolution) do
		{:error, "not_implemented"}
	end

	def register(_parent, args, _resolution) do
		password = Bcrypt.hash_pwd_salt(args.password)

		# TODO beautiful errors
		{:ok, user} = Repo.insert(%User{
			username: args.username,
			name: args.username,
			password: password
		})

		token = JsonWebToken.sign(%{id: user.id}, %{key: ChatWeb.Endpoint.config(:secret_key_base)})

		{:ok, token}
	end
end