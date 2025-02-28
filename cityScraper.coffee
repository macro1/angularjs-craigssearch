rp = require 'request-promise'
cheerio = require 'cheerio'
fs = require 'fs'

module.exports = ->
  rp 'https://geo.craigslist.org/iso/us'
    .then (html) ->
      cities = []
      $ = cheerio.load html
      for e in $('.geo-site-list > li > a')
        cityName = e.children[0].data
        if not cityName?
          cityName = e.children[0].children[0].data
        cities.push
          name: cityName
          slug: e.attribs.href.split(/(\/\/|\.)/)[2]
      fs.writeFile './dist/data/cities.json', JSON.stringify(cities), -> null
