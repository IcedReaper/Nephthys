<div class="com-IcedReaper-privateMessage">
    <div class="row">
        <div class="col-md-12">
            <a href="overview" class="btn btn-primary pull-right"><i class="fa fa-chevron-left"></i> Zurück zur Übersicht</a>
            <h2>Neue Konversation</h2>
            
            <form method="POST" autocomplete="off" action="/user/#request.user.getUserName()#/privateMessages/conversation/new" class="m-t">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="sr-only" for="participants">Teilnehmer</label>
                            <input type="text" class="form-control" id="participants" name="participants" placeholder="Teilnehmer">
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="sr-only" for="message">Text</label>
                            <textarea name="message" class="form-control" placeholder="Ihre Mitteilung"></textarea>
                        </div>
                    </div>
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