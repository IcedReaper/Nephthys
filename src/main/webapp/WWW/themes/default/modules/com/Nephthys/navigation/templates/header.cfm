<cfoutput>
<nav class="navbar m-b-1">
    <div class="container">
        <div class="navbar-header">
            <a href="/" class="navbar-brand"><img src="/themes/default/img/brand.gif" title="IcedReaper's Nephthys CMS" alt="IcedReaper's Nephthys CMS"></a>
        </div>
        <ul class="nav navbar-nav">
            <!--- From 2 as we don't want to have the starting page here too, as it's already inserted by the brand --->
            <cfloop from="2" to="#attributes.sitemap.len()#" index="pageIndex">
                <li class="nav-item <cfif attributes.sitemap[pageIndex].getPageId() EQ request.page.getPageId()>active</cfif>">
                    <a href="#attributes.sitemap[pageIndex].getActualPageVersion().getLink()#" class="nav-link"
                       title="#attributes.sitemap[pageIndex].getActualPageVersion().getTitle()#">#attributes.sitemap[pageIndex].getActualPageVersion().getLinkText()#</a>
                </li>
            </cfloop>
        </ul>
        
        <cfif application.system.settings.getValueOfKey("wwwLoginAvailable")>
            <cfif application.system.settings.getValueOfKey("userModule") NEQ null>
                #createObject("WWW.modules." & application.system.settings.getValueOfKey("userModule") & ".connector").init().renderUserMenu()#
            </cfif>
        </cfif>
        
        <cfif attributes.searchPage NEQ "">
            <form action="#attributes.searchPage#" method="POST" class="form-inline navbar-form pull-right">
                <input type="hidden" name="name" value="com.Nephthys.search">
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Suchbegriff" name="searchStatement">
                    <span class="input-group-btn">
                        <button type="submit" class="btn btn-success"><span class="fa fa-search"></span> Suchen</button>
                    </span>
                </div>
            </form>
        </cfif>
    </div>
</nav>
</cfoutput>