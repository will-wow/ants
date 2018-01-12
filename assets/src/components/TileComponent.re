let tileClassName = (tile: Tile.t) : string =>
  switch tile {
  | Land(_tile) => "tile tile--land"
  | Food(_tile) => "tile tile--land"
  | Home(_tile) => "tile tile--home"
  | Rock(_tile) => "tile tile--rock"
  };

let is_pheromone = (tile: Tile.t) : bool =>
  switch tile {
  | Land({pheromone}) when pheromone > 0. => true
  | _ => false
  };

let has_food = (tile: Tile.t) : bool =>
  switch tile {
  | Food({food}) when food > 0 => true
  | _ => false
  };

let pheromone_opacity = (tile: Tile.t) : string =>
  switch tile {
  | Land({pheromone}) when pheromone > 0. => string_of_float(pheromone *. 5.)
  | _ => ""
  };

let food_opacity = (tile: Tile.t) : string =>
  switch tile {
  | Food({food}) when food > 0 =>  {
    Printf.sprintf("%f", float_of_int(food) /. 10.);
  }
  | _ => ""
};

let antsOfTile = (tile: Tile.t) : bool =>
  switch tile {
  | Land({ants}) => ants
  | Food({ants}) => ants
  | Home({ants}) => ants
  | Rock({ants}) => ants
  };

let antsClassName = (tile: Tile.t, className: string) : string =>
  className ++ (antsOfTile(tile) ? " tile--ants" : "");

let component = ReasonReact.statelessComponent("World");

let make = (~tile: Tile.t, _children) => {
  ...component,
  render: _self =>
    <div className=(tile |> tileClassName |> antsClassName(tile))>
      (
        if (is_pheromone(tile)) {
          <div
            className="tile--pheromone"
            style=(ReactDOMRe.Style.make(~opacity=pheromone_opacity(tile), ()))
          />;
        } else {
          ReasonReact.nullElement;
        }
      )
      (
        if (has_food(tile)) {
          <div
            className="tile--food"
            style=(ReactDOMRe.Style.make(~opacity=food_opacity(tile), ()))
          />;
        } else {
          ReasonReact.nullElement;
        }
      )
    </div>
};