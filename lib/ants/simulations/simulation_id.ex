defmodule Ants.Simulations.SimId do
  use Agent

  @type t :: integer

  def start_link(_) do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @spec get :: t
  def get do
    Agent.get_and_update(__MODULE__, fn id ->
      {id, id + 1}
    end)
  end
end
