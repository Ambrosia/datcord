defmodule DiscordElixir.API.Guild do
  @moduledoc """
  Discord's Guilds API.

  Guilds are referred to as servers everywhere else.
  """

  defstruct afk_channel_id: nil, afk_timeout: 300, embed_channel_id: nil,
  embed_enabled: false, emojis: [], features: [], icon: nil, id: nil,
  joined_at: nil, name: nil, owner_id: nil, region: nil, roles: [], splash: nil

  alias DiscordElixir.API
  alias __MODULE__, as: Guild

  @doc """
  Creates a guild using the given name.

  ## Example

      iex> DiscordElixir.API.Guild.create("Nice server")
      {:ok, DiscordElixir.API.Guild{...}}
  """
  def create(name) when is_binary(name) do
    with :ok <- validate_name_length(name),
         {:ok, response} <- API.post(guild_url, %{name: name}),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Creates a guild using the given name.

  ## Example

      iex> DiscordElixir.API.Guild.create!("Nice server")
      DiscordElixir.API.Guild{...}
  """
  def create!(name) do
    {:ok, guild} = create(name)
    guild
  end

  @doc """
  Changes the given guild's name.

  The guild can either be a `Guild` struct or the guild's id (string).

  ## Example

      iex> DiscordElixir.API.Guild.edit("123", "New name")
      {:ok, DiscordElixir.API.Guild{...}}
  """
  def edit(guild, name) when is_binary(name) do
    with :ok <- validate_name_length(name),
         url = guild |> guild_url,
         {:ok, response} <- API.patch(url, %{name: name}),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Changes the given guild's name.

  The guild can either be a `Guild` struct or the guild's id (string).

  ## Example

      iex> DiscordElixir.API.Guild.edit!("123", "New name")
      DiscordElixir.API.Guild{...}
  """
  def edit!(guild, name) when is_binary(name) do
    {:ok, guild} = edit(guild, name)
    guild
  end

  @doc """
  Deletes the given guild.

  The guild can either be a `Guild` struct or the guild's id (string).

  ## Example

      iex> DiscordElixir.API.Guild.delete("123")
      {:ok, DiscordElixir.API.Guild{...}}
  """
  def delete(guild) do
    with url = guild |> guild_url,
         {:ok, response} <- API.delete(url),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Deletes the given guild.

  The guild can either be a `Guild` struct or the guild's id (string).

  ## Example

      iex> DiscordElixir.API.Guild.delete!("123")
      DiscordElixir.API.Guild{...}
  """
  def delete!(guild) do
    {:ok, guild} = delete(guild)
    guild
  end

  @doc """
  Gets all guilds this user is currently in.

  ## Example

      iex> DiscordElixir.API.Guild.guilds
      {:ok, [DiscordElixir.API.Guild{...}, ...]}
  """
  def guilds do
    with {:ok, response} <- API.get("/users/@me/guilds"),
         guilds = Enum.map(response.body, &parse/1),
         do: {:ok, guilds}
  end

  @doc """
  Gets all guilds this user is currently in.

  ## Example

      iex> DiscordElixir.API.Guild.guilds!
      [DiscordElixir.API.Guild{...}, ...]
  """
  def guilds! do
    {:ok, guilds} = guilds
    guilds
  end

  def guild_url, do: "/guilds"
  def guild_url(%Guild{id: id}), do: guild_url <> "/" <> id
  def guild_url(guild_id), do: guild_url <> "/" <> to_string(guild_id)

  defp validate_name_length(name) do
    case String.length(name) do
      x when x < 2 -> {:error, :too_short}
      x when x > 100 -> {:error, :too_long}
      _ -> :ok
    end
  end

  defp parse(guild) do
    guild = for {key, val} <- guild, into: %{} do
      {String.to_existing_atom(key), val}
    end
    Map.put_new(guild, :__struct__, Guild)
  end
end
