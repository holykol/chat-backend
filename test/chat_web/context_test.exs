defmodule ChatWeb.ContextTest do
	import Plug.Conn
	use ChatWeb.ConnCase

	describe "context plug" do

		test "accepts user token", %{conn: conn} do
			token = JsonWebToken.sign(%{id: 123}, %{key: ChatWeb.Endpoint.config(:secret_key_base)})

			conn = conn
			|> put_req_header("authorization", "Bearer #{token}")
			|> ChatWeb.Context.call(%{})

			assert conn.private.absinthe.context.current_user == 123
		end

		test "rejects unsigned tokens", %{conn: conn} do
			token = JsonWebToken.sign(%{id: 123}, %{alg: "none"})

			conn = conn
			|> put_req_header("authorization", "Bearer #{token}")
			|> ChatWeb.Context.call(%{})

			assert conn.private.absinthe.context == %{}
		end

		test "does nothing when no token is provided", %{conn: conn} do
			conn = ChatWeb.Context.call(conn, %{})

			assert conn.private.absinthe.context == %{}
		end
	end
end