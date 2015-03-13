points = require './points.json'
window.d3 = require "d3/d3.min.js"
window.topojson = require "topojson"
require "datamaps/dist/datamaps.world.min.js"

window.start = (max) ->
  document.getElementById("map").innerHTML = ''
  map = new Datamap
    element: document.getElementById("map")
    projection: "mercator"
  map.bubbles(points)
start(points.length)