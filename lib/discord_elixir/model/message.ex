defmodule Datcord.Model.Message do
  defstruct nonce: nil, attachments: [], tts: false, embeds: [], timestamp: [],
  mention_everyone: false, id: nil, edited_timestamp: nil, author: nil,
  content: [], channel_id: nil, mentions: []

  alias Datcord.Model
  alias Datcord.Model.{Channel, User}
  alias __MODULE__, as: Message

  @type t :: %Message{}

  @spec parse(map | [map]) :: t | [t]
  def parse(map) do
    map
    |> Model.parse_inner({"author", User})
    |> Model.parse(Message)
  end

  @spec url(Message.t | Channel.t | String.t) :: String.t
  @spec url(Channel.t | String.t, t | String.t) :: String.t
  def url(%Message{channel_id: cid, id: id}), do: url(cid, id)
  def url(channel), do: Channel.url(channel) <> "/messages"
  def url(channel, %Message{id: id}), do: url(channel, id)
  def url(channel, message_id), do: url(channel) <> "/" <> to_string(message_id)
end
