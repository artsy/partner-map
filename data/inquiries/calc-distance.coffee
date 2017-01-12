#
# Uses arcs.json to calculate the average distance of an inquiry
#

arcs = require './arcs.json'
Distance = require 'geo-distance'
fs = require 'fs'

# Calculate average
distances = for arc in arcs
  d = Distance.between(
    { lat: arc.destination.latitude, lon: arc.destination.longitude }
    { lat: arc.origin.latitude, lon: arc.origin.longitude }
  )
  Number d.human_readable().distance
total = 0
total += d for d in distances
console.log "The average distance between inquirer and partner is: " +
  "#{avg = km = Math.round total / distances.length}km or #{Math.round km * 0.621371} miles"

# Output above average arcs
aboveAvgArcs = arcs.filter (arc) ->
  d = Distance.between(
    { lat: arc.destination.latitude, lon: arc.destination.longitude }
    { lat: arc.origin.latitude, lon: arc.origin.longitude }
  )
  d.human_readable().distance > 11000
fs.writeFileSync __dirname + '/above-avg-arcs.json', JSON.stringify aboveAvgArcs
console.log "There are #{aboveAvgArcs.length} transactions that span longer than the average."