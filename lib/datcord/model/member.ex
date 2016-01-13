defmodule Datcord.Model.Member do
  defstruct user: nil, roles: [], joined_at: nil, guild_id: nil, mute: nil,
  deaf: nil

  alias Datcord.Model
  alias Datcord.Model.{Roles, User}
  alias __MODULE__, as: Member

  @type t :: %Member{}

  @spec parse(map | [map]) :: t | [t]
  def parse(map) do
    map
    |> Model.parse_inner({"user", User})
    |> Model.parse(Member)
  end
end
