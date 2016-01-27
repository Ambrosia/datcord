defmodule Datcord do
  use Application
  alias Datcord.ConnectionsSupervisor

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Datcord.Supervisor.start_link
  end

  def start_connection(token), do: ConnectionsSupervisor.start_connection(token)
end
