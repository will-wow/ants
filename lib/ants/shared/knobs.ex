defmodule Ants.Shared.Knobs do
  @constants %{
    starting_food: 500,
    map_size: 9,
    pheromone_decay: 0.95,
    pheromone_multiplier: 1.5
  }

  @spec get(atom) :: any
  def get(name) do
    @constants[name]
  end
end