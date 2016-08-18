<div class="container">
    <div class="card card-block">
        <cfif ! structIsEmpty(form)>
            <div class="alert alert-danger" role="alert">
                <h2><span class="fa fa-exclamation" aria-hidden="true"></span> Falscher Username oder Passwort.</h2>
                <p>
                    Bitte versuchen Sie es erneut.
                </p>
            </div>
        </cfif>
        
        <form method="post">
            <div class="form-group row">
                <label for="username" class="col-sm-2 form-control-label">Username</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="username" placeholder="Username" name="username">
                </div>
            </div>
            <div class="form-group row">
                <label for="password" class="col-sm-2 form-control-label">Passwort</label>
                <div class="col-sm-10">
                    <input type="password" class="form-control" id="password" placeholder="Passwort" name="password">
                </div>
            </div>
            <div class="form-group row m-b-0">
                <div class="col-sm-10 offset-sm-2">
                    <button type="submit" class="btn btn-success"><i class="fa fa-sign-in"></i> Einloggen</button>
                </div>
            </div>
        </form>
    </div>
</div>