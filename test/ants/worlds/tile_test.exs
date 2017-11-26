defmodule Ants.Worlds.TileTest do
  use ExUnit.Case, async: true

  alias Ants.Worlds.Tile
  alias Ants.Worlds.Tile.Land
  alias Ants.Worlds.Tile.Food
  alias Ants.Worlds.Tile.Rock
  alias Ants.Worlds.Tile.Home

  describe "given a land tile" do
    setup [:create_land]

    test "returns a land", %{tile: tile} do
      assert Tile.get(tile) == %Land{}
    end

    test "adds pheromones", %{tile: tile} do
      assert Tile.deposit_pheromones(tile) == {:ok}
      assert Tile.get(tile) == %Land{pheromone: 1}

      assert Tile.deposit_pheromones(tile) == {:ok}
      assert Tile.get(tile) == %Land{pheromone: 2}
    end

    test "can't take food", %{tile: tile} do
      cant_take_food tile
    end

    test "can't deposit food", %{tile: tile} do
      cant_deposit_food tile
    end
  end

  describe "given a food tile" do
    setup [:create_food]

    test "returns a full food", %{tile: tile} do
      assert Tile.get(tile) == %Food{food: 10}
    end

    test "can't add pheromones", %{tile: tile} do
      cant_deposit_pheromones tile
    end

    test "can take food", %{tile: tile} do
      assert Tile.take_food(tile) == {:ok, 1}
    end

    test "converts empty food to land", %{tile: tile} do
      Enum.each(1..10, fn(_) -> Tile.take_food(tile) end)

      assert Tile.take_food(tile) == {:error, :not_food}
      assert Tile.get(tile) == %Land{}
    end
  end

  describe "given a rock tile" do
    setup [:create_rock]

    test "returns a rock", %{tile: tile} do
      assert Tile.get(tile) == %Rock{}
    end

    test "can't add pheromones", %{tile: tile} do
      cant_deposit_pheromones tile
    end

    test "can't take food", %{tile: tile} do
      cant_take_food tile
    end

    test "can't deposit food", %{tile: tile} do
      cant_deposit_food tile
    end
  end

  describe "given a home tile" do
    setup [:create_home]

    test "returns a home with no food", %{tile: tile} do
      assert Tile.get(tile) == %Home{food: 0}
    end

    test "can't add pheromones", %{tile: tile} do
      cant_deposit_pheromones tile
    end

    test "can't take food", %{tile: tile} do
      cant_take_food tile
    end

    test "can deposit food", %{tile: tile} do
      assert Tile.deposit_food(tile) == {:ok}
      assert Tile.deposit_food(tile) == {:ok}

      assert Tile.get(tile) == %Home{food: 2}
    end
  end

  defp create_land(_context) do
    {:ok, tile} = GenServer.start_link(Tile, :land)
    %{tile: tile}
  end

  defp create_rock(_context) do
    {:ok, tile} = GenServer.start_link(Tile, :rock)
    %{tile: tile}
  end

  defp create_home(_context) do
    {:ok, tile} = GenServer.start_link(Tile, :home)
    %{tile: tile}
  end

  defp create_food(_context) do
    {:ok, tile} = GenServer.start_link(Tile, :food)
    %{tile: tile}
  end

  defp cant_take_food(tile) do
    assert Tile.take_food(tile) == {:error, :not_food}
  end

  defp cant_deposit_pheromones(tile) do
    assert Tile.deposit_pheromones(tile) == {:error, :not_land}
  end

  defp cant_deposit_food(tile) do
    assert Tile.deposit_food(tile) == {:error, :not_home}
  end
end