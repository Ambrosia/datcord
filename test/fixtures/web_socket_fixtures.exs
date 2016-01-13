defmodule Datcord.Fixtures.WebSocketMessages do
  def ready do
    %{"t" => "READY",
      "s" => 1,
      "op" => 0,
      "d" => %{"v" => 3,
               "user_settings" => %{"theme" => "light",
                                    "show_current_game" => true,
                                    "render_embeds" => true,
                                    "muted_channels" => [],
                                    "message_display_compact" => false,
                                    "locale" => "en",
                                    "inline_embed_media" => true,
                                    "inline_attachment_media" => true,
                                    "enable_tts_command" => true,
                                    "convert_emoticons" => true},
               "user_guild_settings" => [%{"supress_everyone" => false,
                                           "muted" => false,
                                           "mobile_push" => true,
                                           "message_notifications" => 1,
                                           "guild_id" => "11122233344455566",
                                           "channel_overrides" => []}],
               "user" => %{"verified" => true,
                           "username" => "Test Account",
                           "id" => "11122233344455566",
                           "email" => "discordbot@ironboots.net",
                           "discriminator" => "1234",
                           "avatar" => "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1"},
               "session_id" => "aaaabbbbccccddddeeeeffffgggghhhh",
               "read_state" => [%{"mention_count" => 0,
                                  "last_message_id" => "11122233344455566",
                                  "id" => "11122233344455566"}],
               "private_channels" => [%{"recipient" => %{"username" => "Other Test Account",
                                                         "id" => "11122233344455566",
                                                         "discriminator" => "1234",
                                                         "avatar" => "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1"},
                                        "last_message_id" => "11122233344455566",
                                        "is_private" => true,
                                        "id" => "11122233344455566"}],
               "heartbeat_interval" => 41250,
               "guilds" => [%{"voice_states" => [%{"user_id" => "11122233344455566",
                                                   "supress" => true,
                                                   "session_id" => "aaaabbbbccccddddeeeeffffgggghhhh",
                                                   "self_mute" => false,
                                                   "self_deaf" => false,
                                                   "mute" => false,
                                                   "deaf" => false,
                                                   "channel_id" => "11122233344455566"}],
                              "splash" => nil,
                              "roles" => [%{"position" => 1,
                                            "permissions" => 36953089,
                                            "name" => "@everyone",
                                            "managed" => false,
                                            "id" => "11122233344455566",
                                            "hoist" => false,
                                            "color" => 0}],
                              "region" => "us-east",
                              "presences" => [%{"user" => %{"id" => "11122233344455566"},
                                                "status" => "online",
                                                "game" => nil}],
                              "owner_id" => "11122233344455566",
                              "name" => "Example Server",
                              "members" => [%{"user" => %{"username" => "Test Account",
                                                          "id" => "11122233344455566",
                                                          "discriminator" => "1234",
                                                          "avatar" => "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1"},
                                              "roles" => ["11122233344455566"],
                                              "mute" => false,
                                              "joined_at" => "2015-12-25T19: 30: 47.982000+00: 00",
                                              "deaf" => false}],
                              "large" => false,
                              "joined_at" => "2015-12-25T19: 30: 47.982000+00: 00",
                              "id" => "11122233344455566",
                              "icon" => nil,
                              "features" => [],
                              "emojis" => [],
                              "channels" => [%{"type" => "text",
                                               "topic" => "Test Text Channel",
                                               "position" => 0,
                                               "permission_overwrites" => [%{"type" => "role",
                                                                             "id" => "11122233344455566",
                                                                             "deny" => 36864,
                                                                             "allow" => 0}],
                                               "name" => "general",
                                               "last_message_id" => "1112223334445556666",
                                               "id" => "11122233344455566"},
                                             %{"type" => "voice",
                                               "topic" => "",
                                               "position" => 0,
                                               "permission_overwrites" => [],
                                               "name" => "Test Voice Channel",
                                               "last_message_id" => nil,
                                               "id" => "111222333444555667"},
                                             %{"type" => "voice",
                                               "topic" => "",
                                               "position" => 0,
                                               "permission_overwrites" => [%{"type" => "role",
                                                                             "id" => "1112223334445556666",
                                                                             "deny" => 65011737,
                                                                             "allow" => 0}],
                                               "name" => "Test AFK channel",
                                               "last_message_id" => nil,
                                               "id" => "111222333444555670"}],
                              "afk_timeout" => 300,
                              "afk_channel_id" => "111222333444555670"}]}}
  end

  defp channel_format do
    %{"guild_id" => "111222333444555666",
      "name" => "some name",
      "permission_overwrites" => [],
      "topic" => "some topic",
      "position" => 2,
      "last_message_id" => nil,
      "type" => "text",
      "id" => "111222333444555666",
      "is_private" => false}
  end

  def private_create do
    %{"t" => "MESSAGE_CREATE",
      "s" => 1,
      "op" => 0,
      "d" => %{"recipient" => %{"username" => "test user",
                                "id" => "1111222233334444555666",
                                "discriminator" => "1234",
                                "avatar" => "..."},
               "last_message_id" => nil,
               "is_private" => true,
               "id" => "11112222333344445555666"}}
  end

  def channel_create do
    %{"t" => "MESSAGE_CREATE",
      "s" => 1,
      "op" => 0,
      "d" => channel_format}
  end

  def channel_update do
    %{"t" => "CHANNEL_UPDATE",
      "s" => 1,
      "op" => 0,
      "d" => channel_format}
  end

  def private_delete do
    %{"t" => "CHANNEL_DELETE",
      "s" => 1,
      "op" => 0,
      "d" => %{"recipient" => %{"username" => "test user",
                                "id" => "1111222233334444555666",
                                "discriminator" => "1234",
                                "avatar" => "..."},
               "last_message_id" => nil,
               "is_private" => true,
               "id" => "11112222333344445555666"}}
  end

  def channel_delete do
    %{"t" => "CHANNEL_DELETE",
      "s" => 1,
      "op" => 0,
      "d" => channel_format}
  end

  defp message_format do
    %{"nonce" => "1453949470692605952",
      "attachments" => [],
      "tts" => false,
      "embeds" => [],
      "timestamp" => "2015-10-07T20:12:45.743000+00:00",
      "mention_everyone" => false,
      "id" => "111222333444555666",
      "edited_timestamp" => nil,
      "author" => %{"username" => "Test Account",
                    "discriminator" => "1234",
                    "id" => "111222333444555666",
                    "avatar" => "31171c07640015bbc5aed21b28ea2408"},
      "content" => "I'm a test message~",
      "channel_id" => "81384788765712384",
      "mentions" => []}
  end

  def message_create do
    %{"t" => "MESSAGE_CREATE",
      "s" => 1,
      "op" => 0,
      "d" => message_format}
  end

  def message_update do
    %{"t" => "MESSAGE_UPDATE",
      "s" => 1,
      "op" => 0,
      "d" => message_format}
  end

  def message_delete do
    %{"t" => "MESSAGE_DELETE",
      "s" => 1,
      "op" => 0,
      "d" => %{"id" => "111222333444555666",
               "channel_id" => "111222333444555666"}}
  end

  def message_ack do
    %{"t" => "MESSAGE_ACK",
      "s" => 1,
      "op" => 0,
      "d" => %{"message_id" => "101739512769544192",
               "channel_id" => "81385020756865024"}}
  end

  defp guild_format do
    %{"features" => [],
      "afk_timeout" => 300,
      "joined_at" => "2012-12-21T12:34:56.789012+00:00",
      "afk_channel_id" => nil,
      "id" => "111222333444555666",
      "icon" => nil,
      "name" => "Name",
      "roles" => [%{"managed" => false,
                    "name" => "@everyone",
                    "color" => 0,
                    "hoist" => false,
                    "position" => -1,
                    "id" => "111222333444555666",
                    "permissions" => 12345678}],
      "region" => "us-west",
      "embed_channel_id" => nil,
      "embed_enabled" => false,
      "splash" => nil,
      "emojis" => [],
      "owner_id" => "111222333444555666"}
  end

  defp member_format do
    %{"user" => %{"username" => "test user",
                  "id" => "111222333444555666",
                  "discriminator" => "1234",
                  "avatar" => nil},
      "roles" => [],
      "joined_at" => "2016-01-02T16:14:21.451424+00:00",
      "guild_id" => "111222333444555666"}
  end

  def guild_create do
    %{"t" => "GUILD_CREATE",
      "s" => 1,
      "op" => 0,
      "d" => guild_format}
  end

  def guild_update do
    %{"t" => "GUILD_UPDATE",
      "s" => 1,
      "op" => 0,
      "d" => guild_format}
  end

  def guild_delete do
    %{"t" => "GUILD_DELETE",
      "s" => 1,
      "op" => 0,
      "d" => guild_format}
  end

  def guild_member_add do
    %{"t" => "GUILD_MEMBER_ADD",
      "s" => 1,
      "op" => 0,
      "d" => member_format}
  end

  def guild_member_update do
    %{"t" => "GUILD_MEMBER_UPDATE",
      "s" => 1,
      "op" => 0,
      "d" => member_format}
  end

  def guild_member_remove do
    %{"t" => "GUILD_MEMBER_REMOVE",
      "s" => 1,
      "op" => 0,
      "d" => member_format}
  end

  def guild_ban_add do
    %{"t" => "GUILD_BAN_ADD",
      "s" => 1,
      "op" => 0,
      "d" => %{"user" => %{"username" => "test user",
                           "id" => "111222333444555666",
                           "discriminator" => "1234",
                           "avatar" => nil},
               "guild_id" => "111222333444555666"}}
  end

  def guild_ban_remove do
    %{"t" => "GUILD_BAN_REMOVE",
      "s" => 1,
      "op" => 0,
      "d" => %{"user" => %{"username" => "test user",
                           "id" => "111222333444555666",
                           "discriminator" => "1234",
                           "avatar" => nil},
               "guild_id" => "111222333444555666"}}
  end

  defp role_format do
    %{"color" => 0,
      "hoist" => false,
      "id" => "111222333444555666",
      "managed" => false,
      "name" => "new role",
      "permissions" => 36953089,
      "position" => 2}
  end

  def guild_role_create do
    %{"t" => "GUILD_ROLE_CREATE",
      "s" => 1,
      "op" => 0,
      "d" => %{"role" => role_format,
               "guild_id" => "111222333444555666"}}
  end

  def guild_role_update do
    %{"t" => "GUILD_ROLE_UPDATE",
      "s" => 1,
      "op" => 0,
      "d" => %{"role" => role_format,
               "guild_id" => "111222333444555666"}}
  end

  def guild_role_delete do
    %{"t" => "GUILD_ROLE_DELETE",
      "s" => 1,
      "op" => 0,
      "d" => %{"role_id" => "111222333444555666",
               "guild_id" => "111222333444555666"}}
  end

  def user_update do
    %{"t" => "USER_UPDATE",
      "s" => 1,
      "op" => 0,
      "d" => %{"verified" => true,
               "username" => "Something",
               "id" => "11122233344455566",
               "email" => "email@example.com",
               "discriminator" => "1234",
               "avatar" => "a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1"}}
  end
end
