defmodule Ants.Ants.AntFood do
  alias Ants.Worlds
  alias Ants.Simulations.SimId
  alias Ants.Ants.Ant

  @spec deposit_food(Ant.t(), SimId.t()) :: Ant.t()
  def deposit_food(ant = %Ant{food?: false}, _), do: ant

  def deposit_food(ant, sim) do
    %Ant{x: x, y: y} = ant

    case Worlds.deposit_food(sim, x, y) do
      {:ok, _} ->
        %Ant{ant | food?: false}

      {:error, :not_home} ->
        ant
    end
  end

  @spec take_food(Ant.t(), SimId.t()) :: Ant.t()
  def take_food(ant = %Ant{food?: true}, _), do: ant

  def take_food(ant, sim) do
    %Ant{x: x, y: y} = ant

    case Worlds.take_food(sim, x, y) do
      {:ok, _} ->
        %Ant{ant | food?: true}

      {:error, :not_food} ->
        ant
    end
  end

  @spec deposit_pheromones(Ant.t(), SimId.t()) :: Ant.t()
  def deposit_pheromones(ant = %Ant{food?: false}, _), do: ant

  def deposit_pheromones(ant, sim) do
    %Ant{x: x, y: y} = ant

    Worlds.deposit_pheromones(sim, x, y)
    ant
  end
end