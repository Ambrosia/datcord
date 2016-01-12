defmodule DiscordElixir.WebSocket.Handlers.KeepaliveTest do
  use ExUnit.Case, async: true
  alias DiscordElixir.WebSocket.Handlers.Keepalive

  setup do
    {:ok, pid} = GenEvent.start
    GenEvent.add_handler(pid, Keepalive, [])
    GenEvent.ack_notify(pid, {:connected, self()})
    {:ok, %{pid: pid}}
  end

  test "Keepalive handler does nothing when wrong message type is sent", context do
    msg = %{"t" => "TEST"}
    GenEvent.ack_notify(context.pid, {:message, msg})
    refute_receive {:cast, {:text, _}}
  end

  test "Keepalive handler sends keepalive on connect", context do
    msg = %{"t" => "READY", "d" => %{"heartbeat_interval" => 500}}
    GenEvent.ack_notify(context.pid, {:message, msg})

    assert_receive {:cast, {:text, msg}}, 600
    assert msg |> Poison.decode! |> get_in(["op"]) == 1
  end

  test "Keepalive handler detects interval changes", context do
    ready_msg = %{"t" => "READY", "d" => %{"heartbeat_interval" => 5000}}
    GenEvent.ack_notify(context.pid, {:message, ready_msg})

    resume_msg = %{"t" => "RESUME", "d" => %{"heartbeat_interval" => 100}}
    GenEvent.ack_notify(context.pid, {:message, resume_msg})

    assert_receive {:cast, {:text, msg}}, 200
    assert msg |> Poison.decode! |> get_in(["op"]) == 1
  end
end
