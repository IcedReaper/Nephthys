component {
    import "API.modules.com.Nephthys.user.*";
    
    public request function init(required numeric requestId) {
        variables.requestId = arguments.requestId;
        
        loadDetails();
        
        return this;
    }
    
    // SETTER
    public request function setUserName(required string userName) {
        variables.userName = arguments.userName;
        return this;
    }
    public request function setRequestorUserId(required numeric requestorUserId) {
        variables.requestorUserId = arguments.requestorUserId;
        return this;
    }
    public request function setEmail(required string email) {
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
    public request function setRead(required boolean read) {
        variables.read = arguments.read;
        return this;
    }
    public request function addRepy(required reply _reply) {
        variables.replies.append(duplicate(arguments._reply));
        
        return this;
    }
    
    // GETTER
    public numeric function getRequestId() {
        return variables.requestId;
    }
    public string function getUserName() {
        return variables.userName;
    }
    public string function getRequestorUserId() {
        return variables.requestorUserId;
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
    public integer function getReadUserId() {
        return variables.readUserId;
    }
    public array function getReplies() {
        loadReplies();
        
        return variables.replies;
    }
    
    public user function getRequestorUser() {
        if(! variables.keyExists("requestorUser")) {
            variables.requestorUser = new user(variables.requestorUserId);
        }
        return variables.requestorUser;
    }
    public user function getReadUser() {
        if(! variables.keyExists("readUser")) {
            variables.readUser = new user(variables.readUserId);
        }
        return variables.readUser;
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
                                             .addParam(name = "subject",         value = variables.subject,         cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "email",           value = variables.email,           cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "message",         value = variables.message,         cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "userName",        value = variables.userName,        cfsqltype = "cf_sql_varchar")
                                             .addParam(name = "requestorUserId", value = variables.requestorUserId, cfsqltype = "cf_sql_numeric", null = variables.requestorUserId == 0)
                                             .execute()
                                             .getResult()
                                             .requestId[1];
        }
        else {
            new Query().setSQL("UPDATE IcedReaper_contactForm_request
                                   SET read = :read,
                                       readDate   = now(),
                                       readUserId = :readUserId
                                 WHERE requestId  = :requestId")
                       .addParam(name = "requestId",  value = variables.requestId,      cfsqltype = "cf_sql_numeric")
                       .addParam(name = "read",       value = variables.read,           cfsqltype = "cf_sql_bit")
                       .addParam(name = "readUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
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
                variables.userName        = qContactForm.userName[1];
                variables.requestorUserId = qContactForm.requestorUserId[1];
                variables.subject         = qContactForm.subject[1];
                variables.email           = qContactForm.email[1];
                variables.message         = qContactForm.message[1];
                variables.requestDate     = qContactForm.requestDate[1];
                variables.read            = qContactForm.read[1];
                variables.readDate        = qContactForm.readDate[1];
                variables.readUserId      = qContactForm.readUserId[1];
            }
            else {
                throw(type = "icedreaper.contactForm.notFound", message = "Could not find a contact form with this Id");
            }
        }
        else {
            variables.userName        = request.user.getUserName();
            variables.requestorUserId = request.user.getUserId();
            variables.subject         = "";
            variables.email           = "";
            variables.message         = "";
            variables.requestDate     = now();
            variables.read            = false;
            variables.readDate        = null;
            variables.readUserId      = null;
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