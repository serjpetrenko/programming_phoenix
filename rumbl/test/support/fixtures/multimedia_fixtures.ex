defmodule Rumbl.MultimediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rumbl.Multimedia` context.
  """

  alias Rumbl.{Accounts, Multimedia}
  alias Rumbl.Accounts.User

  @doc """
  Create a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some user",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "supersecret"
      })
      |> Accounts.register_user()

    user
  end
  @doc """
  Generate a video.
  """
  def video_fixture(%User{} = user, attrs \\ %{}) do attrs =
    Enum.into(attrs, %{
      title: "A Title",
      url: "http://example.com", description: "a description"
    })
    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end
end
