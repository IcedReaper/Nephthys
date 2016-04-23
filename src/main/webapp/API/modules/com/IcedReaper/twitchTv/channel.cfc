component {
    public channel function init(required string channelName) {
        variables.channelName = arguments.channelName;
        
        loadChannelInfo();
        
        return this;
    }
    
    public string function getChannelName() {
        return variables.channelName;
    }
    
    public string function getLink() {
        return "https://www.twitch.tv/" & variables.channelName;
    }
    
    public string function getVideoLink() {
        return "http://player.twitch.tv/?channel=" & variables.channelName;
    }
    
    public boolean function isLive() {
        return variables.isLive;
    }
    
    public numeric function getViewers() {
        return variables.viewers;
    }
    public boolean function getIsPlaylist() {
        return variables.isPlaylist;
    }
    public boolean function getMature() {
        return variables.mature;
    }
    public string function getTitle() {
        return variables.title;
    }
    public string function getLanguage() {
        return variables.language;
    }
    public string function getLogo() {
        return variables.logo;
    }
    public string function getVideoBanner() {
        return variables.videoBanner;
    }
    public numeric function getFollower() {
        return variables.follower;
    }
    public numeric function getViews() {
        return variables.views;
    }
    public string function getUrl() {
        return variables.url;
    }
    public string function getGame() {
        return variables.game;
    }
    public struct function getPreviewImages() {
        return duplicate(variables.previewImages);
    }
    
    public boolean function getChannelFound() {
        return variables.channelFound;
    }
    
    public string function getPreviewImageInSize(required string size, required boolean returnNextSizeIfNotFound = true, required boolean returnEmptyIfNotFound = true) {
        if(variables.previewImages.keyExists(arguments.size)) {
            return variables.previewImages[arguments.size];
        }
        else {
            if(arguments.returnNextSizeIfNotFound) {
                switch(arguments.size) {
                    case "medium": {
                        return getThumbnailInfoForSize('small', arguments.returnNextSizeIfNotFound);
                    }
                    case "large": {
                        return getThumbnailInfoForSize('medium', arguments.returnNextSizeIfNotFound);
                    }
                    default: {
                        if(arguments.returnEmptyIfNotFound) {
                            return "";
                        }
                        else {
                            throw(type = "application", message = "Size of preview image is unknown");
                        }
                    }
                }
            }
            else {
                if(arguments.returnEmptyIfNotFound) {
                    return "";
                }
                else {
                    throw(type = "application", message = "Size of preview image is unknown");
                }
            }
        }
    }
    
    private void function loadChannelInfo() {
        var requestUrl = "https://api.twitch.tv/kraken/streams/" & variables.channelName;
        
        var twitchRequest = new http().setUrl(requestUrl)
                                      .setMethod("GET")
                                      .setTimeout(20)
                                      .setCharset("UTF-8")
                                      .send()
                                      .getPrefix();
        
        if(twitchRequest.responseHeader.status_code == 200) {
            var streamInfo = deserializeJSON(twitchRequest.fileContent).stream;
            
            if(! isNull(streamInfo)) {
                variables.channelFound = true;
                variables.isLive = true;
                
                variables.viewers       = streamInfo.viewers;
                variables.isPlaylist    = streamInfo.is_playlist;
                variables.game          = streamInfo.game;
                variables.mature        = streamInfo.channel.mature;
                variables.title         = streamInfo.channel.status;
                variables.language      = streamInfo.channel.language;
                variables.logo          = streamInfo.channel.logo;
                variables.videoBanner   = streamInfo.channel.video_banner;
                variables.follower      = streamInfo.channel.followers;
                variables.views         = streamInfo.channel.views;
                variables.url           = streamInfo.channel.url;
                variables.previewImages = {
                    "small"  = streamInfo.preview.small,
                    "medium" = streamInfo.preview.medium,
                    "large"  = streamInfo.preview.large,
                };
                
                if(isNull(variables.game)) {
                    variables.game = "";
                }
            }
            else {
                var requestUrl = "https://api.twitch.tv/kraken/channels/" & variables.channelName;
                
                var twitchRequest = new http().setUrl(requestUrl)
                                              .setMethod("GET")
                                              .setTimeout(20)
                                              .setCharset("UTF-8")
                                              .send()
                                              .getPrefix();
                
                if(twitchRequest.responseHeader.status_code == 200) {
                    var channelInfo = deserializeJSON(twitchRequest.fileContent);
                    
                    if(! isNull(channelInfo)) {
                        variables.channelFound = true;
                        variables.isLive = false;
                        
                        variables.viewers       = 0;
                        variables.isPlaylist    = false;
                        variables.mature        = channelInfo.mature;
                        variables.title         = channelInfo.status;
                        variables.language      = channelInfo.language;
                        variables.logo          = channelInfo.logo;
                        variables.videoBanner   = channelInfo.video_banner;
                        variables.follower      = channelInfo.followers;
                        variables.views         = channelInfo.views;
                        variables.url           = channelInfo.url;
                        variables.previewImages = null;
                    }
                    else {
                        variables.channelFound = false;
                    }
                }
                else {
                    throw(type = "application", message = "http request failed");
                }
            }
        }
        else {
            throw(type = "application", message = "http request failed");
        }
    }
}