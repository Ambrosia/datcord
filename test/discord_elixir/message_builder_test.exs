defmodule MessageBuilderTest do
  use ExUnit.Case, async: true
  doctest DiscordElixir.MessageBuilder, only: [{:list_to_english_list, 2}]

  import DiscordElixir.MessageBuilder
  alias DiscordElixir.MessageBuilder.Message
  alias DiscordElixir.Model.User

  test "text/1 appends text to message" do
    message = %Message{content: "test"}
    |> text(" test")

    assert message.content == "test test"
  end

  test "mention/2 properly mentions a user" do
    user = %User{id: "1"}
    message = mention(user)

    assert String.contains?(message.content, "<@1>")
  end

  test "mention/2 properly mentions multiple users" do
    list = 1..10
    users = Enum.map(list, fn n -> %User{id: to_string(n)} end)
    message = mention(users)

    Enum.each list, fn n ->
      assert String.contains?(message.content, "<@#{n}>")
    end
  end

  test "name/2 properly inserts the name of a user" do
    user = %User{id: "1", username: "abc"}

    assert String.contains?(name(user).content, "abc")
  end

  test "name/2 propertly inserts the names of multiple users" do
    list = 1..10
    users = Enum.map list, fn n ->
      %User{id: to_string(n), username: "a" <> to_string(n)}
    end
    message = name(users)

    Enum.each list, fn n ->
      assert String.contains?(message.content, "a" <> to_string(n))
    end
  end

  test "passing a custom separator to name/3 works" do
    separator = &Enum.join(&1, ",")
    users = Enum.map 1..4, fn n ->
      %User{id: to_string(n), username: to_string(n)}
    end

    message = %Message{} |> name(users, separator: separator)

    assert message.content == "1,2,3,4"
  end
end
