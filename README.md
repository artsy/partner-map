# partner-map
Generates a map visualization of partner locations.

![](https://s3.amazonaws.com/f.cl.ly/items/022d3b2M0Y0T2n1k192k/cimg.jpg)

## Setup

Copy the following collections from Artsy database to your local `gravity_development` mongo.

* partner_locations
* partners

Install node modules

`npm install`

Generate the geo points data and output the bundle

`npm run d && npm run c`

Open public/index.html