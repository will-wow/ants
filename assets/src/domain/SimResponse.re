type data = {simId: SimId.t};

type t = {data};

let data = (json: Js.Json.t) : data =>
  Json.Decode.{simId: field("sim_id", int, json)};

let parse = (json: Js.Json.t) : t =>
  Json.Decode.{data: field("data", data, json)};

let parseSimId = (json: Js.Json.t) : SimId.t => parse(json).data.simId;

let parseWorld = (json: Js.Json.t) : SimId.t => parse(json).data.simId;