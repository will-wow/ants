type metadata = {
  kind: string,
  ants: bool
};

type data = {tile: Tile.t};

let food_tile = (ants, json: Js.Json.t) : Tile.food_tile =>
  Json.Decode.{food: json |> field("food", int), ants};

let home_tile = (ants, json: Js.Json.t) : Tile.home_tile =>
  Json.Decode.{food: json |> field("food", int), ants};

let land_tile = (ants, json: Js.Json.t) : Tile.land_tile =>
  Json.Decode.{pheromone: json |> field("pheromone", float), ants};

let rock_tile = (ants, _json: Js.Json.t) : Tile.rock_tile => {ants: ants};

let tile = (kind: string, ants: bool, json: Js.Json.t) : Tile.t =>
  switch kind {
  | "food" => Food(food_tile(ants, json))
  | "land" => Land(land_tile(ants, json))
  | "home" => Home(home_tile(ants, json))
  | "rock" => Rock(rock_tile(ants, json))
  | _ => Rock(rock_tile(ants, json))
  };

let parse = (json: Js.Json.t) : Tile.t => {
  let metadata =
    Json.Decode.{
      kind: json |> field("kind", string),
      ants: json |> field("ants", bool)
    };
  Json.Decode.{tile: json |> field("tile", tile(metadata.kind, metadata.ants))}.
    tile;
};
