defmodule Ants.Worlds.Point do
  @type x :: integer
  @type y :: integer
  @type t :: {x, y}

  @spec to_index(t, integer) :: integer
  def to_index({x, y}, size) do
    y * size + x
  end

  @spec from_index(integer, integer) :: t
  def from_index(index, size) do
    {
      x_of_index(index, size),
      y_of_index(index, size)
    }
  end

  @spec x_of_index(Enum.index(), integer) :: x
  defp x_of_index(index, size) do
    Integer.mod(index, size)
  end

  @spec y_of_index(Enum.index(), integer) :: y
  defp y_of_index(index, size) do
    Integer.floor_div(index, size)
  end
end
