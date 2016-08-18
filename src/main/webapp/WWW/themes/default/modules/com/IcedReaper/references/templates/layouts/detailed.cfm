<cfoutput>
    <cfloop from="1" to="#arrayLen(attributes.references)#" index="referenceIndex">
        <div class="container-fluid background static-background-#(referenceIndex % 2)#">
            <div class="container">
                <div class="row">
                    <div class="col-md-12 p-a-1">
                        <section>
                            <div class="row">
                                <div class="col-md-3 <cfif referenceIndex % 2 EQ 0> pull-xs-right</cfif>">
                                    <img class="img-fluid" src="#attributes.references[referenceIndex].getImagePath()#" alt="#attributes.references[referenceIndex].getName()#" title="#attributes.references[referenceIndex].getName()#">
                                </div>
                                <div class="col-md-9 <cfif referenceIndex % 2 EQ 0> text-xs-right</cfif>">
                                    <h3>#attributes.references[referenceIndex].getName()#</h3>
                                    <blockquote class="blockquote <cfif referenceIndex % 2 EQ 0> blockquote-reverse</cfif> m-b-0">
                                        #attributes.references[referenceIndex].getQuote()#
                                        <footer class="blockquote-footer">Benutzt das Nephthys CMS seit dem <cite>#application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.references[referenceIndex].getSince(), false)#</cite></footer>
                                    </blockquote>
                                    <a href="#attributes.references[referenceIndex].getHomepage()#" target="_blank">Zur Homepage von #attributes.references[referenceIndex].getName()#</a>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </div>
        </div>
    </cfloop>
</cfoutput>