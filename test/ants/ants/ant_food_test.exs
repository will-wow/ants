defmodule Ants.Ants.AntFoodTest do
  use ExUnit.Case, async: true

  alias Ants.Ants.Ant
  alias Ants.Ants.AntFood

  describe "deposit food" do
    test "does nothing without food" do
      ant = %Ant{food?: false}
      assert AntFood.deposit_food(ant, 1) == ant
    end
  end
end
