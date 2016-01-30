defmodule Datcord.Connection.Supervisor do
  use Supervisor
  alias Datcord.Connection

  def start_link(token) do
    {:ok, sup_pid} = Supervisor.start_link(__MODULE__, [])
    {:ok, server_pid} = start_server(sup_pid, token)
    {:ok, _sub_sup_pid} = start_sub_supervisor(sup_pid, server_pid)
    {:ok, server_pid}
  end

  def init(_) do
    supervise([], strategy: :rest_for_one)
  end

  defp start_server(pid, token) do
    Supervisor.start_child(pid, worker(Connection.Server, [token]))
  end

  defp start_sub_supervisor(pid, server_pid) do
    Supervisor.start_child(pid, supervisor(Connection.SubSupervisor, [server_pid]))
  end
end
