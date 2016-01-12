defmodule Datcord.API.Channel do
  @moduledoc """
  Discord's Channel API.

  If a token is stored using `Token`, all `token` arguments
  are optional.
  """

  @typedoc """
  Channel struct or channel id.
  """
  @type channel :: String.t | Model.Channel.t

  alias Datcord.{API, Token, Model}

  @type create_params :: %{name: String.t, type: :text | :voice}

  @doc """
  Creates a channel inside the given guild.

  - `guild` can either be a `Guild` or guild id.
  - `params` is a map with the values of `name` and `type`.
    These are both required.
    - `name` must be a string 2-100 characters long.
    - `type` must either be `:text` or `:voice`.
      This is optional.
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.create(guild, %{name: "channel", type: :text})
      {:ok, %Model.Channel{...}}
  """
  @spec create(Model.Guild.t, create_params, Token.maybe) :: API.maybe(Model.Channel.t)
  def create(guild, params, token \\ nil) do
    name = Map.get(params, :name)
    type = Map.get(params, :type, :text)

    url = Model.Guild.url(guild) <> "/channels"
    headers = API.token_header(token)

    with :ok <- validate_channel_name(name),
         :ok <- validate_channel_type(type),
         {:ok, response} <- API.post(url, params, headers),
         do: {:ok, Model.Channel.parse(response.body)}
  end

  @doc """
  Creates a channel inside the given guild.

  - `guild` can either be a `Guild` or guild id.
  - `params` is a map with the values of `name` and `type`.
    These are both required.
    - `name` must be a string 2-100 characters long.
    - `type` must either be `:text` or `:voice`.
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.create!(guild, %{name: "channel", type: :text})
      %Model.Channel{...}
  """
  @spec create!(Model.Guild.t, create_params, Token.maybe) :: Model.Channel.t | no_return
  def create!(guild, params, token \\ nil) do
    case create(guild, params, token) do
      {:ok, channel} -> channel
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @type edit_params :: %{name: String.t, position: integer, topic: String.t}

  @doc """
  Edits a channel's settings.

  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `params` is a map with the values of `name`, `position` and `topic`.
    These params are only optional if a `Channel` struct is used.
    - `name` is the channel name to change to.
      Must be a string 2-100 characters long.
    - `position` is the position in the channel list to change to.
    Must be an int over -1.
    - `topic` is the topic to use for the channel. Must be a string.
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.edit(channel, %{name: "cool-kids"})
      {:ok, %Model.Channel{...}}
  """
  @spec edit(channel, edit_params, Token.maybe) :: API.maybe(Model.Channel.t)
  def edit(channel, params, token \\ nil)
  def edit(channel = %Model.Channel{}, params, token) do
    params = params
    |> Map.put_new(:name, channel.name)
    |> Map.put_new(:position, channel.position)
    |> Map.put_new(:topic, channel.topic)

    edit(channel, params, token)
  end

  def edit(channel, params, token) do
    url = Model.Channel.url(channel)
    headers = API.token_header(token)

    with :ok <- validate_channel_name(params.name),
         :ok <- validate_channel_position(params.position),
         {:ok, response} <- API.patch(url, params, headers),
         do: {:ok, Model.Channel.parse(response.body)}
  end

  @doc """
  Edits a channel's settings.

  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `params` is a map with the values of `name`, `position` and `topic`.
    These params are only optional if a `Channel` struct is used.
    - `name` is the channel name to change to.
      Must be a string 2-100 characters long.
    - `position` is the position in the channel list to change to.
      Must be an int over -1.
    - `topic` is the topic to use for the channel. Must be a string.
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.edit!(channel, %{name: "cool-kids"})
      %Model.Channel{...}
  """
  @spec edit!(Model.Channel.t, edit_params, Token.maybe) :: Model.Channel.t | no_return
  def edit!(channel, params, token \\ nil) do
    case edit(channel, params, token) do
      {:ok, channel} -> channel
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Deletes a channel.

  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.delete(channel)
      {:ok, %Model.Channel{...}}
  """
  @spec delete(Model.Channel.t, Token.maybe) :: API.maybe(Model.Channel.t)
  def delete(channel, token \\ nil) do
    url = Model.Channel.url(channel)
    headers = API.token_header(token)

    with {:ok, response} <- API.delete(url, headers),
         do: {:ok, Model.Channel.parse(response.body)}
  end

  @doc """
  Deletes a channel.

  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.delete!(channel)
      API.Channel{...}
  """
  @spec delete!(Model.Channel.t, Token.maybe) :: Model.Channel.t | no_return
  def delete!(channel, token \\ nil) do
    case delete(channel, token) do
      {:ok, channel} -> channel
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Broadcasts to a channel that this user is currently typing.

  The typing notification lasts for 5 seconds.

  - `channel` can either be a `Channel` struct or the channel's id (string).
  - `token` is the API token to use. This is optional if `Token` is used.

  ## Example

      iex> API.Channel.broadcast_typing(channel)
      :ok
  """
  @spec broadcast_typing(Model.Channel.t, Token.maybe) :: :ok | {:error, any}
  def broadcast_typing(channel, token \\ nil) do
    url = Model.Channel.url(channel) <> "/typing"
    headers = API.token_header(token)

    case API.post(url, %{}, headers) do
      {:ok, _response} -> :ok
      {:error, error} -> {:error, error}
    end
  end


  @spec validate_channel_name(String.t) :: :ok | {:error, :invalid_channel_name}
  defp validate_channel_name(name) do
    if Regex.match?(~r/^[a-z0-9\-]{2,100}$/i, name) do
      :ok
    else
      {:error, :invalid_channel_name}
    end
  end

  @spec validate_channel_type(any) :: :ok | {:error, :invalid_channel_type}
  defp validate_channel_type(type) when type in [:text, :voice], do: :ok
  defp validate_channel_type(_type), do: {:error, :invalid_channel_type}

  @spec validate_channel_position(any) :: :ok
                                        | {:error, :invalid_channel_position}
  defp validate_channel_position(pos) when is_integer(pos) and pos >= -1, do: :ok
  defp validate_channel_position(_pos), do: {:error, :invalid_channel_position}
end
