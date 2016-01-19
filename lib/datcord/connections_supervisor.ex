defmodule Datcord.ConnectionsSupervisor do
  use Supervisor
  alias Datcord.Connection

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(_) do
    supervise([], strategy: :one_for_one)
  end
end
