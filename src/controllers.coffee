angular.module("search.controllers", ["search.services"]).controller "SearchController", [
  '$scope', '$filter', '$location', '$http', 'cities'
  ($scope, $filter, $location, $http, cities) ->
    $scope.query = $location.search()
    $scope.result = []
    $scope.query.c = $scope.query.c or "sss"
    $scope.hide_city_list = yes
    $scope.errors = []
    $scope.cities = cities
    $scope.categories =
      'ccc': "community"
      'eee': "events"
      'ggg': "gigs"
      'hhh': "housing"
      'jjj': "jobs"
      'ppp': "personals"
      'res': "resumes"
      'sss': "for sale"
      'bbb': "services"

    $scope.search = (query) ->
      $location.search(query)

    $scope.load = ->
      callback = (city) ->
        (result) ->
          i = undefined
          city.status = "processing"
          unless result.error
            for entry in result.feed.entries
              entry.publishedDate = Date.parse(entry.publishedDate)
            $scope.result = $scope.result.concat(result.feed.entries)
            city.status = "success"
            $scope.$apply()
          else
            $scope.errors.push city.name
            city.status = "error"
      i = undefined
      feed = undefined
      $scope.result.length = 0
      $scope.cities.promise.then ->
        for city in $scope.cities.selected()
          feed = new google.feeds.Feed "http://#{ city.slug }.craigslist.org/search/?catAbb=#{ $scope.query.c }&query=#{ $scope.query.q }&format=rss"
          city.status = "pending"
          feed.setNumEntries 100
          feed.load callback(city)

    $scope.citiesto = (state) ->
      city.selected = state for city in $scope.cities.all

    $scope.now = ->
      new Date()

    if $scope.query.q
      $scope.errors.length = 0
      $scope.result.length = 0
      $scope.load()
      $scope.hide_city_list = yes
  ]
