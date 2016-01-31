component {
    public member function init(required numeric memberId) {
        variables.memberId = arguments.memberId;
        
        loadDetails();
        
        return this;
    }
    
    // SETTER
    public member function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        
        return this;
    }
    
    public member function setSortId(required numeric sortId) {
        variables.sortId = arguments.sortId;
        
        return this;
    }
    
    // GETTER
    public number function getUserId () {
        return variables.userId;
    }
    
    public user function getUser() {
        if(! variables.keyExists("user")) {
            variables.user = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.userId);
        }
        return user;
    }
    
    public number function getCreatorUserId () {
        return variables.creatorUserId;
    }
    
    public user function getCreatorUser() {
        if(! variables.keyExists("creator")) {
            variables.creator = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.userId);
        }
        return creator;
    }
    
    public number function getLastEditorUserId () {
        return variables.lastEditorUserId;
    }
    
    public user function getLastEditorUser() {
        if(! variables.keyExists("lastEditor")) {
            variables.lastEditor = createObject("component", "API.modules.com.Nephthys.user.user").init(variables.lastEditorUserId);
        }
        return lastEditor;
    }
    
    // CRUD
    public member function save() {
        if(variables.userId != null && variables.userId != 0) {
            if(variables.memberId == 0) {
                var qInsMember = new Query();
                var sql = "INSERT INTO icedReaper_teamOverview_member
                                       (
                                           userId,
                                           sortId,
                                           creatorUserId,
                                           lastEditorUserId
                                       )
                                VALUES (
                                           :userId, ";
                if(variables.sortId != 0 && variables.sortId != null) {
                    sql &= "               :sortId, ";
                    qInsMember.addParam(name = "sortId", value = arguments.sortId, cfsqltype = "cf_sql_numeric");
                }
                else {
                    sql &= "               (SELECT MAX(sortId) + 1 FROM icedReaper_teamOverview_member), ";
                }
                sql &= "                   :actualUserId,
                                           :actualUserId
                                       );
                           SELECT currval('seq_icedreaper_teamOverview_memberId' :: regclass) newMemberId;";
                
                variables.memberId = qInsMember.setSQL(sql)
                                               .addParam(name = "actualUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                                               .execute()
                                               .getResult()
                                               .newMemberId[1];
            }
            else {
                new Query().setSQL("UPDATE icedReaper_teamOverview_member
                                       SET sortId           = :sortId,
                                           lastEditorUserId = :lastEditorUserId,
                                           lastEditDate     = now()
                                     WHERE memberId = :memberId")
                           .addParam(name = "memberId",         value = variables.memberId,       cfsqltype = "cf_sql_numeric")
                           .addParam(name = "sortId",           value = arguments.sortId,         cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditorUserId", value = request.user.getUserId(), cfsqltype = "cf_sql_numeric")
                           .execute();
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You are not allowed to add an anonymous team member");
        }
    }
    
    public void function delete() {
        new Query().setSQL("DELETE FROM icedReaper_teamOverview_member
                                  WHERE memberId = :memberId")
                   .addParam(name = "memberId", value = variables.memberId, cfsqltype = "cf_sql_numeric")
                   .execute();
    }
    
    // PRIVATE
    private void function loadDetails() {
        if(variables.memberId != 0 && variables.memberId != null) {
            var qMember = new Query().setSQL("SELECT *
                                                FROM icedReaper_teamOverview_member
                                               WHERE memberId = :memberId")
                                     .addParam(name = "memberId", value = variables.memberId, cfsqltype = "cf_sql_numeric")
                                     .execute()
                                     .getResult();
            
            if(qMember.getRecordCount() == 1) {
                variables.userId           = qMember.userId[1];
                variables.sortId           = qMember.sortId[1];
                variables.creatorUserId    = qMember.creatorUserId[1];
                variables.creationDate     = qMember.creationDate[1];
                variables.lastEditorUserId = qMember.lastEditorUserId[1];
                variables.lastEditDate     = qMember.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.teamOverview.notFound", message = "Couldn't find a team member with this id", detail = variables.memberId);
            }
        }
        else {
            variables.userId           = null;
            variables.sortId           = 0;
            variables.creatorUserId    = null;
            variables.creationDate     = now();
            variables.lastEditorUserId = null;
            variables.lastEditDate     = now();
        }
    }
}