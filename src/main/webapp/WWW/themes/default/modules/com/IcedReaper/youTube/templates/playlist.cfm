<cfoutput>
<div class="com-IcedReaper-youTube">
    <cfloop item="video" array="#attributes.playlist.getVideos()#" index="videoIndex">
        <div class="row<cfif videoIndex NEQ 1> m-t</cfif>">
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
                        <div class="iFrame-fluid">
                            <iframe src="#video.getVideoEmbedUrl()#<cfif videoIndex EQ 1 AND attributes.options.keyExists('autoplayFirstVideo') AND attributes.options.autoplayFirstVideo EQ true>?autoplay=1</cfif>" frameborder="0" allowfullscreen></iframe>
                        </div>
                    </cfif>
                    
                    <p>#video.getDescription()#</p>
                </section>
            </div>
        </div>
    </cfloop>
</div>
</cfoutput>