points = require '../data/jsons/fairs.json'
window.topojson = require "topojson"

window.dateMapped = {}

window.setup = (max) ->
  document.getElementById("map").innerHTML = ''
  window.map = new Datamap
    element: document.getElementById("map")
    projection: "mercator"
    bubblesConfig: {
      animate: false
    }

  allDates = points.map((p) -> p.created_at)
            .filter((v, i, a) -> a.indexOf(v) == i)
            .sort((a, b) -> a - b )

  window.start = allDates[0]
  window.last = allDates[allDates.length - 1]
  window.timeframeMS = 1000 * 10
  window.values = window.last - window.start
  window.frameDuration = window.timeframeMS / window.values
  window.dateMapped.allDates = allDates
  window.iteration = window.start

  for date in allDates
    window.dateMapped[date] = points.filter((p) -> p.created_at <= date)

window.animateIn = () ->
    return if window.iteration > window.last
    $("#year").text(window.iteration)
    if window.dateMapped.allDates.includes(window.iteration)
        toNow = window.dateMapped[window.iteration]
        window.map.bubbles(toNow)

    window.iteration++
    setTimeout(window.animateIn, window.frameDuration)

setup(points.length)
setTimeout(window.animateIn, 1000)

