defmodule RumblWeb.SessionController do
  use RumblWeb, :controller
  alias Rumbl.Accounts
  alias RumblWeb.Auth

  def new(conn, _param) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Accounts.authenticate_by_username_and_pass(username, pass) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username/password")
        |> render("new.html")
    end
  end

  def delete(conn, _param) do
    conn
    |> Auth.logout()
    |> put_flash(:info, "You have been logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
