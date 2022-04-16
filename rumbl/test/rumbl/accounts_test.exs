defmodule Rumbl.AccountsTest do
  use Rumbl.DataCase, async: true

  alias Rumbl.Accounts
  alias Rumbl.Accounts.User
  import Rumbl.MultimediaFixtures, only: [user_fixture: 1]

  describe "register_user/1" do
    @valid_attrs %{
      name: "User",
      username: "superuser",
      password: "secret"
    }
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "User"
      assert user.username == "superuser"
      assert [%User{id: ^id}] = Accounts.list_users()
    end

    test "with invalid data returns error changeset" do
      assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
      assert Accounts.list_users() == []
    end

    test "with valid data and existing username returns error changeset" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert %{username: ["has already been taken"]} = errors_on(changeset)
      assert  [%User{id: ^id}] = Accounts.list_users()
    end

    test  "does not accept long usernames"  do
      attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{username: ["should be at most 20 character(s)"]} = errors_on(changeset)
      assert  Accounts.list_users() == []
    end

    test "requires password to be at least 6 char long" do
      attrs = Map.put(@valid_attrs, :password, "short")
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["should be at least 6 character(s)"]} = errors_on(changeset)
      assert  Accounts.list_users() == []
    end
  end

  describe "authenticate_by_username_and_pass/2" do
    @pass "123456"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} = Accounts.authenticate_by_username_and_pass(user.username, @pass)
      assert auth_user.id == user.id
    end

    test "returns error changeset with incorrect password", %{user: user} do
      assert {:error, :unauthorized} = Accounts.authenticate_by_username_and_pass(user.username, "wrong")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} = Accounts.authenticate_by_username_and_pass("wrong", @pass)
    end
  end
end
