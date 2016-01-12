defmodule Datcord.WebSocket.Handlers.ConnectTest do
  use ExUnit.Case, async: true
  alias Datcord.WebSocket.Handlers.Connect

  setup do
    {:ok, pid} = GenEvent.start
    GenEvent.add_handler(pid, Connect, "test_token")
    {:ok, %{pid: pid}}
  end

  test "Connect handler sends message to given pid with the correct token on connect", context do
    GenEvent.ack_notify(context.pid, {:connected, self()})

    assert_receive {:cast, {:text, msg}}
    assert msg |> Poison.decode! |> get_in(["d", "token"]) == "test_token"
  end
end
