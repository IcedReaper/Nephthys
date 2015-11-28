(function(angular) {
    var images     = []; // we'll store the new images here
    var imageSizes = {};
    var fileNames  = [];
    
    var blogDetailCtrl = angular.module('blogDetailCtrl', ["blogAdminService"]);
    
    blogDetailCtrl
        .controller('blogDetailCtrl', function ($scope, $rootScope, $routeParams, $q, blogService) {
            var activePage = "detail";
            // load
            $scope.load = function() {
                return blogService
                           .getDetails($routeParams.blogpostId)
                           .then(function (blogDetails) {
                               $scope.blogpost = blogDetails.data;
                               
                               $rootScope.$emit('blog-loaded', {blogpostId: blogDetails.data.blogpostId});
                           });
            };
            
            $scope.save = function () {
                var convContent = function() { // todo: change to angular functionality
                    var ed = $('div[id^="taTextElement"]').clone();

                    ed.find('img[imageId]').each(function(index) {
                        var imageId = $(this).attr("imageId");
                        
                        if($(this).attr("width") || $(this).attr("height")) {
                            imageSizes["is" + imageId] = {
                                width: $(this).attr("width") || 0,
                                height: $(this).attr("height") || 0
                            };
                        }
                        
                        $(this).replaceWith("{{{~newImageUpload" + imageId + "}}}");
                    });

                    return ed.html();
                };
                
                for(var i = 0; i < images.length; i++) {
                    fileNames.push(images[i].name);
                }
                
                $scope.blogpost.convertedStory = convContent();
                
                blogService
                    .save($scope.blogpost, fileNames)
                    .then(function (result) {
                        blogService.uploadImages($scope.blogpost.blogpostId, images, imageSizes)
                            .then(function(uploadResult) {
                                $scope.blogpost = result.data;
                                
                                // reset image variables
                                images = [];
                                imageSizes = {};
                                fileNames = [];
                            });
                    });
            };
            
            // tabs and paging
            $scope.showPage = function (page) {
                activePage = page;
            };
            
            $scope.tabClasses = function (page) {
                return (activePage === page ? "active" : "");
            };
            
            $scope.pageClasses = function (page) {
                return (activePage === page ? "active" : "");
            };
            
            // init
            $scope
                .load()
                .then($scope.showPage('details'));
            
            $rootScope.blogpostId = $routeParams.blogpostId;
            $scope.initialized = false;
        })
        .config(["$provide", function ($provide) {
            $provide.decorator('taOptions', ['taRegisterTool', '$delegate', '$uibModal', function(taRegisterTool, taOptions, $uibModal){
                taRegisterTool('uploadImage', {
                    buttontext: 'Upload Image',
                    iconclass: "fa fa-image",
                    action: function (deferred,restoreSelection) {
                        $uibModal.open({
                            controller: 'UploadImageModalCtrl',
                            templateUrl: '/themes/default/modules/com/IcedReaper/blog/partials/upload.html'
                        }).result.then(
                            function (image) { // we don't upload the image before but send them then with our other data. This is required as it could be otherwise that many images are uploaded for no blogpost as they will not be saved later on.
                                images.push(image);
                                
                                restoreSelection();
                                document.execCommand('inserthtml', false, "<img src='" + image.$ngfDataUrl + "' imageId='" + images.length + "' /> ");
                                deferred.resolve();
                            },
                            function () {
                                deferred.resolve();
                            }
                        );
                        return false;
                    }
                });
                taOptions.toolbar[1].push('uploadImage');
                return taOptions;
            }]);
        }]);
}(window.angular));