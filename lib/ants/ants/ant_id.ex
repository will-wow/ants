defmodule Ants.Ants.AntId do
  use Agent

  alias Ants.Simulations.SimId
  alias Ants.Registries.SimRegistry

  @type t :: integer

  def start_link(sim) do
    Agent.start_link(fn -> [] end, name: via(sim))
  end

  @spec get(SimId.t) :: t
  def get(sim) do
    sim
    |> via()
    |> Agent.get(fn ids -> ids end)
  end

  @spec next(SimId.t) :: t
  def next(sim) do
    sim
    |> via()
    |> Agent.get_and_update(fn ids -> 
      case ids do
        [] ->
          {0, [0]}
        [last_id|_] -> 
          id = last_id + 1
          {id, [id|ids]}
      end
    end)
  end

  defp via(sim) do
    SimRegistry.ant_id(sim)
  end
end