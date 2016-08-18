component {
    public struct function prepareOptions(required struct options) {
        return arguments.options;
    }
    
    public void function invokeResources() {
        request.page.addResource("css", "/themes/default/assets/bootstrap.blueimp.gallery/css/blueimp-gallery.min.css")
                    .addResource("css", "/themes/default/assets/bootstrap.blueimp.imageGallery/css/bootstrap-image-gallery.min.css")
                    
                    .addResource("js", "/themes/default/assets/bootstrap.blueimp.gallery/js/jquery.blueimp-gallery.min.js")
                    .addResource("js", "/themes/default/assets/bootstrap.blueimp.imageGallery/js/bootstrap-image-gallery.min.js");
    }
}