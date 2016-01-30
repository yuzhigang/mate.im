angular.module('MateIM')
    .factory('Auth', function ($http, $location, $rootScope, $alert, $window) {
        var token = $window.localStorage.token;
        if (token) {
            $http.get('/api/auth/verify', { params: { token: token } })
                .success(function(data) {
                    if(data.verify){
                        var payload = JSON.parse($window.atob(token.split('.')[1]));
                        $rootScope.currentUser = payload;
                    }else{
                        delete $window.localStorage.token;
                        $rootScope.currentUser = null;
                    }
            });
        }

        return {
            signin: function (user) {
                return $http.post('api/auth/signin', user)
                    .success(function (data) {
                        $window.localStorage.token = data.token;
                        var payload = JSON.parse($window.atob(data.token.split('.')[1]));
                        $rootScope.currentUser = payload;
                        $location.path('/');
                        $alert({
                            title: '欢迎回来！',
                            content: '您已经成功登录',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    })
                    .error(function () {
                        delete $window.localStorage.token;
                        $alert({
                            title: '出错了！',
                            content: '无效的用户名或密码',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    });
            },
            signup: function (user) {
                return $http.post('api/auth/signup', user)
                    .success(function () {
                        $location.path('/signin');
                        $alert({
                            title: '恭喜您！',
                            content: '您的Mate.im的账号已经创建成功了',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    })
                    .error(function (response) {
                        $alert({
                            title: '出错了！',
                            content: response.data,
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    });
            },
            logout: function () {
                delete $window.localStorage.token;
                $rootScope.currentUser = null;
                $alert({
                    content: '您已经成功登出了.',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
            }
        };
    });