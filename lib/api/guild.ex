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

  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.create("Nice server", token)
      {:ok, DiscordElixir.API.Guild{...}}
  """
  def create(name, token) when is_binary(name) do
    with :ok <- validate_name_length(name),
         headers = API.token_header(token),
         {:ok, response} <- API.post(guild_url, %{name: name}, headers),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Creates a guild using the given name.

  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.create!("Nice server", token)
      DiscordElixir.API.Guild{...}
  """
  def create!(name, token) do
    {:ok, guild} = create(name, token)
    guild
  end

  @doc """
  Changes the given guild's name.

  `guild` can either be a `Guild` struct or the guild's id (string).
  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.edit("123", token, "New name")
      {:ok, DiscordElixir.API.Guild{...}}
  """
  def edit(guild, token, name) when is_binary(name) do
    with :ok <- validate_name_length(name),
         headers = API.token_header(token),
         url = guild |> guild_url,
         {:ok, response} <- API.patch(url, %{name: name}, headers),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Changes the given guild's name.

  `guild` can either be a `Guild` struct or the guild's id (string).
  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.edit!("123", token, "New name")
      DiscordElixir.API.Guild{...}
  """
  def edit!(guild, token, name) when is_binary(name) do
    {:ok, guild} = edit(guild, name, token)
    guild
  end

  @doc """
  Deletes the given guild.

  `guild` can either be a `Guild` struct or the guild's id (string).
  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.delete("123", token)
      {:ok, DiscordElixir.API.Guild{...}}
  """
  def delete(guild, token) do
    with url = guild |> guild_url,
         headers = API.token_header(token),
         {:ok, response} <- API.delete(url, headers),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Deletes the given guild.

  `guild` can either be a `Guild` struct or the guild's id (string).
  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.delete!("123", token)
      DiscordElixir.API.Guild{...}
  """
  def delete!(guild, token) do
    {:ok, guild} = delete(guild, token)
    guild
  end

  @doc """
  Gets all guilds this user is currently in.

  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Guild.guilds(token)
      {:ok, [DiscordElixir.API.Guild{...}, ...]}
  """
  def guilds(token) do
    headers = API.token_header(token)
    with {:ok, response} <- API.get("/users/@me/guilds", headers),
         guilds = Enum.map(response.body, &parse/1),
         do: {:ok, guilds}
  end

  @doc """
  Gets all guilds this user is currently in.

  ## Example

      iex> DiscordElixir.API.Guild.guilds!(token)
      [DiscordElixir.API.Guild{...}, ...]
  """
  def guilds!(token) do
    {:ok, guilds} = guilds(token)
    guilds
  end

  def guild_url, do: "/guilds"
  def guild_url(%Guild{id: id}), do: guild_url(id)
  def guild_url(guild_id), do: guild_url <> "/" <> to_string(guild_id)

  defp validate_name_length(name) do
    case String.length(name) do
      x when x < 2 -> {:error, :too_short}
      x when x > 100 -> {:error, :too_long}
      _ -> :ok
    end
  end

  def parse(guild) do
    guild = for {key, val} <- guild, into: %{} do
      {String.to_existing_atom(key), val}
    end
    Map.put_new(guild, :__struct__, Guild)
  end
end
