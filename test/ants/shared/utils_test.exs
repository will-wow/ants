defmodule Ants.Shared.UtilsTest do
  use ExUnit.Case, async: true

  alias Ants.Shared.Utils

  describe "weighted_select" do
    test "selects an item" do
      assert Utils.weighted_select([{"nope", 0}, {"yep", 1}]) == {:ok, "yep"}
    end
  end
end
