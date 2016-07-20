var images     = []; // we'll store the new images here
var imageSizes = {};
var fileNames  = [];

nephthysAdminApp
    .controller('blogDetailCtrl', ["$scope", "$route", "$routeParams", "$q", "blogService", function ($scope, $route, $routeParams, $q, blogService) {
        $scope.linkSet = false;
        // load
        $scope.load = function() {
            $q.all([
                blogService.getDetails($routeParams.blogpostId),
                blogService.getStatus()
            ]).then($q.spread(function (blogDetails, status) {
                $scope.blogpost = blogDetails;
                $scope.status   = status;
                $scope.blogpost = blogDetails;
                
                var dateParts = $scope.blogpost.releaseDate.split("/");
                $scope.blogpost.releaseDate = new Date(dateParts[0], parseInt(dateParts[1], 10) - 1, dateParts[2]);

                if($scope.blogpost.blogpostId != 0) {
                    $scope.linkSet = true;
                }
                else {
                    $scope.linkSet = false;
                }
            }));
        };
        
        $scope.save = function () {
            var convertContent = function() {
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
                if($scope.blogpost[attrib] instanceof Date) {
                    blogpostCopy[attrib] = new Date($scope.blogpost[attrib].valueOf());
                }
                else {
                    blogpostCopy[attrib] = $scope.blogpost[attrib];
                }
            }
            blogpostCopy.releaseDate = blogpostCopy.releaseDate.toAjaxFormat();
            blogpostCopy.story = convertContent();
            
            blogService
                .save(blogpostCopy, fileNames)
                .then(function (blogpostId) {
                    blogService.uploadImages(blogpostId, images, imageSizes)
                        .then(function(uploadResult) {
                            var oldBlogpostId = $scope.blogpost.blogpostId;
                            if(oldBlogpostId == 0) {
                                $route.updateParams({
                                    blogpostId: blogpostId
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
        };
        
        $scope.pushToStatus = function (newStatusId) {
            if(newStatusId) {
                blogService
                    .pushToStatus($routeParams.blogpostId,
                                  newStatusId)
                    .then(function(isEditable) {
                        $scope.blogpost.statusId = newStatusId;
                        $scope.blogpost.isEditable = isEditable;
                    });
            }
        };
        
        $scope.statusButtonClass = function (actualOnline, nextOnline) {
            if(! actualOnline && nextOnline) {
                return "btn-success";
            }
            if(actualOnline && ! nextOnline) {
                return "btn-danger";
            }
            if(! actualOnline && ! nextOnline) {
                return "btn-primary";
            }
            if(actualOnline && nextOnline) {
                return "btn-secondary";
            }
            
            return "btn-warning";
        };
        
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