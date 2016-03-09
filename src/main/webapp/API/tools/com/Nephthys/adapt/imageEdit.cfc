component interface="API.interfaces.imageEdit" {
    public imageEdit function init() {
        return this;
    }
    
    public void function resize(required string  source,
                                required numeric width,
                                required string  target        = "",
                                required boolean overwrite     = true,
                                required numeric height        = 0,
                                required string  interpolation = "highestQuality",
                                required numeric quality       = 0.75) {
        if(arguments.target == "" && arguments.overwrite == false) {
            throw(type = "Application", message = "Cannot resize the image. the target is not specified and the image should not get overwritten.");
        }
        if(arguments.target != "" && arguments.target != arguments.source && fileExists(arguments.target)) {
            throw(type = "Application", message = "Target file already exists, but is not source file");
        }
        
        var theImage = imageRead(arguments.source);
        imageResize(theImage,
                    arguments.width != 0 ? arguments.width : "",
                    arguments.height != 0 ? arguments.height : "",
                    arguments.interpolation);
        
        if(arguments.target == "" && arguments.overwrite) {
            arguments.target = arguments.source;
        }
        else if(arguments.target == "" && ! arguments.overwrite) {
            throw(type = "nephthys.application.notAllowed", message = "It is not allowed to save an image to a blank path without over writing the origin");
        }
        
        imageWrite(theImage, arguments.target, arguments.quality, arguments.overwrite);
    }
}