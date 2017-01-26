#
# Take a set of arcs, and pick a random 1 in x
# yarn run coffee -- data/inquiries/inquiry-random-subsets.coffee
#

fs = require 'fs'

random = (min, max) -> Math.round(Math.random() * (max - min) + min)

derive = (amount, arcs, path) ->
  luckyOnes = arcs.filter (arc) -> random(0, amount) == 23
  console.log "There are #{luckyOnes.length} arcs from #{arcs.length} in #{path}"
  fs.writeFileSync __dirname + '/' + path, JSON.stringify luckyOnes

all_arcs = require '../jsons/every-inquiry-arcs.json'
derive(150, all_arcs, "../jsons/all-inquiries-random-subset.json")

unique_arcs = require '../jsons/unique-inquiry-arcs.json'
derive(100, unique_arcs, "../jsons/unique-inquiries-random-subset.json")
