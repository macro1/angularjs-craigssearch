angular.module("search").controller "SearchController", [
  '$scope', '$filter', '$http'
  ($scope, $filter, $http) ->
    $scope.result = []
    $scope.category = "sss"
    $scope.errors = []
    $http.get('data/cities.json').success((data, status, headers, config) ->
      $scope.cities = data
    )
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
      cities = $filter("filter")($scope.cities,
        selected: true
      )
      $scope.result.length = 0
      for city in cities
        feed = new google.feeds.Feed("http://" + city.slug + ".craigslist.org/search/?catAbb=" + $scope.category + "&query=" + $scope.query + "&format=rss")
        city.status = "pending"
        feed.setNumEntries 100
        feed.load callback(city)

    $scope.citiesto = (state) ->
      i = undefined
      i = 0
      while i < $scope.cities.length
        $scope.cities[i].selected = state
        i += 1

    $scope.now = ->
      new Date()
  ]
