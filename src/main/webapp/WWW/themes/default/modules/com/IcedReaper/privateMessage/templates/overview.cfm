<cfoutput>
<div class="com-IcedReaper-privateMessage">
    <div class="row">
        <div class="col-md-12">
            <a href="privateMessages/new" class="btn btn-secondary pull-right">
                <span class="fa-stack">
                    <i class="fa fa-comment fa-stack-lg"></i>
                    <i class="fa fa-plus fa-stack-1x text-success overlay-lower-right"></i>
                </span> Neue Konversation
            </a>
            
            <h1>Übersicht der Unterhaltungen</h1>
            
            <cfif attributes.conversations.len() GT 0>
                <cfloop from="1" to="#attributes.conversations.len()#" index="conversationIndex">
                    <div class="row m-t-1">
                        <div class="col-sm-12">
                            <div class="card">
                                <div class="card-block">
                                    <div class="row">
                                        <div class="col-sm-6 col-md-10">
                                            <h4>
                                                <cf_userLink userName="#request.user.getUserName()#" deepLink="/privateMessages/conversation/#attributes.conversations[conversationIndex].getConversationId()#">Unterhaltung zwischen</cf_userLink>
                                                <span class="small">
                                                    <cfset participants = attributes.conversations[conversationIndex].getParticipants()>
                                                    <cfloop from="1" to="#participants.len()#" index="participantIndex">
                                                        <cfif participantIndex NEQ 1 AND participantIndex NEQ participants.len()>
                                                            &nbsp;,&nbsp;
                                                        <cfelseif participantIndex EQ participants.len()>
                                                            &nbsp;und&nbsp;
                                                        </cfif>
                                                        <cf_userLink userName="#participants[participantIndex].getUserName()#" target="_blank">#participants[participantIndex].getUserName()#</cf_userLink>
                                                    </cfloop>
                                                </span>
                                            </h4>
                                        </div>
                                        <div class="col-sm-6 col-md-2">
                                            <cf_userLink userName="#request.user.getUserName()#" deepLink="/privateMessages/conversation/#attributes.conversations[conversationIndex].getConversationId()###reply" class="btn btn-primary btn-sm pull-right">
                                                <span class="fa-stack">
                                                    <i class="fa fa-comment fa-stack-lg"></i>
                                                    <i class="fa fa-arrow-right fa-stack-1x text-success overlay-lower-right"></i>
                                                </span> Antworten
                                            </cf_userLink>
                                        </div>
                                    </div>
                                    
                                    <p class="card-text">
                                        #application.system.settings.getValueOfKey("xssProtector").encodeForHTML(attributes.conversations[conversationIndex].getLastMessage().getMessage().replace(chr(10), "<br>", "ALL"))#
                                    </p>
                                    
                                    <p class="card-text">
                                        <small class="text-muted">
                                            Gesendet von <cf_userLink userName="#attributes.conversations[conversationIndex].getLastMessage().getUser().getUserName()#">#attributes.conversations[conversationIndex].getLastMessage().getUser().getUserName()#</cf_userLink>
                                            am #dateFormat(attributes.conversations[conversationIndex].getLastMessage().getSendDate(), "DD.MMM YYYY")#
                                            um #timeFormat(attributes.conversations[conversationIndex].getLastMessage().getSendDate(), "HH:MM")#
                                        </small>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </cfloop>
            <cfelse>
                <p class="text-warning">Wir konnten keine Konversationen finden, an denen Du teilgenommen hast.</p>
                <p>Fange jetzt eine <a href="#attributes.userPage#/#request.user.getUserName()#/privateMessages/conversation/new">neue Konversation</a> an.</p>
            </cfif>
        </div>
    </div>
</div>
</cfoutput>