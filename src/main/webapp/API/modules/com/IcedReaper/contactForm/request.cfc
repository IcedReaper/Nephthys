component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public request function init(required numeric requestId) {
        variables.requestId = arguments.requestId;
        
        loadDetails();
        
        return this;
    }
    
    public request function setUserName(required string userName) {
        variables.userName = arguments.userName;
        return this;
    }
    public request function setRequestor(required user requestor) {
        variables.requestor = arguments.requestor;
        return this;
    }
    public request function setEmail(required string email) {
        variables.email = arguments.email;
        return this;
    }
    public request function setSubject(required string subject) {
        variables.subject = arguments.subject;
        return this;
    }
    public request function setMessage(required string message) {
        variables.message = arguments.message;
        return this;
    }
    public request function setRead(required boolean read) {
        variables.read = arguments.read;
        return this;
    }
    public request function addRepy(required reply _reply) {
        variables.replies.append(duplicate(arguments._reply));
        
        return this;
    }
    
    
    public numeric function getRequestId() {
        return variables.requestId;
    }
    public string function getUserName() {
        return variables.userName;
    }
    public numeric function getRequestor() {
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
    public string function getRequestDate() {
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
    
    
    public request function save(required user user) {
        if(variables.requestId == 0) {
            variables.requestId = new Query().setSQL("INSERT INTO IcedReaper_contactForm_request
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
                                                      SELECT currval('seq_icedreaper_contactForm_requestId') requestId;")
                                             .addParam(name = "subject",         value = variables.subject,               cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "email",           value = variables.email,                 cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "message",         value = variables.message,               cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "userName",        value = variables.userName,              cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "requestorUserId", value = variables.requestor.getUserId(), cfsqltype = "cf_sql_numeric", null = variables.requestor.getUserId() == null)
                                             .execute()
                                             .getResult()
                                             .requestId[1];
        }
        else {
            new Query().setSQL("UPDATE IcedReaper_contactForm_request
                                   SET read       = :read,
                                       readDate   = now(),
                                       readUserId = :readUserId
                                 WHERE requestId  = :requestId")
                       .addParam(name = "requestId",  value = variables.requestId,          cfsqltype = "cf_sql_numeric")
                       .addParam(name = "read",       value = variables.read,               cfsqltype = "cf_sql_bit")
                       .addParam(name = "readUserId", value = variables.reader.getUserId(), cfsqltype = "cf_sql_numeric")
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
        var qReplies = new Query().setSQL("  SELECT replyId
                                               FROM IcedReaper_contactForm_reply
                                              WHERE requestId = :requestId
                                           ORDER BY replyDate DESC")
                                  .addParam(name = "requestId", value = variables.requestId, cfsqltype = "cf_sql_numeric")
                                  .execute()
                                  .getResult();
        
        variables.replies = [];
        for(var i = 1; i <= qReplies.getRecordCount(); ++i) {
            variables.replies.append(new reply(qReplies.replyId[i]));
        }
    }
}