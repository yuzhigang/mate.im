angular.module('MateIM')
    .directive('ttWangEditor', ["Upyun", function(Upyun) {
        return {
            restrict: 'C',
            scope:{
                content: "=",
                bucket: "="
            },
            link: function(scope, element, attrs, ngModel) {
                var ready = false;
                var $uploadContainer = $('#uploadContainer');
                var $fileList = $('#fileList');
                var $btnUpload = $('#btnUpload');
                var event;
                var upyunConf = null;
                var editor = element.wangEditor({
                    'menuConfig': [
                        ['bold', 'underline', 'italic', 'foreColor', 'backgroundColor', 'strikethrough'],
                        ['blockquote', 'fontFamily', 'fontSize', 'setHead', 'list', 'justify'],
                        ['createLink', 'unLink', 'insertTable'],
                        ['insertImage', 'insertVideo','insertCode'],
                        ['undo', 'redo', 'fullScreen']
                    ],
                    'onchange': function(html){
                        if (ready) {
                            scope.content = html;
                            scope.$apply();
                        }
                    },
                    uploadImgComponent: $uploadContainer
                });
                var uploader = new plupload.Uploader({
                    runtimes : 'html5,html4',
                    browse_button: 'btnBrowse',
                    url: 'https://v0.api.upyun.com/' + scope.bucket,
                    filters: {
                        mime_types: [
                        //只允许上传图片文件 （注意，extensions中，逗号后面不要加空格）
                        { title: "图片文件", extensions: "jpg,gif,png,bmp" }
                        ]
                    },
                    init: {
                        PostInit: function() {
                            document.getElementById('fileList').innerHTML = '';
                        },

                        FilesAdded: function(up, files) {
                            plupload.each(files, function(file) {
                                document.getElementById('fileList').innerHTML += '<div id="' + file.id + '">' + file.name + ' (' + plupload.formatSize(file.size) + ') <b></b></div>';
                            });
                        },

                        UploadProgress: function(up, file) {
                            document.getElementById(file.id).getElementsByTagName('b')[0].innerHTML = '<span>' + file.percent + "%</span>";
                        },

                        FileUploaded: function(up, file, info) {
                            var response = JSON.parse(info.response);
                            var image = upyunConf.base + response.url;
                            editor.command(event, 'insertHTML', '<img src="' + image + '"/>');
                        },

                        Error: function(up, err) {
                        }
                    }
                });

                uploader.init();
                    //上传事件
                $btnUpload.click(function(){
                    Upyun.bucketConfig(scope.bucket,function(data){
                        if(null != data) {
                            upyunConf = data;
                            uploader.setOption('multipart_params',{
                                'filename': '${filename}',
                                'policy': upyunConf.policy,
                                'signature': upyunConf.signature
                            });
                            uploader.start();
                        }
                    });

                });
                editor.html(scope.content);
                ready = true;
                return editor;
            }
        };
    }]);