defmodule ChatWeb.AuthTest do
	use ExUnit.Case

	describe "auth middleware" do
		test "when authenticated" do
			resolution = %Absinthe.Resolution{context: %{current_user: "777"}}

			assert resolution == ChatWeb.Auth.call(resolution, %{})
		end

		test "when not authenticated" do
			resolution = %Absinthe.Resolution{context: %{}}
			resolution = ChatWeb.Auth.call(resolution, %{})

			assert resolution.state == :resolved
			assert length(resolution.errors) == 1
		end
	end


end