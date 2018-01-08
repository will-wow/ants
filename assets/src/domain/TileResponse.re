type tile = {
  food: option(int),
  pheromone: option(int)
};

type t = {
  kind: string,
  ants: bool,
  tile: tile
};

let tile = (json: Js.Json.t) : tile =>
  Json.Decode.{
    food: json |> optional(field("food", int)),
    pheromone: json |> optional(field("pheromone", int))
  };

let parse = (json: Js.Json.t) : t =>
  Json.Decode.{
    kind: json |> field("kind", string),
    ants: json |> field("ants", bool),
    tile: json |> field("tile", tile)
  };

let parseTile = (json: Js.Json.t) : Tile.t => {
  let data = parse(json);

  let ants = data.ants;

  let food = switch data.tile.food {
  | Some(food) => food
  | None => 0
  };

  let pheromone = switch data.tile.pheromone {
  | Some(pheromone) => pheromone
  | None => 0
  };

  switch data.kind {
  | "land" => 
    Land({ants: data.ants, pheromone: pheromone});
  };
};