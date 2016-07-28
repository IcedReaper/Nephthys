component {
    import "API.modules.com.IcedReaper.teamOverview.*";
    
    remote array function getMember() {
        var filterCtrl = new filter().for("member");
        var formatCtrl = application.system.settings.getValueOfKey("formatLibrary");

        var members = [];
        for(var member in filterCtrl.execute().getResult()) {
            members.append({
                memberId = member.getMemberId(),
                userId   = member.getUser().getUserId(),
                userName = member.getUser().getUserName(),
                addDate  = formatCtrl.formatDate(member.getCreationDate())
            });
        }
        return members;
    }
    
    remote array function getRemainingUser() {
        var filterCtrl = new filter().for("user");
        
        var noMember = [];
        for(var user in filterCtrl.execute().getResult()) {
            noMember.append({
                userId   = user.getUserId(),
                userName = user.getUserName()
            });
        }
        return noMember;
    }
    
    remote numeric function addUser(required numeric userId) {
        new member(0)
            .setUserId(arguments.userId)
            .save(request.user);
        
        return true;
    }
    
    remote boolean function removeUser(required numeric userId) {
        var filterCtrl = new filter().for("member");
        var member = filterCtrl.setUserId(arguments.userId).execute().getResult();
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
            .delete(request.user);
        
        return true;
    }
    
    remote boolean function sortUp(required numeric memberId) {
        var actualMember = new member(arguments.memberId);
        
        var actualSortId = actualMember.getSortId();
        
        var filterCtrl = new filter().for("member");
        var higherMember = filterCtrl.setSortId(actualSortId - 1).execute().getResult()[1];
        
        transaction {
            // first we need to set the sortId to an unused space, as we would otherwise get an unique key error
            higherMember
                .setSortId(-1)
                .save(request.user);
            
            actualMember
                .setSortId(actualSortId - 1)
                .save(request.user);
            
            higherMember
                .setSortId(actualSortId)
                .save(request.user);
            
            transactionCommit();
        }
        
        return true;
    }
    
    remote boolean function sortDown(required numeric memberId) {
        var actualMember = new member(arguments.memberId);
        
        var actualSortId = actualMember.getSortId();
        
        var filterCtrl = new filter().for("member");
        var lowerMember = filterCtrl.setSortId(actualSortId + 1).execute().getResult()[1];
        
        transaction {
            lowerMember
                .setSortId(-2)
                .save(request.user);
            
            actualMember
                .setSortId(actualSortId + 1)
                .save(request.user);
            
            lowerMember
                .setSortId(actualSortId)
                .save(request.user);
            
            transactionCommit();
        }
        
        return true;
    }
}