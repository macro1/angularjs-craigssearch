angular.module 'search', ['ngSanitize', 'ngRoute', 'search.services', 'search.controllers']
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when "/search", {}
      .otherwise redirectTo: "/search"
  ]
