component {
    remote struct function getList() {
        var userListCtrl = createObject("component", "API.com.Nephthys.controller.user.userList").init();
        
        var userArray = userListCtrl.getList();
        
        var data = [];
        
        for(var i = 1; i <= userArray.len(); i++) {
            data.append({
                    'userId'   = userArray[i].getUserId(),
                    'username' = userArray[i].getUserName(),
                    'email'    = userArray[i].getEmail(),
                    'active'   = userArray[i].getActiveStatus()/*,
                    'actions' = [
                        'activeStatus' = true,
                        'permissions'  = false
                    ]*/
                });
        }
        
        return {
            'success' = true,
            'data'    = data
        };
    }
    
    remote struct function getDetails(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        
        return {
            'success' = true,
            'data' = prepareDetailStruct(user)
        };
    }
    
    remote struct function save(required numeric userId,
                                required string  userName,
                                required string  eMail,
                                required numeric active,
                                required string  password) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        
        if(arguments.userId == 0) {
            user.setUsername(arguments.userName);
        }
        
        user.setEmail(arguments.eMail)
            .setActiveStatus(arguments.active);
        
        if(trim(arguments.password) != "") {
            user.setPassword(encrypt(arguments.password,
                                     application.system.settings.getEncryptionKey(),
                                     application.system.settings.getEncryptionAlgorithm()));
        }
        
        user.save();
        
        return {
            'success' = true,
            'data'    = prepareDetailStruct(createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId))
        };
    }
    
    remote struct function delete(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        fileDelete(expandPath("/upload/com.Nephthys.user/avatar/") & user.getAvatarFilename());
        user.delete();
        
        return {
            'success' = true
        };
    }
    
    remote struct function activate(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        user.setActiveStatus(1)
            .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function deactivate(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        user.setActiveStatus(0)
            .save();
        
        return {
            'success' = true
        };
    }
    
    remote struct function getPermissions(required numeric userId) {
        return {
            'success' = true
        };
    }
    
    remote struct function getPermissionList() {
        return {
            'success' = true,
            'permissions' = [
                {
                    'id'   = 1,
                    'name' = 'userEdit',
                    'roles' = [
                        {
                            'id' = 1,
                            'name' = 'Reader'
                        },
                        {
                            'id' = 2,
                            'name' = 'Editor'
                        }
                    ]
                },
                {
                    'id'   = 2,
                    'name' = 'permissionEdit',
                    'roles' = [
                        {
                            'id' = 1,
                            'name' = 'Reader'
                        },
                        {
                            'id' = 2,
                            'name' = 'Editor'
                        }
                    ]
                },
                {
                    'id'   = 3,
                    'name' = 'moduleEdit',
                    'roles' = [
                        {
                            'id' = 1,
                            'name' = 'Reader'
                        },
                        {
                            'id' = 2,
                            'name' = 'Editor'
                        }
                    ]
                }
            ]
        };
    }
    
    remote struct function uploadAvatar(required numeric userId) {
        var user = createObject("component", "API.com.Nephthys.classes.user.user").init(arguments.userId);
        
        if(user.getUserId() == request.user.getUserId()) {
            user.uploadAvatar()
                .save();
            
            return {
                'success' = true,
                'avatar'  = "/upload/com.Nephthys.user/avatar/" & user.getAvatarFilename()
            };
        }
        
        throw(type = "nephthys.permission.notAuthorized", message = "It's only allowed to upload an avatar for yourself");
    }
    
    // P R I V A T E   M E T H O D S
    
    private struct function prepareDetailStruct(required user userObject) {
        return {
            'userId'     = arguments.userObject.getUserId(),
            'username'   = arguments.userObject.getUserName(),
            'email'      = arguments.userObject.getEmail(),
            'active'     = toString(arguments.userObject.getActiveStatus()),
            'password'   = '      ',
            'avatar'     = "/upload/com.Nephthys.user/avatar/" & arguments.userObject.getAvatarFilename(),
            'actualUser' = arguments.userObject.getUserId() == request.user.getUserId()
        };
    }
}