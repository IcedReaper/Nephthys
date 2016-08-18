component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.youTube.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.youTube";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        if(arguments.options.keyExists("playlistId") && arguments.options.playlistId != "") {
            var playlist = new playlist(arguments.options.playlistId);
            
            if(arguments.options.keyExists("videoCount")) {
                playlist.setMaxResults(arguments.options.videoCount);
            }
            
            return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("channel.cfm")
                .addParam("options", arguments.options)
                .addParam("playlist", playlist)
                .render();
        }
        else if(arguments.options.keyExists("videoId") && arguments.options.videoId != "") {
            var video = new video(arguments.options.videoId);
            
            return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("channel.cfm")
                .addParam("options", arguments.options)
                .addParam("video", video)
                .render();
        }
        
        return "";
    }
}