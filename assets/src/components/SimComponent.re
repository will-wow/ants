let str = ReasonReact.stringToElement;

type state = {world: World.t};

type action =
  | FetchWorld
  | DoTurn
  | UpdateWorld(World.t);

let updateWorld = (send, json) => {
  let world = json |> SimResponse.parseWorld;
  send(UpdateWorld(world));
};

let fetchWorld = (send, simId: SimId.t) : unit => {
  let _ =
    Js.Promise.(
      Http.get({j|/api/sim/$simId|j})
      |> then_(json => json |> updateWorld(send) |> resolve)
    );
  ();
};

let doTurn = (send, simId: SimId.t) : unit => {
  let _ =
    Js.Promise.(
      {j|/api/sim/$simId/turn|j}
      |> Http.post
      |> then_(json => json |> updateWorld(send) |> resolve)
    );
  ();
};

let component = ReasonReact.reducerComponent("Sim");

let make = (~simId: SimId.t, _children) => {
  ...component,
  initialState: () => {world: []},
  reducer: (action, state) =>
    switch action {
    | UpdateWorld(world) => ReasonReact.Update({world: world})
    | DoTurn => ReasonReact.SideEffects((({send}) => doTurn(send, simId)))
    | FetchWorld =>
      ReasonReact.SideEffects((({send}) => fetchWorld(send, simId)))
    },
  didMount: ({send}) => {
    send(FetchWorld);
    ReasonReact.NoUpdate;
  },
  render: ({state, send}) =>
    <div className="sim">
      <h1> (str({j|Sim $simId|j})) </h1>
      <h2> (str("Go ants go!")) </h2>
      <WorldComponent world=state.world />
      <button onClick=(_event => send(DoTurn))> (str("Turn")) </button>
    </div>
};