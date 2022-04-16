defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.{Video, Category}

  describe "videos" do
    import Rumbl.MultimediaFixtures

    @invalid_attrs %{description: nil, title: nil, url: nil}

    setup do
      {:ok, owner: user_fixture()}
    end

    test "list_videos/0 returns all videos", %{owner: owner} do
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end

    test "get_video!/1 returns the video with given id", %{owner: owner} do
      %Video{id: id} = video_fixture(owner)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "create_video/1 with valid data creates a video", %{owner: owner} do
      valid_attrs = %{description: "some description", title: "some title", url: "some url"}

      assert {:ok, %Video{} = video} = Multimedia.create_video(owner, valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset", %{owner: owner} do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(owner, @invalid_attrs)
    end

    test "update_video/2 with valid data updates the video", %{owner: owner} do
      video = video_fixture(owner)
      update_attrs = %{description: "some updated description", title: "some updated title", url: "some updated url"}

      assert {:ok, %Video{} = video} = Multimedia.update_video(video, update_attrs)
      assert video.description == "some updated description"
      assert video.title == "some updated title"
      assert video.url == "some updated url"
    end

    test "update_video/2 with invalid data returns error changeset", %{owner: owner} do
      video = video_fixture(owner)
      id = video.id
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert %Video{id: ^id} = Multimedia.get_video!(id)
    end

    test "delete_video/1 deletes the video", %{owner: owner} do
      video = video_fixture(owner)
      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset", %{owner: owner} do
      video = video_fixture(owner)
      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for name <- ~w(Drama Comedy SciFi) do
        Multimedia.create_category!(name)
      end

      assert [%Category{name: "Comedy"}, %Category{name: "Drama"}, %Category{name: "SciFi"}] = Multimedia.list_alphabetical_categories()
    end
  end
end
