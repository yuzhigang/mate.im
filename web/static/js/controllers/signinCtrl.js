angular.module('MateIM')
  .controller('SigninCtrl', function($scope, Auth) {
    $scope.signin = function() {
      Auth.signin({ email: $scope.email, password: $scope.password });
    };
    $scope.pageClass = 'fadeZoom';
  });