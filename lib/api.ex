defmodule DiscordElixir.API do
  use HTTPoison.Base

  @url "https://discordapp.com/api"

  defp process_url(url) do
    @url <> url
  end

  defp process_request_headers(headers) do
    headers
    |> add_json_headers
    |> add_token_header
  end

  defp process_request_body(map) do
    Poison.encode!(map)
  end

  defp process_response_body(binary) do
    Poison.decode!(binary)
  end

  defp add_token_header(headers) do
    [{"Authorization", token} | headers]
  end

  defp add_json_headers(headers) do
    [{"Accept", "application/json"},
     {"Content-Type", "application/json"} | headers]
  end

  defp token do
    Application.get_env(:discord_elixir, :token)
  end
end
