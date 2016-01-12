defmodule DiscordElixir.WebSocket.Handlers.Connect do
  use GenEvent
  alias DiscordElixir.WebSocket.Client
  require Logger

  def init(token) do
    Logger.debug("Connect handler started")
    {:ok, token}
  end

  def handle_event({:connected, ws_client_pid}, token) do
    Logger.debug("Sending connect message")
    Client.cast(ws_client_pid, connect_msg(token))
    {:ok, token}
  end

  def handle_event(_, state) do
    {:ok, state}
  end

  defp connect_msg(token) do
    %{op: 2,
      d: %{token: token,
           v: 3,
           properties: %{"$os" => os,
                         "$browser" => "discord_elixir",
                         "$device" => "discord_elixir",
                         "$referrer" => "",
                         "$referring_domain" => ""},
           large_threshold: 100}}
    |> Poison.encode!
  end

  defp os do
    case :os.type do
      {:unix, :linux} -> "Linux"
      {:unix, :darwin} -> "Mac OS X"
      {:win32, _} -> "Windows"
      {family, name} -> "#{Atom.to_string(family)} #{Atom.to_string(name)}"
    end
  end
end
