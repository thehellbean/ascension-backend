defmodule AscensionWeb.SessionView do
  use AscensionWeb, :view

  def render("token.json", %{token: token}) do
    %{data: %{ token: token } }
  end

  def render("login.json", %{user: user}) do
    %{
      data: %{
        user: %{
          id: user.id,
          username: user.username
        }
      }
    }
  end

  def render("logout.json", _opts) do
    %{
      data: %{
        message: "Logged out"
      }
    }
  end
end
