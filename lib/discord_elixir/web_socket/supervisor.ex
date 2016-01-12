defmodule DiscordElixir.WebSocket.Supervisor do
  use Supervisor
  require Logger
  alias DiscordElixir.WebSocket.Handlers

  def start_link(token) do
    Logger.debug("Starting WebSocket")
    {:ok, sup_pid} = Supervisor.start_link(__MODULE__, token)
    {:ok, event_pid, ws_client_pid} = start_workers(sup_pid, token)
    {:ok, sup_pid, event_pid, ws_client_pid}
  end

  def start_workers(sup_pid, token) do
    Logger.debug("Starting GenEvent worker")
    event_spec = worker(GenEvent, [])
    {:ok, event_pid} = Supervisor.start_child(sup_pid, event_spec)

    add_default_handlers(event_pid, token)

    Logger.debug("Starting WebSocket client")
    ws_client_spec = worker(DiscordElixir.WebSocket.Client, [token, event_pid])
    {:ok, ws_client_pid} = Supervisor.start_child(sup_pid, ws_client_spec)

    {:ok, event_pid, ws_client_pid}
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end

  def add_default_handlers(event_pid, token) do
    GenEvent.add_handler(event_pid, Handlers.Connect, token)
    GenEvent.add_handler(event_pid, Handlers.Keepalive, [])
  end
end
