component {
    public playlist function init(required string playlistId) {
        variables.playlistId = arguments.playlistId;
        variables.maxResults = null;
        
        loadPlaylist();
        
        return this;
    }
    
    public playlist function setMaxResults(required numeric maxResults) {
        if(arguments.maxResults > 0) {
            variables.maxResults = arguments.maxResults;
        }
        
        return this;
    }
    
    public array function getVideos(numeric maxCount = 0) {
        setMaxResults(arguments.maxCount);
        
        if(variables.maxResults != null && variables.maxResults <= variables.videos.len() && variables.maxResults > 0) {
            return variables.videos.slice(1, variables.maxResults);
        }
        else {
            return variables.videos;
        }
    }
    
    public numeric function getVideoCount() {
        return variables.videos.len();
    }
    
    private void function loadPlaylist() {
        var requestUrl = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50"
                       & "&playlistId=" & variables.playlistId
                       & "&key=" & application.system.settings.getValueOfKey("googleApiKey");
        
        var youTubeRequest = new http().setUrl(requestUrl)
                                       .setMethod("GET")
                                       .setTimeout(20)
                                       .setCharset("UTF-8")
                                       .setThrowOnError(true)
                                       .send()
                                       .getPrefix();
        
        if(youTubeRequest.responseHeader.status_code == 200) {
            var playlistInfo = deserializeJSON(youTubeRequest.fileContent);
            variables.videos = [];
            variables.totalResults = playlistInfo.pageInfo.totalResults;
            
            for(var vid in playlistInfo.items) {
                variables.videos.append(new video(vid.snippet.resourceId.videoId));
                
                if(! variables.videos[variables.videos.len()].getVideoFound()) {
                    variables.videos.deleteAt(variables.videos.len());
                }
            }
        }
        else {
            throw(type="application", message = "http request failed");
        }
    }
}