let str = ReasonReact.stringToElement;

let startSim = (router: DirectorRe.t) => {
  let _ =
    Js.Promise.(
      Fetch.fetchWithInit(
        "/api/sim",
        Fetch.RequestInit.make(~method_=Post, ())
      )
      |> then_(Fetch.Response.json)
      |> then_(json => json |> SimResponse.parse |> resolve)
      |> then_((simResponse: SimResponse.t) => {
           let simId = simResponse.simId;
           {j|sim/$(simId)|j} |> DirectorRe.setRoute(router) |> resolve;
         })
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