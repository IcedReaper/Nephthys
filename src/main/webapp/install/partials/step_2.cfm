<div class="row m-y-2">
    <div class="col-sm-12">
        <h1>Einrichtung der Datenbankverbindungen</h1>
        <form method="POST" action="?step=2&proceed">
            <h3>Allgemeine Datenbankeinstellungen</h3>
            <div class="form-group row">
                <label for="server" class="col-xs-4 col-md-2">server</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="server" name="server" value="localhost">
                </div>
            </div>
            <div class="form-group row">
                <label for="Port" class="col-xs-4 col-md-2">Port</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="Port" name="Port" value="5432">
                </div>
            </div>
            <div class="form-group row">
                <label for="Database" class="col-xs-4 col-md-2">Database</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="Database" name="Database" placeholder="Datenbankname">
                </div>
            </div>
            
            <h3>Admin</h3>
            <p>Diese Verbindung wird in der Adminoberfläche eingesetzt. Dementsprechend sollte dieser User über alle* benötigten Berechtigungen verfügen.</p>
            <ul>
                <li>CREATE</li>
                <li>ALTER</li>
                <li>SELECT</li>
                <li>UPDATE</li>
                <li>DELETE</li>
                <li>?GRANT?</li>
            </ul>
            
            <div class="form-group row">
                <label for="dbAdminUsername" class="col-xs-4 col-md-2">Username</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="dbAdminUsername" name="dbAdminUsername">
                </div>
            </div>
            <div class="form-group row">
                <label for="dbAdminPassword" class="col-xs-4 col-md-2">Passwort</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="dbAdminPassword" name="dbAdminPassword">
                </div>
            </div>
            
            <h3>Webseite</h3>
            <p>Diese Verbindung wird auf der Webseite verwendet. Sie sollte dementsprechend nur über die minimalen* Berechtigungen verfügen.</p>
            <ul>
                <li>SELECT</li>
                <li>UPDATE</li>
                <li>DELETE</li>
            </ul>
                
            <div class="form-group row">
                <label for="dbUserUsername" class="col-xs-4 col-md-2">Username</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="dbUserUsername" name="dbUserUsername">
                </div>
            </div>
            <div class="form-group row">
                <label for="dbUserPassword" class="col-xs-4 col-md-2">Passwort</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="dbUserPassword" name="dbUserPassword">
                </div>
            </div>
            
            <h3>Lucee Admin Passwort</h3>
            <div class="form-group row">
                <label for="luceeAdminPassword" class="col-xs-4 col-md-2">Passwort</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="luceeAdminPassword" name="luceeAdminPassword">
                </div>
            </div>
            
            <div class="form-group row">
                <div class="col-xs-12 text-sm-right">
                    <button type="submit" class="btn btn-success"><i class="fa fa-chevron-right"></i> Weiter</button>
                </div>
            </div>
        </form>
    </div>
</div>