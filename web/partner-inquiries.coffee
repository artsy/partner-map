# yarn run browserify -- lib/partners-inquiries.coffee -t coffeeify > public/partners-inquiries.js
# yarn run watchify -- lib/partners-inquiries.coffee -t coffeeify -o public/partners-inquiries.js

points = require '../data/jsons/galleries-subset.json'
raw_arcs = require '../data/jsons/unique-inquiries-random-subset'
# raw_arcs = require '../data/jsons/shuffled-every-inquiry-arcs.json'
# raw_arcs = require '../data/jsons/shuffled-fatter-arcs.json'

window.arcs = raw_arcs.map (p) -> { origin: p.origin, destination: p.destination, created_at: Date.parse(p.created_at) }
                      .filter (a) -> !!a.origin.latitude && !!a.origin.longitude
                      .filter (a) -> !!a.destination.latitude && !!a.destination.longitude
                       .sort((a, b) -> a.created_at - b.created_at )

window.topojson = require "topojson"

window.dateMapped = {}

# Setup the bubbles to start
window.setup = (max) ->
  document.getElementById("map").innerHTML = ''
  window.map = new Datamap
    element: document.getElementById("map")
    projection: "mercator"
    bubblesConfig: {
      animate: false
    }

  window.map.bubbles(points)

window.startArcs = () ->
  allDates = window.arcs.map((p) -> p.created_at)
            .filter((v, i, a) -> a.indexOf(v) == i)
            .sort((a, b) -> a - b )

  window.start = allDates[0]
  window.last = allDates[allDates.length - 1]
  window.values = window.last - window.start

  window.timeframeMS = 1000 * 10
  
  window.increment = Math.round(window.values / allDates.length) * 4.5
  window.frameDuration = window.timeframeMS / window.values
  
  # Get all potential increments ( these numbers are big )
  allIncrements = []
  for v in [window.start..window.last] by window.increment
    allIncrements.push v

  window.dateMapped.allDates = allIncrements
  window.iteration = window.start

  for date in allIncrements
    window.dateMapped[date] = window.arcs.filter((p) -> p.created_at <= date)

  window.animateIn()


window.formatter = new Intl.DateTimeFormat "en", { month: "short", year: "numeric" }

window.animateIn = () ->
    return if window.iteration > window.last

    date = new Date(window.iteration)
    $("#year").text(window.formatter.format(date))

    if window.dateMapped.allDates.includes(window.iteration)
        toNow = window.dateMapped[window.iteration]
        window.map.arc(toNow)

    window.iteration += window.increment
    setTimeout(window.animateIn, window.frameDuration)


setup(points.length)
setTimeout(window.startArcs, 1000)
