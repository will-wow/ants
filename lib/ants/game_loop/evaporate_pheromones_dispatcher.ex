defmodule Ants.GameLoop.EvaporatePheromonesDispatcher do
  def start_link do
    Registry.start_link(keys: :duplicate)
  end
end