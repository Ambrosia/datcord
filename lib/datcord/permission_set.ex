defmodule Datcord.PermissionSet do
  @moduledoc """
  Helper to make changing permissions easy

  See
  https://discordapi.readthedocs.org/en/latest/reference/channels/permissions.html
  to see which permissions are available to use (convert the names to atoms).

  It may be possible to get two permissions when you only expected one when
  converting from integers. This is because some permissions share the same
  offset (e.g. 8 will give both :manage_roles and :manage_permissions).
  """

  defstruct allow: MapSet.new, deny: MapSet.new
  use Bitwise
  alias __MODULE__, as: PermissionSet

  @type t :: %PermissionSet{allow: MapSet.t, deny: MapSet.t}
  @type permission :: :create_instant_invite
                    | :kick_members
                    | :ban_members
                    | :manage_roles
                    | :manage_permissions
                    | :manage_channels
                    | :manage_channel
                    | :manage_server
                    | :read_messages
                    | :send_messages
                    | :send_tts_messages
                    | :manage_messages
                    | :embed_links
                    | :attach_files
                    | :read_message_history
                    | :mention_everyone
                    | :voice_connect
                    | :voice_speak
                    | :voice_mute_members
                    | :voice_deafen_members
                    | :voice_move_members
                    | :voice_use_vad

  @offsets [create_instant_invite: 0,
            kick_members: 1,
            ban_members: 2,
            manage_roles: 3,
            manage_permissions: 3,
            manage_channels: 4,
            manage_channel: 4,
            manage_server: 5,
            read_messages: 10,
            send_messages: 11,
            send_tts_messages: 12,
            manage_messages: 13,
            embed_links: 14,
            attach_files: 15,
            read_message_history: 16,
            mention_everyone: 17,
            voice_connect: 20,
            voice_speak: 21,
            voice_mute_members: 22,
            voice_deafen_members: 23,
            voice_move_members: 24,
            voice_use_vad: 25]

  @permissions Keyword.keys(@offsets)

  @doc """
  Creates a new PermissionSet struct from a list of allowed and a list of
  denied permissions.

  An error tuple will be returned if an invalid permission is given.

  ## Example

      iex> PermissionSet.new([:read_messages, :send_messages], [:voice_connect])
      %PermissionSet{allow: #MapSet<[:read_messages, :send_messages]>,
      deny: #MapSet<[:voice_connect]>}
  """
  @spec new([permission], [permission]) :: t | {:error, :invalid_permissions}
  def new(allow, deny) when is_list(allow) and is_list(deny) do
    cond do
      !valid_permissions(allow) -> {:error, :invalid_permissions}
      !valid_permissions(deny) -> {:error, :invalid_permissions}
      true -> %PermissionSet{allow: MapSet.new(allow), deny: MapSet.new(deny)}
    end
  end

  @doc """
  Creates a new PermissionSet struct from an integer containing allowed
  permissions and an integer containing denied permissions.

  ## Example

      iex> PermissionSet.new(3072, 1048576)
      %PermissionSet{allow: #MapSet<[:read_messages, :send_messages]>,
        deny: #MapSet<[:voice_connect]>}
  """
  @spec new(integer, integer) :: t
  def new(allow, deny) when is_integer(allow) and is_integer(deny) do
    allow_permissions = allow |> integer_to_permissions |> MapSet.new
    deny_permissions = deny |> integer_to_permissions |> MapSet.new
    %PermissionSet{allow: allow_permissions, deny: deny_permissions}
  end

  @doc """
  Allows the given permissions.

  An error tuple will be returned if an invalid permission is given.

  ## Example

      iex> annoy_everyone = [:send_tts_messages, :mention_everyone]
      iex> PermissionSet.allow(permissionset, annoy_everyone)
      {:ok, %PermissionSet{allow: #MapSet<[:mention_everyone, :read_messages,
        :send_messages, :send_tts_messages]>, deny: #MapSet<[]>}}
  """
  @spec allow(t, [permission]) :: {:ok, t} | {:error, :invalid_permissions}
  def allow(permission = %PermissionSet{allow: allow}, new_permissions)
  when is_list(new_permissions) do
    case valid_permissions(new_permissions) do
      true ->
        new_permissions = MapSet.new(new_permissions)
        {:ok, %{permission | allow: MapSet.union(allow, new_permissions)}}
      false -> {:error, :invalid_permissions}
    end
  end

  @doc """
  Allows the given permission.

  An error tuple will be returned if an invalid permission is given.

  ## Example

  iex> PermissionSet.allow(permissionset, :send_tts_messages)
      {:ok, %PermissionSet{allow: #MapSet<[:read_messages, :send_messages,
        :send_tts_messages]>, deny: #MapSet<[]>}}
  """
  @spec allow(t, permission) :: {:ok, t} | {:error, :invalid_permission}
  def allow(permission = %PermissionSet{allow: allow}, new_permission) do
    case valid_permission(permission) do
      true ->
        {:ok, %{permission | allow: MapSet.put(allow, new_permission)}}
      false -> {:error, :invalid_permission}
    end
  end

  @doc """
  Denies the given permissions.

  An error tuple will be returned if an invalid permission is given.

  ## Example

      iex> annoy_everyone = [:send_tts_messages, :mention_everyone]
      iex> PermissionSet.deny(permissionset, annoy_everyone)
      {:ok, %PermissionSet{allow: #MapSet<[]>, deny: #MapSet<[:mention_everyone,
        :read_messages, :send_messages, :send_tts_messages]>}}
  """
  @spec deny(t, [permission]) :: {:ok, t} | {:error, :invalid_permissions}
  def deny(permission = %PermissionSet{deny: deny}, del_permissions)
  when is_list(del_permissions) do
    case valid_permissions(del_permissions) do
      true ->
        del_permissions = MapSet.new(del_permissions)
        {:ok, %{permission | deny: MapSet.difference(deny, del_permissions)}}
      false -> {:error, :invalid_permissions}
    end
  end

  @doc """
  Denies the given permission.

  An error tuple will be returned if an invalid permission is given.

  ## Example

      iex> PermissionSet.deny(permissionset, :send_tts_messages)
      {:ok, %PermissionSet{allow: #MapSet<[:read_messages, :send_messages]>,
        deny: #MapSet<[:send_tts_messages]>}}
  """
  @spec deny(t, permission) :: {:ok, t} | {:error, :invalid_permission}
  def deny(permission = %PermissionSet{deny: deny}, del_permission) do
    case valid_permission(del_permission) do
      true ->
        {:ok, %{permission | deny: MapSet.delete(deny, del_permission)}}
      false -> {:error, :invalid_permission}
    end
  end

  @doc """
  Converts the allowed permissions of a PermissionSet to an integer

  ## Example

      iex> PermissionSet.allow_to_integer(permissionset)
      {:ok, 3072}
  """
  @spec allow_to_integer(t) :: {:ok, integer}
  def allow_to_integer(%PermissionSet{allow: permissions}) do
    {:ok, permissions_to_integer(permissions)}
  end

  @doc """
  Converts the denied permissions of a PermissionSet to an integer

  ## Example

      iex> PermissionSet.deny_to_integer(permissionset)
      {:ok, 0}
  """
  @spec deny_to_integer(t) :: {:ok, integer}
  def deny_to_integer(%PermissionSet{deny: permissions}) do
    {:ok, permissions_to_integer(permissions)}
  end

  @doc """
  Converts the given list of permissions to an integer

  ## Example

      iex> PermissionSet.permissions_to_integer([:read_messages, :send_messages])
      3072
  """
  @spec permissions_to_integer([permission]) :: integer
  def permissions_to_integer(permissions) do
    offsets = Enum.map(permissions, &Keyword.get(@offsets, &1))
    Enum.reduce offsets, 0, fn(offset, num) ->
      num ||| (1 <<< offset)
    end
  end

  @doc """
  Converts the given integer to a list of permissions

  ## Example

      iex> PermissionSet.integer_to_permissions(3072)
      [:read_messages, :send_messages]
  """
  @spec integer_to_permissions(integer) :: [permission]
  def integer_to_permissions(integer) do
    @offsets
    |> Enum.filter(fn {_permission, offset} ->
      (integer &&& (1 <<< offset)) > 0
    end)
    |> Enum.map(fn {permission, _offset} -> permission end)
  end

  defp valid_permissions(permissions) do
    permissions
    |> MapSet.new
    |> MapSet.subset?(@permissions |> MapSet.new)
  end

  defp valid_permission(permission) do
    MapSet.member?(@permissions |> MapSet.new, permission)
  end
end
