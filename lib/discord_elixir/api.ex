defmodule DiscordElixir.API do
  @moduledoc """
  HTTPoison.Base wrapper.

  See HTTPoison docs at http://hexdocs.pm/httpoison/HTTPoison.html
  This module adds the required json headers, encodes request bodies and
  decodes response bodies.
  """

  @type maybe(struct) :: {:ok, struct}
                       | {:error, HTTPoison.Error.t}
                       | {:error, atom}

  use HTTPoison.Base
  alias DiscordElixir.Token
  alias __MODULE__, as: API

  @endpoint "https://discordapp.com/api"

  @spec process_url(String.t) :: String.t
  defp process_url(url), do: @endpoint <> url

  @spec process_request_headers(HTTPoison.headers) :: HTTPoison.headers
  defp process_request_headers(headers) do
    headers
    |> add_json_headers
  end

  @spec process_request_body(map) :: String.t
  defp process_request_body(map) when map == %{}, do: ""
  defp process_request_body(map), do: Poison.encode!(map)

  @spec process_response_body(String.t) :: map | nil
  defp process_response_body(""), do: nil
  defp process_response_body(binary), do: Poison.decode!(binary)

  @doc """
  Returns a token header.

  If `nil` is passed, this attempts to get the token from the
  `DiscordElixir.Token` agent. This will fail if not used.

  As this is already a list, it must be merged to be used with other headers.
  """
  @spec token_header(String.t | nil) :: HTTPoison.headers
  def token_header(nil), do: Token.get |> token_header
  def token_header(token), do: [{"Authorization", token}]

  @spec add_json_headers(HTTPoison.headers) :: HTTPoison.headers
  defp add_json_headers(headers) do
    [{"Accept", "application/json"},
     {"Content-Type", "application/json"} | headers]
  end
end
