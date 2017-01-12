#
# Maps data from the gravity_development mongo db into something the map can use.
# yarn run coffee -- data/partners/artsy-partner-map-data.coffee

fs = require 'fs'
async = require 'async'
mongojs = require "mongojs"
db = mongojs "mongodb://localhost:27017/gravity_development", [
  "partner_locations"
  "partners"
]

# Find partners and their locations
db.partner_locations.find (err, locations) ->
  return process.exit(1) if err
  partnerIds = (location.partner_id for location in locations)
  db.partners.find { _id: $in: partnerIds }, (err, partners) ->
    return process.exit(1) if err

    # Map the locations into bubble data
    json = for location in locations
      name = (partner for partner in partners when partner._id.toString() \
        is location.partner_id.toString())[0]?.display_name
      continue unless name and location.coordinates?.length is 2
      {
        name: name or ''
        radius: 5
        significance: 'Ipsum'
        fillKey: location.country
        longitude: location.coordinates[0]
        latitude: location.coordinates[1],
        created_at: partner.created_at
      }

    # Write to a json file to be required on the client
    fs.writeFileSync __dirname + '/../jsons/artsy-partners-points.json', JSON.stringify json
    process.exit()
