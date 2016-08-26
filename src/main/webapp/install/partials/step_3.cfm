<cfoutput>
<div class="row m-y-2">
    <div class="col-sm-12">
        <h1>Einrichtung der Grundeinstellungen</h1>
        <form method="POST" action="?step=3&proceed">
            <div class="form-group row">
                <label for="_description" class="col-xs-4 col-md-2">Seitenbeschreibung</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="_description" name="_description" placeholder="Beschreibung Deiner Webseite">
                </div>
            </div>
            
            <div class="form-group row">
                <label for="_wwwDomain" class="col-xs-4 col-md-2">Link zur Webseite</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="_wwwDomain" name="_wwwDomain" placeholder="https://www.nephthys.com/">
                </div>
            </div>
            <div class="form-group row">
                <label for="_adminDomain" class="col-xs-4 col-md-2">Link zum Adminpanel</label>
                <div class="col-xs-8 col-md-10">
                    <input class="form-control" type="text" id="_adminDomain" name="_adminDomain" placeholder="https://www.admin.nephthys.com">
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
</cfoutput>