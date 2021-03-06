component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.privateMessage.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.privateMessage";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        if(arguments.options.keyExists("userId") && arguments.options.userId == request.user.getUserId()) {
            if(arguments.options.otherParameter.len() == 0) {
                arguments.options.otherParameter[1] = "overview";
            }
            
            var aPages = createObject("component", "API.modules.com.Nephthys.pageManager.filter").init().for("pageWithModule")
                                                                                                        .setModuleName("com.Nephthys.userManager")
                                                                                                        .execute()
                                                                                                        .getResult(); 
            var userPage = aPages.len() >= 1 ? aPages[1].getLink() : "";
            
            if(arguments.options.keyExists("otherParameter") && arguments.options.otherParameter.len() > 0) {
                switch(arguments.options.otherParameter[1]) {
                    case "new": {
                        if(! form.isEmpty()) {
                            transaction {
                                var conversation = new conversation(null);
                                conversation.setInitiator(request.user);
                                
                                conversation.addParticipant(request.user);
                                for(var userName in listToArray(form.participants, ";")) {
                                    var participant = createObject("component", "API.modules.com.Nephthys.userManager.filter").init().for("user")
                                                                                                                                     .setUsername(userName)
                                                                                                                                     .execute()
                                                                                                                                     .getResult();
                                    if(participant.len() == 1) {
                                        conversation.addParticipant(participant[1]);
                                    }
                                }
                                
                                conversation.save(request.user);
                                
                                var message = new message(null).setConversationId(conversation.getConversationId())
                                                               .setUser(request.user)
                                                               .setMessage(form.message)
                                                               .send();
                                
                                conversation.addMessage(message);
                                
                                transactionCommit();
                            }
                            
                            location(addtoken = false, statuscode = "302", url = userPage & "/" & request.user.getUserName() & "/privateMessages/conversation/" & conversation.getConversationId());
                        }
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("newConversation.cfm")
                            .addParam("options",  arguments.options)
                            .addParam("userPage", userPage)
                            .render();
                    }
                    case "conversation": {
                        if(! form.isEmpty()) {
                            var conversation = new conversation(arguments.options.otherParameter[2]);
                            
                            if(conversation.isParticipant(request.user)) {
                                var message = new message(null).setConversationId(conversation.getConversationId())
                                                               .setUser(request.user)
                                                               .setMessage(form.message)
                                                               .send();
                                
                                conversation.addMessage(message);
                                
                                location(addtoken = false, statuscode = "302", url = userPage & "/" & request.user.getUserName() & "/privateMessages/conversation/" & conversation.getConversationId());
                            }
                            else {
                                throw(type = "nephthys.application.notAllowed", message = "You aren't a participant of this conversation; You cannot reply");
                            }
                        }
                        
                        if(url.keyExists("delete") && url.keyExists("messageId")) {
                            var message = new message(url.messageId);
                            
                            if(message.getUser().getUserId() == request.user.getUserId()) {
                                if(! message.isReadByOther(request.user)) {
                                    message.delete(request.user);
                                    
                                    location(addtoken = false, statuscode = "302", url = userPage & "/" & request.user.getUserName() & "/privateMessages/conversation/" & message.getConversation().getConversationId());
                                }
                                else {
                                    throw(type = "nephthys.application.notAllowed", message = "The reply couldn't be deleted. It was already read by someone");
                                }
                            }
                            else {
                                throw(type = "nephthys.application.notAllowed", message = "You have not written the reply, so you cannot delete it!");
                            }
                        }
                        
                        if(arguments.options.otherParameter.len() == 2) {
                            if(isNumeric(arguments.options.otherParameter[2])) {
                                var conversation = new filter().for("conversation")
                                                               .setParticipantId(request.user.getUserId())
                                                               .setConversationId(arguments.options.otherParameter[2])
                                                               .execute()
                                                               .getResult();
                                
                                if(conversation.len() == 1) {
                                    for(var message in conversation[1].getMessages()) {
                                        if(! message.isRead(request.user)) {
                                            message.read(request.user);
                                        }
                                        else {
                                            // The previous messages were shown once so we don't have to check further and mark as read.
                                            break;
                                        }
                                    }
                                    
                                    return application.system.settings.getValueOfKey("templateRenderer")
                                        .setModulePath(getModulePath())
                                        .setTemplate("conversation.cfm")
                                        .addParam("options",      arguments.options)
                                        .addParam("conversation", conversation[1])
                                        .addParam("userPage",     userPage)
                                        .render();
                                }
                                else {
                                    return application.system.settings.getValueOfKey("templateRenderer")
                                        .setModulePath(getModulePath())
                                        .setTemplate("conversationNotFound.cfm")
                                        .addParam("options",  arguments.options)
                                        .addParam("userPage", userPage)
                                        .render();
                                }
                            }
                        }
                        break;
                    }
                    case "overview": {
                        var conversationOverview = new filter().for("conversation")
                                                               .setParticipantId(request.user.getUserId())
                                                               .execute()
                                                               .getResult();
                        
                        return application.system.settings.getValueOfKey("templateRenderer")
                            .setModulePath(getModulePath())
                            .setTemplate("overview.cfm")
                            .addParam("options",       arguments.options)
                            .addParam("conversations", conversationOverview)
                            .addParam("userPage",      userPage)
                            .render();
                    }
                    default: {
                        throw(type = "nephthys.notFound.user", message = "Action not found or invalid");
                    }
                }
            }
            else {
                throw(type = "nephthys.notFound.user", message = "Action not found or invalid");
            }
        }
        else {
            throw(type = "nephthys.notFound.user", message = "User not found or invalid");
        }
        return "";
    }
}