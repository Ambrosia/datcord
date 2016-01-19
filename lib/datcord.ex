defmodule Datcord do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [supervisor(Datcord.ConnectionsSupervisor, [])]

    opts = [strategy: :one_for_one, name: Datcord.ConnectionsSupervisor]
    Supervisor.start_link(children, opts)
  end
end
