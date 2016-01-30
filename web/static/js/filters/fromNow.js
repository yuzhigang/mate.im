angular.module('MateIM').
  filter('fromNow', function() {
    return function(date) {
      return moment(date).fromNow();
    }
  });