<cfoutput>
<div class="com-IcedReaper-youTube m-t-2">
    <div class="row">
        <div class="col-md-12">
            <header>
                <h2>#attributes.video.getTitle()#</h2>
            </header>
            <section>
                <div class="embed-responsive embed-responsive-16by9">
                    <iframe src="#attributes.video.getVideoEmbedUrl()#<cfif attributes.options.keyExists('autoplayFirstVideo') AND attributes.options.autoplayFirstVideo EQ true>?autoplay=1</cfif>" class="embed-responsive-item" allowfullscreen scrolling="no"></iframe>
                </div>
                
                <div class="m-t-1 bg-inverse p-a-1">
                    <div class="row">
                        <div class="col-md-9">
                            <cfif attributes.video.getDescription() NEQ "">
                                <p class="m-b-0">#attributes.video.getDescription()#</p>
                            </cfif>
                        </div>
                        <div class="col-md-3">
                            <span class="label label-success label-md"><i class="fa fa-eye"></i> #attributes.video.getViewCount()#</span><br>
                            <span class="label label-success label-md m-t-1"><i class="fa fa-thumbs-up"></i> #attributes.video.getLikeCount()#</span>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>
</cfoutput>