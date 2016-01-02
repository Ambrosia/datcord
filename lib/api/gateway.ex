defmodule DiscordElixir.API.Gateway do
  alias DiscordElixir.API

  @doc """
  Gets the WebSocket endpoint.

  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Gateway.endpoint(token)
      {:ok, "wss://gateway-fafnir.discord.gg"}
  """
  def endpoint(token) do
    headers = API.token_header(token)
    with {:ok, response} <- API.get("/gateway", headers),
         do: {:ok, response.body["url"]}
  end

  @doc """
  Gets the WebSocket endpoint.

  `token` is the API token to use.

  ## Example

      iex> DiscordElixir.API.Gateway.endpoint!(token)
      "wss://gateway-fafnir.discord.gg"
  """
  def endpoint!(token) do
    headers = API.token_header(token)
    API.get!("/gateway", headers).body["url"]
  end
end
