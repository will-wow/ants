// Generated by BUCKLESCRIPT VERSION 2.1.1, PLEASE EDIT WITH CARE
'use strict';

var Block       = require("bs-platform/lib/js/block.js");
var Json_decode = require("@glennsl/bs-json/lib/js/src/Json_decode.js");

function food_tile(ants, json) {
  return /* record */[
          /* ants */ants,
          /* food */Json_decode.field("food", Json_decode.$$int, json)
        ];
}

function home_tile(ants, json) {
  return /* record */[
          /* ants */ants,
          /* food */Json_decode.field("food", Json_decode.$$int, json)
        ];
}

function land_tile(ants, json) {
  return /* record */[
          /* ants */ants,
          /* pheromone */Json_decode.field("pheromone", Json_decode.$$float, json)
        ];
}

function rock_tile(ants, _) {
  return /* record */[/* ants */ants];
}

function tile(kind, ants, json) {
  switch (kind) {
    case "food" : 
        return /* Food */Block.__(1, [food_tile(ants, json)]);
    case "home" : 
        return /* Home */Block.__(2, [home_tile(ants, json)]);
    case "land" : 
        return /* Land */Block.__(0, [land_tile(ants, json)]);
    case "rock" : 
        return /* Rock */Block.__(3, [/* record */[/* ants */ants]]);
    default:
      return /* Rock */Block.__(3, [/* record */[/* ants */ants]]);
  }
}

function parse(json) {
  var metadata_000 = /* kind */Json_decode.field("kind", Json_decode.string, json);
  var metadata_001 = /* ants */Json_decode.field("ants", Json_decode.bool, json);
  var partial_arg = metadata_001;
  var partial_arg$1 = metadata_000;
  return /* record */[/* tile */Json_decode.field("tile", (function (param) {
                    return tile(partial_arg$1, partial_arg, param);
                  }), json)][/* tile */0];
}

exports.food_tile = food_tile;
exports.home_tile = home_tile;
exports.land_tile = land_tile;
exports.rock_tile = rock_tile;
exports.tile      = tile;
exports.parse     = parse;
/* No side effect */
