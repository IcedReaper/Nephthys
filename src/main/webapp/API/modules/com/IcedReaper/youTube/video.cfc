component {
    public video function init(required string videoId) {
        variables.videoId = arguments.videoId;
        
        loadVideoInfo();
        
        return this;
    }
    
    public string function getPublishedAt() {
        return variables.publishedAt;
    }
    
    public string function getVideoId() {
        return variables.videoId;
    }
    
    public string function getVideoUrl() {
        return "https://www.youtube.com/watch?v=" & variables.videoId;
    }
    
    public string function getVideoEmbedUrl() {
        return "https://www.youtube.com/embed/" & variables.videoId;
    }
    
    public string function getTitle() {
        return variables.title;
    }
    
    public string function getDescription() {
        return replace(variables.description, "\n", "<br>", "ALL");
    }
    
    public struct function getThumbnailInfo() {
        return variables.thumbnails;
    }
    
    public struct function getThumbnailInfoForSize(required string size, required boolean returnNextSizeIfNotFound = true) {
        if(variables.thumbnails.keyExists(arguments.size)) {
            return variables.thumbnails[arguments.size];
        }
        else {
            if(arguments.returnNextSizeIfNotFound) {
                switch(arguments.size) {
                    case "medium": {
                        return getThumbnailInfoForSize('default', arguments.returnNextSizeIfNotFound);
                    }
                    case "high": {
                        return getThumbnailInfoForSize('medium', arguments.returnNextSizeIfNotFound);
                    }
                    case "standard": {
                        return getThumbnailInfoForSize('high', arguments.returnNextSizeIfNotFound);
                    }
                    case "maxres":  {
                        return getThumbnailInfoForSize('standard', arguments.returnNextSizeIfNotFound);
                    }
                    default: {
                        throw(type = "application", message = "Size of thumbnail unknown");
                    }
                }
            }
            else {
                throw(type = "application", message = "Size of thumbnail unknown");
            }
        }
    }
    
    public array function getTags() {
        return variables.tags;
    }
    
    public boolean function getVideoFound() {
        return variables.videoFound;
    }
    
    private void function loadVideoInfo() {
        var requestUrl = "https://www.googleapis.com/youtube/v3/videos?part=snippet"
                       & "&id=" & variables.videoId
                       & "&key=" & application.system.settings.getValueOfKey("googleApiKey");
        
        var youTubeRequest = new http().setUrl(requestUrl)
                                       .setMethod("GET")
                                       .setTimeout(20)
                                       .setCharset("UTF-8")
                                       .setThrowOnError(true)
                                       .send()
                                       .getPrefix();
        
        if(youTubeRequest.responseHeader.status_code == 200) {
            var videoInfo = deserializeJSON(youTubeRequest.fileContent);
            
            if(videoInfo.items.len() >= 1) {
                var vidInfo = videoInfo.items[1].snippet;
                
                variables.publishedAt = vidInfo.publishedAt;
                variables.title       = vidInfo.title;
                variables.description = vidInfo.description;
                variables.thumbnails  = vidInfo.thumbnails;
                
                if(vidInfo.keyExists("tags")) {
                    variables.tags = vidInfo.tags;
                }
                else {
                    variables.tags = [];
                }
                variables.videoFound = true;
            }
            else {
                variables.videoFound = false;
            }
        }
        else {
            throw(type = "application", message = "http request failed");
        }
    }
}