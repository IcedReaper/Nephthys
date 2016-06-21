component implements="WWW.interfaces.connector" {
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.twitchTv";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        if(arguments.options.keyExists("channelName") && arguments.options.channelName != "") {
            var channel = createObject("component", "API.modules.com.IcedReaper.twitchTv.channel").init(arguments.options.channelName);
            
            saveContent variable="renderedContent" {
                module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/twitchTv/templates/channel.cfm"
                       channel  = channel
                       options  = duplicate(arguments.options);
            }
        }
        else {
            if(arguments.options.keyExists("videoId") && arguments.options.videoId != "") {
                var video = createObject("component", "API.modules.com.IcedReaper.twitchTv.video").init(arguments.options.videoId);
                
                saveContent variable="renderedContent" {
                    module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/twitchTv/templates/video.cfm"
                           video    = video
                           options  = duplicate(arguments.options);
                }
            }
        }
        
        return renderedContent;
    }
}