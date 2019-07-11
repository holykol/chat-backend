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

end