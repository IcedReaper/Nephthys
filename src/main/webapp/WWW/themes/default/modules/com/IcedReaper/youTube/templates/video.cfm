<cfoutput>
<div class="com-IcedReaper-youTube">
    <div class="row">
        <div class="col-md-12">
            <header>
                <h2>#attributes.video.getTitle()#</h2>
            </header>
            <section>
                <div class="iFrame-fluid">
                    <iframe src="#attributes.video.getVideoEmbedUrl()#<cfif attributes.options.keyExists('autoplayFirstVideo') AND attributes.options.autoplayFirstVideo EQ true>?autoplay=1</cfif>" frameborder="0" allowfullscreen scrolling="no"></iframe>
                </div>
                
                <p>#attributes.video.getDescription()#</p>
            </section>
        </div>
    </div>
</div>
</cfoutput>