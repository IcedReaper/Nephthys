<cfoutput>
<cfif attributes.video.getVideoFound()>
    <div class="com-IcedReaper-twitchTv">
        <div class="row">
            <div class="col-md-12">
                <header>
                    <h2>#attributes.video.getTitle()#</h2>
                </header>
                <section>
                    <div class="iFrame-fluid">
                        <iframe src="#attributes.video.getVideoLink()#<cfif attributes.options.keyExists('autoplay') AND attributes.options.autoplay EQ false>&autoplay=false</cfif><cfif attributes.options.keyExists('muted') AND attributes.options.muted EQ false>&muted=false</cfif>" frameborder="0" scrolling="no" allowfullscreen></iframe>
                    </div>
                    
                    <cfif attributes.video.getDescription() NEQ "">
                        <p class="m-t">
                            #attributes.video.getDescription()#
                        </p>
                    </cfif>
                    
                    <cfif attributes.options.keyExists("showExtInfo") AND attributes.options.showExtInfo EQ true>
                        <div class="row m-t">
                            <div class="col-md-4">
                                <p>Spiel: #attributes.video.getGame()#</p>
                            </div>
                            <div class="col-md-4">
                                <p>Länge: #attributes.video.getLength()#</p>
                            </div>
                            <div class="col-md-4">
                                <p>Angesehen: #attributes.video.getViews()#</p>
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