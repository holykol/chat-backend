# https://media.pragprog.com/titles/wwgraphql/code/06-chp.subscriptions/4-publish/test/support/subscription_case.ex
defmodule Chat.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with channels
      use ChatWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest,
        schema: ChatWeb.Schema

      setup do
        {:ok, socket} =
          Phoenix.ChannelTest.connect(ChatWeb.UserSocket, %{})
        {:ok, socket} =
            Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end