defmodule Datcord.WebSocketHandlers.Connect do
  @moduledoc """
  Sends the mandatory connect message to Discord on websocket connect.
  """

  use GenEvent
  alias Datcord.Connection.WebSocket
  require Logger

  def init(token) do
    Logger.debug("Connect handler started")
    {:ok, token}
  end

  def handle_event({:connected, ws_client_pid}, token) do
    Logger.debug("Sending connect message")
    WebSocket.cast(ws_client_pid, connect_msg(token))
    {:ok, token}
  end

  def handle_event(_, state) do
    {:ok, state}
  end

  @spec connect_msg(String.t) :: String.t
  defp connect_msg(token) do
    %{op: 2,
      d: %{token: token,
           v: 3,
           properties: %{"$os" => os,
                         "$browser" => "datcord",
                         "$device" => "datcord",
                         "$referrer" => "",
                         "$referring_domain" => ""},
           large_threshold: 100}}
  end

  @spec os :: String.t
  defp os do
    case :os.type do
      {:unix, :linux} -> "Linux"
      {:unix, :darwin} -> "Mac OS X"
      {:win32, _} -> "Windows"
      {family, name} -> "#{Atom.to_string(family)} #{Atom.to_string(name)}"
    end
  end
end
