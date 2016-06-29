component {
    public exifReader function init() {
        variables.imagePath = "";
        variables.exifInfo = null;
        
        return this;
    }
    
    public exifReader function setImagePath(required string imagePath) {
        variables.imagePath = arguments.imagePath;
        return this;
    }
    
    public array function getExifInfo() {
        if(isNull(variables.exifInfo)) {
            readExifInfo();
        }
        
        return variables.exifInfo;
    }
    
    public string function getExifKey(required string exifKey) {
        if(isNull(variables.exifInfo)) {
            readExifInfo();
        }
        
        for(var i = 1; i <= variables.exifInfo.len(); ++i) {
            if(lCase(variables.exifInfo[i].key) == lCase(arguments.exifKey)) {
                return variables.exifInfo[i].value;
            }
        }
        return "";
    }
    
    private void function readExifInfo() {
        if(variables.imagePath != "") {
            var myImage = createObject("java", "java.io.File").init(variables.imagePath);
            
            var metadata = createObject("java", "com.drew.imaging.ImageMetadataReader").readMetadata(myImage);
            
            variables.exifInfo = [];
            
            for(var directory in metadata.getDirectories()) {
                for(var tag in directory.getTags().toArray()) {
                    variables.exifInfo.append({
                        region = directory.getName(),
                        key    = tag.getTagName(),
                        value  = tag.getDescription()
                    });
                }
            }
        }
        else {
            throw(type = "nephthys.application.invalidResource", message = "Source image isn't defined");
        }
    }
}