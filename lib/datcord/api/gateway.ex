defmodule Datcord.API.Gateway do
  @moduledoc """
  Discord's Gateway API.
  """

  alias Datcord.API

  @doc """
  Gets the WebSocket endpoint.

  - `token` is the API token to use.

  ## Example

      iex> API.Gateway.endpoint("abc")
      {:ok, "wss://gateway-fafnir.discord.gg"}
  """
  @spec endpoint(String.t) :: {:ok, String.t}
                            | {:error, HTTPoison.Error.t}
  def endpoint(token) do
    headers = API.token_header(token)
    with {:ok, response} <- API.get("/gateway", headers),
         do: {:ok, response.body["url"]}
  end

  @doc """
  Gets the WebSocket endpoint.

  - `token` is the API token to use.

  ## Example

      iex> API.Gateway.endpoint!("abc")
      "wss://gateway-fafnir.discord.gg"
  """
  @spec endpoint!(String.t) :: String.t | no_return
  def endpoint!(token) do
    case endpoint(token) do
      {:ok, url} -> url
      {:error, error = %HTTPoison.Error{}} -> raise error
    end
  end
end
