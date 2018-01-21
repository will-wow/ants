defmodule Ants.Ants.ToHome do
  alias Ants.Ants.Move
  alias Ants.Worlds.Point

  @spec backwards_move(Point.t()) :: Move.t()
  def backwards_move({x, y}) do
    cond do
      x < y -> {0, -1}
      x > y -> {-1, 0}
      x == y -> {-1, -1}
    end
  end
end
