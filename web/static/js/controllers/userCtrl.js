angular.module('MateIM')
    .controller('UserCtrl', function($scope, $rootScope, $location, $routeParams,$alert,User,Article) {
        $scope.currentPage = 1;
        function getArticles() {
            Article.query({user_id:$routeParams.id,page: $scope.currentPage},
                function (payload, headers) {
                    if (payload.length) {
                        var items = payload;

                        for (var i = 0; i < items.length; i++) {
                            items[i].inserted_at = moment(items[i].inserted_at).format('YYYY-MM-DD HH:mm:ss');
                            items[i].updated_at = moment(items[i].updated_at).format('YYYY-MM-DD HH:mm:ss');

                        }
                        $scope.articles = items;
                    } else {
                        if(null == $scope.articles || undefined == $scope.articles){
                            $alert({
                                content: '君，这位仁兄啥都没留下~~',
                                animation: 'fadeZoomFadeDown',
                                type: 'material',
                                duration: 3
                            });
                            $scope.articles = [];
                        }else{
                            $alert({
                                content: '君，底都被你掏空了，这是最后一页啦~~~',
                                animation: 'fadeZoomFadeDown',
                                type: 'material',
                                duration: 3
                            });
                        }

                        $scope.currentPage = $scope.currentPage - 1;
                        if ($scope.currentPage < 1){
                            $scope.currentPage = 1;
                        }
                    }
                }, function (httpResponse) {
                    $alert({
                        content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });
                });
        };

        function getUser(){
            User.get({ id: $routeParams.id }, function(user,headers) {
                $scope.user = user;
                getArticles()
            });
        };

        //前一页
        $scope.prePage = function () {
            $scope.currentPage = $scope.currentPage - 1;
            if ($scope.currentPage >= 1) {
                getArticles();
            } else {
                $scope.currentPage = $scope.currentPage + 1;
                $alert({
                    content: '君，别翻旧账了，这是第一页啦~~~',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
            }
        };
        //下一页
        $scope.nextPage = function () {
            $scope.currentPage = $scope.currentPage + 1;
            getArticles();
        };
        getUser();
    });
