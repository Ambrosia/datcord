defmodule Datcord.Connection.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(a) do
    supervise([], strategy: :one_for_one)
  end
end
