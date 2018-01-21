defmodule Ants.Simulations do
  alias Ants.Shared.Knobs
  alias Ants.Simulations.SimulationsSupervisor
  alias Ants.Simulations.SimId
  alias Ants.Simulations.Render
  alias Ants.Worlds
  alias Ants.Ants

  @starting_ants Knobs.constant(:starting_ants)

  @spec start :: {:ok, SimId.t()}
  def start() do
    sim = SimId.next()

    {:ok, _} = SimulationsSupervisor.start_simulation(sim)

    Worlds.create_world(sim)

    {:ok, sim}
  end

  @spec get(SimId.t()) :: Render.world()
  def get(sim) do
    Render.data(sim)
  end

  @spec turn(SimId.t()) :: {:error, :done} | {:ok, Render.world()}
  def turn(sim) do
    if done?(sim) do
      {:error, :done}
    else
      Ants.move_all(sim)

      Ants.deposit_all_pheromones(sim)
      Worlds.decay_all_pheromones(sim)

      Ants.create_new_ant(sim, 1, 1, @starting_ants)

      {:ok, Render.data(sim)}
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
end
