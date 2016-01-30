angular.module('MateIM')
    .controller('ArticleCtrl', function($scope, $rootScope, $location, $routeParams,$alert, Article,Comment) {
        $scope.articleEditing = false;
        $scope.commentEditing = false;
        $scope.bucket = "mate-image";
        $scope.currentPage = 1;
        function getComments() {
            if($scope.article.comments_count == 0){
                $scope.comments = [];
                return;
            }
            Comment.query({post_id:$routeParams.id , page: $scope.currentPage},
                function (payload, headers) {
                    if (payload.length) {
                        var items = payload;

                        for (var i = 0; i < items.length; i++) {
                            items[i].inserted_at = moment(items[i].inserted_at).format('YYYY-MM-DD HH:mm:ss');

                        }
                        $scope.comments = items;
                    } else {
                        $alert({
                            content: '君，底都被你掏空了，这是最后一页啦~~~',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
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

        function getArticle(){
            Article.get({ id: $routeParams.id }, function(article,headers) {
                $scope.article = article;
                getComments()
            });
        };

        $scope.articleOwner = function (article){
            if (null == article || undefined == article){
                return false;
            }
            var user = article.user;
            if (null != $rootScope.currentUser) {
                if (user.id == $rootScope.currentUser.id){
                    return true;
                }
            }
            return false;
        };

        $scope.deleteArticle = function (article){
            Article.remove({id: article.id}, function(payload, headers){
                if(payload.data){
                    $alert({
                        content: '君，文章删除成功了，不要担心黑历史了',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });
                    $location.path('/');
                }else{
                    $alert({
                        content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });
                }
            },function(httpResponse){
                $alert({
                    content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
            });

        };

        $scope.editArticle = function (){
            if ($scope.commentEditing){
                $alert({
                    content: '君，你正在编写新的评论，请保存后再编辑文章',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
                return;
            }
            $scope.articleEditing = true;

        };
        $scope.saveArticle = function (){

            var article = $scope.article;
            article.$update({id: article.id},function(payload, headers){
                if (payload.data) {
                    $alert({
                        content: '君，文章更新成功了',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });

                    $scope.articleEditing = false;
                    getArticle();
                }else{
                    $alert({
                        content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });

                }
            },function(httpResponse){
                $alert({
                    content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
            });

        };

        $scope.hasComments = function(article){
            if (null == article || undefined == article){
                return false;
            }
            return article.comments_count > 0;
        };

        $scope.commentOwner = function(comment){
            if (null == comment || undefined == comment){
                return false;
            }
            var user = comment.user;
            if (null != $rootScope.currentUser) {
                if (user.id == $rootScope.currentUser.id){
                    return true;
                }
            }
            return false;
        };

        $scope.deleteComment = function (comment){
            Comment.remove({post_id: $scope.article.id, id: comment.id},
                function(payload, headers){
                    if(payload.data){
                        $alert({
                            content: '君，评论删除成功了，不要担心黑历史了',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                        getArticle();
                    }else{
                        $alert({
                            content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    }
                },function(httpResponse){
                    $alert({
                        content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });
                });

        };
        $scope.createComment = function(article){
            if (null == article || undefined == article){
                return;
            }
            if ($scope.articleEditing){
                $alert({
                    content: '君，你正在编辑的文章，请保存后再进行评论',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
                return;
            }
            $scope.commentEditing = true;
            $scope.currentComment = new Comment({post_id: article.id, content: ""});
        };
        $scope.quitCommentEditor = function(){
            $scope.currentComment = null;
            $scope.commentEditing = false;
        };
        $scope.saveComment = function(){
            if ($scope.currentComment.content.length > 0 ){
                $scope.currentComment.$save({post_id: $scope.article.id},function(payload, headers){
                    if(payload.data){
                        $alert({
                            content: '君，评论创建成功',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                        $scope.commentEditing = false;
                        getArticle();
                    }else{
                        $alert({
                            content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                            animation: 'fadeZoomFadeDown',
                            type: 'material',
                            duration: 3
                        });
                    }
                },function(httpResponse){
                    $alert({
                        content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                        animation: 'fadeZoomFadeDown',
                        type: 'material',
                        duration: 3
                    });
                });

            }else{
                $alert({
                    content: '君，无字的天书，大家是看不懂的',
                    animation: 'fadeZoomFadeDown',
                    type: 'material',
                    duration: 3
                });
            }
        };
        //前一页
        $scope.prePage = function () {
            $scope.currentPage = $scope.currentPage - 1;
            if ($scope.currentPage >= 1) {
                getComments();
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
            getComments();
        };
        getArticle();
    });
