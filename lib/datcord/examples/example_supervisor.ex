defmodule Datcord.Examples.ExampleSupervisor do
  use Supervisor
  alias Datcord.WebSocket
  alias Datcord.WebSocketHandlers.{Connect, Keepalive}

  def start_link(token) do
    result = {:ok, pid} = Supervisor.start_link(__MODULE__, [])
    start_children(pid, token)
    result
  end

  def init([]) do
    supervise([], strategy: :rest_for_one)
  end

  def start_children(supervisor_pid, token) do
    # A GenEvent must be started and handlers added before starting
    # the websocket connection.
    gen_event_spec = worker(GenEvent, [])
    {:ok, gen_event} = Supervisor.start_child(supervisor_pid, gen_event_spec)

    start_handlers(gen_event, token)

    web_socket_spec = worker(WebSocket, [token, gen_event])
    {:ok, _} = Supervisor.start_child(supervisor_pid, web_socket_spec)
  end

  defp start_handlers(gen_event, token) do
    # These two handlers are required to keep a connection to Discord alive
    :ok = GenEvent.add_handler(gen_event, Connect, token)
    :ok = GenEvent.add_handler(gen_event, Keepalive, [])
  end
end
