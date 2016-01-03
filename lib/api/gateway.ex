defmodule DiscordElixir.API.Gateway do
  @moduledoc """
  Discord's Gateway API.

  If a token is stored using `DiscordElixir.API.Token`, all `token` arguments
  are optional.
  """

  alias DiscordElixir.API

  @doc """
  Gets the WebSocket endpoint.

  `token` is the API token to use. This is optional if `DiscordElixir.API.Token` is used.

  ## Example

      iex> DiscordElixir.API.Gateway.endpoint
      {:ok, "wss://gateway-fafnir.discord.gg"}
  """
  def endpoint(token \\ nil) do
    headers = API.token_header(token)
    with {:ok, response} <- API.get("/gateway", headers),
         do: {:ok, response.body["url"]}
  end

  @doc """
  Gets the WebSocket endpoint.

  `token` is the API token to use. This is optional if `DiscordElixir.API.Token` is used.

  ## Example

      iex> DiscordElixir.API.Gateway.endpoint!
      "wss://gateway-fafnir.discord.gg"
  """
  def endpoint!(token \\ nil) do
    headers = API.token_header(token)
    API.get!("/gateway", headers).body["url"]
  end
end
