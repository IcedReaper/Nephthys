component {
    import "API.modules.com.IcedReaper.teamOverview.*";
    
    remote array function getMember() {
        var filterCtrl = new filter();
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");

        var rawMember = filterCtrl.filter();
        var member = [];
        for(var i = 1; i <= rawMember.len(); ++i) {
            member.append({
                memberId = rawMember[i].getMemberId(),
                userId   = rawMember[i].getUser().getUserId(),
                userName = rawMember[i].getUser().getUserName(),
                addDate  = formatCtrl.formatDate(rawMember[i].getCreationDate())
            });
        }
        return member;
    }
    
    remote array function getRemainingUser() {
        var filterCtrl = new filter();
        
        var rawNoMember = filterCtrl.setIsMember(false).filter();
        var noMember = [];
        for(var i = 1; i <= rawNoMember.len(); ++i) {
            noMember.append({
                userId   = rawNoMember[i].getUserId(),
                userName = rawNoMember[i].getUserName()
            });
        }
        return noMember;
    }
    
    remote numeric function addUser(required numeric userId) {
        new member(0)
            .setUserId(arguments.userId)
            .save();
        
        return true;
    }
    
    remote boolean function removeUser(required numeric userId) {
        var filterCtrl = new filter();
        var member = filterCtrl.setUserId(arguments.userId).filter();
        if(member.len() == 1) {
            removeMember(member[1].getUserId());
        }
        else {
            throw(type = "icedreaper.teamOverview.notFound", message = "Could not find a member with this userId", detail = arguments.userId);
        }
        
        return true;
    }
    
    remote boolean function removeMember(required numeric memberId) {
        new member(arguments.memberId)
            .delete();
        
        return true;
    }
    
    remote boolean function sortUp(required numeric memberId) {
        var actualMember = new member(arguments.memberId);
        
        var actualSortId = actualMember.getSortId();
        
        var filterCtrl = new filter();
        var higherMember = filterCtrl.setSortId(actualSortId - 1).filter()[1];
        
        transaction {
            // first we need to set the sortId to an unused space, as we would otherwise get an unique key error
            higherMember
                .setSortId(-1)
                .save();
            
            actualMember
                .setSortId(actualSortId - 1)
                .save();
            
            higherMember
                .setSortId(actualSortId)
                .save();
            
            transactionCommit();
        }
        
        return true;
    }
    
    remote boolean function sortDown(required numeric memberId) {
        var actualMember = new member(arguments.memberId);
        
        var actualSortId = actualMember.getSortId();
        
        var filterCtrl = new filter();
        var lowerMember = filterCtrl.setSortId(actualSortId + 1).filter()[1];
        
        transaction {
            lowerMember
                .setSortId(-2)
                .save();
            
            actualMember
                .setSortId(actualSortId + 1)
                .save();
            
            lowerMember
                .setSortId(actualSortId)
                .save();
            
            transactionCommit();
        }
        
        return true;
    }
}