defmodule DiscordElixir.WebSocket.Client do
  defmodule State do
    defstruct [:token, :event_pid]
  end

  @behaviour :websocket_client_handler

  alias DiscordElixir.API
  alias DiscordElixir.WebSocket.Messages
  require Logger

  # Public API

  def start_link(token, event_pid) do
    :crypto.start
    :ssl.start
    endpoint = token |> API.Gateway.endpoint! |> String.to_char_list

    Logger.debug("Connecting to #{endpoint}")
    :websocket_client.start_link(endpoint, __MODULE__, [token, event_pid])
  end

  def cast(pid, message) do
    Logger.debug("Sending message #{inspect message}")
    :websocket_client.cast(pid, {:text, message})
  end

  # Private

  def init([token, event_pid], _conn_state) do
    state = %State{token: token, event_pid: event_pid}
    Logger.debug("Connected")
    GenEvent.ack_notify(event_pid, {:connected, {self(), token}})
    {:ok, state}
  end

  def websocket_handle({:text, msg}, _conn_state, state) do
    Logger.debug("Received message #{inspect msg}")
    GenEvent.ack_notify(state.event_pid, {:message,
                                          {self(), state.token},
                                          msg |> Poison.decode!})
    {:ok, state}
  end

  def websocket_info(info, _conn_state, state) do
    {:ok, state}
  end

  def websocket_terminate(reason, _conn_state, state) do
    Logger.debug("Disconnected")
    GenEvent.ack_notify(state.event_pid, {:disconnected, {self(), state.token}})
    IO.inspect reason
    :ok
  end
end
