<cfoutput>
<nav class="navbar navbar-dark bg-inverse m-b">
    <div class="container">
        <div class="navbar-header">
            <a href="/" class="navbar-brand"><img src="/themes/default/img/brand.gif" title="IcedReaper's Nephthys CMS" alt="IcedReaper's Nephthys CMS"></a>
        </div>
        <ul class="nav navbar-nav">
            <cfloop from="2" to="#attributes.sitemap.len()#" index="pageIndex"> <!-- From 2 as we don't want to have the starting page here too, as it's already inserted by the brand --->
                <li class="nav-item <cfif attributes.sitemap[pageIndex].getPageId() EQ request.page.getPageId()>active</cfif>">
                    <a href="#attributes.sitemap[pageIndex].getLink()#" class="nav-link"
                       title="#attributes.sitemap[pageIndex].getTitle()#">#attributes.sitemap[pageIndex].getLinkText()#</a>
                </li>
            </cfloop>
        </ul>
            
        <form action="/search" method="POST" class="form-inline navbar-form pull-right">
            <input type="text"class="form-control" placeholder="Suchbegriff" name="searchStatement">
            <button type="submit" class="btn btn-success-outline"><span class="fa fa-search"></span> Suchen</button>
        </form>
    </div>
</nav>
</cfoutput>