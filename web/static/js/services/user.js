//获取
angular.module('MateIM').factory('User', function($resource) {
    return $resource('/api/users/:id', null,
        {
            'update': { method:'PUT' }
        });
});
