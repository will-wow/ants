defmodule Ants.Shared.Knobs do
  alias Ants.Worlds.WorldMapData

  @constants %{
    starting_food: 50,
    map_size: WorldMapData.get() |> Enum.count(),
    starting_ants: 50
  }

  @variables %{
    pheromone_deposit: 1,
    pheromone_evaporation_coefficient: 0.03,
    pheromone_influence: 2.0
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

  @spec parse(String.t()) :: {:ok, atom} | {:error}
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
