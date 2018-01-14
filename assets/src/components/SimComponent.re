let str = ReasonReact.stringToElement;

type state = {
  world: World.t,
  fetching: bool
};

type action =
  | FetchWorld
  | DoTurn
  | DoAutoTurn
  | Pause
  | UpdateWorld(World.t);

let turnLength = 50;

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
  initialState: () => {world: [], fetching: false},
  reducer: (action, state) =>
    switch action {
    | UpdateWorld(world) => ReasonReact.Update({...state, world})
    | DoAutoTurn =>
      ReasonReact.SideEffects(
        (
          ({state, send}) =>
            if (state.fetching) {
              send(DoTurn);
            }
        )
      )
    | DoTurn => ReasonReact.SideEffects((({send}) => doTurn(send, simId)))
    | Pause => ReasonReact.Update({...state, fetching: ! state.fetching})
    | FetchWorld =>
      ReasonReact.SideEffects((({send}) => fetchWorld(send, simId)))
    },
  didMount: ({send}) => {
    send(FetchWorld);
    ReasonReact.NoUpdate;
  },
  subscriptions: ({send}) => [
    Sub(
      () => Js.Global.setInterval(() => send(DoAutoTurn), turnLength),
      Js.Global.clearInterval
    )
  ],
  render: ({state, send}) =>
    <div className="sim">
      <h1> (str({j|Sim $simId|j})) </h1>
      <h2> (str("Go ants go!")) </h2>
      <WorldComponent world=state.world />
      <div className="sim__buttons">
        <button onClick=(_event => send(DoTurn))> (str("Turn")) </button>
        <button onClick=(_event => send(Pause))>
          (state.fetching ? str("Pause") : str("Play"))
        </button>
      </div>
    </div>
};