<div class="container">
    <cfif ! structIsEmpty(form)>
        <div class="alert alert-danger" role="alert">
            <h2><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span> Falscher Username oder Passwort.</h2>
            <p>
                Bitte versuchen Sie es erneut.
            </p>
        </div>
    </cfif>

    <form method="post">
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" class="form-control" id="username" placeholder="Username" name="username">
        </div>
        <div class="form-group">
            <label for="password">Passwort</label>
            <input type="password" class="form-control" id="password" placeholder="Passwort" name="password">
        </div>
        <button type="submit" class="btn btn-success"><i class="fa fa-sign-in"></i> Einloggen</button>
    </form>
</div>