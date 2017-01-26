# yarn run browserify -- lib/partners-inquiries.coffee -t coffeeify > public/partners-inquiries.js
# yarn run watchify -- lib/partners-inquiries.coffee -t coffeeify -o public/partners-inquiries.js

points = require '../data/jsons/galleries-subset.json'
# raw_arcs = require '../data/jsons/unique-inquiries-random-subset'
raw_arcs = require '../data/jsons/shuffled-every-inquiry-arcs.json'

window.arcs = raw_arcs.map (p) -> { origin: p.origin, destination: p.destination, created_at: Date.parse(p.created_at) }
                      .filter (a) -> !!a.origin.latitude && !!a.origin.longitude
                      .filter (a) -> !!a.destination.latitude && !!a.destination.longitude
                       .sort((a, b) -> a.created_at - b.created_at )

window.topojson = require "topojson"

window.arcMapped = {}
window.bubbleMapped = {}


window.bubblesTime = 1
window.arcsTime = 10
window.arcsMultiplier = 4

# Setup the bubbles to start
window.setup = (max) ->
  document.getElementById("map").innerHTML = ''
  window.map = new Datamap
    element: document.getElementById("map")
    projection: "mercator"
    bubblesConfig: {
      animate: false
    }

window.startBubbles = () ->
  allDates = points.map((p) -> p.created_at)
            .filter((v, i, a) -> a.indexOf(v) == i)
            .sort((a, b) -> a - b )

  window.start = allDates[0]
  window.last = allDates[allDates.length - 1]
  window.timeframeMS = 1000 * window.bubblesTime
  window.values = window.last - window.start
  window.frameDuration = window.timeframeMS / window.values
  window.bubbleMapped.allDates = allDates
  window.iteration = window.start

  for date in allDates
    window.bubbleMapped[date] = points.filter((p) -> p.created_at <= date)
  
  window.animateInArcsBubbles()

window.animateInArcsBubbles = () ->
  if window.iteration > window.last
    window.startArcs()
    return

  console.log("sure")
  $("#year").text(window.iteration)
  if window.bubbleMapped.allDates.includes(window.iteration)
      toNow = window.bubbleMapped[window.iteration]
      window.map.bubbles(toNow)

  window.iteration++
  setTimeout(window.animateInArcsBubbles, window.frameDuration)


window.startArcs = () ->
  allDates = window.arcs.map((p) -> p.created_at)
            .filter((v, i, a) -> a.indexOf(v) == i)
            .sort((a, b) -> a - b )

  window.start = allDates[0]
  window.last = allDates[allDates.length - 1]
  window.values = window.last - window.start

  window.timeframeMS = 1000 * window.arcsTime
  
  window.increment = Math.round(window.values / allDates.length) * window.arcsMultiplier
  window.frameDuration = window.timeframeMS / window.values
  
  # Get all potential increments ( these numbers are big )
  allIncrements = []
  for v in [window.start..window.last] by window.increment
    allIncrements.push v

  window.arcMapped.allDates = allIncrements
  window.iteration = window.start

  for date in allIncrements
    window.arcMapped[date] = window.arcs.filter((p) -> p.created_at <= date)

  window.animateInArcs()


window.formatter = new Intl.DateTimeFormat "en", { month: "short", year: "numeric" }

window.animateInArcs = () ->
    return if window.iteration > window.last

    date = new Date(window.iteration)
    $("#year").text(window.formatter.format(date))

    if window.arcMapped.allDates.includes(window.iteration)
        toNow = window.arcMapped[window.iteration]
        window.map.arc(toNow)

    window.iteration += window.increment
    setTimeout(window.animateInArcs, window.frameDuration)


setup(points.length)
setTimeout(window.startBubbles, 1000)

