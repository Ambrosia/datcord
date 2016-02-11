defmodule Datcord.API do
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

  @endpoint "https://discordapp.com/api"

  @spec process_url(String.t) :: String.t
  defp process_url(url), do: @endpoint <> url

  @spec process_request_headers(HTTPoison.headers) :: HTTPoison.headers
  defp process_request_headers(headers) do
    headers
    |> add_json_headers
    |> add_user_agent
  end

  @spec process_request_body(map) :: String.t
  defp process_request_body(""), do: ""
  defp process_request_body(map) when map == %{}, do: ""
  defp process_request_body(map), do: Poison.encode!(map)

  @spec process_response_body(String.t) :: map | nil
  defp process_response_body(""), do: nil
  defp process_response_body(binary), do: Poison.decode!(binary)

  @doc """
  Returns a token header.

  As this is already a list, it must be merged to be used with other headers.
  """
  @spec token_header(String.t) :: HTTPoison.headers
  def token_header(token), do: [{"Authorization", token}]

  @spec add_json_headers(HTTPoison.headers) :: HTTPoison.headers
  defp add_json_headers(headers) do
    [{"Accept", "application/json"},
     {"Content-Type", "application/json"} | headers]
  end

  @spec add_user_agent(HTTPoison.headers) :: HTTPoison.headers
  defp add_user_agent(headers) do
    [{"User-Agent", user_agent} | headers]
  end

  @spec user_agent :: String.t
  defp user_agent do
    version = Datcord.Mixfile.project[:version]
    "DiscordBot (ambrosia/datcord #{version})"
  end
end
