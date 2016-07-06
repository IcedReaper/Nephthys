<cfoutput>
<div class="com-IcedReaper-permissionRequest">
    <div class="row">
        <div class="col-md-12">
            <a href="#attributes.userPage#/#request.user.getUserName()#/permissionRequest/overview" class="btn btn-primary pull-right"><i class="fa fa-chevron-left"></i> Zurück zur Übersicht</a>
            <h2>Neue Berechtigung anfragen</h2>
            
            <!--- TODO: Fehlerausgabe --->
            
            <form method="POST" autocomplete="off" action="#attributes.userPage#/#request.user.getUserName()#/permissionRequest/new" class="m-t-1">
                <input type="hidden" name="name" value="com.IcedReaper.permissionRequest">
                <div class="form-group row">
                    <label class="form-label col-md-3" for="moduleId">Modul</label>
                    <div class="col-md-9">
                        <select id="moduleId" name="moduleId" class="form-control">
                            <cfloop from="1" to="#attributes.modules.len()#" index="moduleIndex">
                                <option value="#attributes.modules[moduleIndex].getModuleId()#">#attributes.modules[moduleIndex].getModuleName()#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="form-label col-md-3" for="roleId">Rolle</label>
                    <div class="col-md-9">
                        <select id="roleId" name="roleId" class="form-control">
                            <cfloop from="1" to="#attributes.roles.len()#" index="roleIndex">
                                <option value="#attributes.roles[roleIndex].roleId#">#attributes.roles[roleIndex].name#</option>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group row">
                    <label class="form-label col-md-3" for="comment">Wieso möchtest Du diese Berechtigung?</label>
                    <div class="col-md-9">
                        <textarea name="comment" class="form-control" placeholder="Dein Kommentar" maxlength="500"></textarea
>                    </div>
                </div>
                
                <button type="submit" class="btn btn-success"><i class="fa fa-comment-o"></i> Abschicken</button>
            </form>
        </div>
    </div>
    <!--- TODO:
     - validation
     - user auto complete
    --->
</div>
</cfoutput>