<cfoutput>
    <article class="com-IcedReaper-blog layout2">
        <section class="story background static-background-2 p-a-1">
            <h2><a href="#request.page.getLink()##attributes.blogpost.getLink()#">#attributes.blogpost.getHeadline()#</a></h2>
            
            #attributes.blogpost.getStory()#
        </section>
        <cfset pictures = attributes.blogpost.getPictures()>
        <cfif pictures.len() GT 0>
            <section class="images background static-background-1 p-a-1">
                <div class="row">
                    <cfloop from="1" to="#pictures.len()#" index="pictureIndex">
                        <cfif pictureIndex NEQ 1 AND pictureIndex % 4 EQ 1>
                            </div><div class="row">
                        </cfif>
                        <div class="col-sm-12 col-md-6 col-lg-3">
                            <a href="#attributes.blogpost.getRelativePath()#/#pictures[pictureIndex].getPictureFileName()#" class="img-fluid" data-gallery title="#pictures[pictureIndex].getCaption()#">
                                <img src="#attributes.blogpost.getRelativePath()#/#pictures[pictureIndex].getThumbnailFileName()#" title="#pictures[pictureIndex].getTitle()#" class="img-fluid img-rounded">
                            </a>
                        </div>
                    </cfloop>
                </div>
            </section>
        </cfif>
        <footer class="p-a-1 background static-background-2">
            <cfinclude template="partials/footer.cfm">
        </footer>
        
        <section class="p-a-1 background static-background-2">
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
</cfoutput>