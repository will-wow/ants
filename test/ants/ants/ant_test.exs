defmodule Ants.Ants.AntTest do
  use ExUnit.Case, async: true

  alias Ants.Ants.Ant

  describe "given an ant" do
    setup [:create_ant]

    test "returns an ant at 0, 0", %{ant: ant} do
      assert Ant.get(ant) == %Ant{x: 0, y: 0}
    end
  end

  defp create_ant(_context) do
    {:ok, ant} = GenServer.start_link(Ant, {1, 0, 0})

    %{ant: ant}
  end
end
