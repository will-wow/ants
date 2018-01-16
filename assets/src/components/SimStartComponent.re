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
      <h1> <AntIcon /> (Utils.str("Ants")) <AntIcon /> </h1>
      <p>
        (
          Utils.str(
            "Simulate ant colony foraging behavior, using Elixir processes."
          )
        )
      </p>
      <button onClick=(_event => startSim())>
        (Utils.str("Start a simulation"))
      </button>
    </div>
};
