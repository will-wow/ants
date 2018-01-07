let str = ReasonReact.stringToElement;

type action =
  | StartSim;

let startSim = () => {
  let _ =
    Js.Promise.(
      Fetch.fetchWithInit(
        "/api/sim",
        Fetch.RequestInit.make(~method_=Post, ())
      )
      |> then_(Fetch.Response.json)
      |> then_(json => json |> SimResponse.parse |> resolve)
      |> then_(json => json |> Js.log |> resolve)
    );
  ();
};

let component = ReasonReact.statelessComponent("SimStart");

let make = _children => {
  ...component,
  render: _self =>
    <div className="sim-start">
      <h1> (str("Ants!")) </h1>
      <p>
        (str("Simulate ant colony foraging behavior, using Elixir processes."))
      </p>
      <button onClick=((_) => startSim())>
        (str("Start a simulation"))
      </button>
    </div>
};