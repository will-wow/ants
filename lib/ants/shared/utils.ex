defmodule Ants.Shared.Utils do
  @typep acc :: Enum.acc()
  @typep element :: Enum.element()
  @typep index :: Enum.index()

  def inc(n), do: n + 1

  def dec(n), do: n - 1

  @spec map_indexed(Enum.t(), ({element, index} -> any)) :: list
  def map_indexed(enum, f) do
    enum
    |> Stream.with_index()
    |> Enum.map(f)
  end

  @spec reduce_indexed(Enum.t(), acc, ({element, index}, acc -> acc)) :: acc
  def reduce_indexed(enum, acc, f) do
    enum
    |> Stream.with_index()
    |> Enum.reduce(f, acc)
  end
end
