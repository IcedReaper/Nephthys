<cfoutput>
    &copy; IcedReaper und das Nephthys Team 2014 - #year(now())#
    <div class="footerLinks">
        <a href="https://www.nephthys.com">Aktuelle Version: V#application.system.settings.getValueOfKey('nephthysVersion')#</a>
        <cfloop from="1" to="#attributes.sitemap.len()#" index="pageIndex">
            <a href="#attributes.sitemap[pageIndex].getLink()#"
               title="#attributes.sitemap[pageIndex].getTitle()#">#attributes.sitemap[pageIndex].getLinkText()#</a>
        </cfloop>
    </div>
    
    <div class="row">
        <div class="col-sm-4 col-sm-offset-8">
            Folge uns auf:<br />
            <div class="btn-group" role="group" aria-label="Folge uns auf">
                <a type="button" class="btn btn-secondary" href="https://www.facebook.com/nephthys-cms" target="_blank"><i class="fa fa-facebook"></i></a>
                <a type="button" class="btn btn-secondary" href="https://www.twitter.com/nephthys-cms" target="_blank"><i class="fa fa-twitter"></i></a>
                <a type="button" class="btn btn-secondary" href="https://www.github.com/nephthys-cms" target="_blank"><i class="fa fa-github"></i></a>
            </div>
        </div>
    </div>
</cfoutput>