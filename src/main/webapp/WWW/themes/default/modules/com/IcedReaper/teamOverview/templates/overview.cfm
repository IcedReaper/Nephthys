<cfoutput>
    <section class="com-IcedReaper-teamOverview">
        <h2>Teamübersicht</h2>

        <cfloop from="1" to="#attributes.member.len()#" index="memberIndex">
            <cfif memberIndex % 3 EQ 1>
                <cfif memberIndex NEQ 1>
                    </div>
                </cfif>
                
                <div class="row">
            </cfif>
            <div class="col-md-4">
                <div class="card">
                    <img class="card-img-top" src="#attributes.member[memberIndex].getUser().getAvatarPath()#">
                    <div class="card-block">
                        <h4 class="card-title">
                            <cf_userLink userName="#attributes.member[memberIndex].getUser().getUserName()#"><cfif attributes.member[memberIndex].getUser().getExtProperties().getValue("realName") NEQ null>#attributes.member[memberIndex].getUser().getExtProperties().getValue("realName")#<cfelse>#attributes.member[memberIndex].getUser().getUserName()#</cfif></cf_userLink>
                        </h4>
                        <cfif attributes.member[memberIndex].getUser().getExtProperties().getValue("description") NEQ null>
                            <p class="card-text">
                                #attributes.member[memberIndex].getUser().getExtProperties().getValue("description")#
                            </p>
                        </cfif>
                        <p class="card-text">
                            <cfif attributes.member[memberIndex].getUser().getExtProperties().getValue("githubUser") NEQ null>
                                <a href="https://www.gibhub.com/#attributes.member[memberIndex].getUser().getExtProperties().getValue('githubUser')#" class="btn btn-info" title="#attributes.member[memberIndex].getUser().getUserName()# auf GitHub" target="_blank"><i class="fa fa-github"></i></a>
                            </cfif>
                            <cfif attributes.member[memberIndex].getUser().getExtProperties().getValue("twitterUser") NEQ null>
                                <a href="https://www.twitter.com/#attributes.member[memberIndex].getUser().getExtProperties().getValue('twitterUser')#" class="btn btn-info" title="#attributes.member[memberIndex].getUser().getUserName()# auf Twitter" target="_blank"><i class="fa fa-twitter"></i></a>
                            </cfif>
                            <cfif attributes.member[memberIndex].getUser().getExtProperties().getValue("facebookPage") NEQ null>
                                <a href="https://www.facebook.com/#attributes.member[memberIndex].getUser().getExtProperties().getValue('facebookPage')#" class="btn btn-info" title="#attributes.member[memberIndex].getUser().getUserName()# auf Facebook" target="_blank"><i class="fa fa-facebook"></i></a>
                            </cfif>
                        </p>
                    </div>
                </div>
            </div>
        </cfloop>
        <cfif attributes.member.len() GT 0>
            </div>
        </cfif>
    </section>
</cfoutput>