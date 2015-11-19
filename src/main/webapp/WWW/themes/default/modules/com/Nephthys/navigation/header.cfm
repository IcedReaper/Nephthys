<cfoutput>
<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <button aria-controls="navbar" aria-expanded="false" data-target="##navbar" data-toggle="collapse" class="navbar-toggle collapsed" type="button">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            
            <a href="/" class="navbar-brand"><img src="/themes/default/img/brand.gif" title="IcedReaper's Nephthys CMS" alt="IcedReaper's Nephthys CMS"></a>
        </div>
        <div class="navbar-collapse collapse" id="navbar">
            <ul class="nav navbar-nav">
                <cfloop from="2" to="#attributes.sitemap.len()#" index="pageIndex"> <!-- From 2 as we don't want to have the starting page here too, as it's already inserted by the brand --->
                    <li class="<cfif attributes.sitemap[pageIndex].getPageId() EQ request.page.getPageId()>active</cfif>">
                        <a href="#attributes.sitemap[pageIndex].getLink()#"
                           title="#attributes.sitemap[pageIndex].getTitle()#">#attributes.sitemap[pageIndex].getLinkText()#</a>
                    </li>
                </cfloop>
            </ul>
            
            <form action="/search" method="POST" class="navbar-form navbar-right">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="Suchbegriff" name="searchStatement">
                </div>
                <button type="submit" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span> Suchen</button>
            </form>
        </div>
    </div>
</nav>
</cfoutput>