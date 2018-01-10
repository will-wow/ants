let str = ReasonReact.stringToElement;

let startSim = (router: DirectorRe.t) => {
  let _ =
    Js.Promise.(
      "/api/sim"
      |> Http.post
      |> then_(json => json |> SimResponse.parseSimId |> resolve)
      |> then_((simId: SimId.t) =>
           {j|sim/$(simId)|j} |> DirectorRe.setRoute(router) |> resolve
         )
    );
  ();
};

let component = ReasonReact.statelessComponent("SimStart");

let make = (~router: DirectorRe.t, _children) => {
  ...component,
  render: (_) =>
    <div className="sim-start">
      <h1> (str("Ants!")) </h1>
      <p>
        (str("Simulate ant colony foraging behavior, using Elixir processes."))
      </p>
      <button onClick=(_event => startSim(router))>
        (str("Start a simulation"))
      </button>
    </div>
};