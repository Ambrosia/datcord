defmodule DiscordElixir.API.Gateway do
  alias DiscordElixir.API

  def endpoint do
    with {:ok, response} <- API.get("/gateway"),
         url <- response.body["url"],
         do: {:ok, url}
  end

  def endpoint! do
    API.get!("/gateway").body["url"]
  end
end
