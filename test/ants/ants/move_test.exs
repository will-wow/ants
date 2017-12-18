defmodule Ants.Ants.MoveTest do
  use ExUnit.Case, async: true

  alias Ants.Worlds.Surroundings
  alias Ants.Ants.Move

  describe "forward_to_index" do
    test "goes north east" do
      assert Move.forward_to_index({1, 1}) == 8
    end

    test "goes south west" do
      assert Move.forward_to_index({-1, -1}) == 0
    end

    test "goes south" do
      assert Move.forward_to_index({0, -1}) == 1
    end
  end

  describe "backward_to_index" do
    test "goes back to south west" do
      assert Move.backward_to_index({1, 1}) == 0
    end

    test "goes back to north east" do
      assert Move.backward_to_index({-1, -1}) == 8
    end

    test "goes back to north" do
      assert Move.backward_to_index({0, -1}) == 7
    end
  end
end