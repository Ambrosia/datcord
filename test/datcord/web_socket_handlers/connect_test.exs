defmodule Datcord.WebSocketHandlers.ConnectTest do
  use ExUnit.Case, async: true
  alias Datcord.WebSocketHandlers.Connect
  alias Datcord.Connection

  setup do
    {:ok, server_pid} = Connection.Server.start_link("test_token")
    {:ok, event_pid} = GenEvent.start
    GenEvent.add_handler(event_pid, Connect, server_pid)
    {:ok, %{event_pid: event_pid}}
  end

  test "Connect handler sends message to given pid with the correct token on connect", context do
    GenEvent.ack_notify(context.event_pid, {:connected, self()})

    assert_receive {:cast, {:text, msg}}
    assert msg |> Poison.decode! |> get_in(["d", "token"]) == "test_token"
  end
end
