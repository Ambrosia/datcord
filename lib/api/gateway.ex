defmodule DiscordElixir.API.Gateway do
  alias DiscordElixir.API

  def endpoint do
    with {:ok, response} <- API.get("/gateway"),
         do: {:ok, response.body["url"]}
  end

  def endpoint! do
    API.get!("/gateway").body["url"]
  end
end
