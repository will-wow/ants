defmodule Ants.Worlds.World do
  use GenServer

  alias Ants.Worlds.Tile

  @typep world_map :: [[String.t]]
  @typep world :: %{
    optional({integer, integer}) => pid
  }
  @typep pid_and_world :: {pid, world}

  ## Consts

  @world_map [
    "0 0 0 0 0 0 0",
    "0 _ _ _ 0 F 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ 0 _ 0",
    "0 _ 0 _ _ _ 0",
    "0 H _ _ _ _ 0",
    "0 0 0 0 0 0 0"
  ]

  ## Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, @world_map, opts)
  end

  def print(pid) do
    GenServer.call(pid, :print)
  end

  def lookup(pid, {x, y}) do
    GenServer.call(pid, {:tick, x, y})
  end

  def tick(pid) do
    GenServer.cast(pid, :tick)
  end

  ## Server 
  
  @spec init([String.t]) :: {:ok, any}
  def init(map) do
    world_map = world_map_of_list map
    cell_strings = Enum.concat world_map

    tiles = Enum.map &tile_of_cell cell_strings
  end

  def handle_call(:print, _from, world) do
    {:reply, world, world}
  end

  def handle_call({:lookup, x, y}, _from, world) do
    {:reply, world, world}
  end

  def handle_cast(:tick, _from, world) do
    {:noreply, world}
  end

  @spec world_map_of_list([String.t]) :: [[String.t]]
  defp world_map_of_list(rows) do
    Enum.map rows, &split_map_rows/1 
  end

  @spec split_map_rows(String.t) :: [String.t]
  defp split_map_rows(row) do
    String.split row, " "
  end

  @spec tile_type_of_cell(string) :: atom
  defp tile_type_of_cell("0"), do: :rock
  defp tile_type_of_cell("_"), do: :land
  defp tile_type_of_cell("F"), do: :food
  defp tile_type_of_cell("H"), do: :home

  @spec tile_of_cell(string) :: pid
  defp tile_of_cell(cell) do
    type = tile_type_of_cell cell
    Tile.start_link type []
  end
end
