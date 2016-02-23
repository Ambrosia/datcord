defmodule Datcord.API.Channel do
  @moduledoc """
  Discord's Channel API.
  """

  @typedoc """
  Channel struct or channel id.
  """
  @type channel :: String.t | Model.Channel.t

  alias Datcord.{API, Model}

  @type create_params :: %{name: String.t, type: :text | :voice}

  @doc """
  Creates a channel inside the given guild.

  - `token` is the API token to use.
  - `guild` can either be a `Guild` or guild id.
  - `params` is a map with the values of `name` and `type`.
    These are both required.
    - `name` must be a string 2-100 characters long.
    - `type` must either be `:text` or `:voice`. This is optional.

  ## Example

      iex> API.Channel.create("abc", guild, %{name: "channel", type: :text})
      {:ok, %Model.Channel{...}}
  """
  @spec create(String.t, Model.Guild.t, create_params) :: API.maybe(Model.Channel.t)
  def create(token, guild, params) do
    name = Map.get(params, :name)
    type = Map.get(params, :type, :text)

    url = Model.Guild.url(guild) <> "/channels"
    headers = API.token_header(token)

    with {:ok, response} <- API.post(url, params, headers),
         do: {:ok, Model.Channel.parse(response.body)}
  end

  @doc """
  Creates a channel inside the given guild.

  - `token` is the API token to use.
  - `guild` can either be a `Guild` or guild id.
  - `params` is a map with the values of `name` and `type`.
    These are both required.
    - `name` must be a string 2-100 characters long.
    - `type` must either be `:text` or `:voice`.

  ## Example

      iex> API.Channel.create!("abc", guild, %{name: "channel", type: :text})
      %Model.Channel{...}
  """
  @spec create!(String.t, Model.Guild.t, create_params) :: Model.Channel.t | no_return
  def create!(token, guild, params) do
    case create(token, guild, params) do
      {:ok, channel} -> channel
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @type edit_params :: %{name: String.t, position: integer, topic: String.t}

  @doc """
  Edits a channel's settings.

  - `token` is the API token to use.
  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `params` is a map with the values of `name`, `position` and `topic`.
    These params are only optional if a `Channel` struct is used.
    - `name` is the channel name to change to.
      Must be a string 2-100 characters long.
    - `position` is the position in the channel list to change to.
    Must be an int over -1.
    - `topic` is the topic to use for the channel. Must be a string.

  ## Example

      iex> API.Channel.edit("abc", channel, %{name: "cool-kids"})
      {:ok, %Model.Channel{...}}
  """
  @spec edit(String.t, channel, edit_params) :: API.maybe(Model.Channel.t)
  def edit(token, channel, params)
  def edit(token, channel = %Model.Channel{}, params) do
    params = params
    |> Map.put_new(:name, channel.name)
    |> Map.put_new(:position, channel.position)
    |> Map.put_new(:topic, channel.topic)

    edit(token, channel, params)
  end

  def edit(token, channel, params) do
    url = Model.Channel.url(channel)
    headers = API.token_header(token)

    with {:ok, response} <- API.patch(url, params, headers),
         do: {:ok, Model.Channel.parse(response.body)}
  end

  @doc """
  Edits a channel's settings.

  - `token` is the API token to use.
  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `params` is a map with the values of `name`, `position` and `topic`.
    These params are only optional if a `Channel` struct is used.
    - `name` is the channel name to change to.
      Must be a string 2-100 characters long.
    - `position` is the position in the channel list to change to.
      Must be an int over -1.
    - `topic` is the topic to use for the channel. Must be a string.

  ## Example

      iex> API.Channel.edit!("abc", channel, %{name: "cool-kids"})
      %Model.Channel{...}
  """
  @spec edit!(String.t, Model.Channel.t, edit_params) :: Model.Channel.t | no_return
  def edit!(token, channel, params) do
    case edit(token, channel, params) do
      {:ok, channel} -> channel
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Deletes a channel.

  - `token` is the API token to use.
  - `channel` can either be a `Channel` struct or the channel's id (string).

  ## Example

      iex> API.Channel.delete("abc", channel)
      {:ok, %Model.Channel{...}}
  """
  @spec delete(String.t, Model.Channel.t) :: API.maybe(Model.Channel.t)
  def delete(token, channel) do
    url = Model.Channel.url(channel)
    headers = API.token_header(token)

    with {:ok, response} <- API.delete(url, headers),
         do: {:ok, Model.Channel.parse(response.body)}
  end

  @doc """
  Deletes a channel.

  - `token` is the API token to use.
  - `channel` can either be a `Channel` struct or the channel's id (string).

  ## Example

      iex> API.Channel.delete!("abc", channel)
      API.Channel{...}
  """
  @spec delete!(String.t, Model.Channel.t) :: Model.Channel.t | no_return
  def delete!(token, channel) do
    case delete(token, channel) do
      {:ok, channel} -> channel
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Broadcasts to a channel that this user is currently typing.

  The typing notification lasts for 5 seconds.

  - `token` is the API token to use.
  - `channel` can either be a `Channel` struct or the channel's id (string).

  ## Example

      iex> API.Channel.broadcast_typing("abc", channel)
      :ok
  """
  @spec broadcast_typing(String.t, Model.Channel.t) :: :ok | {:error, any}
  def broadcast_typing(token, channel) do
    url = Model.Channel.url(channel) <> "/typing"
    headers = API.token_header(token)

    case API.post(url, %{}, headers) do
      {:ok, _response} -> :ok
      {:error, error} -> {:error, error}
    end
  end
end
