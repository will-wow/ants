let parse = (json: Js.Json.t) : Knobs.t =>
  Json.Decode.{
    startingFood: json |> field("starting_food", int),
    mapSize: json |> field("map_size", int),
    startingAnts: json |> field("starting_ants", int),
    pheromoneDeposit: json |> field("pheromone_deposit", float),
    pheromoneEvaporationCoefficient:
      json |> field("pheromone_evaporation_coefficient", float),
    pheromoneInfluence: json |> field("pheromone_influence", float)
  };
