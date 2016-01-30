
angular.module('MateIM').factory('Comment', function($resource) {
    return $resource('/api/posts/:post_id/comments/:id', null,
        {
            'update': { method:'PUT' }
        });
});

