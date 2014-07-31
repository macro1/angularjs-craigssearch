angular.module('search', ['ngSanitize']);

angular.module("search").controller("SearchController", [
  '$scope', '$filter', '$http', 'cities', function($scope, $filter, $http, cities) {
    $scope.result = [];
    $scope.category = "sss";
    $scope.errors = [];
    $scope.cities = cities;
    $scope.search = function(query) {
      $scope.errors.length = 0;
      $scope.result.length = 0;
      $scope.query = query;
      $scope.load();
      return $("#city_list").hide();
    };
    $scope.load = function() {
      var callback, city, feed, i, _i, _len, _ref, _results;
      callback = function(city) {
        return function(result) {
          var entry, i, _i, _len, _ref;
          i = void 0;
          city.status = "processing";
          if (!result.error) {
            _ref = result.feed.entries;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              entry = _ref[_i];
              entry.publishedDate = Date.parse(entry.publishedDate);
            }
            $scope.result = $scope.result.concat(result.feed.entries);
            city.status = "success";
            return $scope.$apply();
          } else {
            $scope.errors.push(city.name);
            return city.status = "error";
          }
        };
      };
      i = void 0;
      feed = void 0;
      $scope.result.length = 0;
      _ref = $scope.cities.selected();
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        city = _ref[_i];
        feed = new google.feeds.Feed("http://" + city.slug + ".craigslist.org/search/?catAbb=" + $scope.category + "&query=" + $scope.query + "&format=rss");
        city.status = "pending";
        feed.setNumEntries(100);
        _results.push(feed.load(callback(city)));
      }
      return _results;
    };
    $scope.citiesto = function(state) {
      var city, _i, _len, _ref, _results;
      _ref = $scope.cities.all;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        city = _ref[_i];
        _results.push(city.selected = state);
      }
      return _results;
    };
    return $scope.now = function() {
      return new Date();
    };
  }
]);



angular.module("search").filter("delta", function() {
  return function(delta) {
    var days, hours, minutes, seconds;
    seconds = Math.floor(delta / 1000);
    minutes = Math.floor(seconds / 60);
    hours = Math.floor(minutes / 60);
    days = Math.floor(hours / 24);
    if (days > 0) {
      return days + "d " + (hours - days * 24) + "h";
    }
    if (hours > 0) {
      return hours + "h " + (minutes - hours * 60) + "m";
    }
    if (minutes > 0) {
      return minutes + "m " + (seconds - minutes * 60) + "s";
    }
    return seconds + "s";
  };
});

angular.module("search").factory("cities", [
  "$http", "$filter", "$q", function($http, $filter, $q) {
    var all;
    all = [];
    $http.get('data/cities.json').success(function(data) {
      return angular.copy(data, all);
    });
    return {
      all: all,
      selected: function() {
        return $filter("filter")(this.all, {
          selected: true
        });
      }
    };
  }
]);
