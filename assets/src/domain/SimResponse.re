type data = {
  simId: SimId.t,
  world: World.t
};

type t = {data};

let data = (json: Js.Json.t) : data =>
  Json.Decode.{
    simId: json |> field("sim_id", int),
    world: json |> field("world", list(list(TileResponse.parse)))
  };

let parse = (json: Js.Json.t) : t =>
  Json.Decode.{data: json |> field("data", data)};

let parseSimId = (json: Js.Json.t) : SimId.t => parse(json).data.simId;

let parseWorld = (json: Js.Json.t) : World.t => parse(json).data.world;