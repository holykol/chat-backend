defmodule ChatWeb.Resolvers.SubscriptionsTest do
	use Chat.SubscriptionCase
	import Chat.Factory

	test "user can subscribe to new messages", %{socket: socket} do
		room = insert(:room)
		user = insert(:user)

		# setup a subscription
		subscription = """
			subscription {
				newMessage(chatIds: ["#{room.id}"]) {
					id
				}
			}
		"""

    ref = push_doc socket, subscription, variables: %{}
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    # send mutation
		mutation = """
			mutation {
				sendMessage(chat_id: "#{room.id}", text: "Message text") {
					id
				}
			}
		"""

		{:ok, %{data: result}} = Absinthe.run(
			mutation,
			ChatWeb.Schema,
			context: %{current_user: user.id, pubsub: ChatWeb.Endpoint}
		)

		# Make sure message got inserted
		message_id = result["sendMessage"]["id"]
		assert Chat.Repo.get!(Chat.Message, message_id) != nil

		# Check if we received event
    expected = %{
      result: %{data: %{"newMessage" => %{"id" => message_id}}},
      subscriptionId: subscription_id
    }
    assert_push "subscription:data", push
    assert expected == push
	end
end