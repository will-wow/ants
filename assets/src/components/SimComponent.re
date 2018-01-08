let str = ReasonReact.stringToElement;

type state = {world: World.t};

type action =
  | UpdateWorld(World.t);

let updateWorld = (reduce, json) =>
  json |> SimResponse.parseWorld |> reduce(world => UpdateWorld(world));

let fetchWorld = (reduce, simId: SimId.t) : unit => {
  let _ =
    Js.Promise.(
      Http.get({j|/api/sim/$simId|j})
      |> then_(json => json |> updateWorld(reduce) |> resolve)
    );
  ();
};

let doTurn = (reduce, simId: SimId.t) : unit => {
  let _ =
    Js.Promise.(
      {j|/api/sim/$simId/turn|j}
      |> Http.post
      |> then_(json => json |> updateWorld(reduce) |> resolve)
    );
  ();
};

let component = ReasonReact.reducerComponent("Sim");

let make = (~simId: SimId.t, _children) => {
  ...component,
  initialState: () => {world: []},
  didMount: ({reduce}) =>
    ReasonReact.SideEffects(_self => fetchWorld(reduce, simId)),
  render: ({reduce}) =>
    <div className="sim">
      <h1> (str({j|Sim $simId|j})) </h1>
      <h2> (str("Go ants go!")) </h2>
      /* <WorldComponent /> */
      <button> (str("Pause")) </button>
    </div>
};