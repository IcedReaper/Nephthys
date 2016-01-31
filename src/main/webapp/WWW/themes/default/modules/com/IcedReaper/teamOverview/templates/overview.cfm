<cfoutput>
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
                        <a href="/User/#attributes.member[memberIndex].getUser().getUserName()#">#attributes.member[memberIndex].getUser().getUserName()#</a>
                    </h4>
                    <cfif attributes.member[memberIndex].getUser().getExtendedProperty("description") NEQ null>
                        <p class="card-text">
                            #attributes.member[memberIndex].getUser().getExtendedProperty("description")#
                        </p>
                    </cfif>
                    <p class="card-text">
                        <cfif attributes.member[memberIndex].getUser().getExtendedProperty("githubUser") NEQ null>
                            <a href="https://www.gibhub.com/#attributes.member[memberIndex].getUser().getExtendedProperty('githubUser')#" class="btn btn-info" title="#attributes.member[memberIndex].getUser().getUserName()# auf GitHub" target="_blank"><i class="fa fa-github"></i></a>
                        </cfif>
                        <cfif attributes.member[memberIndex].getUser().getExtendedProperty("twitterUser") NEQ null>
                            <a href="https://www.twitter.com/#attributes.member[memberIndex].getUser().getExtendedProperty('twitterUser')#" class="btn btn-info" title="#attributes.member[memberIndex].getUser().getUserName()# auf Twitter" target="_blank"><i class="fa fa-twitter"></i></a>
                        </cfif>
                        <cfif attributes.member[memberIndex].getUser().getExtendedProperty("facebookPage") NEQ null>
                            <a href="https://www.facebook.com/#attributes.member[memberIndex].getUser().getExtendedProperty('facebookPage')#" class="btn btn-info" title="#attributes.member[memberIndex].getUser().getUserName()# auf Facebook" target="_blank"><i class="fa fa-facebook"></i></a>
                        </cfif>
                    </p>
                </div>
            </div>
        </div>
    </cfloop>
    <cfif attributes.member.len() GT 1>
        </div>
    </cfif>
</cfoutput>