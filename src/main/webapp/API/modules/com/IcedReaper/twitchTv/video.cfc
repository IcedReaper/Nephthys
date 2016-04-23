component {
    public video function init(required string videoId) {
        variables.videoId = arguments.videoId;
        
        loadChannelInfo();
        
        return this;
    }
    
    public string function getVideoId() {
        return variables.channelName;
    }
    
    public string function getLink() {
        return "https://www.twitch.tv/v/" & variables.videoId;
    }
    
    public string function getVideoLink() {
        return "http://player.twitch.tv/?video=v" & variables.videoId;
    }
    
    public string function getUser() {
        return variables.user;
    }
    public string function getDescription() {
        return variables.description;
    }
    public string function getCreatedAt() {
        return variables.createdAt;
    }
    public string function getLength() {
        return variables.length;
    }
    public string function getGame() {
        return variables.game;
    }
    public string function getResolutions() {
        return variables.resolutions;
    }
    public string function getTitle() {
        return variables.title;
    }
    public string function getViews() {
        return variables.views;
    }
    
    public channel function getChannel() {
        return new channel(variables.user);
    }
    
    public boolean function getVideoFound() {
        return variables.videoFound;
    }
    
    private void function loadChannelInfo() {
        var requestUrl = "https://api.twitch.tv/kraken/videos/v" & variables.videoId;
        
        var twitchRequest = new http().setUrl(requestUrl)
                                      .setMethod("GET")
                                      .setTimeout(20)
                                      .setCharset("UTF-8")
                                      .send()
                                      .getPrefix();
        
        if(twitchRequest.responseHeader.status_code == 200) {
            var videoInfo = deserializeJSON(twitchRequest.fileContent);
            
            variables.videoFound = true;
            
            variables.user        = videoInfo.channel.name;
            variables.description = videoInfo.description;
            variables.createdAt   = videoInfo.created_at;
            variables.length      = videoInfo.length;
            variables.game        = videoInfo.game;
            variables.resolutions = videoInfo.resolutions;
            variables.title       = videoInfo.title;
            variables.views       = videoInfo.views;
            
        }
        else {
            variables.videoFound = false;
        }
    }
}