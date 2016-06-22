component implements="WWW.interfaces.connector" {
    import "API.modules.com.IcedReaper.contactForm.*";
    
    public connector function init() {
        return this;
    }
    
    public string function getName() {
        return "com.IcedReaper.contactForm";
    }
    
    public string function render(required struct options, required string childContent) {
        var renderedContent = "";
        
        if(form.isEmpty()) {
            saveContent variable="renderedContent" {
                module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/contactForm/templates/form.cfm"
                       options  = arguments.options;
            }
        }
        else {
            try {
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
                
                saveContent variable="renderedContent" {
                    module template = "/WWW/themes/" & request.user.getWwwTheme().getFolderName() & "/modules/com/IcedReaper/contactForm/templates/thanks.cfm"
                           options  = arguments.options;
                }
            }
            catch(icedreaper.contactForm.invalidData e) {
                writeDump(var=e, abort=true);
                return "Fehler";
            }
        }
        
        return renderedContent;
    }
}