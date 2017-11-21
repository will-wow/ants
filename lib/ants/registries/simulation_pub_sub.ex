defmodule Ants.Registries.SimulationPubSub do
  @typep registration_response = 
    {:ok, pid} | {:error, {:already_registered, pid}}

  @spec register_for_deposit_pheromones(integer) :: registration_response
  def register_for_deposit_pheromones(sim_id) do
    register(sim_id, :deposit_pheromones)
  end

  @spec register_for_evaporate_pheromones(integer) :: registration_response
  def register_for_evaporate_pheromones(sim_id) do
    register(sim_id, :evaporate_pheromones)
  end

  @spec register_for_move(integer) :: registration_response
  def register_for_move(sim_id) do
    register(sim_id, :move)
  end


  @spec deposit_pheromones(integer) :: :ok
  def deposit_pheromones(sim_id) do
    send_messages(sim_id, :deposit_pheromones)
  end

  @spec deposit_pheromones(integer) :: :ok
  def evaporate_pheromones do
    send_messages(sim_id, :evaporate_pheromones)
  end

  @spec deposit_pheromones(integer) :: :ok
  def move do
    send_messages(sim_id, :move)
  end

  @spec send_messages(integer, atom) :: :ok
  defp send_messages(sim_id, topic) do
    Registry.dispatch(
      __MODULE__,
      {sim_id, topic},
      send_message(topic)
    )
  end

  @spec send_message(atom) :: (GenServer.server -> any)
  defp send_message(topic) do
    fn server -> GenServer.call(server, topic) end
  end

  @spec register(integer, atom) :: registration_response
  defp register(sim_id, topic) do
    Registry.register(
      __MODULE__,
      {sim_id, topic},
      []
    )
  end
end
_