defmodule Datcord.ModelTest do
  use ExUnit.Case, async: true

  alias Datcord.Model

  defmodule Test do
    defstruct [:a, :b]
  end

  test "parse/2 parses a map correctly" do
    map = %{"a" => 1, "b" => 2}

    assert Model.parse(map, Test) == %Test{a: 1, b: 2}
  end

  test "parse/2 parses multiple maps correctly" do
    maps = [%{"a" => 1, "b" => 2}, %{"a" => 3, "b" => 4}]
    assert Model.parse(maps, Test) == [%Test{a: 1, b: 2}, %Test{a: 3, b: 4}]
  end

  test "parse_inner/2 parses a nested map correctly" do
    map = %{map: %{"a" => 1, "b" => 2}}
    assert Model.parse_inner(map, {:map, Test}) == %{map: %Test{a: 1, b: 2}}
  end

  test "parse_inner/2 parses deeply nested maps correctly" do
    map = %{map: %{content: %{test: %{"a" => 1, "b" => 2}}}}
    result = %{map: %{content: %{test: %Test{a: 1, b: 2}}}}
    assert Model.parse_inner(map, {[:map, :content, :test], Test}) == result
  end
end
