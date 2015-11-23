<cfoutput>
    &copy; IcedReaper 2014 - #year(now())#
    <div class="footerLinks">
        <a href="https://www.nephthys.com">Aktuelle Version: V#application.system.settings.getNephthysVersion()#</a>
        <cfloop from="1" to="#attributes.sitemap.len()#" index="pageIndex">
            <a href="#attributes.sitemap[pageIndex].getLink()#"
               title="#attributes.sitemap[pageIndex].getTitle()#">#attributes.sitemap[pageIndex].getLinkText()#</a>
        </cfloop>
    </div>
</cfoutput>