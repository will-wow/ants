type sim = {simId: SimId.t};

type t = {data: sim};

let sim = (json: Js.Json.t) : sim =>
  Json.Decode.{simId: field("sim_id", int, json)};

let parse = (json: Js.Json.t) : t =>
  Json.Decode.{data: field("data", sim, json)};