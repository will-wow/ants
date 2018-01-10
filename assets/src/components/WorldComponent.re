let component = ReasonReact.statelessComponent("World");

let make = (~world: World.t, _children) => {
  ...component,
  render: _self => {
    let _ = Js.log(world);
    <div className="world">
      (
        Utils.each_element(world, row =>
          <div className="world__row">
            (
              Utils.each_element(row, _tile =>
                <div className="world__tile"> (Utils.str("x")) </div>
              )
            )
          </div>
        )
      )
    </div>;
  }
};