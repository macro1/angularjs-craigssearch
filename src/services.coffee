angular.module("search").factory "cities", [
  "$http", "$filter", "$q"
  ($http, $filter, $q) ->
    all = []
    $http.get 'data/cities.json'
      .success (data) ->
        angular.copy data, all

    all: all
    selected: ->
      $filter("filter") @all, selected: true
]
