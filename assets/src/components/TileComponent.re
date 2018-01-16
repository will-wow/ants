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

let pheromoneOpacity = (tile: Tile.t, maxPheromone: float) : string =>
  switch tile {
  | Land({pheromone}) when pheromone > 0. =>
    string_of_float(pheromone /. maxPheromone)
  | _ => ""
  };

let foodOpacity = (tile: Tile.t, maxFood: float) : string =>
  switch tile {
  | Food({food}) when food > 0 =>
    Printf.sprintf("%f", float_of_int(food) /. maxFood)
  | _ => ""
  };

let maxFood = (knobs: Knobs.t) : float => float_of_int(knobs.startingFood);

let maxPheromone = (knobs: Knobs.t) : float => 5. *. knobs.pheromoneDeposit;

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

let make = (~tile: Tile.t, ~knobs: Knobs.t, _children) => {
  ...component,
  render: _self =>
    <div className=(tile |> tileClassName |> antsClassName(tile))>
      (
        if (is_pheromone(tile)) {
          <div
            className="tile--pheromone"
            style=(
              ReactDOMRe.Style.make(
                ~opacity=maxPheromone(knobs) |> pheromoneOpacity(tile),
                ()
              )
            )
          />;
        } else {
          ReasonReact.nullElement;
        }
      )
      (
        if (has_food(tile)) {
          <div
            className="tile--food"
            style=(
              ReactDOMRe.Style.make(
                ~opacity=maxFood(knobs) |> foodOpacity(tile),
                ()
              )
            )
          />;
        } else {
          ReasonReact.nullElement;
        }
      )
    </div>
};
