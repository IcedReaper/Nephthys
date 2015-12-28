<cfoutput>
<nav class="navbar m-b">
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
        
        <cfif application.system.settings.getValueOfKey("wwwLoginAvailable")>
            <cfif request.user.getUserId() EQ 0>
                <div class="btn-group pull-right m-l">
                    <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        Login
                    </button>
                    <div class="dropdown-menu p-r p-l p-b">
                        <form action="?" method="POST" class="form-inline" auto-complete="off">
                            <fieldset class="form-group">
                                <label for="username">Username</label>
                                <input type="text" name="Username" id="username" class="form-control">
                            </fieldset>
                            <fieldset class="form-group">
                                <label for="password">Passwort</label>
                                <input type="password" name="Password" id="password" class="form-control">
                            </fieldset>
                            <button type="submit" class="btn btn-success m-t"><i class="fa fa-sign-in"></i> Einloggen</button>
                        </form>
                    </div>
                </div>
            <cfelse>
                <div class="btn-group pull-right m-l">
                    <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        #request.user.getUsername()#
                    </button>
                    <div class="dropdown-menu p-r p-l p-b">
                        <a href="?logout" class="dropdown-item"><i class="fa fa-sign-out"></i> Ausloggen</a>
                    </div>
                </div>
            </cfif>
        </cfif>
        
        <form action="/search" method="POST" class="form-inline navbar-form pull-right">
            <input type="text" class="form-control" placeholder="Suchbegriff" name="searchStatement">
            <button type="submit" class="btn btn-success"><span class="fa fa-search"></span> Suchen</button>
        </form>
    </div>
</nav>
</cfoutput>