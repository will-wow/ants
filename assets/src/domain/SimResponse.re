type t = {simId: SimId.t};

type response = {data: t};

let sim = (json: Js.Json.t) : t =>
  Json.Decode.{simId: field("sim_id", int, json)};

let parse = (json: Js.Json.t) : t => {
  let response: response = Json.Decode.{data: field("data", sim, json)};
  response.data;
};