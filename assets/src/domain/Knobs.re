type t = {
  startingFood: int,
  mapSize: int,
  startingAnts: int,
  pheromoneDeposit: float,
  pheromoneDecay: float,
  pheromoneMultiplier: float,
  forwardWeight: float
};

let default = {
  startingFood: 0,
  mapSize: 0,
  startingAnts: 0,
  pheromoneDeposit: 0.,
  pheromoneDecay: 0.,
  pheromoneMultiplier: 0.,
  forwardWeight: 0.
};
