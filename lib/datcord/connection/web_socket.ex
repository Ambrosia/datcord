defmodule Datcord.Connection.WebSocket do
  defmodule State do
    defstruct [:server_pid, :token, :event_pid]
  end

  @behaviour :websocket_client_handler

  alias Datcord.API
  alias Datcord.Connection
  alias Datcord.Connection.WebSocket.MessageParser
  require Logger
  import Poison, only: [encode!: 1, decode!: 1]

  # Public API

  def start_link(server_pid) do
    :crypto.start
    :ssl.start

    server_state = server_pid |> Connection.Server.state
    token = server_state.token

    endpoint = token
    |> API.Gateway.endpoint!
    |> String.to_char_list

    Logger.debug("Connecting to #{endpoint}")
    :websocket_client.start_link(endpoint, __MODULE__, [token, server_pid])
  end

  def cast(pid, message) do
    Logger.debug("Sending message #{inspect message}")
    do_cast(pid, message)
  end

  defp do_cast(pid, map) when is_map(map), do: do_cast(pid, map |> encode!)
  defp do_cast(pid, message), do: :websocket_client.cast(pid, {:text, message})

  # Private

  def init([token, server_pid], _conn_state) do
    Connection.Server.update_websocket_pid(server_pid, self)

    server_state = server_pid
    |> Connection.Server.state

    event_pid = Map.get(server_state, :gen_event_pid) || receive do
      {:gen_event_pid, event_pid, ^server_pid} -> event_pid
    end

    state = %State{server_pid: server_pid, token: token, event_pid: event_pid}
    Logger.debug("Connected")
    GenEvent.ack_notify(event_pid, {:connected, self})
    {:ok, state}
  end

  def websocket_handle({:text, json}, _conn_state, state) do
    raw_map = json |> decode!
    {type, map} = raw_map |> MessageParser.parse
    Logger.debug("Received message #{inspect map}")
    GenEvent.ack_notify(state.event_pid, {:message, type, map})
    {:ok, state}
  end

  def websocket_info({:gen_event_pid, evpid, spid}, state = %State{server_pid: spid}) do
    {:ok, %State{state | event_pid: evpid}}
  end

  def websocket_info(_info, _conn_state, state) do
    {:ok, state}
  end

  def websocket_terminate(reason, _conn_state, state) do
    Logger.debug("Disconnected")
    GenEvent.ack_notify(state.event_pid, {:disconnected, reason})
  end
end
