# Мидлварь для graphql
# Тут ещё нет директив, так-что приходится вызывать это в резолверах
defmodule ChatWeb.Auth do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution
      _ ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "unauthenticated"})
    end
  end
end