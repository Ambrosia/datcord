defmodule Datcord.Model do
  @moduledoc """
  Utility function for `Model`s
  """

  @doc """
  Parses a map with string keys into a struct of the given module.

  ## Example

      iex> Model.parse(channels, Channel)
      [%Datcord.Model.Channel{...}]

      iex> Model.Parse(guild, Guild)
      Datcord.Model.Guild{...}
  """
  @spec parse([map], module) :: [struct]
  def parse(maps, module) when is_list(maps) do
    Enum.map(maps, &parse(&1, module))
  end

  @spec parse(map, module) :: struct
  def parse(map, module) do
    map = for {k, v} <- map, into: %{} do
      {String.to_atom(k), v}
    end

    struct(module, map)
  end

  @doc """
  Parses a map (with string keys) nested inside another map into a struct.

  A key module pair must be given for the second argument, e.g.
  `{"author", User}`.

  This uses `update_in/3`, so you can pass a list of keys.

  ## Example

      iex> map = %{"author" => %{"name" => "Test"}}
      iex> parse_inner(map, {"author", User})
      %{"author" => %Test{name: "Test"}}
  """
  @spec parse_inner([map], {any | [any], module}) :: map
  def parse_inner(maps, key_module_pair) when is_list(maps) do
    Enum.map(maps, &parse_inner(&1, key_module_pair))
  end

  @spec parse_inner(map, {any | [any], module}) :: map
  def parse_inner(map, {keys, module}) do
    keys = case keys do
             key when not is_list(key) -> [key]
             keys -> keys
           end

    update_in(map, keys, &module.parse(&1))
  end
end
