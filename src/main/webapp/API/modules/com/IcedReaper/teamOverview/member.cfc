component {
    import "API.modules.com.Nephthys.userManager.*";
    
    public member function init(required numeric memberId) {
        variables.memberId = arguments.memberId;
        
        loadDetails();
        
        return this;
    }
    
    public member function setUser(required user user) {
        variables.user = arguments.user;
        
        return this;
    }
    public member function setSortId(required numeric sortId) {
        variables.sortId = arguments.sortId;
        
        return this;
    }
    
    public numeric function getMemberId() {
        return variables.memberId;
    }
    public user function getUser() {
        return variables.user;
    }
    public numeric function getSortId() {
        return variables.sortId;
    }
    public user function getCreator() {
        return creator;
    }
    public date function getCreationDate() {
        return variables.creationDate;
    }
    public user function getLastEditor() {
        return lastEditor;
    }
    public date function getLastEditDate() {
        return variables.lastEditDate;
    }
    
    // CRUD
    public member function save(required user user) {
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
                    sql &= "               (SELECT CASE 
                                                     WHEN MAX(sortId) IS NOT NULL THEN
                                                       MAX(sortId)
                                                     ELSE
                                                       0
                                                   END + 1
                                              FROM icedReaper_teamOverview_member), ";
                }
                sql &= "                   :creatorUserId,
                                           :lastEditorUserId
                                       );
                           SELECT currval('seq_icedreaper_teamOverview_memberId') newMemberId;";
                
                variables.memberId = qInsMember.setSQL(sql)
                                               .addParam(name = "userId",           value = variables.user.getUserId,         cfsqltype = "cf_sql_numeric")
                                               .addParam(name = "creatorUserId",    value = variables.creator.getUserId(),    cfsqltype = "cf_sql_numeric")
                                               .addParam(name = "lastEditorUserId", value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
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
                           .addParam(name = "memberId",         value = variables.memberId,               cfsqltype = "cf_sql_numeric")
                           .addParam(name = "sortId",           value = variables.sortId,                 cfsqltype = "cf_sql_numeric")
                           .addParam(name = "lastEditorUserId", value = variables.lastEditor.getUserId(), cfsqltype = "cf_sql_numeric")
                           .execute();
            }
        }
        else {
            throw(type = "nephthys.application.notAllowed", message = "You are not allowed to add an anonymous team member");
        }
        return this;
    }
    public void function delete(required user user) {
        new Query().setSQL("DELETE FROM icedReaper_teamOverview_member
                                  WHERE memberId = :memberId")
                   .addParam(name = "memberId", value = variables.memberId, cfsqltype = "cf_sql_numeric")
                   .execute();
        
        variables.memberId = null;
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
                variables.user         = new user(qMember).userId[1];
                variables.sortId       = qMember.sortId[1];
                variables.creator      = new user(qMember).creatorUserId[1];
                variables.creationDate = qMember.creationDate[1];
                variables.lastEditor   = new user(qMember).lastEditorUserId[1];
                variables.lastEditDate = qMember.lastEditDate[1];
            }
            else {
                throw(type = "icedreaper.teamOverview.notFound", message = "Couldn't find a team member with this id", detail = variables.memberId);
            }
        }
        else {
            variables.user         = new user(null);
            variables.sortId       = 0;
            variables.creator      = new user(null);
            variables.creationDate = now();
            variables.lastEditor   = new user(null);
            variables.lastEditDate = now();
        }
    }
}