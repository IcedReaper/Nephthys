<cfoutput>
    <div class="row">
        <cfloop from="1" to="#arrayLen(attributes.references)#" index="referenceIndex">
            <div class="col-md-3 p-a-1">
                <section class="card">
                    <header class="card-header">
                        <img class="img-fluid" src="#attributes.references[referenceIndex].getImagePath()#" alt="#attributes.references[referenceIndex].getName()#" title="#attributes.references[referenceIndex].getName()#">
                        
                        <h3 class="m-t-1">#attributes.references[referenceIndex].getName()#</h3>
                    </header>
                    <blockquote class="blockquote card-block m-b-0">
                        #attributes.references[referenceIndex].getQuote()#
                        <footer class="blockquote-footer">Benutzt das Nephthys CMS seit dem <cite>#application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.references[referenceIndex].getSince(), false)#</cite></footer>
                    </blockquote>
                    <footer class="card-footer">
                        <a href="#attributes.references[referenceIndex].getHomepage()#" target="_blank">Zur Homepage von #attributes.references[referenceIndex].getName()#</a>
                    </footer>
                </section>
            </div>
        </cfloop>
    </div>
</cfoutput>