component {
    public filter function init() {
        variables.isMember = true;
        variables.userId = null;
        variables.sortId = null;
        variables.minSortId = null;
        variables.maxSortId = null;
        
        return this;
    }
    
    public filter function setIsMember(required boolean isMember) {
        variables.isMember = arguments.isMember;
        return this;
    }
    public filter function setUserId(required numeric userId) {
        variables.userId = arguments.userId;
        return this;
    }
    public filter function setSortId(required numeric sortId) {
        variables.sortId = arguments.sortId;
        return this;
    }
    public filter function setMinSortId(required numeric sortId) {
        variables.minSortId = arguments.sortId;
        return this;
    }
    public filter function setMaxSortId(required numeric sortId) {
        variables.maxSortId = arguments.sortId;
        return this;
    }
    
    public array function filter() {
        if(variables.isMember) {
            var qryMember = new Query();
            
            var sql = "SELECT memberId
                         FROM icedReaper_teamOverview_member";
            var where = "";
            if(variables.userId != 0 && variables.userId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " userId = :userId";
                qryMember.addParam(name = "userId", value = variables.userId, cfsqltype = "cf_sql_numeric");
            }
            if(variables.sortId != null) {
                where &= (where == "" ? " WHERE " : " AND ") & " sortId = :sortId";
                qryMember.addParam(name = "sortId", value = variables.sortId, cfsqltype = "cf_sql_numeric");
            }
            else {
                if(variables.minSortId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & " sortId >= :minSortId";
                    qryMember.addParam(name = "minSortId", value = variables.minSortId, cfsqltype = "cf_sql_numeric");
                }
                
                if(variables.maxSortId != null) {
                    where &= (where == "" ? " WHERE " : " AND ") & " sortId <= :maxSortId";
                    qryMember.addParam(name = "maxSortId", value = variables.maxSortId, cfsqltype = "cf_sql_numeric");
                }
            }
            sql &= where &
                   " ORDER BY sortId ASC";
            
            var qMember = qryMember.setSQL(sql)
                                   .execute()
                                   .getResult();
            
            var member = [];
            for(var i = 1; i <= qMember.getRecordCount(); ++i) {
                member.append(new member(qMember.memberId[i]));
            }
            
            return member;
        }
        else {
            var qNoMember = new Query().setSQL("  SELECT userId
                                                    FROM nephthys_user
                                                   WHERE userId NOT IN (SELECT userId
                                                                          FROM icedReaper_teamOverview_member)
                                                     AND active = :active
                                                ORDER BY userName ASC")
                                       .addParam(name = "active", value = true, cfsqltype = "cf_sql_bit")
                                       .execute()
                                       .getResult();
            
            var user = [];
            for(var i = 1; i <= qNoMember.getRecordCount(); ++i) {
                user.append(createObject("component", "API.modules.com.Nephthys.user.user").init(qNoMember.userId[i]));
            }
            
            return user;
        }
    }
}