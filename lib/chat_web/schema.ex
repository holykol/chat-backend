defmodule ChatWeb.Schema do
   use Absinthe.Schema

   alias ChatWeb.Resolvers

   object :chat do
      field :id, non_null(:id)
      field :title, non_null(:string)

      field :creator, :user do
         resolve &Resolvers.Rooms.room_owner/3
      end

      field :members, list_of(:user) do
         resolve fn _, _ -> {:error, "not implemented"} end
      end

      field :messages, list_of(:message) do
         arg :last_id, :id
         arg :limit, :integer

         resolve fn _, _ -> {:error, "not implemented"} end
      end
   end

   object :user do
      field :id, :id
      field :username, :string
   end

   object :message do
      field :id, non_null(:id)
      field :text, non_null(:string)
      field :from, non_null(:user)
      field :chat_id, non_null(:id)
      field :chat, non_null(:chat)
      field :created_at, :integer
   end

   query do
      field :token, :string do
         arg :username, non_null(:string)
         arg :password, non_null(:string)

         resolve &Resolvers.Users.login/3
      end

      field :me, :user do
         middleware ChatWeb.Auth
         resolve &Resolvers.Users.user_info/3
      end

      field :chat, :chat do
         arg :id, non_null(:id)
         resolve &Resolvers.Rooms.room/2
      end

      field :my_chats, list_of(:chat) do
         middleware ChatWeb.Auth
         resolve &Resolvers.Rooms.user_rooms/2
      end

   end

   mutation do
      field :register, :string do
         @desc "Register with login and password. Returns token"
         arg :username, non_null(:string)
         arg :password, non_null(:string)

         resolve &Resolvers.Users.register/3
      end

      field :create_chat, :chat do
         arg :title, :string
         arg :members, list_of(:id)

         middleware ChatWeb.Auth
         resolve &Resolvers.Rooms.create_room/3
      end

      field :join_chat, :chat do
         arg :chat_id, :string

         middleware ChatWeb.Auth
         resolve &Resolvers.Rooms.join_room/2
      end

      field :send_message, :message do
         arg :chat_id, non_null(:id)
         arg :text, non_null(:string)

         middleware ChatWeb.Auth

         resolve fn args, _ ->
            IO.puts "Helo"
            message = %{id: "id", text: args.text, from: "id", chat_id: args.chat_id}
            Absinthe.Subscription.publish(ChatWeb.Endpoint, message, multiple_topics: args.chat_id)
            {:ok, message}
         end
      end

      field :delete_message, :boolean do
         arg :chat_id, non_null(:id)
         arg :text, non_null(:string)

         middleware ChatWeb.Auth

         resolve fn _, _ -> {:error, "not implemented"} end
      end

   end

   subscription do
      field :new_message, :message do
         arg :chat_ids, list_of(:id)

         config fn args, _ ->
            {:ok, args.topics}
         end

         trigger :send_message, topic: fn message ->
            message.chat_id
         end

      end

   end

end