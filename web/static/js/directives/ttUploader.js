angular.module('MateIM')
    .directive('ttUploader', ['FileUploader',
    	function(FileUploader) {
    	return {
            scope: true,
            templateUrl: 'views/tt-uploader.html',
            link: function (scope, element, attr) {
                var options = scope.$eval(attr.ttUploader);
                var fileType = options.fileType;
                scope.triggerUpload = function () {
                    setTimeout(function () {
                        element.find('.upload-input').click();
                    });
                };
                scope.clickImage = options.clickImage || angular.noop;
                var uploaded = scope.uploaded = [];

                // create a uploader with options
                var uploader = scope.uploader = new FileUploader({
                    scope: options.scope || scope,
                    url: options.url,
                    formData: [{
                        policy: options.policy,
                        signature: options.signature
                    }],
                    filters: [
                        function (file) {
                            var judge = true,
                                parts = file.name.split('.');
                            parts = parts.length > 1 ? parts.slice(-1)[0] : '';
                            if (!parts || options.allowFileType.indexOf(parts.toLowerCase()) < 0) {
                                judge = false;
                            }
                            return judge;
                        }
                    ]
                });
               	uploader.onCompleteItem = function(fileItem, response, status, headers){
                    var r = app.parseJSON(response) || {};
                    if (~[200, 201].indexOf(status)) {
                        var file = app.union(item.file, r);
                        file.url = options.baseUrl + file.url;
                        uploaded.push(file);
                        item.remove();
                    } else {
                        item.progress = 0;
                    }
                };
            }
        };
    }]);