defmodule AscensionWeb.Router do
  use AscensionWeb, :router

  pipeline :api do
    plug :fetch_session
    plug :accepts, ["json"]
    plug Plug.Parsers, parsers: [:json], json_decoder: Jason
    plug :put_secure_browser_headers
#    plug :protect_from_forgery
  end

  pipeline :protected_api do
    plug :ensure_authentication
  end

  scope "/api/v1", AscensionWeb do
    pipe_through :api

    get "/session", SessionController, :show
    post "/users", UserController, :create
    get "/token", SessionController, :token
    post "/session", SessionController, :create
  end

  scope "/api/v1", AscensionWeb do
    pipe_through [:api, :protected_api]

    delete "/session", SessionController, :delete
    resources "/users", UserController, except: [:create, :edit]
    get "/books/isbn", BookController, :isbn
    resources "/books", BookController do
      resources "/audio", AudioController
      post "/audio/:id/progress", AudioController, :update_progress
    end
  end

  defp ensure_authentication(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(AscensionWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
      |> halt()
    end
  end
end
