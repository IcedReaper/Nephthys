component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public contactRequest function init(required numeric contactRequestId) {
        variables.contactRequestId = arguments.contactRequestId;
        
        loadDetails();
        
        return this;
    }
    
    
    public contactRequest function setUserName(required string userName) {
        variables.userName = arguments.userName;
        return this;
    }
    public contactRequest function setRequestor(required user requestor) {
        variables.requestor = arguments.requestor;
        return this;
    }
    public contactRequest function setEmail(required string email) {
        variables.email = arguments.email;
        return this;
    }
    public contactRequest function setSubject(required string subject) {
        variables.subject = arguments.subject;
        return this;
    }
    public contactRequest function setMessage(required string message) {
        variables.message = arguments.message;
        return this;
    }
    public contactRequest function setRead(required boolean read) {
        variables.read = arguments.read;
        return this;
    }
    public contactRequest function addRepy(required reply _reply) {
        variables.replies.append(duplicate(arguments._reply));
        
        return this;
    }
    
    
    public numeric function getContactRequestId() {
        return variables.contactRequestId;
    }
    public string function getUserName() {
        return variables.userName;
    }
    public user function getRequestor() {
        return variables.requestor;
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
    public date function getRequestDate() {
        return variables.requestDate;
    }
    public boolean function getRead() {
        return variables.read == 1;
    }
    public any function getReadDate() {
        return variables.readDate;
    }
    public integer function getReader() {
        return variables.reader;
    }
    public array function getReplies() {
        loadReplies();
        
        return variables.replies;
    }
    
    
    public contactRequest function save(required user user) {
        if(variables.contactRequestId == null) {
            variables.contactRequestId = new Query().setSQL("INSERT INTO IcedReaper_contactForm_contactRequest
                                                                  (
                                                                      subject,
                                                                      email,
                                                                      message,
                                                                      userName,
                                                                      requestorUserId
                                                                  )
                                                           VALUES (
                                                                      :subject,
                                                                      :email,
                                                                      :message,
                                                                      :userName,
                                                                      :requestorUserId
                                                                  );
                                                      SELECT currval('seq_icedreaper_contactForm_requestId') contactRequestId;")
                                             .addParam(name = "subject",         value = variables.subject,          cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "email",           value = variables.email,            cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "message",         value = variables.message,          cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "userName",        value = variables.userName,         cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "requestorUserId", value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric", null = arguments.user.getUserId() == null)
                                             .execute()
                                             .getResult()
                                             .contactRequestId[1];
            
            variables.requestor = arguments.user;
            variables.requestDate = now();
        }
        else {
            new Query().setSQL("UPDATE IcedReaper_contactForm_contactRequest
                                   SET read       = :read,
                                       readDate   = now(),
                                       readUserId = :readUserId
                                 WHERE contactRequestId  = :contactRequestId")
                       .addParam(name = "contactRequestId", value = variables.contactRequestId, cfsqltype = "cf_sql_numeric")
                       .addParam(name = "read",             value = variables.read,             cfsqltype = "cf_sql_bit")
                       .addParam(name = "readUserId",       value = arguments.user.getUserId(), cfsqltype = "cf_sql_numeric")
                       .execute();
            
            variables.reader = arguments.user;
            variables.readDate = now();
        }
        
        return this;
    }
    
    
    private void function loadDetails() {
        if(variables.contactRequestId != null) {
            var qContactForm = new Query().setSQL("SELECT *
                                                     FROM IcedReaper_contactForm_contactRequest
                                                    WHERE contactRequestId = :contactRequestId")
                                          .addParam(name = "contactRequestId", value = variables.contactRequestId, cfsqltype = "cf_sql_numeric")
                                          .execute()
                                          .getResult();
            
            if(qContactForm.getRecordCount() == 1) {
                variables.userName    = qContactForm.userName[1];
                variables.requestor   = new user(qContactForm.requestorUserId[1]);
                variables.subject     = qContactForm.subject[1];
                variables.email       = qContactForm.email[1];
                variables.message     = qContactForm.message[1];
                variables.requestDate = qContactForm.requestDate[1];
                variables.read        = qContactForm.read[1];
                variables.readDate    = qContactForm.readDate[1];
                variables.reader      = new user(qContactForm.readUserId[1]);
            }
            else {
                throw(type = "icedreaper.contactForm.notFound", message = "Could not find a contact form with this Id");
            }
        }
        else {
            variables.userName    = request.user.getUserName();
            variables.requestor   = request.user;
            variables.subject     = "";
            variables.email       = "";
            variables.message     = "";
            variables.requestDate = now();
            variables.read        = false;
            variables.readDate    = null;
            variables.reader      = new user(null);
        }
    }
    
    private void function loadReplies() {
        variables.replies = new filter().for("reply")
                                        .setContactRequest(this)
                                        .execute()
                                        .getResult();
    }
}