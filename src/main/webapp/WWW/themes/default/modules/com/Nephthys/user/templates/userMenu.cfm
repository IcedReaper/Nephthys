<cfoutput>
<cfif request.user.getUserId() EQ 0>
    <div class="btn-group pull-right m-l-1">
        <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            Login
        </button>
        <div class="dropdown-menu p-r-1 p-l-1 p-b-1">
            <form action="?" method="POST" class="form-inline" auto-complete="off">
                <input type="hidden" name="name" value="com.Nephthys.user.login">
                <fieldset class="form-group">
                    <label for="username">Username</label>
                    <input type="text" name="Username" id="username" class="form-control">
                </fieldset>
                <fieldset class="form-group">
                    <label for="password">Passwort</label>
                    <input type="password" name="Password" id="password" class="form-control">
                </fieldset>
                <button type="submit" class="btn btn-success btn-block m-t-1"><i class="fa fa-sign-in"></i> Einloggen</button>
                <a href="#attributes.userPage#/registrieren" class="btn btn-secondary btn-block m-t-1"><i class="fa fa-user-plus"></i> Registieren</a>
            </form>
        </div>
    </div>
<cfelse>
    <div class="btn-group pull-right m-l-1">
        <button type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            #request.user.getUsername()#
        </button>
        <div class="dropdown-menu p-r-1 p-l-1 p-b-1">
            <a href="#attributes.userPage#/#request.user.getUsername()#" class="btn btn-link btn-sm font-light"><i class="fa fa-cog"></i> Mein Profil</a>
            <a href="#attributes.userPage#/#request.user.getUsername()#/edit" class="btn btn-link btn-sm font-light"><i class="fa fa-cog"></i> Mein Profil bearbeiten</a>
            <cfif application.system.settings.getValueOfKey("privateMessageModule") NEQ null>
                <a href="#attributes.userPage#/#request.user.getUsername()#/privateMessages" class="btn btn-link btn-sm font-light">
                    <i class="fa fa-commenting-o"></i> Private Nachrichten
                    <cfif attributes.privateMessages.len() GT 0>
                        <span class="label label-danger" title="Du hast #attributes.privateMessages.len()# neue Private Nachrichten">#attributes.privateMessages.len()#</span>
                    </cfif>
                </a>
            </cfif>
            <div class="dropdown-divider"></div>
            <a href="?logout" class="btn btn-link btn-sm font-light"><i class="fa fa-sign-out"></i> Ausloggen</a>
        </div>
    </div>
</cfif>
</cfoutput>