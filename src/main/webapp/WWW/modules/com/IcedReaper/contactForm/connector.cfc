component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.contactForm.*";
    import "API.modules.com.Nephthys.userManager.user";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.contactForm";
    }
    public string function getModulePath() {
        return getName().replace(".", "/", "ALL");
    }
    
    public string function render(required struct options, required boolean rootElement, required string childContent) {
        var errors = {
            error             = false,
            contactSuccessful = false,
            subject           = false,
            message           = false,
            username          = false,
            usernameUsed      = false,
            email             = false,
            emailUsed         = false
        };
        
        if(! form.isEmpty() && form.keyExists("name") && form.name == "com.IcedReaper.contactForm") {
            var validator = application.system.settings.getValueOfKey("validator");
            
            if(form.subject == "") {
                errors.subject = true;
                errors.error = true;
            }
            if(form.message == "") {
                errors.message = true;
                errors.error = true;
            }
            if(! request.user.getStatus().getCanLogin()) {
                if(form.username == "") {
                    errors.username = true;
                    errors.error = true;
                }
                if(form.email == "") {
                    errors.email = true;
                    errors.error = true;
                }
                if(! validator.validate(form.email, "Email")) {
                    errors.email = true;
                    errors.error = true;
                }
                if(createObject("component", "API.modules.com.Nephthys.userManager.filter").init().for("user").setUsername(form.username).setActive(true).execute().getResultCount() != 0) {
                    errors.usernameUsed = true;
                    errors.error = true;
                }
                if(createObject("component", "API.modules.com.Nephthys.userManager.filter").init().for("user").setEmail(form.email).setActive(true).execute().getResultCount() != 0) {
                    errors.emailUsed = true;
                    errors.error = true;
                }
            }
            
            if(! errors.error) {
                var contactFormRequest = new contactRequest(null);
                contactFormRequest.setSubject(form.subject)
                                  .setMessage(form.message);
                
                if(request.user.getStatus().getCanLogin()) {
                    contactFormRequest.setRequestor(request.user)
                                      .setUsername(request.user.getUsername())
                                      .setEmail(request.user.getEmail());
                }
                else {
                    contactFormRequest.setRequestor(new user(null))
                                      .setUsername(form.username)
                                      .setEmail(form.email);
                }
                
                contactFormRequest.save(request.user);
                
                errors.contactSuccessful = true;
                
                return application.system.settings.getValueOfKey("templateRenderer")
                    .setModulePath(getModulePath())
                    .setTemplate("thanks.cfm")
                    .addParam("options", arguments.options)
                    .render();
            }
        }
        
        return application.system.settings.getValueOfKey("templateRenderer")
                .setModulePath(getModulePath())
                .setTemplate("form.cfm")
                .addParam("options", arguments.options)
                .addParam("errors",  errors)
                .render();
    }
}