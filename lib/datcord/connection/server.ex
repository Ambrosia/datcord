defmodule Datcord.Connection.Server do
  use GenServer
  alias Datcord.Connection

  defmodule State do
    defstruct [:token, :state_pid, :gen_event_pid, :websocket_pid]
  end

  ## Public API

  def start_link(sup_pid, token) do
    GenServer.start_link(__MODULE__, [sup_pid, token])
  end

  def state(pid), do: GenServer.call(pid, :state)

  def update_state_pid(pid, state_pid) do
    GenServer.cast(pid, {:update_state_pid, state_pid})
  end

  def update_gen_event_pid(pid, gen_event_pid) do
    GenServer.cast(pid, {:update_gen_event_pid, gen_event_pid})
  end

  def update_websocket_pid(pid, websocket_pid) do
    GenServer.cast(pid, {:update_websocket_pid, websocket_pid})
  end

  ## Private API

  def init([sup_pid, token]) do
    {:ok, %State{token: token}}
  end

  def handle_call(:state, _from, state), do: {:reply, state, state}

  def handle_cast({:update_state_pid, pid}, state) do
    {:ok, %State{state | state_pid: pid}}
  end

  def handle_cast({:update_gen_event_pid, pid}, state) do
    {:ok, %State{state | gen_event_pid: pid}}
  end

  def handle_cast({:update_websocket_pid, pid}, state) do
    {:ok, %State{state | websocket_pid: pid}}
  end
end
