defmodule Ants.Shared.Knobs do
  @constants %{
    starting_food: 500,
    map_size: 9
  }

  @variables %{
    pheromone_decay: 0.95,
    pheromone_multiplier: 1.5,
    forward_weight: 3
  }

  @spec get(atom) :: any
  def get(name) do
    @variables[name]
  end

  @spec constant(atom) :: any
  def constant(name) do
    @constants[name]
  end
end