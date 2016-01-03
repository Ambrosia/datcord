defmodule DiscordElixir.API do
  @moduledoc """
  HTTPoison.Base wrapper.

  See HTTPoison docs at http://hexdocs.pm/httpoison/HTTPoison.html
  This module adds the required json headers, encodes request bodies and
  decodes response bodies.
  """

  use HTTPoison.Base
  alias __MODULE__, as: API

  @endpoint "https://discordapp.com/api"

  defp process_url(url), do: @endpoint <> url

  defp process_request_headers(headers) do
    headers
    |> add_json_headers
  end

  defp process_request_body(:empty), do: ""
  defp process_request_body(map), do: Poison.encode!(map)

  defp process_response_body(""), do: nil
  defp process_response_body(binary), do: Poison.decode!(binary)

  @doc """
  Returns a token header.

  If `nil` is passed, this attempts to get the token from the
  `DiscordElixir.API.Token` agent. This will fail if not used.

  As this is already a list, it must be merged to be used with other headers.
  """
  def token_header(nil), do: API.Token.get |> token_header
  def token_header(token), do: [{"Authorization", token}]

  defp add_json_headers(headers) do
    [{"Accept", "application/json"},
     {"Content-Type", "application/json"} | headers]
  end
end
