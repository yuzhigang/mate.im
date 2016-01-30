angular.module('MateIM')
  .controller('ArticleAddCtrl', function($scope, $rootScope, $location, $alert, Article) {
      $scope.article = new Article({title:"", content:""});
      $scope.bucket = "mate-image";
      $scope.saveArticle = function (){
          var regex = "^[ ]+$";
          var re = new RegExp(regex);
          var article = $scope.article;
          if (article.title.length == 0 || re.test(article.title)){
              $alert({
                  content: '君，文章标题不能为空',
                  animation: 'fadeZoomFadeDown',
                  type: 'material',
                  duration: 3
              });
              return;

          }
          if (article.content.length == 0 || re.test(article.content)){
              $alert({
                  content: '君，文章内容不能为空',
                  animation: 'fadeZoomFadeDown',
                  type: 'material',
                  duration: 3
              });
              return;

          }
          article.$save({id: article.id},function(payload, headers){
              if (payload.data) {
                  $alert({
                      content: '君，文章发布成功了',
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
              if (response.status === 401 || response.status === 403) {
                 return;
              }
              $alert({
                  content: '君，貌似我们的服务器鸭梨山大，请稍后再尝试',
                  animation: 'fadeZoomFadeDown',
                  type: 'material',
                  duration: 3
              });
          });

      };
  });