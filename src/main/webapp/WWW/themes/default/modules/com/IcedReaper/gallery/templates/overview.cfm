<cfoutput>
    <section class="com-IcedReaper-gallery">
        <cfif attributes.totalPageCount GT 1>
            <nav>
                <ul class="pagination">
                    <li <cfif attributes.actualPage EQ 1>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage GT 1>href="#request.page.getLink()#/Seite/#attributes.actualPage - 1#"</cfif> aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <cfloop from="1" to="#attributes.totalPageCount#" index="pageIndex">
                        <li <cfif pageIndex EQ attributes.actualPage>class="active"</cfif>>
                            <a href="#request.page.getLink()#/Seite/#pageIndex#">#pageIndex#</a>
                        </li>
                    </cfloop>
                    <li <cfif attributes.actualPage EQ attributes.totalPageCount>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage LT attributes.totalPageCount>href="#request.page.getLink()#/Seite/#attributes.actualPage + 1#"</cfif> aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </cfif>
        
        <cfloop from="1" to="#attributes.galleries.len()#" index="galleryIndex">
            <cfif NOT attributes.options.keyExists("galleryLayout")>
                <cfinclude template="layouts/overview/default.cfm"/>
            <cfelse>
                <cfswitch expression="#attributes.options.galleryLayout#">
                    <cfcase value="1">
                        <cfinclude template="layouts/overview/galleryLayout1.cfm" />
                    </cfcase>
                </cfswitch>
            </cfif>
        </cfloop>
        
        <cfif attributes.totalPageCount GT 1>
            <nav>
                <ul class="pagination">
                    <li <cfif attributes.actualPage EQ 1>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage GT 1>href="#request.page.getLink()#/Seite/#attributes.actualPage - 1#"</cfif> aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    <cfloop from="1" to="#attributes.totalPageCount#" index="pageIndex">
                        <li <cfif pageIndex EQ attributes.actualPage>class="active"</cfif>>
                            <a href="#request.page.getLink()#/Seite/#pageIndex#">#pageIndex#</a>
                        </li>
                    </cfloop>
                    <li <cfif attributes.actualPage EQ attributes.totalPageCount>class="disabled"</cfif>>
                        <a <cfif attributes.actualPage LT attributes.totalPageCount>href="#request.page.getLink()#/Seite/#attributes.actualPage + 1#"</cfif> aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </cfif>
        
        <cfif attributes.galleries.len() EQ 1>
            <h2>Wir konnten leider aktuell keine Gallerien finden</h2>
            <p>Es tut uns leid und würden Dich bitten später noch einmal vorbeizuschauen</p>
        </cfif>
    </section>
</cfoutput>