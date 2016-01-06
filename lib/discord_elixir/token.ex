defmodule DiscordElixir.Token do
  @moduledoc """
  Helper for storing a token to use with the API.

  The most of the API functions need a token passed in as an argument.
  Since it's likely that only one token will ever be used at a time,
  the token can be kept here. This makes it possible for the token
  to not be given as an argument each time an API function is called.
  """

  @typedoc """
  Maybe a token or nil
  """
  @type maybe :: String.t | nil

  @doc """
  Starts an `Agent`, storing the given token.
  """
  @spec start_link(String.t) :: Agent.on_start
  def start_link(token) do
    Agent.start_link(fn -> token end, name: __MODULE__)
  end

  @doc """
  Gets the stored token.
  """
  @spec get :: String.t
  def get do
    Agent.get(__MODULE__, fn token -> token end)
  end

  @doc """
  Stores a new token, replacing the currently stored one.
  """
  @spec set(String.t) :: :ok
  def set(token) do
    Agent.update(__MODULE__, fn _ -> token end)
  end
end
