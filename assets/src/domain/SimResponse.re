type data = {
  simId: SimId.t,
  world: World.t
};

type t = {data};

let parse = (json: Js.Json.t) : data =>
  Json.Decode.{
    simId: json |> field("sim_id", int),
    world: json |> field("world", list(list(TileResponse.parse)))
  };

let parseSimId = (json: Js.Json.t) : SimId.t => parse(json).simId;

let parseWorld = (json: Js.Json.t) : World.t => parse(json).world;
