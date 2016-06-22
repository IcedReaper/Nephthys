var images     = []; // we'll store the new images here
var imageSizes = {};
var fileNames  = [];

nephthysAdminApp
    .controller('blogDetailCtrl', ["$scope", "$route", "$routeParams", "$q", "blogService", function ($scope, $route, $routeParams, $q, blogService) {
        $scope.linkSet = false;
        // load
        $scope.load = function() {
            return blogService
                       .getDetails($routeParams.blogpostId)
                       .then(function (blogDetails) {
                           $scope.blogpost = blogDetails;
                           
                           if($scope.blogpost.blogpostId != 0) {
                               $scope.linkSet = true;
                           }
                           else {
                               $scope.linkSet = false;
                           }
                       });
        };
        
        $scope.save = function () {
            var convContent = function() {
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
            
            var blogpostCopy = {};
            for(var attrib in $scope.blogpost) {
                blogpostCopy[attrib] = $scope.blogpost[attrib];
            }
            blogpostCopy.story = convContent();
            
            blogService
                .save(blogpostCopy, fileNames)
                .then(function (result) {
                    blogService.uploadImages(result.blogpostId, images, imageSizes)
                        .then(function(uploadResult) {
                            var oldBlogpostId = $scope.blogpost.blogpostId;
                            $scope.blogpost = result;
                            
                            if(oldBlogpostId == 0) {
                                $route.updateParams({
                                    blogpostId: result.blogpostId
                                });
                            }
                            
                            // reset image variables
                            images = [];
                            imageSizes = {};
                            fileNames = [];
                        });
                });
        };
        
        $scope.updateLink = function() {
            if(! $scope.linkSet) {
                $scope.blogpost.link = "/" + $scope.blogpost.headline;
            }
        };
        
        $scope.openReleaseDate = function () {
            $scope.releaseDate.isOpen = true;
        }
        
        // init
        $scope.releaseDate = {
            isOpen: false,
            options: {
                
            }
        };
        $scope.blogpost = {};
        
        $scope.load();
        
        $scope.initialized = false;
    }])
    .config(["$provide", function ($provide) {
        $provide.decorator('taOptions', ['taRegisterTool', '$delegate', '$uibModal', function(taRegisterTool, taOptions, $uibModal){
            taRegisterTool('uploadImage', {
                buttontext: 'Upload Image',
                iconclass:  "fa fa-image",
                action: function (deferred, restoreSelection) {
                    $uibModal.open({
                        controller:  'UploadImageModalCtrl',
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