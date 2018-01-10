type metadata = {
  kind: string,
  ants: bool,
};

let food_tile = (ants, json: Js.Json.t) : Tile.food_tile => 
  Json.Decode.{
    food: json |> field("food", int),
    ants: ants
  };

let home_tile = (ants, json: Js.Json.t) : Tile.home_tile => 
  Json.Decode.{
    food: json |> field("food", int),
    ants: ants
  };
  
let land_tile = (ants, json: Js.Json.t) : Tile.land_tile => 
  Json.Decode.{
    pheromone: json |> field("pheromone", int),
    ants: ants
  };

let rock_tile = (ants, json: Js.Json.t) : Tile.rock_tile => 
  Json.Decode.{
    food: json |> field("food", int),
    ants: ants
  };

let tile = (kind: string, ants: ants, json: Js.Json.t) : tile =>
  switch kind {
  | "food" => food_tile(ants, json)
  | "land" => land_tile(ants, json)
  | "home" => home_tile(ants, json)
  | "rock" => rock_tile(ants, json)
  }
;

let parse = (json: Js.Json.t) : t => {
  let metadata = Json.Decode.{
    kind: json |> field("kind", string),
    ants: json |> field("ants", bool),
  }

  Json.Decode.{
    tile: json |> field("tile", tile(metadata.kind, metadata.ants, json))
  }.tile;
};
