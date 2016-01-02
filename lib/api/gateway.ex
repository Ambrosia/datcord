defmodule DiscordElixir.API.Gateway do
  alias DiscordElixir.API

  @doc """
  Gets the WebSocket endpoint.

  ## Example

      iex> DiscordElixir.API.Gateway.endpoint
      {:ok, "wss://gateway-fafnir.discord.gg"}
  """
  def endpoint do
    with {:ok, response} <- API.get("/gateway"),
         do: {:ok, response.body["url"]}
  end

  @doc """
  Gets the WebSocket endpoint.

  ## Example

      iex> DiscordElixir.API.Gateway.endpoint!
      "wss://gateway-fafnir.discord.gg"
  """
  def endpoint! do
    API.get!("/gateway").body["url"]
  end
end
