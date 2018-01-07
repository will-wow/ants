let str = ReasonReact.stringToElement;

let component = ReasonReact.statelessComponent("SimStart");
let make = (_children) => {
  ...component,
  render: _self =>
  <div className="sim-start">
    <h1>(str("Ants!"))</h1>
    <p>(str("Simulate ant colony foraging behavior, using Elixir processes."))</p>
    <button>(str("Start a simulation"))</button>
  </div>
};

