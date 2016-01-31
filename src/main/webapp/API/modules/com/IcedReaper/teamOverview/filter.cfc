component {
    public filter function init() {
        return this;
    }
    
    public array function filter() {
        var qMember = new Query().setSQL(" SELECT memberId
                                             FROM icedReaper_teamOverview_member
                                         ORDER BY sortId ASC")
                                 .execute()
                                 .getResult();
        
        var member = [];
        for(var i = 1; i <= qMember.getRecordCount(); ++i) {
            member.append(new member(qMember.memberId[i]));
        }
        
        return member;
    }
}