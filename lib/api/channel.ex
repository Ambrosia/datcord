defmodule DiscordElixir.API.Channel do
  defstruct guild_id: nil, id: nil, is_private: false,
  last_message_id: nil, name: nil, permission_overwrites: [], position: nil,
  topic: nil, type: nil

  alias DiscordElixir.API
  alias __MODULE__, as: Channel

  @doc """
  Creates a channel inside the given guild.

  `guild` can either be a `Guild` or guild id.
  `position` is a map with the values of `name` and `type`. These are both required.
  `name` must be a string 2-100 characters long.
  `type` must either be `:text` or `:voice`.

  ## Example

      iex> DiscordElixir.API.Channel.create(guild, %{name: "channel", type: :text})
      {:ok, DiscordElixir.API.Channel{...}}
  """
  def create(guild, params) do
    with :ok <- validate_create_params(params),
         url = API.Guild.guild_url(guild) <> "/channels",
         {:ok, response} <- API.post(url, params),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Creates a channel inside the given guild.

  `guild` can either be a `Guild` or guild id.
  `position` is a map with the values of `name` and `type`.
  `name` must be a string 2-100 characters long.
  `type` must either be `:text` or `:voice`.

  ## Example

      iex> DiscordElixir.API.Channel.create!(guild, %{name: "channel", type: :text})
      DiscordElixir.API.Channel{...}
  """
  def create!(guild, params) do
    {:ok, channel} = create(guild, params)
    channel
  end

  @doc """
  Edits a channel's settings.

  `channel` can either be a `Channel` struct or the channel's id (string).
  `params` is a map with the values of `name`, `position` and `topic`. These params are only optional if a `Channel` struct is used.
  `name` is the channel name to change to. Must be a string 2-100 characters long.
  `position` is the position in the channel list to change to. Must be an int over -1.
  `topic` is the topic to use for the channel. Must be a string.

  ## Example

      iex> DiscordElixir.API.Channel.edit(channel, %{name: "cool-kids"})
      {:ok, DiscordElixir.API.Channel{...}}
  """
  def edit(channel, params) do
    params = fill_edit_params(channel, params)
    with :ok <- validate_edit_params(params),
         url = channel |> channel_url,
         {:ok, response} <- API.patch(url, params),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Edits a channel's settings.

  `channel` can either be a `Channel` struct or the channel's id (string).
  `params` is a map with the values of `name`, `position` and `topic`. These params are only optional if a `Channel` struct is used.
  `name` is the channel name to change to. Must be a string 2-100 characters long.
  `position` is the position in the channel list to change to. Must be an int over -1.
  `topic` is the topic to use for the channel. Must be a string.

  ## Example

      iex> DiscordElixir.API.Channel.edit!(channel, %{name: "cool-kids"})
      DiscordElixir.API.Channel{...}
  """
  def edit!(channel, params) do
    {:ok, channel} = edit(channel, params)
    channel
  end

  @doc """
  Deletes a channel.

  `channel` can either be a `Channel` struct or the channel's id (string).

  ## Example

      iex> DiscordElixir.API.Channel.delete(channel)
      {:ok, DiscordElixir.API.Channel{...}}
  """
  def delete(channel) do
    url = channel |> channel_url
    with {:ok, response} <- API.delete(url),
         do: {:ok, parse(response.body)}
  end

  @doc """
  Deletes a channel.

  `channel` can either be a `Channel` struct or the channel's id (string).

  ## Example

      iex> DiscordElixir.API.Channel.delete!(channel)
      DiscordElixir.API.Channel{...}
  """
  def delete!(channel) do
    {:ok, channel} = delete(channel)
    channel
  end

  @doc """
  Broadcasts to a channel that this user is currently typing.

  The typing notification lasts for 5 seconds.

  ## Example

      iex> DiscordElixir.API.Channel.broadcast_typing(channel)
      :ok
  """
  def broadcast_typing(channel) do
    url = channel |> channel_url
    API.post(url <> "/typing", :empty)
    with {:ok, _response} <- API.post(url <> "/typing", :empty),
         do: :ok
  end

  def channel_url, do: "/channels"
  def channel_url(%Channel{id: id}), do: channel_url(id)
  def channel_url(channel_id), do: channel_url <> "/" <> to_string(channel_id)

  defp validate_channel_name(name) do
    case Regex.match?(~r/^[a-z0-9\-]{2,100}$/i, name) do
      true -> :ok
      false -> {:error, :invalid_channel_name}
    end
  end

  defp validate_channel_type(type) when type in [:text, :voice], do: :ok
  defp validate_channel_type(_type), do: {:error, :invalid_channel_type}

  defp validate_channel_position(pos) when is_integer(pos) and pos >= -1, do: :ok
  defp validate_channel_position(_pos), do: {:error, :invalid_channel_position}

  defp validate_create_params(params) do
    with :ok <- validate_channel_name(params.name),
         :ok <- validate_channel_type(params.type),
         do: :ok
  end

  defp validate_edit_params(params) do
    with :ok <- validate_channel_name(params.name),
         :ok <- validate_channel_position(params.position),
         do: :ok
  end

  defp fill_edit_params(channel = %Channel{}, params) do
    params
    |> Map.put_new(:name, channel.name)
    |> Map.put_new(:position, channel.position)
    |> Map.put_new(:topic, channel.topic)
  end

  defp fill_edit_params(_channel, params), do: params

  def parse(channel) do
    channel = for {key, val} <- channel, into: %{} do
      {String.to_existing_atom(key), val}
    end
    Map.put_new(channel, :__struct__, Channel)
  end
end