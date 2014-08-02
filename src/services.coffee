angular.module("search.services", []).factory "cities", [
  "$http", "$filter", "$q"
  ($http, $filter, $q) ->
    all = []

    all: all
    promise: $http.get 'data/cities.json'
      .success (data) ->
        angular.copy data, all
    selected: ->
      $filter("filter") @all, selected: true
]
