//获取
angular.module('MateIM').factory('Article', function($resource) {
    return $resource('/api/posts/:id', null,
        {
            'update': { method:'PUT' }
        });
});

