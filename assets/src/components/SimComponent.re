let str = ReasonReact.stringToElement;

let component = ReasonReact.statelessComponent("Sim");
let make = (~simId, _children) => {
  ...component,
  render: _self =>
  <div className="sim">
    <h1>(str({j|Sim $simId|j}))</h1>
    <h2>(str("Go ants go!"))</h2>
    <div className="ants"></div>
    <button>(str("Pause"))</button>
  </div>
};

