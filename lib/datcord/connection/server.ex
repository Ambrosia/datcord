defmodule Datcord.Connection.Server do
  use GenServer

  defmodule State do
    defstruct [:token, :state_pid, :gen_event_pid, :websocket_pid]
  end

  ## Public API

  def start_link(token) do
    GenServer.start_link(__MODULE__, token)
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

  def init(token) do
    {:ok, %State{token: token}}
  end

  def handle_call(:state, _from, state), do: {:reply, state, state}

  def handle_cast({:update_state_pid, pid}, state) do
    {:noreply, %State{state | state_pid: pid}}
  end

  def handle_cast({:update_gen_event_pid, pid}, state) do
    state = %State{state | gen_event_pid: pid}
    send_event_pid(state)
    {:noreply, state}
  end

  def handle_cast({:update_websocket_pid, pid}, state) do
    state = %State{state | websocket_pid: pid}
    send_event_pid(state)
    {:noreply, state}
  end

  def send_event_pid(%State{gen_event_pid: evpid, websocket_pid: wspid})
  when is_pid(evpid) and is_pid(wspid) do
    send(wspid, {:gen_event_pid, evpid, self})
  end

  def send_event_pid(_), do: nil
end
