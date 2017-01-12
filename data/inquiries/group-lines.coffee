#
# Groups dense arcs together into thicker arcs to visually clean things up.
# yarn run coffee -- data/inquiries/group-lines.coffee

arcs = require '../jsons/every-inquiry-arcs.json'
Distance = require 'geo-distance'
fs = require 'fs'

MIN_KM = 500
NEIGHBOR_KM_THRESHOLD = 500
FILTERED_RADIUS = 2000

avgPoint = (arcs, name, point) ->
  avg = 0
  for arc in arcs
    avg += arc[name][point]
  avg = avg / arcs.length

# Find the arcs that are long distance e.g. not NY to NY
longDistanceArcs = []
for arc in arcs
  dist = Distance.between(
    { lat: arc.origin.latitude, lon: arc.origin.longitude }
    { lat: arc.destination.latitude, lon: arc.destination.longitude }
  ).human_readable().distance
  longDistanceArcs.push arc if dist > km = MIN_KM
console.log "There are #{longDistanceArcs.length} inquiries over #{km}km"

# Find the arcs the originate close to a specified point
bejing = { lat: 39.9388838, lon: 116.3974589 }
ny = { lat: 40.7188368, lon: -74.0026667 }
london = { lat: 51.5286416, lon: -0.1015987 }
argentina = { lat: -38.4192641, lon: -63.5989206 }
sydney = { lat: -33.7969235, lon: 150.9224326 }
capetown = { lat: -33.9149861, lon: 18.6560594 }
senegal = { lat: 14.5001717, lon: -14.4392276 }
la = { lat: 34.0204989, lon: -118.4117325 }
dubai = { lat: 21.6440504, lon: 57.1889897 }
filteredArcs = []
for arc in longDistanceArcs
  dist = Distance.between(
    { lat: arc.destination.latitude, lon: arc.destination.longitude }
    ny
  ).human_readable().distance
  filteredArcs.push arc if dist < FILTERED_RADIUS
console.log "There are #{filteredArcs.length} inquiries going to filtered city"

console.log("About to start looking at grouping the arcs, warning, this will take a very, very long time.")
console.log("It took 13500.87s last time, 4 hours on a Mac Pro.")

# Find the arcs that have less than 10 neighboring arcs
# Warning: This took 4 hours in Jan 2017, https://artsy.slack.com/archives/dev-offtopic/p1485286651000846
#
grouppedArcs = {}
for arc, i in filteredArcs
  neighbors = []
  for arc2 in filteredArcs
    originKm = Distance.between(
      { lat: arc.origin.latitude, lon: arc.origin.longitude }
      { lat: arc2.origin.latitude, lon: arc2.origin.longitude }
    ).human_readable().distance
    destKm = Distance.between(
      { lat: arc.destination.latitude, lon: arc.destination.longitude }
      { lat: arc2.destination.latitude, lon: arc2.destination.longitude }
    ).human_readable().distance
    if originKm < NEIGHBOR_KM_THRESHOLD and destKm < NEIGHBOR_KM_THRESHOLD
      neighbors.push(arc2)
  key = [
    String Math.round avgPoint(neighbors, 'origin', 'latitude')
    String Math.round avgPoint(neighbors, 'origin', 'longitude')
  ].join ''
  grouppedArcs[key] ?= []
  grouppedArcs[key].push arc

averagedArcs = (for key, arcs of grouppedArcs
  arcs[0]
  # {
  #   origin:
  #     latitude: avgPoint(arcs, 'origin', 'latitude')
  #     longitude: avgPoint(arcs, 'origin', 'longitude')
  #   destination:
  #     latitude: avgPoint(arcs, 'destination', 'latitude')
  #     longitude: avgPoint(arcs, 'destination', 'longitude')
  # }
)
console.log "There are #{averagedArcs.length} arcs with similar arcs averaged together"
fs.writeFileSync __dirname + '../jsons/every-inquiry-arcs-grouped.json', JSON.stringify averagedArcs
