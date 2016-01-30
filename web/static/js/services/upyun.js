angular.module('MateIM')
    .factory('Upyun', function ($http) {
        return {
            bucketConfig: function (bucket, callback) {
                $http.get('/api/upyun/bucket', {params: {bucket: bucket}})
                    .success(function (data) {
                        callback(data);
                    })
                    .error(function () {
                        callback(null);
                    });
            }
        }
    });