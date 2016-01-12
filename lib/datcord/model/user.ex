defmodule Datcord.Model.User do
  defstruct username: nil, id: nil, discriminator: nil, avatar: nil,
  verified: nil, email: nil

  alias Datcord.Model
  alias __MODULE__, as: User

  @type t :: %User{}

  @spec parse(map | [map]) :: t | [t]
  def parse(map) do
    Model.parse(map, User)
  end

  @spec url :: String.t
  @spec url(t | String.t) :: String.t
  def url, do: "/users"
  def url(%User{id: id}), do: url(id)
  def url(id), do: url <> "/" <> to_string(id)

  @spec channels_url :: String.t
  @spec channels_url(t) :: String.t
  def channels_url, do: "/channels"
  def channels_url(user), do: url(user) <> channels_url

  @spec avatar_url :: String.t
  @spec avatar_url(t) :: String.t
  def avatar_url, do: "/avatars"
  def avatar_url(user = %User{avatar: avatar}) do
    url(user) <> avatar_url <> "/" <> avatar <> ".jpg"
  end
end
