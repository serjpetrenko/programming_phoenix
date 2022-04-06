defmodule RumblWeb.UserController do
  use RumblWeb, :controller

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user(id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = Accounts.change_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user}) do
    with {:ok, user} <- Accounts.register_user(user) do
      conn
      |> put_flash(:info, "#{user.name} was created.")
      |> redirect(to: Routes.user_path(conn, :index))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
