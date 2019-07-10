# defmodule ChatWeb.Schema do
#   use Absinthe.Schema
#   import_types ChatWeb.Schema.ContentTypes

#   alias ChatWeb.Resolvers

#   query do

#     # @desc "Get all chat rooms"
#     # field :allchats, list_of(:chat) do
#       # resolve []
#     # end

#     field :hello, :string do
#     	resolve "world"
#     end

#   end

# end

defmodule ChatWeb.Schema do
  use Absinthe.Schema

 	# Example data
  @items [
    %{id: "foo", title: "Foo"},
    %{id: "bar", title: "Bar"}
  ]

	object :chat do
	  field :id, :id
	  field :title, :string
	  field :creator, :user do
	  	resolve fn _, _ ->
	  		{:ok, %{id: "1", username: "deadrime"}}
	  	end
	  end
	end

	object :user do
		field :id, :id
		field :username, :string do
			resolve fn _, ctx ->
				{:ok, "user-#{ctx.source.id}" }
			end
		end
	end

  query do
    field :chat, :chat do
      arg :id, non_null(:id)
      resolve fn %{id: item_id}, _ ->
        {:ok, Enum.find(@items, &(&1.id == item_id))}
      end
    end

    field :all_chats, list_of(:chat) do
    	resolve fn _, _ ->
    		{:ok, @items}
	    end
	  end

  end

end