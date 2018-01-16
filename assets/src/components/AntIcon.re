let component = ReasonReact.statelessComponent("AntIcon");

let make = _children => {
  ...component,
  render: (_) => <span className="icon"> (Utils.str({js|🐜|js})) </span>
};
