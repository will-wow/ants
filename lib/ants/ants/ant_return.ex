defmodule Ants.Ants.AntReturn do
  alias Ants.Ants.Move

  @spec backwards_move(Move.coord, Move.coord) :: Move.t
  def backwards_move(x, y) do
    cond do
      x < y -> {0, -1}
      x > y -> {-1, 0}
      x == y -> {-1, -1}
    end
  end
end