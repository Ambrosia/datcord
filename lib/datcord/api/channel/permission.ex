defmodule Datcord.API.Channel.Permission do
  @moduledoc """
  Discord's Channel Permission API.
  """

  @typedoc """
  Permission struct or map with the same keys.

  - `id` is the target's id, specified by type.
  - `type` is an atom which can be either `:role` or `:member`.
  - `set` is a `PermissionSet`. This is optional if `allow` and `deny` are
    specified.
  For information on `allow` and `deny`, see `PermissionSet`.
  """
  @type permission :: map | Model.Permission.t

  alias Datcord.{API, Model}

  @doc """
  Creates or edits permissions inside the given `channel` using the given role
  or member.

  - `channel` can either be a `Channel` or channel id.
  - `permission` can either be a `Permission` struct or equivelant map. See
    the typedoc for `permission` for more information.
  - `token` is the API token to use.

  ## Example

      iex> permission = %{id: "12345678", type: :role, set: permission_set}
      iex> API.Channel.Permission.create(channel, permission_set, "abc")
      :ok
  """
  @spec create(Model.Channel.t | String.t, permission, String.t) :: :ok | {:error, HTTPoison.Error.t}
  def create(channel, permission = %Model.Permission{}, token) do
    url = Model.Permission.url(channel, permission)
    params = %{id: permission.id,
               type: Atom.to_string(permission.type),
               allow: Model.Permission.allow(permission),
               deny: Model.Permission.deny(permission)}
    headers = API.token_header(token)

    with {:ok, _response} = API.put(url, params, headers),
         do: :ok
  end

  @doc """
  Creates or edits permissions inside the given `channel` using the given role
  or member.

  - `channel` can either be a `Channel` or channel id.
  - `permission` can either be a `Permission` struct or equivalent map. See
  the typedoc for `permission` for more information.
  - `token` is the API token to use.

  ## Example

      iex> permission = %{id: "12345678", type: :role, set: permission_set}
      iex> API.Channel.Permission.create(channel, permission_set, "abc")
      :ok
  """
  @spec edit(Model.Channel.t | String.t, permission, String.t) :: :ok | {:error, HTTPoison.Error.t}
  def edit(channel, permission, token) do
    create(channel, permission, token)
  end

  @doc """
  Deletes the given permission inside the given channel.

  - `channel` can either be a `Channel` or channel id.
  - `permission` can either be a `Permission` struct, equivalent map or string
  id.
  - `token` is the API token to use.

  ## Example

      iex> API.Channel.Permission.delete(channel, "75653453454334423", "abc")
      :ok
  """
  @spec delete(Model.Channel.t | String.t, permission | String.t, String.t) :: :ok | {:error, HTTPoison.Error.t}
  def delete(channel, permission, token) do
    url = Model.Permission.url(channel, permission)
    headers = API.token_header(token)

    with {:ok, _response} = API.delete(url, headers),
         do: :ok
  end
end
