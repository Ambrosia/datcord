defmodule Datcord.Model.Guild do
  defstruct features: [], afk_timeout: nil, joined_at: nil, afk_channel_id: nil,
  id: nil, icon: nil, name: nil, roles: [], region: nil, embed_channel_id: nil,
  embed_enabled: nil, splash: nil, emojis: [], owner_id: nil, voice_states: [],
  presences: [], members: [], large: nil, channels: []

  alias Datcord.Model
  alias Datcord.Model.Role
  alias __MODULE__, as: Guild

  @type t :: %Guild{}

  @spec parse(map | [map]) :: t | [t]
  def parse(map) do
    map
    |> Model.parse_inner({"roles", Role})
    |> Model.parse(Guild)
  end

  @spec url :: String.t
  @spec url(t) :: String.t
  def url, do: "/guilds"
  def url(%Guild{id: id}), do: url(id)
  def url(id), do: url <> "/" <> to_string(id)
end
