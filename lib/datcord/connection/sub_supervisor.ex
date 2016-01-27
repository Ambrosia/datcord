defmodule Datcord.Connection.SubSupervisor do
  use Supervisor

  def start_link(server_pid) do
    Supervisor.start_link(__MODULE__, [server_pid])
  end

  def init([_server_pid]) do
    supervise([], strategy: :one_for_one)
  end
end
