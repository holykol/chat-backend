defmodule Chat.Factory do
	use ExMachina.Ecto, repo: Chat.Repo

	def user_factory do
		%Chat.User{
			name: sequence("username"),
			username: sequence("user"),
			password: Bcrypt.hash_pwd_salt("pa$$word"),
		}
	end

end