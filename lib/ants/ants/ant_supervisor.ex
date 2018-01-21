defmodule Ants.Ants.AntSupervisor do
  use DynamicSupervisor

  alias Ants.Shared.SimRegistry
  alias Ants.Simulations.SimId
  alias Ants.Ants.AntId
  alias Ants.Ants.Ant

  def start_link(sim) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: via(sim))
  end

  @spec start_ant(SimId.t(), integer, integer, AntId.t()) :: Supervisor.on_start_child()
  def start_ant(sim, x, y, id) do
    DynamicSupervisor.start_child(
      via(sim),
      {Ant, {sim, x, y, [name: ant_via(sim, id)]}}
    )
  end

  @spec get_ant(integer, integer) :: pid
  def get_ant(sim, id) do
    sim
    |> ant_via(id)
    |> GenServer.whereis()
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defdelegate via(sim), to: SimRegistry, as: :ant_supervisor
  defdelegate ant_via(sim, id), to: SimRegistry, as: :ant
end
