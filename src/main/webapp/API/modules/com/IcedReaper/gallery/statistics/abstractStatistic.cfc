component extends="API.abstractClasses.statistic" {
    public statistic function init() {
        variables.galleryId = null;
        
        super.init();
        
        return this;
    }
    
    public statistic function setGalleryId(required numeric galleryId) {
        variables.galleryId = arguments.galleryId;
        
        return this;
    }
}