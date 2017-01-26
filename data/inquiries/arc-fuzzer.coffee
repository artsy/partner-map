#
# Take a set of arcs, and moves duplicates slightly to a random direction
# yarn run coffee -- data/inquiries/arc-fuzzer.coffee
#

fs = require 'fs'
arcs = require '../jsons/all-inquiries-random-subset.json'

# After messing around on http://www.movable-type.co.uk/scripts/latlong.html
# it felt like a difference of +- .04 should do that (~100km circular dist)
# we're looking from pretty far back
diff = 0.4

shift = (min, max) -> Math.random() * (max - min) + min

all_locations = []

shuffle = (arcs, path) ->
  for arc in arcs
    origin_str = "" + arc.origin.latitude + arc.origin.longitude
    destination_str = "" + arc.destination.latitude + arc.destination.longitude

    if all_locations.includes origin_str
      arc.origin.latitude += shift(-diff, diff)
      arc.origin.longitude += shift(-diff, diff)

    if all_locations.includes destination_str
      arc.destination.latitude += shift(-diff, diff)
      arc.destination.longitude += shift(-diff, diff)

    all_locations.push origin_str
    all_locations.push destination_str

  fs.writeFileSync __dirname + '/' + path, JSON.stringify arcs

shuffle(arcs, "../jsons/shuffled-every-inquiry-arcs.json")
