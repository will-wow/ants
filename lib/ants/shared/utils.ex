defmodule Ants.Shared.Utils do
  def inc(n), do: n + 1

  def dec(n), do: n - 1

  @spec map_indexed(Enum.t, ({Enum.element, Enum.index} -> any)) :: list
  def map_indexed(enum, f) do
    enum
    |> Stream.with_index()
    |> Enum.map(f)
  end
end