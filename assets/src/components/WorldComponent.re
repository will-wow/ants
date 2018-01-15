let component = ReasonReact.statelessComponent("World");

let make = (~world: World.t, ~knobs: Knobs.t, _children) => {
  ...component,
  render: _self =>
    <div className="world">
      (
        Utils.each_element(world, (i, row) =>
          <div className="world__row" key=(string_of_int(i))>
            (
              Utils.each_element(row, (i, tile) =>
                <div className="world__tile" key=(string_of_int(i))>
                  <TileComponent tile knobs />
                </div>
              )
            )
          </div>
        )
      )
    </div>
};
