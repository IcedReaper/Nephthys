component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.contactForm.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.contactForm";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        if(form.isEmpty()) {
            return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("form.cfm")
                .addParam("options", arguments.options)
                .render();
        }
        else {
            try {
                // TODO: add validation
                var contactFormRequest = new request(0);
                
                contactFormRequest.setSubject(form.subject)
                                  .setMessage(form.message);
                
                if(request.user.isActive()) {
                    contactFormRequest.setRequestorUserId(request.user.getUserId())
                                      .setUsername(request.user.getUsername())
                                      .setEmail(request.user.getEmail());
                }
                else {
                    contactFormRequest.setRequestorUserId(0)
                                      .setUsername(form.username)
                                      .setEmail(form.email);
                }
                
                contactFormRequest.save();
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("thanks.cfm")
                    .addParam("options", arguments.options)
                    .render();
            }
            catch(icedreaper.contactForm.invalidData e) {
                // TODO: Return to form show error
                writeDump(var=e, abort=true);
                return "Fehler";
            }
        }
    }
}