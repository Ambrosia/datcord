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

      iex> API.Guild.create("Nice server", "abc")
      {:ok, %Model.Guild{...}}
  """
  @spec create(String.t, String.t) :: API.maybe(Model.Guild.t)
  def create(name, token) when is_binary(name) do
    headers = API.token_header(token)

    with :ok <- validate_name_length(name),
         {:ok, response} <- API.post(Model.Guild.url, %{name: name}, headers),
         do: {:ok, Model.Guild.parse(response.body)}
  end

  @doc """
  Creates a guild using the given name.

  - `name` is the name to use for the guild.
  - `token` is the API token to use.

  ## Example

      iex> API.Guild.create!("Nice server", "abc")
      %Model.Guild{...}
  """
  @spec create!(String.t, String.t) :: Model.Guild.t | no_return
  def create!(name, token) do
    case create(name, token) do
      {:ok, guild} -> guild
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Changes the given guild's name.

  - `guild` can either be a `Guild` struct or the guild's id (string).
  - `name` is the guild's new name.
  - `token` is the API token to use.

  ## Example

      iex> API.Guild.edit("123", "New name", "abc")
      {:ok, %Model.Guild{...}}
  """
  @spec edit(guild, String.t, String.t) :: API.maybe(Model.Guild.t)
  def edit(guild, name, token) when is_binary(name) do
    url = Model.Guild.url(guild)
    headers = API.token_header(token)

    with :ok <- validate_name_length(name),
         {:ok, response} <- API.patch(url, %{name: name}, headers),
         do: {:ok, Model.Guild.parse(response.body)}
  end

  @doc """
  Changes the given guild's name.

  - `guild` can either be a `Guild` struct or the guild's id (string).
  - `token` is the API token to use.

  ## Example

      iex> API.Guild.edit!("123", "New name", "abc")
      %Model.Guild{...}
  """
  @spec edit!(guild, String.t, String.t) :: Model.Guild.t | no_return
  def edit!(guild, name, token) when is_binary(name) do
    case edit(guild, name, token) do
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

      iex> API.Guild.delete("123", "abc")
      {:ok, API.Guild{...}}
  """
  @spec delete(guild, String.t) :: API.maybe(Model.Guild.t)
  def delete(guild, token) do
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

      iex> API.Guild.delete!("123", "abc")
      API.Guild{...}
  """
  @spec delete!(guild, String.t) :: Model.Guild.t | no_return
  def delete!(guild, token) do
    case delete(guild, token) do
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
      {:ok, [API.Guild{...}, ...]}
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
      [API.Guild{...}, ...]
  """
  @spec guilds!(String.t) :: [Model.Guild.t] | no_return
  def guilds!(token) do
    case guilds(token) do
      {:ok, user_guilds} -> user_guilds
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @spec validate_name_length(String.t) :: :ok | {:error, :too_short | :too_long}
  defp validate_name_length(name) do
    case String.length(name) do
      x when x < 2 -> {:error, :too_short}
      x when x > 100 -> {:error, :too_long}
      _ -> :ok
    end
  end
end
