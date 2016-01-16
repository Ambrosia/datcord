defmodule Datcord.Model.Permission do
  defstruct [:type, :id, :set, :allow, :deny]

  alias Datcord.PermissionSet
  alias Datcord.Model.Channel
  alias __MODULE__, as: Permission

  @type t :: %Permission{}

  def allow(%Permission{set: set = %PermissionSet{}}) do
    {:ok, integer} = PermissionSet.allow_to_integer(set)
    integer
  end

  def allow(%Permission{allow: allow}), do: allow

  def deny(%Permission{set: set = %PermissionSet{}}) do
    {:ok, integer} = PermissionSet.deny_to_integer(set)
    integer
  end

  def deny(%Permission{deny: deny}), do: deny

  @spec url(Channel.t | String.t, t | String.t) :: String.t
  def url(channel), do: Channel.url(channel) <> "/permissions"
  def url(channel, %Permission{id: id}), do: url(channel, id)
  def url(channel, id), do: url(channel) <> "/" <> to_string(id)
end
