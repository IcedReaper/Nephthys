<cfoutput>
    <cfif attributes.rootElement>
        <cfinclude template="blogLayout1.cfm">
    <cfelse>
        <article class="com-IcedReaper-blog">
            <header>
                <h2><a href="#request.page.getLink()##attributes.blogpost.getLink()#">#attributes.blogpost.getHeadline()#</a></h2>
            </header>
            <section class="story">
                <p>#attributes.blogpost.getStory()#</p>
                
                <cfset pictures = attributes.blogpost.getPictures()>
                <cfif pictures.len() GT 0>
                    <div class="m-y-2 p-a-1">
                        <div class="center-block">
                            <cfloop from="1" to="#pictures.len()#" index="pictureIndex">
                                <div class="thumbnail">
                                    <a href="#attributes.blogpost.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="img-fluid" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                        <img src="#attributes.blogpost.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid">
                                    </a>
                                </div>
                            </cfloop>
                        </div>
                    </div>
                </cfif>
            </section>
            <footer>
                <cfinclude template="partials/footer.cfm">
            </footer>
            
            <section>
                <cfinclude template="partials/comments.cfm">
            </section>
            
            <script>
                $(function() {
                    $('textarea##comment').on('change', function() {
                        $('##remaining').text(500 - parseInt($(this).val().length, 10));
                    });
                });
            </script>
        </article>
        
        <cfinclude template="../generic/blueimpGallery.cfm">
    </cfif>
</cfoutput>