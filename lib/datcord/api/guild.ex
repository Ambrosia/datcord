defmodule Datcord.API.Guild do
  @moduledoc """
  Discord's Guild API.

  Guilds are referred to as servers everywhere else.
  """

  @typedoc """
  Guild struct or channel id.
  """
  @type guild :: String.t | Model.Guild.t

  alias Datcord.{API, Model}

  @doc """
  Creates a guild using the given name.

  - `token` is the API token to use.

  ## Example

      iex> API.Guild.create("abc", "Nice server")
      {:ok, %Model.Guild{...}}
  """
  @spec create(String.t, String.t) :: API.maybe(Model.Guild.t)
  def create(token, name) when is_binary(name) do
    headers = API.token_header(token)

    with {:ok, response} <- API.post(Model.Guild.url, %{name: name}, headers),
         do: {:ok, Model.Guild.parse(response.body)}
  end

  @doc """
  Creates a guild using the given name.

  - `token` is the API token to use.
  - `name` is the name to use for the guild.

  ## Example

      iex> API.Guild.create!("abc", "Nice server")
      %Model.Guild{...}
  """
  @spec create!(String.t, String.t) :: Model.Guild.t | no_return
  def create!(token, name) do
    case create(token, name) do
      {:ok, guild} -> guild
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Changes the given guild's name.

  - `token` is the API token to use.
  - `guild` can either be a `Guild` struct or the guild's id (string).
  - `name` is the guild's new name.

  ## Example

      iex> API.Guild.edit("abc", "123", "New name")
      {:ok, %Model.Guild{...}}
  """
  @spec edit(String.t, guild, String.t) :: API.maybe(Model.Guild.t)
  def edit(token, guild, name) when is_binary(name) do
    url = Model.Guild.url(guild)
    headers = API.token_header(token)

    with {:ok, response} <- API.patch(url, %{name: name}, headers),
         do: {:ok, Model.Guild.parse(response.body)}
  end

  @doc """
  Changes the given guild's name.

  - `token` is the API token to use.
  - `guild` can either be a `Guild` struct or the guild's id (string).

  ## Example

      iex> API.Guild.edit!("abc", "123", "New name")
      %Model.Guild{...}
  """
  @spec edit!(Stirng.t, guild, String.t) :: Model.Guild.t | no_return
  def edit!(token, guild, name) when is_binary(name) do
    case edit(token, guild, name) do
      {:ok, guild} -> guild
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Deletes the given guild.

  - `guild` can either be a `Guild` struct or the guild's id (string).
  - `token` is the API token to use.

  ## Example

      iex> API.Guild.delete("abc", "123")
      {:ok, %Model.Guild{...}}
  """
  @spec delete(String.t, guild) :: API.maybe(Model.Guild.t)
  def delete(token, guild) do
    url = Model.Guild.url(guild)
    headers = API.token_header(token)

    with {:ok, response} <- API.delete(url, headers),
         do: {:ok, Model.Guild.parse(response.body)}
  end

  @doc """
  Deletes the given guild.

  - `guild` can either be a `Guild` struct or the guild's id (string).
  - `token` is the API token to use.

  ## Example

      iex> API.Guild.delete!("abc", "123")
      %Model.Guild{...}
  """
  @spec delete!(String.t, guild) :: Model.Guild.t | no_return
  def delete!(token, guild) do
    case delete(token, guild) do
      {:ok, guild} -> guild
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Gets all guilds this user is currently in.

  - `token` is the API token to use.

  ## Example

      iex> API.Guild.guilds("abc")
      {:ok, [%Model.Guild{...}, ...]}
  """
  @spec guilds(String.t) :: API.maybe([Model.Guild.t])
  def guilds(token) do
    headers = API.token_header(token)

    with {:ok, response} <- API.get("/users/@me/guilds", headers),
         user_guilds = Model.Guild.parse(response.body),
         do: {:ok, user_guilds}
  end

  @doc """
  Gets all guilds this user is currently in.

  - `token` is the API token to use.

  ## Example

      iex> API.Guild.guilds!("abc")
      [%Model.Guild{...}, ...]
  """
  @spec guilds!(String.t) :: [Model.Guild.t] | no_return
  def guilds!(token) do
    case guilds(token) do
      {:ok, user_guilds} -> user_guilds
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end
end
