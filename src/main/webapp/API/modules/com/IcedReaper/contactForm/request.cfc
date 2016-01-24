component {
    public request function init(required numeric requestId) {
        variables.requestId = arguments.requestId;
        
        loadDetails();
        
        return this;
    }
    
    // SETTER
    public request function setUserName(required string userName) { // todo: implement validations
        variables.userName = arguments.userName;
        return this;
    }
    public request function setCreatorUserId(required numeric creatorUserId) { // todo: implement validations
        variables.creatorUserId = arguments.creatorUserId;
        return this;
    }
    public request function setEmail(required string email) { // todo: implement validations
        variables.email = arguments.email;
        return this;
    }
    public request function setSubject(required string subject) {
        if(arguments.subject != "") {
            variables.subject = arguments.subject;
            return this;
        }
        else {
            throw(type = "icedreaper.contactForm.invalidData", message = "Please insert a subject");
        }
    }
    public request function setMessage(required string message) {
        if(arguments.message != "") {
            variables.message = arguments.message;
            return this;
        }
        else {
            throw(type = "icedreaper.contactForm.invalidData", message = "Please insert a message");
        }
    }
    
    // GETTER
    public string function getUserName() {
        return variables.userName;
    }
    public string function getCreatorUserId() {
        return variables.creatorUserId;
    }
    public string function getEmail() {
        return variables.email;
    }
    public string function getSubject() {
        return variables.subject;
    }
    public string function getMessage() {
        return variables.message;
    }
    public string function getCreationDate() {
        return variables.creationDate;
    }
    
    // CRUD
    public request function save() {
        if(variables.requestId == 0) {
            variables.requestId = new Query().setSQL("INSERT INTO IcedReaper_contactForm_request
                                                                  (
                                                                      subject,
                                                                      email,
                                                                      message,
                                                                      userName,
                                                                      creatorUserId
                                                                  )
                                                           VALUES (
                                                                      :subject,
                                                                      :email,
                                                                      :message,
                                                                      :userName,
                                                                      :creatorUserId
                                                                  );
                                                      SELECT currval('seq_icedreaper_contactForm_requestId' :: regclass) requestId;")
                                             .addParam(name = "subject",       value = variables.subject,       cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "email",         value = variables.email,         cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "message",       value = variables.message,       cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "userName",      value = variables.userName,      cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "creatorUserId", value = variables.creatorUserId, cfsqltype = "cf_sql_numeric", null = variables.creatorUserId == 0)
                                             .execute()
                                             .getResult()
                                             .requestId[1];
        }
        else { // todo: change...
            new Query().setSQL("UPDATE IcedReaper_contactForm_request
                                   SET lastEditDate = now()
                                 WHERE requestId = :requestId")
                       .addParam(name = "requestId",     value = variables.requestId,     cfsqltype = "cf_sql_numeric")
                       .addParam(name = "subject",       value = variables.subject,       cfsqltype = "cf_sql_varchar")
                       .addParam(name = "email",         value = variables.email,         cfsqltype = "cf_sql_varchar")
                       .addParam(name = "message",       value = variables.message,       cfsqltype = "cf_sql_varchar")
                       .addParam(name = "userName",      value = variables.userName,      cfsqltype = "cf_sql_varchar")
                       .addParam(name = "creatorUserId", value = variables.creatorUserId, cfsqltype = "cf_sql_numeric")
                       .execute();
        }
        
        return this;
    }
    
    // PRIVATE
    private void function loadDetails() {
        if(variables.requestId != 0) {
            var qContactForm = new Query().setSQL("SELECT *
                                                     FROM IcedReaper_contactForm_request
                                                    WHERE requestId = :requestId")
                                          .addParam(name = "requestId", value = variables.requestId, cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            if(qContactForm.getRecordCount() == 1) {
                variables.userName      = qContactForm.userName[1];
                variables.creatorUserId = qContactForm.creatorUserId[1];
                variables.subject       = qContactForm.subject[1];
                variables.email         = qContactForm.email[1];
                variables.message       = qContactForm.message[1];
                variables.creationDate  = qContactForm.creationDate[1];
            }
            else {
                throw(type = "icedreaper.contactForm.notFound", message = "Could not find a contact form with this Id");
            }
        }
        else {
            variables.userName      = request.user.getUserName();
            variables.creatorUserId = request.user.getUserId();
            variables.subject       = "";
            variables.email         = "";
            variables.message       = "";
            variables.creationDate  = now();
        }
    }
}