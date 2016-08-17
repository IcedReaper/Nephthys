<cfoutput>
    <article class="com-IcedReaper-blog">
        <header>
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <h2><a href="#request.page.getLink()##attributes.blogpost.getLink()#">#attributes.blogpost.getHeadline()#</a></h2>
                    </div>
                </div>
            </div>
        </header>
        <section class="story">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <p>#attributes.blogpost.getStory()#</p>
                    </div>
                </div>
            </div>
            <cfset pictures = attributes.blogpost.getPictures()>
            <cfif pictures.len() GT 0>
                <div class="m-y-2 container-fluid background static-background-1 p-a-1">
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
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <cfinclude template="partials/footer.cfm">
                    </div>
                </div>
            </div>
        </footer>
        
        <section>
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <cfinclude template="partials/comments.cfm">
                    </div>
                </div>
            </div>
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
</cfoutput>