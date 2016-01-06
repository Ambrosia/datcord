defmodule DiscordElixir.Model.Guild do
  defstruct features: [], afk_timeout: nil, joined_at: nil, afk_channel_id: nil,
  id: nil, icon: nil, name: nil, roles: [], region: nil, embed_channel_id: nil,
  embed_enabled: nil, splash: nil, emojis: [], owner_id: nil

  alias __MODULE__, as: Guild

  @type t :: %Guild{}

  @spec parse([map]) :: [t]
  def parse(maps) when is_list(maps) do
    Enum.map(maps, &parse/1)
  end

  @spec parse(map) :: t
  def parse(map) do
    map = for {k, v} <- map, into: %{} do
      {String.to_existing_atom(k), v}
    end

    struct(Guild, map)
  end

  @spec url :: String.t
  @spec url(t) :: String.t
  def url, do: "/guilds"
  def url(%Guild{id: id}), do: url(id)
  def url(id), do: url <> "/" <> to_string(id)
end
