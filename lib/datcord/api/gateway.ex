defmodule Datcord.API.Gateway do
  @moduledoc """
  Discord's Gateway API.

  If a token is stored using `Token`, all `token` arguments
  are optional.
  """

  alias Datcord.API
  alias Datcord.Connection.Token

  @doc """
  Gets the WebSocket endpoint.

  - `token` is the API token to use.
    This is optional if `Token` is used.

  ## Example

      iex> API.Gateway.endpoint
      {:ok, "wss://gateway-fafnir.discord.gg"}
  """
  @spec endpoint(Token.maybe) :: {:ok, String.t}
                               | {:error, HTTPoison.Error.t}
  def endpoint(token \\ nil) do
    headers = API.token_header(token)
    with {:ok, response} <- API.get("/gateway", headers),
         do: {:ok, response.body["url"]}
  end

  @doc """
  Gets the WebSocket endpoint.

  - `token` is the API token to use.
    This is optional if `Token` is used.

  ## Example

      iex> API.Gateway.endpoint!
      "wss://gateway-fafnir.discord.gg"
  """
  @spec endpoint!(Token.maybe) :: String.t | no_return
  def endpoint!(token \\ nil) do
    case endpoint(token) do
      {:ok, url} -> url
      {:error, error = %HTTPoison.Error{}} -> raise error
    end
  end
end
