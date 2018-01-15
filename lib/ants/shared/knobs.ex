defmodule Ants.Shared.Knobs do
  alias Ants.Worlds.CellMap

  @constants %{
    starting_food: 100,
    map_size: CellMap.get() |> Enum.count(),
    starting_ants: 100
  }

  @variables %{
    pheromone_deposit: 0.75,
    pheromone_decay: 0.95,
    pheromone_multiplier: 1.5,
    forward_weight: 3
  }

  @names Enum.map(
    Map.keys(@constants) ++ Map.keys(@variables),
    &Atom.to_string/1
  )

  @spec get(atom) :: any
  def get(name) do
    @variables[name]
  end

  @spec constant(atom) :: any
  def constant(name) do
    @constants[name]
  end

  @spec parse(String.t) :: {:ok, atom} | {:error}
  def parse(name) do
    if Enum.member?(@names, name) do
      {:ok, String.to_atom(name)}
    else
      {:error}
    end
  end

  @spec all() :: map()
  def all() do
    Map.merge(@variables, @constants)
  end
end