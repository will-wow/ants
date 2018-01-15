let str = ReasonReact.stringToElement;

let startSim = () => {
  let _ =
    Js.Promise.(
      "/api/sim"
      |> Http.post
      |> Http.json
      |> then_(json => json |> SimResponse.parseSimId |> resolve)
      |> then_((simId: SimId.t) =>
           {j|sim/$(simId)|j} |> ReasonReact.Router.push |> resolve
         )
    );
  ();
};

let component = ReasonReact.statelessComponent("SimStart");

let make = _children => {
  ...component,
  render: (_) =>
    <div className="sim-start">
      <h1> (str("Ants!")) </h1>
      <p>
        (str("Simulate ant colony foraging behavior, using Elixir processes."))
      </p>
      <button onClick=(_event => startSim())>
        (str("Start a simulation"))
      </button>
    </div>
};
