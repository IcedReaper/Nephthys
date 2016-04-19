component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.youTube";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        if(arguments.options.keyExists("playlistId") && arguments.options.playlistId != "") {
            var playlist = createObject("component", "API.modules.com.IcedReaper.youTube.playlist").init(arguments.options.playlistId);
            
            if(arguments.options.keyExists("videoCount")) {
                playlist.setMaxResults(arguments.options.videoCount);
            }
        
            saveContent variable="renderedContent" {
                module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/youTube/templates/playlist.cfm"
                       playlist = playlist
                       options  = duplicate(arguments.options);
            }
        }
        else if(arguments.options.keyExists("videoId") && arguments.options.videoId != "") {
            var video = createObject("component", "API.modules.com.IcedReaper.youTube.video").init(arguments.options.videoId);
        
            saveContent variable="renderedContent" {
                module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/youTube/templates/video.cfm"
                       video    = video
                       options  = duplicate(arguments.options);
            }
        }
        
        return renderedContent;
    }
}