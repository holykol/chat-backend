defmodule Chat.Factory do
	use ExMachina.Ecto, repo: Chat.Repo

	def user_factory do
		%Chat.User{
			name: sequence("username"),
			username: sequence("user"),
			password: Bcrypt.hash_pwd_salt("pa$$word"),
		}
	end

	def room_factory do
		%Chat.Room{
			title: sequence("room"),
			owner: build(:user),
			members: build_list(3, :user)
		}
	end

	def message_factory do
		%Chat.Message{
			text: "Message text",
			room: build(:room),
			sender: build(:user)
		}
	end
end