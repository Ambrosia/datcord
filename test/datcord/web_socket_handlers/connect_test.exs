defmodule Datcord.WebSocketHandlers.ConnectTest do
  use ExUnit.Case, async: true
  alias Datcord.WebSocketHandlers.Connect
  alias Datcord.WebSocket

  setup do
    {:ok, gen_event} = GenEvent.start
    GenEvent.add_handler(gen_event, Connect, "test_token")
    {:ok, %{gen_event: gen_event}}
  end

  test "Connect handler sends message to given pid with the correct token on connect", context do
    GenEvent.ack_notify(context.gen_event, {:connected, self()})

    assert_receive {:cast, {:text, msg}}
    assert msg |> Poison.decode! |> get_in(["d", "token"]) == "test_token"
  end
end
