<cfoutput>
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
            <a href="/user/#request.user.getUsername()#" class="btn btn-secondary btn-link btn-sm font-light"><i class="fa fa-cog"></i> Mein Profil</a>
            <cfif application.system.settings.getValueOfKey("privateMessageModule") NEQ null>
                <a href="/user/#request.user.getUsername()#/privateMessages" class="btn btn-secondary btn-link btn-sm font-light"><i class="fa fa-commenting-o"></i> Private Nachrichten</a>
            </cfif>
            <div class="dropdown-divider"></div>
            <a href="?logout" class="btn btn-secondary btn-link btn-sm font-light"><i class="fa fa-sign-out"></i> Ausloggen</a>
        </div>
    </div>
</cfif>
</cfoutput>