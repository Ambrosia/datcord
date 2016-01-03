defmodule DiscordElixir.API.Token do
  @moduledoc """
  Helper for storing a token to use with the API.

  The most of the API functions need a token passed in as an argument.
  Since it's likely that only one token will ever be used at a time,
  the token can be kept here. This makes it possible for the token
  to not be given as an argument each time an API function is called.
  """

  @doc """
  Starts an `Agent`, storing the given token.
  """
  def start_link(token) do
    Agent.start_link(fn -> token end, name: __MODULE__)
  end

  @doc """
  Gets the stored token.
  """
  def get do
    Agent.get(__MODULE__, fn token -> token end)
  end

  @doc """
  Stores a new token, replacing the currently stored one.
  """
  def set(token) do
    Agent.update(__MODULE__, fn _ -> token end)
  end
end
