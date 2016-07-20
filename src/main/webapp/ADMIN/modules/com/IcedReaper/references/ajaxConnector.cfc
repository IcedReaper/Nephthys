component {
    import "API.modules.com.IcedReaper.references.*";
    
    formatCtrl = application.system.settings.getValueOfKey("formatLibrary");
    
    remote array function getList() {
        var referenceFilter = new filter().setFor("reference").execute();
        
        var references = [];
        for(var reference in referenceFilter.getResult()) {
            references.append({
                referenceId = reference.getReferenceId(),
                name        = reference.getName(),
                since       = formatCtrl.formatDate(reference.getSince(), false),
                quote       = reference.getQuote(),
                homepage    = reference.getHomepage(),
                imagePath   = reference.getImagePath(),
                
                creator = {
                    name   = reference.getCreator().getUsername(),
                    userId = reference.getCreator().getUserId(),
                    avatar = reference.getCreator().getAvatarPath()
                },
                creationDate = formatCtrl.formatDate(reference.getCreationDate()),
                lastEditor = {
                    name   = reference.getLastEditor().getUsername(),
                    userId = reference.getLastEditor().getUserId(),
                    avatar = reference.getLastEditor().getAvatarPath()
                },
                lastEditDate = formatCtrl.formatDate(reference.getLastEditDate())
            });
        }
        
        return references;
    }
    
    remote struct function getDetails(required numeric referenceId) {
        var reference = new reference(arguments.referenceId);
        
        return {
            referenceId = reference.getReferenceId(),
            name        = reference.getName(),
            since       = dateFormat(reference.getSince(), "YYYY/MM/DD"),
            quote       = reference.getQuote(),
            homepage    = reference.getHomepage(),
            imagePath   = reference.getImagePath(),
            
            creator = {
                name   = reference.getCreator().getUsername(),
                userId = reference.getCreator().getUserId(),
                avatar = reference.getCreator().getAvatarPath()
            },
            creationDate = formatCtrl.formatDate(reference.getCreationDate()),
            lastEditor = {
                name   = reference.getLastEditor().getUsername(),
                userId = reference.getLastEditor().getUserId(),
                avatar = reference.getLastEditor().getAvatarPath()
            },
            lastEditDate = formatCtrl.formatDate(reference.getLastEditDate())
        };
    }
    
    remote struct function save(numeric referenceId = null, required string name, required string link, required string quote, required string since) {
        var reference = new reference(arguments.referenceId);
        
        reference.setName(arguments.name)
                 .setHomepage(arguments.link) // homepage
                 .setQuote(arguments.quote)
                 .setSince(arguments.since)
                 .save();
        
        if(arguments.newImage != "") {
            reference.uploadNewImage()
                     .save();
        }
        
        return getDetails(reference.getReferenceId());
    }
}