defmodule Ants.AntTest do
  use ExUnit.Case, async: true

  alias Ants.Ant

  describe "given a land tile" do
    setup [:create_ant]

    test "returns a land", %{ant: ant} do
      assert Ant.get(ant) == %Ant{x: 0, y: 0}
    end
  end

  defp create_ant(_context) do
    {:ok, ant} = GenServer.start_link(Ant, {0, 0})

    %{ant: ant}
  end
end
