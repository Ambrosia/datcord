Code.require_file("../../fixtures/web_socket_fixtures.exs", __DIR__)

defmodule Datcord.WebSocket.MessageParserTest do
  use ExUnit.Case, async: true

  alias Datcord.Fixtures.WebSocketMessages
  alias Datcord.WebSocket.MessageParser
  alias Datcord.Model.{Channel, Guild, Member, Message, Role, User}

  test "READY messages are parsed correctly" do
    {type, map} = WebSocketMessages.ready |> MessageParser.parse

    assert type == :ready

    assert %User{username: "Test Account"} = get_in(map, ["d", "user"])

    [private_channel | _] = get_in(map, ["d", "private_channels"])
    assert %User{username: "Other Test Account"} = private_channel["recipient"]

    [guild | _] = get_in(map, ["d", "guilds"])
    assert %Guild{id: "11122233344455566", name: "Example Server"} = guild

    [channel | _] = guild.channels
    assert %Channel{name: "general"} = channel

    [role | _] = guild.roles
    assert %Role{name: "@everyone"} = role
  end

  test "MESSAGE_CREATE (private channel create) messages are parsed correctly" do
    {type, map} = WebSocketMessages.private_create |> MessageParser.parse

    assert type == :private_create
    assert %User{username: "test user"} = get_in(map, ["d", "recipient"])
  end

  test "MESSAGE_CREATE (public channel create) messages are parsed correctly" do
    {type, map} = WebSocketMessages.channel_create |> MessageParser.parse

    assert type == :channel_create
    assert %Channel{name: "some name"} = map["d"]
  end

  test "CHANNEL_UPDATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.channel_update |> MessageParser.parse

    assert type == :channel_update
    assert %Channel{name: "some name"} = map["d"]
  end

  test "CHANNEL_DELETE (private channel delete) messages are parsed correctly" do
    {type, map} = WebSocketMessages.private_delete |> MessageParser.parse

    assert type == :private_delete
    assert %User{username: "test user"} = get_in(map, ["d", "recipient"])
  end

  test "CHANNEL_DELETE (public channel delete) messages are parsed correctly" do
    {type, map} = WebSocketMessages.channel_delete |> MessageParser.parse

    assert type == :channel_delete
    assert %Channel{name: "some name"} = map["d"]
  end

  test "MESSAGE_CREATE (new chat message) messages are parsed correctly" do
    {type, map} = WebSocketMessages.message_create |> MessageParser.parse

    assert type == :message_create
    assert %Message{content: "I'm a test message~"} = map["d"]
    assert %User{username: "Test Account"} = map["d"].author
  end

  test "MESSAGE_UPDATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.message_update |> MessageParser.parse

    assert type == :message_update
    assert %Message{content: "I'm a test message~"} = map["d"]
    assert %User{username: "Test Account"} = map["d"].author
  end

  test "MESSAGE_DELETE messages are parsed correctly" do
    {type, _map} = WebSocketMessages.message_delete |> MessageParser.parse

    assert type == :message_delete
  end

  test "MESSAGE_ACK messages are parsed correclty" do
    {type, _map} = WebSocketMessages.message_ack |> MessageParser.parse

    assert type == :message_ack
  end

  test "GUILD_CREATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_create |> MessageParser.parse

    assert type == :guild_create

    assert %Guild{name: "Name"} = map["d"]

    [role | _] = map["d"].roles
    assert %Role{name: "@everyone"} = role
  end

  test "GUILD_UPDATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_update |> MessageParser.parse

    assert type == :guild_update

    assert %Guild{name: "Name"} = map["d"]

    [role | _] = map["d"].roles
    assert %Role{name: "@everyone"} = role
  end

  test "GUILD_DELETE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_delete |> MessageParser.parse

    assert type == :guild_delete

    assert %Guild{name: "Name"} = map["d"]

    [role | _] = map["d"].roles
    assert %Role{name: "@everyone"} = role
  end

  test "GUILD_MEMBER_ADD messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_member_add |> MessageParser.parse

    assert type == :guild_member_add

    assert %Member{guild_id: "111222333444555666"} = map["d"]
    assert %User{username: "test user"} = map["d"].user
  end

  test "GUILD_MEMBER_UPDATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_member_update |> MessageParser.parse

    assert type == :guild_member_update

    assert %Member{guild_id: "111222333444555666"} = map["d"]
    assert %User{username: "test user"} = map["d"].user
  end

  test "GUILD_MEMBER_REMOVE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_member_remove |> MessageParser.parse

    assert type == :guild_member_remove

    assert %Member{guild_id: "111222333444555666"} = map["d"]
    assert %User{username: "test user"} = map["d"].user
  end

  test "GUILD_BAN_ADD messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_ban_add |> MessageParser.parse

    assert type == :guild_ban_add
    assert %User{username: "test user"} = get_in(map, ["d", "user"])
  end

  test "GUILD_BAN_REMOVE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_ban_remove |> MessageParser.parse

    assert type == :guild_ban_remove
    assert %User{username: "test user"} = get_in(map, ["d", "user"])
  end

  test "GUILD_ROLE_CREATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_role_create |> MessageParser.parse

    assert type == :guild_role_create
    assert %Role{name: "new role"} = get_in(map, ["d", "role"])
  end

  test "GUILD_ROLE_UPDATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.guild_role_update |> MessageParser.parse

    assert type == :guild_role_update
    assert %Role{name: "new role"} = get_in(map, ["d", "role"])
  end

  test "GUILD_ROLE_DELETE messages are parsed correctly" do
    {type, _map} = WebSocketMessages.guild_role_delete |> MessageParser.parse

    assert type == :guild_role_delete
  end

  test "USER_UPDATE messages are parsed correctly" do
    {type, map} = WebSocketMessages.user_update |> MessageParser.parse

    assert type == :user_update
    assert %User{email: "email@example.com", username: "Something"} = map["d"]
  end
end
