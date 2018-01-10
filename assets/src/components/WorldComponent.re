let component = ReasonReact.statelessComponent("World");

let make = (~world: World.t, _children) => {
  ...component,
  render: _self =>
    <div className="world">
      (
        Utils.each_element(world, row =>
          <div className="world__row">
            (
              Utils.each_element(row, tile =>
                <div className="world__tile"> <TileComponent tile /> </div>
              )
            )
          </div>
        )
      )
    </div>
};