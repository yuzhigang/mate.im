angular.module('MateIM')
  .factory('Show', function($resource) {
    return $resource('/api/shows/:_id');
  });