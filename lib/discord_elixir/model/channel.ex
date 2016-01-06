defmodule DiscordElixir.Model.Channel do
  defstruct guild_id: nil, name: nil, permission_overwrites: [], topic: nil,
  position: nil, last_message_id: nil, type: nil, id: nil, is_private: nil

  alias __MODULE__, as: Channel

  @type t :: %Channel{}

  @spec parse(map) :: t
  def parse(map) do
    map = for {k, v} <- map, into: %{} do
      {String.to_existing_atom(k), v}
    end

    struct(Channel, map)
  end

  @spec url :: String.t
  @spec url(t) :: String.t
  def url, do: "/channels"
  def url(%Channel{id: id}), do: url(id)
  def url(id), do: url <> "/" <> to_string(id)
end
