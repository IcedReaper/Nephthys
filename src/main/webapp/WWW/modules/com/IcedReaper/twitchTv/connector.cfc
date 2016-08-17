component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.twitchTv.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.twitchTv";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        if(arguments.options.keyExists("channelName") && arguments.options.channelName != "") {
            var channel = new channel(arguments.options.channelName);
            
            return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("channel.cfm")
                .addParam("options", arguments.options)
                .addParam("channel", channel)
                .render();
        }
        else {
            if(arguments.options.keyExists("videoId") && arguments.options.videoId != "") {
                var video = new video(arguments.options.videoId);
        
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("video.cfm")
                    .addParam("options", arguments.options)
                    .addParam("video",  video)
                    .render();
            }
        }
        
        return "";
    }
}