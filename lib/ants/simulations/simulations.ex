defmodule Ants.Simulations do
  alias Ants.Shared.Knobs
  alias Ants.Simulations.SimulationsSupervisor
  alias Ants.Simulations.SimId
  alias Ants.Simulations.Print
  alias Ants.Worlds
  alias Ants.Ants

  @starting_ants Knobs.constant(:starting_ants)

  @spec start :: {:ok, SimId.t()}
  def start() do
    sim = SimId.next()

    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    {:ok, home: {home_x, home_y}} = Worlds.create_world(sim)

    Ants.create_ants(sim, home_x, home_y, @starting_ants)

    {:ok, sim}
  end

  @spec get(SimId.t()) :: Print.world()
  def get(sim) do
    Print.data(sim)
  end

  @spec turn(SimId.t()) :: {:error, :done} | {:ok, Print.world()}
  def turn(sim) do
    if done?(sim) do
      {:error, :done}
    else
      Ants.move_all(sim)
      Ants.deposit_all_pheromones(sim)
      Worlds.decay_all_pheromones(sim)

      {:ok, Print.data(sim)}
    end
  end

  @spec done?(SimId.t()) :: boolean
  def done?(sim) do
    food_in_world = Worlds.count_food(sim)

    food_in_world <= 0
  end

  @spec knob(String.t()) :: {:ok, any} | {:error}
  def knob(name) when is_binary(name) do
    case Knobs.parse(name) do
      {:ok, atom} ->
        value = Knobs.get(atom) || Knobs.constant(atom)
        {:ok, value}

      {:error} ->
        {:error}
    end
  end

  defdelegate all_knobs(), to: Knobs, as: :all
  defdelegate print(sim), to: Print
end
