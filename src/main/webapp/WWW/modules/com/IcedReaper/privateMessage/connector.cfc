component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.privateMessage.*";
    import "API.modules.com.Nephthys.user.*"
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.privateMessage";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        if(arguments.options.keyExists("userId") && arguments.options.userId == request.user.getUserId()) {
            if(arguments.options.otherParameter.len() == 0) {
                arguments.options.otherParameter[1] = "overview";
            }
            
            if(arguments.options.keyExists("otherParameter") && arguments.options.otherParameter.len() > 0) {
                switch(arguments.options.otherParameter[1]) {
                    case "new": {
                        if(! form.isEmpty()) {
                            transaction {
                                var conversation = new conversation(0);
                                conversation.setInitiator(request.user);
                                
                                conversation.addParticipant(request.user);
                                for(var userName in listToArray(form.participants, ";")) {
                                    var participant = createObject("component", "API.modules.com.Nephthys.user.filter").init().setUsername(userName).execute().getResult();
                                    if(participant.len() == 1) {
                                        conversation.addParticipant(participant[1]);
                                    }
                                }
                                
                                conversation.save();
                                
                                var message = new message(0).setConversationId(conversation.getConversationId())
                                                            .setUser(request.user)
                                                            .setMessage(form.message)
                                                            .send();
                                
                                conversation.addMessage(message);
                                
                                transactionCommit();
                            }
                            
                            location(addtoken = false, statuscode = "302", url = "/user/" & request.user.getUserName() & "/privateMessages/conversation/" & conversation.getConversationId());
                        }
                        
                        saveContent variable="renderedContent" {
                            module template = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/privateMessage/templates/newConversation.cfm";
                        }
                        
                        break;
                    }
                    case "conversation": {
                        if(! form.isEmpty()) {
                            var conversation = new conversation(arguments.options.otherParameter[2]);
                            
                            if(conversation.isParticipant(request.user)) {
                                var message = new message(0).setConversationId(conversation.getConversationId())
                                                            .setUser(request.user)
                                                            .setMessage(form.message)
                                                            .send();
                                
                                conversation.addMessage(message);
                                
                                location(addtoken = false, statuscode = "302", url = "/user/" & request.user.getUserName() & "/privateMessages/conversation/" & conversation.getConversationId());
                            }
                            else {
                                throw(type = "nephthys.application.notAllowed", message = "You aren't a participant of this conversation; You cannot reply");
                            }
                        }
                        
                        if(arguments.options.otherParameter.len() == 2) {
                            // TODO: save readingä
                            
                            if(isNumeric(arguments.options.otherParameter[2])) {
                                var conversation = new filter().setParticipantId(request.user.getUserId())
                                                               .setConversationId(arguments.options.otherParameter[2])
                                                               .execute()
                                                               .getResult();
                                
                                if(conversation.len() == 1) {
                                    saveContent variable="renderedContent" {
                                        module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/privateMessage/templates/conversation.cfm"
                                               conversation = conversation[1];
                                    }
                                }
                                else {
                                    saveContent variable="renderedContent" {
                                        module template     = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/privateMessage/templates/conversationNotFound.cfm";
                                    }
                                }
                            }
                        }
                        break;
                    }
                    case "overview": {
                        var conversationOverview = new filter().setParticipantId(request.user.getUserId())
                                                               .execute()
                                                               .getResult();
                        
                        saveContent variable="renderedContent" {
                            module template      = "/WWW/themes/" & request.user.getTheme().getFolderName() & "/modules/com/IcedReaper/privateMessage/templates/overview.cfm"
                                   conversations = conversationOverview;
                        }
                        
                        break;
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
        
        return renderedContent;
    }
}