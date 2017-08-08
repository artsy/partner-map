# Artsy Maps

Generates a map visualization of interesting data.

![](https://s3.amazonaws.com/f.cl.ly/items/022d3b2M0Y0T2n1k192k/cimg.jpg)

## Setup

Copy the following collections from Artsy database to your local `gravity_development` mongo.

* `partner_locations`
* `partners`
* `users`

Get a backup of the impulse production database from heroku, and move it into a local postgres setup in `artsy-impulse-production`.

## Install node modules:

`yarn install`

Generate the geo points data, by using the coffescript files in the `data` dirs, then to start up the sites run

`npm run watch`

Then look at the html files inside `public/web`.

## Docs

There's a write-up on the Artsy Blog: [Mashing Data, Making Maps](http://artsy.github.io/blog/2017/01/25/mashing-maps/).
