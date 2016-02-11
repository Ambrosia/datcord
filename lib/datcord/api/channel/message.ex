defmodule Datcord.API.Channel.Message do
  @moduledoc """
  Discord's Message API.
  """

  @typedoc """
  Message struct or message id.
  """
  @type message :: String.t | Model.Message.t

  @typedoc """
  MessageBuilder.Message struct or string.
  """
  @type new_message :: String.t | MessageBuilder.Message.t

  alias Datcord.{API, Model, MessageBuilder}

  @doc """
  Gets a block of messages from the given `Channel`.

  - `channel` can either be a `Model.Channel` struct or a channel id.
  - `params` is a map with the values of `before`, `after` and `limit`.
  None of the values inside the map are required, i.e. an empty map is fine.
    - `before` gets messages that were sent before the message with this id.
    - `after` gets messages that were send after the message with this id.
    - `limit` is the maximum amount of messages to download.
      This is capped at 100.
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.messages(channel, %{}, "abc")
      {:ok, [%Model.Message{...}]}
  """
  @spec messages(Model.Channel.t | String.t, map, String.t) :: API.maybe([Model.Message.t])
  def messages(channel, params \\ %{}, token) do
    url = case params do
            x when x == %{} -> Model.Message.url(channel)
            x -> Model.Message.url(channel) <> "?" <> URI.encode_query(x)
          end

    headers = API.token_header(token)

    with {:ok, response} <- API.get(url, headers),
         do: {:ok, Model.Message.parse(response.body)}
  end

  @doc """
  Gets a block of messages from the given `Channel`.

  - `channel` can either be a `Model.Channel` struct or a channel id.
  - `params` is a map with the values of `before`, `after` and `limit`.
    None of the values inside the map are required, i.e. an empty map is fine.
    - `before` gets messages that were sent before the message with this id.
    - `after` gets messages that were send after the message with this id.
    - `limit` is the maximum amount of messages to download.
      This is capped at 100.
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.messages!(channel, %{}, "abc")
      [%Model.Message{...}]
  """
  @spec messages!(Model.Channel.t, map, String.t) :: [Model.Message.t] | no_return
  def messages!(channel, params \\ %{}, token) do
    case messages(channel, params, token) do
      {:ok, channel_messages} -> channel_messages
      {:error, error = %HTTPoison.Error{}} -> raise error
      {:error, error} -> raise ArgumentError, Atom.to_string(error)
    end
  end

  @doc """
  Sends a message to the given `Channel`.

  - `channel` can either be a `Model.Channel` struct or a channel id.
  - `new_message` can either be a string or a `MessageBuilder.Message` struct
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.send(channel, message, "abc")
      {:ok, %Model.Message{...}}
  """
  @spec send(Model.Channel.t | String.t, new_message, String.t) :: API.maybe(Model.Message.t)
  def send(channel, message, token)

  def send(channel, message, token) when is_binary(message) do
    send(channel, MessageBuilder.text(message), token)
  end

  def send(channel, message = %MessageBuilder.Message{}, token) do
    url = Model.Message.url(channel)
    headers = API.token_header(token)

    with {:ok, response} <- API.post(url, message, headers),
         do: {:ok, Model.Message.parse(response.body)}
  end

  @doc """
  Sends a message to the given `Channel`.

  - `channel` can either be a `Model.Channel` struct or a channel id.
  - `new_message` can either be a string or a `MessageBuilder.Message` struct
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.send!(channel, message, "abc")
      %Model.Message{...}
  """
  @spec send!(Model.Channel.t, new_message, String.t) :: Model.Message.t | no_return
  def send!(channel, message, token) do
    case send(channel, message, token) do
      {:ok, message} -> message
      {:error, error = %HTTPoison.Error{}} -> raise error
    end
  end

  @doc """
  Edits the given message, replacing the content with `new_content`.

  - `message` is a `Model.Message` struct.
  - `new_message` can either be a string or a `MessageBuilder.Message` struct
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.edit(message, new_message, "abc")
      {:ok, %Model.Message{...}}
  """
  @spec edit(Model.Message.t, new_message, String.t) :: API.maybe(Model.Message.t)
  def edit(message, new_message, token)

  def edit(message, new_message, token) when is_binary(new_message) do
    edit(message, MessageBuilder.text(new_message), token)
  end

  def edit(message = %Model.Message{},
           new_message = %MessageBuilder.Message{},
           token) do
    url = Model.Message.url(message)
    headers = API.token_header(token)

    with {:ok, response} <- API.patch(url, new_message, headers),
         do: {:ok, Model.Message.parse(response.body)}
  end

  @doc """
  Edits the given message, replacing the content with `new_content`.

  - `message` is a `Model.Message` struct.
  - `new_message` can either be a string or a `MessageBuilder.Message` struct
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.edit!(message, new_message, "abc")
      %Model.Message{...}
  """
  @spec edit!(Model.Message.t, new_message, String.t) :: Model.Message.t | no_return
  def edit!(message, new_message, token) do
    case edit(message, new_message, token) do
      {:ok, message} -> message
      {:error, error = %HTTPoison.Error{}} -> raise error
    end
  end

  @doc """
  Deletes the given message.

  - `message` is a `Model.Message` struct.
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.delete(message, "abc")
      :ok
  """
  @spec delete(Model.Message.t, String.t) :: :ok | {:error, HTTPoison.Error.t}
  def delete(message = %Model.Message{}, token) do
    url = Model.Message.url(message)
    headers = API.token_header(token)

    with {:ok, _response} <- API.delete(url, headers),
         do: :ok
  end

  @doc """
  Marks the given message as read.

  - `message` is a `Model.Message` struct.
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Message.ack(message, "abc")
      :ok
  """
  @spec ack(Model.Message.t, String.t) :: :ok | {:error, HTTPoison.Error.t}
  def ack(message = %Model.Message{}, token) do
    url = Model.Message.url(message) <> "/ack"
    headers = API.token_header(token)

    with {:ok, _response} <- API.post(url, %{}, headers),
         do: :ok
  end

  @doc """
  Marks the given message as read.

  - `message` is a `Model.Message` struct.
  - `token` is the API token to use.

  ## Example

  iex> API.Channel.Message.read(message, "abc")
  :ok
  """
  @spec read(Model.Message.t, String.t) :: :ok | {:error, HTTPoison.Error.t}
  def read(message = %Model.Message{}, token), do: ack(message, token)
end
