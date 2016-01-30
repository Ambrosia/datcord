defmodule Datcord.Connection.SubSupervisor do
  use Supervisor
  alias Datcord.Connection
  alias Datcord.WebSocketHandlers, as: Handlers

  def start_link(server_pid) do
    result = {:ok, pid} = Supervisor.start_link(__MODULE__, [])
    {:ok, _} = start_gen_event(pid, server_pid)
    {:ok, _} = start_web_socket(pid, server_pid)
    result
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end

  defp start_web_socket(pid, server_pid) do
    spec = worker(Connection.WebSocket, [server_pid])
    Supervisor.start_child(pid, spec)
  end

  defp start_gen_event(pid, server_pid) do
    spec = worker(GenEvent, [])
    result = {:ok, gen_event_pid} = Supervisor.start_child(pid, spec)
    Connection.Server.update_gen_event_pid(server_pid, gen_event_pid)
    add_default_handlers(server_pid, gen_event_pid)
    result
  end

  defp add_default_handlers(server_pid, gen_event_pid) do
    GenEvent.add_handler(gen_event_pid, Handlers.Connect, server_pid)
    GenEvent.add_handler(gen_event_pid, Handlers.Keepalive, [])
  end
end
