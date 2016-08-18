<cfoutput>
<cfif attributes.channel.getChannelFound()>
    <div class="com-IcedReaper-twitchTv m-t-2">
        <div class="row">
            <div class="col-md-12">
                <header class="m-a-1">
                    <h2>#attributes.channel.getTitle()#</h2>
                </header>
                <section>
                    <cfif attributes.channel.isLive()>
                        <div class="embed-responsive embed-responsive-16by9">
                            <iframe src="#attributes.channel.getVideoLink()#<cfif attributes.options.keyExists('autoplay') AND attributes.options.autoplay EQ false>&autoplay=false</cfif><cfif attributes.options.keyExists('muted') AND attributes.options.muted EQ false>&muted=false</cfif>" class="embed-responsive-item" scrolling="no" allowfullscreen></iframe>
                        </div>
                        
                        <cfif attributes.options.keyExists("showExtInfo") AND attributes.options.showExtInfo EQ true>
                            <div class="m-t-1 bg-inverse p-a-1">
                                <div class="row">
                                    <div class="col-md-3 col-sm-6">
                                        <p><strong>Spiel:</strong> #attributes.channel.getGame()#</p>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <p><strong>Sprache:</strong> #attributes.channel.getLanguage()#</p>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <p><strong>Zuschauer:</strong> #attributes.channel.getViewers()#</p>
                                    </div>
                                    <div class="col-md-3 col-sm-6">
                                        <p><strong>Follower:</strong> #attributes.channel.getFollower()#</p>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    <cfelse>
                        <img src="#attributes.channel.getVideoBanner()#" class="img-fluid">
                        <p class="m-t-1 m-b-0">Der Channel ist gerade offline. Bitte gucke zu einem späteren Zeitpunkt nocheinmal hinein.</p>
                        
                        <cfif attributes.options.keyExists("showExtInfo") AND attributes.options.showExtInfo EQ true>
                            <div class="m-t-1 bg-inverse p-a-1">
                                <div class="row">
                                    <div class="col-sm-4">
                                        <p><strong>Sprache:</strong> #attributes.channel.getLanguage()#</p>
                                    </div>
                                    <div class="col-sm-4">
                                        <p><strong>Angesehen:</strong> #attributes.channel.getViews()#</p>
                                    </div>
                                    <div class="col-sm-4">
                                        <p><strong>Follower:</strong> #attributes.channel.getFollower()#</p>
                                    </div>
                                </div>
                            </div>
                        </cfif>
                    </cfif>
                </section>
            </div>
        </div>
    </div>
<cfelse>
    Channel nicht gefunden
</cfif>
</cfoutput>