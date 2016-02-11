defmodule Datcord.WebSocket.MessageParser do
  alias Datcord.Model.{Channel, Guild, Member, Message, Role, User}

  def parse(msg = %{"t" => "READY"}) do
    msg =
      msg
      |> update_in(["d", "user"], &User.parse/1)
      |> update_in(["d", "private_channels"], fn private_channels ->
        Enum.map(private_channels, &Map.update!(&1, "recipient", fn user -> User.parse(user) end))
      end)
      |> update_in(["d", "guilds"], fn guilds ->
        Enum.map(guilds, &Map.update!(&1, "channels", fn channel -> Channel.parse(channel) end))
      end)
      |> update_in(["d", "guilds"], &Guild.parse/1)
    {:ready, msg}
  end

  def parse(msg = %{"t" => "RESUMED"}) do
    {:resumed, msg}
  end

  def parse(msg = %{"t" => "MESSAGE_CREATE", "d" => %{"is_private" => true}}) do
    msg =
      msg
      |> update_in(["d", "recipient"], &User.parse/1)
    {:private_create, msg}
  end

  def parse(msg = %{"t" => "MESSAGE_CREATE", "d" => %{"is_private" => false}}) do
    msg =
      msg
      |> Map.update!("d", &Channel.parse/1)

    {:channel_create, msg}
  end

  def parse(msg = %{"t" => "CHANNEL_UPDATE"}) do
    msg =
      msg
      |> Map.update!("d", &Channel.parse/1)

    {:channel_update, msg}
  end

  def parse(msg = %{"t" => "CHANNEL_DELETE", "d" => %{"is_private" => true}}) do
    msg =
      msg
      |> update_in(["d", "recipient"], &User.parse/1)

    {:private_delete, msg}
  end

  def parse(msg = %{"t" => "CHANNEL_DELETE", "d" => %{"is_private" => false}}) do
    msg =
      msg
      |> Map.update!("d", &Channel.parse/1)

    {:channel_delete, msg}
  end

  def parse(msg = %{"t" => "MESSAGE_CREATE", "d" => %{"nonce" => _}}) do
    msg =
      msg
      |> Map.update!("d", &Message.parse/1)

    {:message_create, msg}
  end

  def parse(msg = %{"t" => "MESSAGE_UPDATE"}) do
    msg =
      msg
      |> Map.update!("d", &Message.parse/1)

    {:message_update, msg}
  end

  def parse(msg = %{"t" => "MESSAGE_DELETE"}) do
    {:message_delete, msg}
  end

  def parse(msg = %{"t" => "MESSAGE_ACK"}) do
    {:message_ack, msg}
  end

  def parse(msg = %{"t" => "GUILD_CREATE"}) do
    msg =
      msg
      |> Map.update!("d", &Guild.parse/1)

    {:guild_create, msg}
  end

  def parse(msg = %{"t" => "GUILD_UPDATE"}) do
    msg =
      msg
      |> Map.update!("d", &Guild.parse/1)

    {:guild_update, msg}
  end

  def parse(msg = %{"t" => "GUILD_DELETE"}) do
    msg =
      msg
      |> Map.update!("d", &Guild.parse/1)

    {:guild_delete, msg}
  end

  def parse(msg = %{"t" => "GUILD_MEMBER_ADD"}) do
    msg =
      msg
      |> Map.update!("d", &Member.parse/1)

    {:guild_member_add, msg}
  end

  def parse(msg = %{"t" => "GUILD_MEMBER_UPDATE"}) do
    msg =
      msg
      |> Map.update!("d", &Member.parse/1)

    {:guild_member_update, msg}
  end

  def parse(msg = %{"t" => "GUILD_MEMBER_REMOVE"}) do
    msg =
      msg
      |> Map.update!("d", &Member.parse/1)

    {:guild_member_remove, msg}
  end

  def parse(msg = %{"t" => "GUILD_BAN_ADD"}) do
    msg =
      msg
      |> update_in(["d", "user"], &User.parse/1)

    {:guild_ban_add, msg}
  end

  def parse(msg = %{"t" => "GUILD_BAN_REMOVE"}) do
    msg =
      msg
      |> update_in(["d", "user"], &User.parse/1)

    {:guild_ban_remove, msg}
  end

  def parse(msg = %{"t" => "GUILD_ROLE_CREATE"}) do
    msg =
      msg
      |> update_in(["d", "role"], &Role.parse/1)

    {:guild_role_create, msg}
  end

  def parse(msg = %{"t" => "GUILD_ROLE_UPDATE"}) do
    msg =
      msg
      |> update_in(["d", "role"], &Role.parse/1)

    {:guild_role_update, msg}
  end

  def parse(msg = %{"t" => "GUILD_ROLE_DELETE"}) do
    {:guild_role_delete, msg}
  end

  def parse(msg = %{"t" => "USER_UPDATE"}) do
    msg =
      msg
      |> Map.update!("d", &User.parse/1)

    {:user_update, msg}
  end

  def parse(msg) do
    {:unknown, msg}
  end
end
