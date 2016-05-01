<cfoutput>
<div class="com-IcedReaper-youTube">
    <cfloop item="video" array="#attributes.playlist.getVideos()#" index="videoIndex">
        <div class="row<cfif videoIndex NEQ 1> m-t-lg</cfif>">
            <div class="col-md-12">
                <header>
                    <h2>#video.getTitle()#</h2>
                </header>
                <section>
                    <cfif attributes.options.keyExists("showOnlyThumbnails") AND attributes.options.showOnlyThumbnails EQ true>
                        <a href="#video.getVideoUrl()#" target="_blank">
                            <img src="#video.getThumbnailInfoForSize('maxres').url#" class="img-fluid">
                        </a>
                    <cfelse>
                        <div class="embed-responsive embed-responsive-16by9">
                            <iframe src="#video.getVideoEmbedUrl()#<cfif videoIndex EQ 1 AND attributes.options.keyExists('autoplayFirstVideo') AND attributes.options.autoplayFirstVideo EQ true>?autoplay=1</cfif>" class="embed-responsive-item" allowfullscreen scrolling="no"></iframe>
                        </div>
                    </cfif>
                    
                    <div class="m-t bg-inverse p-a">
                        <div class="row">
                            <div class="col-md-9">
                                <cfif video.getDescription() NEQ "">
                                    <p class="m-b-0">#video.getDescription()#</p>
                                </cfif>
                            </div>
                            <div class="col-md-3">
                                <span class="label label-success label-md"><i class="fa fa-eye"></i> #video.getViewCount()#</span><br>
                                <span class="label label-success label-md m-t"><i class="fa fa-thumbs-up"></i> #video.getLikeCount()#</span>
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </cfloop>
</div>
</cfoutput>