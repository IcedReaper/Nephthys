<cfoutput>
<cfif attributes.video.getVideoFound()>
    <div class="com-IcedReaper-twitchTv m-t-lg">
        <div class="row">
            <div class="col-md-12">
                <header>
                    <h2>#attributes.video.getTitle()#</h2>
                </header>
                <section>
                    <div class="embed-responsive embed-responsive-16by9">
                        <iframe src="#attributes.video.getVideoLink()#<cfif attributes.options.keyExists('autoplay') AND attributes.options.autoplay EQ false>&autoplay=false</cfif><cfif attributes.options.keyExists('muted') AND attributes.options.muted EQ false>&muted=false</cfif>" class="embed-responsive-item" scrolling="no" allowfullscreen></iframe>
                    </div>
                    
                    <cfif attributes.options.keyExists("showExtInfo") AND attributes.options.showExtInfo EQ true>
                        <div class="m-t bg-inverse p-a">
                            <cfif attributes.video.getDescription() NEQ "">
                                <p class="m-b">
                                    #attributes.video.getDescription()#
                                </p>
                            </cfif>
                            <div class="row">
                                <div class="col-md-4">
                                    <p><strong>Spiel:</strong> #attributes.video.getGame()#</p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Länge:</strong> #attributes.video.getLength()#</p>
                                </div>
                                <div class="col-md-4">
                                    <p><strong>Angesehen:</strong> #attributes.video.getViews()#</p>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </section>
            </div>
        </div>
    </div>
<cfelse>
    video nicht gefunden
</cfif>
</cfoutput>