trigger userDuplicatePreventer on User
                               (before insert, before update) {

    Map<String, User> userMap = new Map<String, User>();
    for (User user : System.Trigger.new) {
        
        // Make sure we don't treat an email address that  
    
        // isn't changing during an update as a duplicate.  
    
        if ((user.Email != null) &&
                (System.Trigger.isInsert ||
                (user.Email != 
                    System.Trigger.oldMap.get(user.Id).Email))) {
        
            // Make sure another new user isn't also a duplicate  
    
            if (userMap.containsKey(user.Email)) {
                user.Email.addError('Another new user has the '
                                    + 'same email address.');
            } else {
                userMap.put(user.Email, user);
            }
       }
    }
    
    // Using a single database query, find all the users in  
    
    // the database that have the same email address as any  
    
    // of the users being inserted or updated.  
    
    for (User user : [SELECT Email FROM User
                      WHERE Email IN :userMap.KeySet()]) {
        User newUser = userMap.get(user.Email);
        newUser.Email.addError('A user with this email '
                               + 'address already exists.');
    }
}