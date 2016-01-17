defmodule Datcord.ModelTest do
  use ExUnit.Case, async: true

  alias Datcord.Model

  defmodule Test do
    defstruct [:a, :b]

    def parse(map) do
      Model.parse(map, Test)
    end
  end

  defmodule Test2 do
    defstruct [:test]

    def parse(map) do
      map
      |> Model.parse_inner({"test", Test})
      |> Model.parse(Test2)
    end
  end

  test "parse/2 parses a map into a model correctly" do
    map = %{"a" => 1, "b" => 2}

    assert Model.parse(map, Test) == %Test{a: 1, b: 2}
  end

  test "parse/2 parses multiple maps into models correctly" do
    maps = [%{"a" => 1, "b" => 2}, %{"a" => 3, "b" => 4}]
    assert Model.parse(maps, Test) == [%Test{a: 1, b: 2}, %Test{a: 3, b: 4}]
  end

  test "parse_inner/2 parses a map nested inside another map into a model correctly" do
    map = %{map: %{"a" => 1, "b" => 2}}
    assert Model.parse_inner(map, {:map, Test}) == %{map: %Test{a: 1, b: 2}}
  end

  test "parse_inner/2 parses a map nested inside multiple levels of maps correctly" do
    map = %{map: %{content: %{test: %{"a" => 1, "b" => 2}}}}
    result = %{map: %{content: %{test: %Test{a: 1, b: 2}}}}
    assert Model.parse_inner(map, {[:map, :content, :test], Test}) == result
  end

  test "parse_inner/2 parses a map into a model and all children maps into their modules correctly" do
    map = %{map: %{"test" => %{"a" => 1, "b" => 2}}}
    parsed = Model.parse_inner(map, {:map, Test2})

    assert parsed == %{map: %Test2{test: %Test{a: 1, b: 2}}}
  end
end
