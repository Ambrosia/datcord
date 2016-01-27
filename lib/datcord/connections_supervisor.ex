defmodule Datcord.ConnectionsSupervisor do
  use Supervisor
  alias Datcord.Connection

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [supervisor(Connection.Supervisor, [], restart: :transient)]
    supervise(children, strategy: :simple_one_for_one)
  end

  def start_connection(token) do
    Supervisor.start_child(__MODULE__, [token])
  end
end
