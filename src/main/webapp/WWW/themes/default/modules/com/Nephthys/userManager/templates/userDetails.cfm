<cfoutput>
<section>
    <header>
        <h1>Userdetails</h1>
    </header>

    <section class="userDetails">
        <h4>#attributes.user.getUsername()#</h4>
        <div class="row">
            <div class="col-md-3">
                <img class="avatar img-rounded" alt="#attributes.user.getUsername()# Avatar" src="#attributes.user.getAvatarPath()#">
            </div>
            <div class="col-md-9">
                <details>
                    <div class="row">
                        <div class="col-md-3 col-lg-2">
                            <strong>Registriert am:</strong>
                        </div>
                        <div class="col-md-9 col-lg-10">
                            #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.user.getRegistrationDate())#
                        </div>
                    </div>
                    <cfset extProperties = attributes.user.getExtProperties()>
                    <cfloop from="1" to="#extProperties.len()#" index="epIndex">
                        <div class="row">
                            <div class="col-md-3 col-lg-2">
                                <strong>#extProperties[epIndex].getExtPropertyKey().getDescription()#:</strong>
                            </div>
                            <div class="col-md-9 col-lg-10">
                                <cfswitch expression="#extProperties[epIndex].getExtPropertyKey().getType()#">
                                    <cfcase value="date">
                                        #application.system.settings.getValueOfKey("formatLibrary").formatDate(extProperties[epIndex].getValue(), false)#
                                    </cfcase>
                                    <cfcase value="githubuser">
                                        <a href="https://www.github.com/#extProperties[epIndex].getValue()#" alt="#attributes.user.getUsername()# auf GitHub" target="_blank">#extProperties[epIndex].getValue()#</a>
                                    </cfcase>
                                    <cfcase value="facebookuser">
                                        <a href="https://www.github.com/#extProperties[epIndex].getValue()#" alt="#attributes.user.getUsername()# auf Facebook" target="_blank">#extProperties[epIndex].getValue()#</a>
                                    </cfcase>
                                    <cfcase value="twitteruser">
                                        <a href="https://www.twitter.com/#extProperties[epIndex].getValue()#" alt="#attributes.user.getUsername()# auf Twitter" target="_blank">#extProperties[epIndex].getValue()#</a>
                                    </cfcase>
                                    <cfcase value="facebookpage">
                                        <a href="https://www.github.com/#extProperties[epIndex].getValue()#" alt="#attributes.user.getUsername()# auf Facebook" target="_blank">#extProperties[epIndex].getValue()#</a>
                                    </cfcase>
                                    <cfdefaultcase>
                                        #extProperties[epIndex].getValue()#
                                    </cfdefaultcase>
                                </cfswitch>
                            </div>
                        </div>
                    </cfloop>
                </details>
            </div>
        </div>
        <cfif attributes.user.getUserId() == request.user.getUserId()>
            <div class="row m-t-1">
                <div class="col-sm-12 text-xs-right">
                    <a href="#attributes.userPage#/#attributes.user.getUsername()#/edit" class="btn btn-primary"><i class="fa fa-edit"></i> Profil bearbeiten</a>
                </div>
            </div>
        </cfif>
    </section>
</section>
</cfoutput>