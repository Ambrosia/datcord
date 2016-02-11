defmodule Datcord.WebSocket do
  defmodule State do
    defstruct [:token, :gen_event]
  end

  @behaviour :websocket_client_handler

  alias Datcord.API
  alias Datcord.WebSocket.MessageParser
  require Logger
  import Poison, only: [encode!: 1, decode!: 1]

  # Public API

  def start_link(token, gen_event) do
    endpoint = token
    |> API.Gateway.endpoint!
    |> String.to_char_list

    state = %State{token: token, gen_event: gen_event}

    Logger.debug("Connecting to #{endpoint}")
    :websocket_client.start_link(endpoint, __MODULE__, state)
  end

  def cast(pid, message) do
    Logger.debug("Sending message #{inspect message}")
    do_cast(pid, message)
  end

  defp do_cast(pid, map) when is_map(map), do: do_cast(pid, map |> encode!)
  defp do_cast(pid, message), do: :websocket_client.cast(pid, {:text, message})

  # Private

  def init(state, _conn_state) do
    Logger.debug("Connected")
    GenEvent.ack_notify(state.gen_event, {:connected, self})
    {:ok, state}
  end

  def websocket_handle({:text, json}, _conn_state, state) do
    raw_map = json |> decode!
    {type, map} = raw_map |> MessageParser.parse
    Logger.debug("Received message #{inspect map}")
    GenEvent.ack_notify(state.gen_event, {:message, type, map})
    {:ok, state}
  end

  def websocket_info(_info, _conn_state, state) do
    {:ok, state}
  end

  def websocket_terminate(reason, _conn_state, state) do
    Logger.debug("Disconnected")
    GenEvent.ack_notify(state.gen_event, {:disconnected, reason})
  end
end
