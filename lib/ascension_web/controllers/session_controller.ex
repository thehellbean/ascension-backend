defmodule AscensionWeb.SessionController do
  use AscensionWeb, :controller
  alias Ascension.Auth

  action_fallback AscensionWeb.FallbackController

  def show(conn, _opts) do
    current_user_id = get_session(conn, :current_user_id)

    if current_user_id do
      conn
      |> put_status(:ok)
      |> put_view(AscensionWeb.UserView)
      |> render("login.json", user: Auth.get_user!(current_user_id))
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(AscensionWeb.ErrorView)
      |> render("401.json", message: "Unauthenticated user")
    end
  end

  def create(conn, %{"username" => username, "password" => password}) do
    case Ascension.Auth.authenticate_user(username, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user_id, user.id)
        |> put_status(:ok)
        |> render("login.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user_id)
        |> put_status(:forbidden)
        |> put_view(AscensionWeb.ErrorView)
        |> render("403.json", message: message)
    end
  end

  def delete(conn, _opts) do
    conn
    |> delete_session(:current_user_id)
    |> put_status(:ok)
    |> render("logout.json")
  end

  def token(conn, _opts) do
    token = get_csrf_token()
    conn
    |> put_status(:ok)
    |> render("token.json", token: token)
  end
end
