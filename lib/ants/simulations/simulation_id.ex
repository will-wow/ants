defmodule Ants.Simulations.SimId do
  use Agent

  @type t :: integer

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @spec next :: t
  def next do
    Agent.get_and_update(__MODULE__, fn id ->
      {id, id + 1}
    end)
  end

  @spec exists?(t) :: boolean
  def exists?(sim_id) do
    sim_id <= top() - 1
  end

  @spec top :: t
  defp top do
    Agent.get(__MODULE__, fn id ->
      id
    end)
  end
end