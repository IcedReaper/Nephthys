<cfoutput>
<section>
    <header>
        <h1>Userdetails</h1>
    </header>

    <section class="well userDetails">
        <h4>#attributes.user.getUsername()#</h4>
        <div class="row">
            <div class="col-md-3">
                <img class="avatar img-rounded" alt="#attributes.user.getUsername()# Avatar" src="#attributes.user.getAvatarPath()#">
            </div>
            <div class="col-md-9">
                <details>
                    <div class="row">
                        <div class="col-md-3 text-right">
                            <strong>Registriert am:</strong>
                        </div>
                        <div class="col-md-9">
                            #application.system.settings.getValueOfKey("formatLibrary").formatDate(attributes.user.getRegistrationDate())#
                        </div>
                    </div>
                </details>
            </div>
        </div>
    </section>
</section>
</cfoutput>