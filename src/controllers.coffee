angular.module("search").controller "SearchController", [
  '$scope', '$filter', '$http', 'cities'
  ($scope, $filter, $http, cities) ->
    $scope.result = []
    $scope.category = "sss"
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
      $scope.errors.length = 0
      $scope.result.length = 0
      $scope.query = query
      $scope.load()
      $("#city_list").hide()

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
      for city in $scope.cities.selected()
        feed = new google.feeds.Feed "http://#{ city.slug }.craigslist.org/search/?catAbb=#{ $scope.category }&query=#{ $scope.query }&format=rss"
        city.status = "pending"
        feed.setNumEntries 100
        feed.load callback(city)

    $scope.citiesto = (state) ->
      city.selected = state for city in $scope.cities.all

    $scope.now = ->
      new Date()
  ]
