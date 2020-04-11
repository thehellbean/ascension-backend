defmodule AscensionWeb.UserView do
  use AscensionWeb, :view
  alias AscensionWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
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
end
