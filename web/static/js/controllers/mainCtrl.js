angular.module('MateIM')
    .controller('MainCtrl', function ($scope, $alert,Article) {
        $scope.currentPage = 1;

        function getArticles() {
            Article.query({page: $scope.currentPage},
                function (payload, headers) {
                    if (payload.length) {
                        var items = payload;
                        for (var i = 0; i < items.length; i++) {
                            items[i].inserted_at = moment(items[i].inserted_at).format('YYYY-MM-DD HH:mm:ss');
                            items[i].updated_at = moment(items[i].updated_at).format('YYYY-MM-DD HH:mm:ss');

                        }

                        $scope.articles = items;
                    } else {
                        $alert({
                            content: '君，还没有人发帖子，不来一发吗~~~',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                        $scope.currentPage = $scope.currentPage - 1;
                        if($scope.currentPage < 1){
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
                    $scope.currentPage = $scope.currentPage - 1;
                });
        };

        $scope.hasComments = function (article) {
            return article.comments_count > 0;
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
        getArticles();
    });