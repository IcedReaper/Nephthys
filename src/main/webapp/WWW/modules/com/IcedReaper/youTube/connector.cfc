component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.youTube.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.youTube";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        if(arguments.options.keyExists("playlistId") && arguments.options.playlistId != "") {
            var playlist = new playlist(arguments.options.playlistId);
            
            if(arguments.options.keyExists("videoCount")) {
                playlist.setMaxResults(arguments.options.videoCount);
            }
            
            saveContent variable="renderedContent" {
                module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/youTube/templates/playlist.cfm"
                       playlist = playlist
                       options  = duplicate(arguments.options);
            }
        }
        else if(arguments.options.keyExists("videoId") && arguments.options.videoId != "") {
            var video = new video(arguments.options.videoId);
        
            saveContent variable="renderedContent" {
                module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/youTube/templates/video.cfm"
                       video    = video
                       options  = duplicate(arguments.options);
            }
        }
        
        return renderedContent;
    }
}