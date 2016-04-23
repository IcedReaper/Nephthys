<cfoutput>
<cfif attributes.channel.getChannelFound()>
    <div class="com-IcedReaper-twitchTv">
        <div class="row">
            <div class="col-md-12">
                <header>
                    <h2>#attributes.channel.getTitle()#</h2>
                </header>
                <section>
                    <cfif attributes.channel.isLive()>
                        <div class="iFrame-fluid">
                            <iframe src="#attributes.channel.getVideoLink()#<cfif attributes.options.keyExists('autoplay') AND attributes.options.autoplay EQ false>&autoplay=false</cfif><cfif attributes.options.keyExists('muted') AND attributes.options.muted EQ false>&muted=false</cfif>" frameborder="0" scrolling="no" allowfullscreen></iframe>
                        </div>
                        
                        <cfif attributes.options.keyExists("showExtInfo") AND attributes.options.showExtInfo EQ true>
                            <div class="row m-t">
                                <div class="col-md-3 col-sm-6">
                                    <p>Spiel: #attributes.channel.getGame()#</p>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <p>Sprache: #attributes.channel.getLanguage()#</p>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <p>Zuschauer: #attributes.channel.getViewers()#</p>
                                </div>
                                <div class="col-md-3 col-sm-6">
                                    <p>Follower: #attributes.channel.getFollower()#</p>
                                </div>
                            </div>
                        </cfif>
                    <cfelse>
                        <img src="#attributes.channel.getVideoBanner()#" class="img-fluid">
                        <p class="m-t">Der Channel ist gerade offline. Bitte gucke zu einem späteren Zeitpunkt nocheinmal hinein.</p>
                        
                        <cfif attributes.options.keyExists("showExtInfo") AND attributes.options.showExtInfo EQ true>
                            <div class="row m-t">
                                <div class="col-sm-4">
                                    <p>Sprache: #attributes.channel.getLanguage()#</p>
                                </div>
                                <div class="col-sm-4">
                                    <p>Angesehen: #attributes.channel.getViews()#</p>
                                </div>
                                <div class="col-sm-4">
                                    <p>Follower: #attributes.channel.getFollower()#</p>
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