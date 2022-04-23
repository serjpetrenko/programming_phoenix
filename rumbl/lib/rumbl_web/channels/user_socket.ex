defmodule RumblWeb.UserSocket do
  use Phoenix.Socket

  channel "videos:*", RumblWeb.VideoChannel

  def connect(%{"token" => token}, socket, _connect_info) do
    # max_age: 1209600 is equivalent to two weeks in seconds
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
      {:ok, user_id} ->
        {:ok, assign(socket, :current_user, user_id)}
      {:error, reason} ->
        :error
    end
  end

  def id(_socket), do: nil
end
