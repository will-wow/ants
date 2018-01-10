type land_tile = {
  ants: bool,
  pheromone: int
};

type food_tile = {
  ants: bool,
  food: int
};

type home_tile = {
  ants: bool,
  food: int
};

type rock_tile = {ants: bool};

type t =
  | Land(land_tile)
  | Food(food_tile)
  | Home(home_tile)
  | Rock(rock_tile);