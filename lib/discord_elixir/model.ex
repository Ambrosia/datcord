defmodule DiscordElixir.Model do
  @moduledoc """
  Utility function for `Model`s
  """

  @doc """
  Parses a map with string keys into a struct of the given module.

  ## Example

      iex> Model.parse(channels, Channel)
      [%DiscordElixir.Model.Channel{...}]

      iex> Model.Parse(guild, Guild)
      DiscordElixir.Model.Guild{...}
  """
  @spec parse([map], module) :: [struct]
  def parse(maps, module) when is_list(maps) do
    Enum.map(maps, &parse(&1, module))
  end

  @spec parse(map, module) :: struct
  def parse(map, module) do
    map = for {k, v} <- map, into: %{} do
      {String.to_existing_atom(k), v}
    end

    struct(module, map)
  end
end
