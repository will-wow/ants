let component = ReasonReact.statelessComponent("NotFound");

let make = _children => {
  ...component,
  render: _self =>
    <div className="not-found">
      <h1> (Utils.str("404")) </h1>
      <p> (Utils.str("The ants got lost!")) </p>
    </div>
};
