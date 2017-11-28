defmodule Ants.Registries.SimulationPubSub do
  @typep registration_response :: {:ok, pid} | {:error, {:already_registered, pid}}

  @spec register_for_deposit_pheromones(integer) :: registration_response
  def register_for_deposit_pheromones(sim) do
    register(sim, :deposit_pheromones)
  end

  @spec register_for_evaporate_pheromones(integer) :: registration_response
  def register_for_evaporate_pheromones(sim) do
    register(sim, :evaporate_pheromones)
  end

  @spec register_for_move(integer) :: registration_response
  def register_for_move(sim) do
    register(sim, :move)
  end

  @spec deposit_pheromones(integer) :: :ok
  def deposit_pheromones(sim) do
    send_messages(sim, :deposit_pheromones)
  end

  @spec evaporate_pheromones(integer) :: :ok
  def evaporate_pheromones(sim) do
    send_messages(sim, :evaporate_pheromones)
  end

  @spec move(integer) :: :ok
  def move(sim) do
    send_messages(sim, :move)
  end

  @spec send_messages(integer, atom) :: :ok
  defp send_messages(sim, topic) do
    Registry.dispatch(
      __MODULE__,
      {sim, topic},
      send_message(topic)
    )
  end

  @spec send_message(atom) :: (GenServer.server() -> any)
  defp send_message(topic) do
    fn server -> GenServer.call(server, topic) end
  end

  @spec register(integer, atom) :: registration_response
  defp register(sim, topic) do
    Registry.register(__MODULE__, {sim, topic}, [])
  end
end
