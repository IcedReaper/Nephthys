<cfoutput>
<div class="com-IcedReaper-privateMessage">
    <div class="row">
        <div class="col-sm-12">
            <cf_userLink userName="#request.user.getUserName()#" deepLink="/privateMessages" class="btn btn-primary pull-right"><i class="fa fa-chevron-left"></i> Zurück zur Übersicht</cf_userLink>
            <h3>
                Unterhaltung zwischen
                <span class="small">
                    <cfset participants = attributes.conversation.getParticipants()>
                    <cfloop from="1" to="#participants.len()#" index="participantIndex">
                        <cfif participantIndex NEQ 1 AND participantIndex NEQ participants.len()>
                            &nbsp;,&nbsp;
                        <cfelseif participantIndex EQ participants.len()>
                            &nbsp;und&nbsp;
                        </cfif>
                        <cf_userLink userName="#participants[participantIndex].getUserName()#" target="_blank">#participants[participantIndex].getUserName()#</cf_userLink>
                    </cfloop>
                </span>
            </h3>
        </div>
    </div>
    
    <form method="POST" autocomplete="off" class="m-t-1" action="#attributes.conversation.getConversationId()#">
        <div class="row">
            <div class="col-sm-12">
                <h4>Antworten</h4>
                <div class="form-group">
                    <label class="sr-only" for="message">Ihre Antwort</label>
                    <textarea name="message" class="form-control" placeholder="Ihre Antwort"></textarea>
                </div>
            </div>
        </div>
        
        <button type="submit" class="btn btn-success"><i class="fa fa-comment-o"></i> Antwort abschicken</button>
    </form>
    
    <cfset messages = attributes.conversation.getMessages()>
    <cfloop from="1" to="#messages.len()#" index="messageIndex">
        <cfif messages[messageIndex].isDeleted() EQ false OR messages[messageIndex].getUser().getUserId() EQ request.user.getUserId()>
            <div class="row">
                <div class="col-sm-8
                            <cfif messages[messageIndex].getUser().getUserId() EQ request.user.getUserId()>
                                offset-sm-4 myMessage
                                <cfif messages[messageIndex].isDeleted()>
                                    deleted
                                </cfif>
                            <cfelse>
                                response
                                <cfif messages[messageIndex].isRead(request.user)>
                                    read
                                <cfelse>
                                    unread
                                </cfif>
                            </cfif>">
                    <div class="card m-t-1">
                        <div class="card-block">
                            <cfif messages[messageIndex].getUser().getUserId() EQ request.user.getUserId() AND messages[messageIndex].isReadByOther(request.user) EQ false AND messages[messageIndex].isDeleted() EQ false>
                                <cf_userLink userName="#request.user.getUserName()#" deepLink="/privateMessages/conversation/#attributes.conversation.getConversationId()#?delete&messageId=#messages[messageIndex].getMessageId()#" class="close" title="Nachricht löschen">&times;</cf_userLink>
                            </cfif>
                            <p>#application.system.settings.getValueOfKey("xssProtector").encodeForHTML(messages[messageIndex].getMessage()).replace(chr(10), "<br>", "ALL")#</p>
                        </div>
                        <div class="card-footer text-muted">
                            Gesendet von <cf_userLink userName="#messages[messageIndex].getUser().getUserName()#">#messages[messageIndex].getUser().getUserName()#</cf_userLink>
                            am #dateFormat(messages[messageIndex].getSendDate(), "DD.MMM YYYY")#
                            um #timeFormat(messages[messageIndex].getSendDate(), "HH:MM")#
                            
                            <cfif messages[messageIndex].isReadByOther(request.user)>
                                <i class="fa fa-check <cfif messages[messageIndex].isReadByAll()>text-success<cfelse>text-info</cfif>"
                                   title="Nachricht wurde <cfif messages[messageIndex].isReadByAll()>von allen </cfif>gelesen, zuletzt von #messages[messageIndex].getLastRead(request.user).user.getUserName()# am #dateFormat(messages[messageIndex].getLastRead(request.user).readDate, 'DD.MMM YYYY')# um #timeFormat(messages[messageIndex].getLastRead(request.user).readDate, 'HH:MM:SS')#"></i>
                            </cfif>
                        </div>
                    </div>
                </div>
            </div>
        </cfif>
    </cfloop>
</div>
</cfoutput>