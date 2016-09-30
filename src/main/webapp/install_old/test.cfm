<cfscript>
    request.progressRenderer = new progress.progress();
    request.progressRenderer.setTitle("Einrichtung der Datasourcen");
    request.progressRenderer.setDescription("<h1>Einrichtung der Datasource im ColdFusion Admin</h1>");
    
    request.progressRenderer.start();
    request.progressRenderer.startTask("Connect to Admin");
    sleep(10000);
    request.progressRenderer.finishTask(true);
    
    request.progressRenderer.startTask("Admin Datasource");
    sleep(10000);
    request.progressRenderer.finishTask(false);
</cfscript>