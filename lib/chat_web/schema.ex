defmodule ChatWeb.Schema do
  use Absinthe.Schema

	object :chat do
	  field :id, non_null(:id)
	  field :title, non_null(:string)

	  field :creator, :user do
	  	resolve fn _, _ -> {:error, "not implemented"} end
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

	  	resolve fn _, _ -> {:error, "not implemented"} end
	  end

  	field :me, :user do
  		resolve fn _, _ -> {:error, "not implemented"} end
  	end

    field :chat, :chat do
      arg :id, non_null(:id)
      resolve fn _, _ -> {:error, "not implemented"} end
    end

    field :my_chats, list_of(:chat) do
    	resolve fn _, _ -> {:error, "not implemented"} end
	  end

  end

  mutation do
  	field :register, :string do
  		@desc "Register with login and password. Returns token"
  		arg :username, non_null(:string)
  		arg :password, non_null(:string)

      resolve fn _, _ -> {:error, "not implemented"} end
  	end

  	field :create_chat, :chat do
  		arg :title, :string
  		arg :members, list_of(:id)

      resolve fn _, _ -> {:error, "not implemented"} end
  	end

  	field :join_chat, :chat do
  		arg :chat_id, :string

      resolve fn _, _ -> {:error, "not implemented"} end
  	end

  	field :send_message, :message do
  		arg :chat_id, non_null(:id)
  		arg :text, non_null(:string)

      resolve fn _, _ -> {:error, "not implemented"} end
  	end

		field :delete_message, :boolean do
  		arg :chat_id, non_null(:id)
  		arg :text, non_null(:string)

      resolve fn _, _ -> {:error, "not implemented"} end
  	end



  end

  # TBD
 	subscription do
 		field :new_message, :message do
 			arg :chat_ids, list_of(:id)

 			config fn args, _ ->
      	{:ok, topic: args.chat_ids}
    	end

    	trigger :send_message, topic: fn message ->
    		true # TODO
    	end
 		end
 	end

end