#
# Take a set of arcs, and for duplicate routes, increase strokeWidth
# yarn run coffee -- data/inquiries/arc-make-fatter-over-time.coffee
#

fs = require 'fs'
arcs = require '../jsons/all-inquiries-random-subset.json'

additional = 0.4

shuffle = (arcs, path) ->
  # key-value store based origin + dest strings
  derived_arcs = {}

  for arc in arcs
    origin_str = "" + arc.origin.latitude + arc.origin.longitude
    destination_str = "" + arc.destination.latitude + arc.destination.longitude
    arc_str = origin_str + destination_str 

    if derived_arcs.hasOwnProperty origin_str
      derived_arcs[origin_str].strokeWidth += additional
    else
      arc.strokeWidth = 1
      derived_arcs[origin_str] = arc

  # Pull out all values into an array
  new_arcs = []
  Object.keys(derived_arcs).forEach (key) -> new_arcs.push(derived_arcs[key])
  new_arcs = new_arcs.sort((a, b) -> a.strokeWidth - b.strokeWidth)

  fs.writeFileSync __dirname + '/' + path, JSON.stringify new_arcs

shuffle(arcs, "../jsons/shuffled-fatter-inquiry-arcs.json")
