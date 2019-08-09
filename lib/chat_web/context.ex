# Это что-то вроде мидлвари для запроса
defmodule ChatWeb.Context do
   @behaviour Plug

   import Plug.Conn

   def init(opts), do: opts

   def call(conn, _) do
      context = build_context(conn)
      Absinthe.Plug.put_options(conn, context: context)
   end

   @doc """
   Прикрепляет данные о пользователе к контексту, если в запросе есть jwt токен
   """
   def build_context(conn) do
      conn
      |> get_token
      |> authorize
      |> case do
         {:ok, current_user} -> %{current_user: current_user}
         {:error, _} -> %{}
      end
   end

   defp get_token(conn) do
      case get_req_header(conn, "authorization") do
         ["Bearer " <> token] -> token
         _ -> ""
      end
   end

   defp authorize(token) do
      try do
         JsonWebToken.verify(token, %{key: ChatWeb.Endpoint.config(:secret_key_base)})
         |> case do
            {:ok, claims} -> {:ok, claims.id}
            {:error, "invalid"} -> {:error, "invalid authorization token"}
         end
      rescue
         _ -> {:error, "invalid authorization token"}
      end


   end

end