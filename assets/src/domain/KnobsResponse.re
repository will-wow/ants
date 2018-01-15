let parse = (json: Js.Json.t) : Knobs.t =>
  Json.Decode.{
    startingFood: json |> field("starting_food", int),
    mapSize: json |> field("map_size", int),
    startingAnts: json |> field("starting_ants", int),
    pheromoneDeposit: json |> field("pheromone_deposit", float),
    pheromoneDecay: json |> field("pheromone_decay", float),
    pheromoneMultiplier: json |> field("pheromone_multiplier", float),
    forwardWeight: json |> field("forward_weight", float),
  };
