defmodule Ants.Ants.Move do
  alias Ants.Worlds.Point

  @type dx :: integer
  @type dy :: integer
  @type t :: {dx, dy}

  @row_length 3
  @highest_index @row_length * 3 - 1

  @spec x(t) :: dx
  def x({x, _}), do: x

  @spec y(t) :: dy
  def y({_, y}), do: y

  @spec forward_to_index(t) :: Enum.index()
  def forward_to_index(move) do
    move
    |> to_point()
    |> Point.to_index(@row_length)
  end

  @spec backward_to_index(t) :: Enum.index()
  def backward_to_index(move) do
    @highest_index - forward_to_index(move)
  end

  @spec to_point(t) :: Point.t()
  def to_point({dx, dy}) do
    {dx + 1, dy + 1}
  end

  def from_index(index) do
    index
    |> Point.from_index(@row_length)
    |> from_point()
  end

  @spec from_point(Point.t()) :: t
  def from_point({x, y}) do
    {x - 1, y - 1}
  end
end
