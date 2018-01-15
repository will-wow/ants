// Generated by BUCKLESCRIPT VERSION 2.1.1, PLEASE EDIT WITH CARE
'use strict';

var Json_decode                = require("@glennsl/bs-json/lib/js/src/Json_decode.js");
var TileResponse$ReactTemplate = require("./TileResponse.bs.js");

function parse(json) {
  return /* record */[
          /* simId */Json_decode.field("sim_id", Json_decode.$$int, json),
          /* world */Json_decode.field("world", (function (param) {
                  return Json_decode.list((function (param) {
                                return Json_decode.list(TileResponse$ReactTemplate.parse, param);
                              }), param);
                }), json)
        ];
}

function parseSimId(json) {
  return parse(json)[/* simId */0];
}

function parseWorld(json) {
  return parse(json)[/* world */1];
}

exports.parse      = parse;
exports.parseSimId = parseSimId;
exports.parseWorld = parseWorld;
/* No side effect */
