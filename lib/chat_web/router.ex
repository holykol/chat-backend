defmodule ChatWeb.Router do
   use ChatWeb, :router

   pipeline :api do
      plug :accepts, ["json"]
      # Распознаём пользователя
      plug ChatWeb.Context
   end

   scope "/api" do
      pipe_through :api

      forward "/graphiql", Absinthe.Plug.GraphiQL,
         schema: ChatWeb.Schema

      forward "/", Absinthe.Plug,
         schema: ChatWeb.Schema

   end

end