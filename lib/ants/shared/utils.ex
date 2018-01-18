defmodule Ants.Shared.Utils do
  alias Ants.Shared.Pair

  @type weighted_pair :: Pair.t(any, number)
  @type on_weighted_select :: maybe(any, atom)

  @type maybe(ok, error) :: {:ok, ok} | {:error, error}

  @typep acc :: Enum.acc()
  @typep element :: Enum.element()
  @typep index :: Enum.index()

  @spec inc(number) :: number
  def inc(n), do: n + 1

  @spec dec(number) :: number
  def dec(n), do: n - 1

  @spec inc_by(number) :: (number -> number)
  def inc_by(i), do: fn n -> n + i end

  @spec dec_by(number) :: (number -> number)
  def dec_by(i), do: fn n -> n - i end

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

  @spec log(any, any | [any]) :: nil
  def log(data, info) when is_list(info) do
    IO.inspect([data | info])
    data
  end

  def log(data, info) do
    IO.inspect([data, info])
    data
  end

  @spec weighted_select([weighted_pair]) :: on_weighted_select
  def weighted_select([]), do: {:error, :empty}

  def weighted_select(list) do
    total =
      list
      |> Enum.map(&Pair.last/1)
      |> Enum.sum()

    case total do
      0 ->
        {:error, :no_weights}

      _ ->
        random = :rand.uniform() * total

        {:ok, weighted_select(list, random, 0)}
    end
  end

  defp weighted_select(list, random, sum) do
    case list do
      [] ->
        raise "bad total"

      [hd | tl] ->
        sum = sum + Pair.last(hd)

        if sum >= random do
          Pair.first(hd)
        else
          weighted_select(tl, random, sum)
        end
    end
  end
end
