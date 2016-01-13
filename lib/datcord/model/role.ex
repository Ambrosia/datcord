defmodule Datcord.Model.Role do
  defstruct color: nil, hoist: nil, id: nil, managed: nil, name: nil,
  permissions: nil, position: nil

  alias Datcord.Model
  alias __MODULE__, as: Role

  @type t :: %Role{}

  @spec parse(map | [map]) :: t | [t]
  def parse(map) do
    Model.parse(map, Role)
  end
end
