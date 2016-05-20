<cfoutput>
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
                <div class="row">
                    <div class="col-sm-12">
                        <div class="card">
                            <div class="card-header">
                                <div class="row">
                                    <div class="col-sm-6 col-md-10">
                                        Unterhaltung zwischen
                                        <cfset participants = attributes.conversations[conversationIndex].getParticipants()>
                                        <cfloop from="1" to="#participants.len()#" index="participantIndex">
                                            <cfif participantIndex NEQ 1>
                                                &nbsp;/&nbsp;
                                            </cfif>
                                            <a href="/user/#participants[participantIndex].getUserName()#">#participants[participantIndex].getUserName()#</a>
                                        </cfloop>
                                    </div>
                                    <div class="col-sm-6 col-md-2">
                                        <a class="btn btn-primary btn-sm pull-right" href="privateMessages/conversation/#attributes.conversations[conversationIndex].getConversationId()#/reply">
                                            <span class="fa-stack">
                                                <i class="fa fa-comment fa-stack-lg"></i>
                                                <i class="fa fa-arrow-right fa-stack-1x text-success overlay-lower-right"></i>
                                            </span> Antworten
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="card-block">
                                <p class="card-text">
                                    #attributes.conversations[conversationIndex].getLastMessage().getMessage().replace(chr(10), "<br>", "ALL")#
                                </p>
                                
                                <p class="card-text">
                                    <small class="text-muted">
                                        Gesendet von <a href="/user/#attributes.conversations[conversationIndex].getLastMessage().getUser().getUserName()#">#attributes.conversations[conversationIndex].getLastMessage().getUser().getUserName()#</a>
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
            <p>Fange jetzt eine <a href="privateMessages/new">neue Konversation</a> an.</p>
        </cfif>
    </div>
</div>
</cfoutput>