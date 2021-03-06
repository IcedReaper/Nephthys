<cfoutput>
    <cfif application.system.settings.getValueOfKey('showCopyright')>
        #application.system.settings.getValueOfKey('copyrightText')# #year(now())#
    </cfif>
    <div class="footerLinks">
        <cfif application.system.settings.getValueOfKey('showNephthysBacklink')>
            <a href="https://www.nephthys.com">Aktuelle Version: V#application.system.settings.getValueOfKey('nephthysVersion')#</a>
        </cfif>
        <cfloop from="1" to="#attributes.sitemap.len()#" index="pageIndex">
            <a href="#attributes.sitemap[pageIndex].getActualPageVersion().getLink()#"
               title="#attributes.sitemap[pageIndex].getActualPageVersion().getTitle()#">#attributes.sitemap[pageIndex].getActualPageVersion().getLinkText()#</a>
        </cfloop>
    </div>
    
    <cfif application.system.settings.getValueOfKey('showSocialLinksInFooter')>
        <div class="row">
            <div class="col-sm-4 offset-sm-8">
                Folge uns auf:<br />
                <div class="btn-group" role="group" aria-label="Folge uns auf">
                    <cfif application.system.settings.getValueOfKey('facebook-page') NEQ "">
                        <a type="button" class="btn btn-secondary" href="https://www.facebook.com/#application.system.settings.getValueOfKey('facebook-page')#" target="_blank"><i class="fa fa-facebook"></i></a>
                    </cfif>
                    <cfif application.system.settings.getValueOfKey('twitter-user') NEQ "">
                        <a type="button" class="btn btn-secondary" href="https://www.twitter.com/#application.system.settings.getValueOfKey('twitter-user')#" target="_blank"><i class="fa fa-twitter"></i></a>
                    </cfif>
                    <cfif application.system.settings.getValueOfKey('github-user') NEQ "">
                        <a type="button" class="btn btn-secondary" href="https://www.github.com/#application.system.settings.getValueOfKey('github-user')#" target="_blank"><i class="fa fa-github"></i></a>
                    </cfif>
                    <cfif application.system.settings.getValueOfKey('instagram-user') NEQ "">
                        <a type="button" class="btn btn-secondary" href="https://www.instagram.com/#application.system.settings.getValueOfKey('instagram-user')#" target="_blank"><i class="fa fa-instagram"></i></a>
                    </cfif>
                    <cfif application.system.settings.getValueOfKey('google-plus-page') NEQ "">
                        <a type="button" class="btn btn-secondary" href="https://plus.google.com/#application.system.settings.getValueOfKey('google-plus-page')#" target="_blank"><i class="fa fa-google-plus"></i></a>
                    </cfif>
                    <cfif application.system.settings.getValueOfKey('lastfm-user') NEQ "">
                        <a type="button" class="btn btn-secondary" href="https://last.fm/user/#application.system.settings.getValueOfKey('lastfm-user')#" target="_blank"><i class="fa fa-lastfm"></i></a>
                    </cfif>
                </div>
            </div>
        </div>
    </cfif>
</cfoutput>