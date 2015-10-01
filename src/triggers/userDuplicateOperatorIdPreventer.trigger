trigger userDuplicateOperatorIdPreventer on User
                               (before insert, before update) {

    Map<String, User> userMap = new Map<String, User>();
    for (User user : System.Trigger.new) {
        
        // Make sure we don't treat an PSFT_Operator_ID__c that  
    
        // isn't changing during an update as a duplicate.  
    
        if ((user.PSFT_Operator_ID__c != null) &&
                (System.Trigger.isInsert ||
                (user.PSFT_Operator_ID__c != 
                    System.Trigger.oldMap.get(user.Id).PSFT_Operator_ID__c))) {
        
            // Make sure another new user isn't also a duplicate  
    
            if (userMap.containsKey(user.PSFT_Operator_ID__c)) {
                user.PSFT_Operator_ID__c.addError('Another new user has the '
                                    + 'same PSFT Operator Id.');
            } else {
                userMap.put(user.PSFT_Operator_ID__c, user);
            }
       }
    }
    
    // Using a single database query, find all the users in  
    
    // the database that have the same Peoplesoft Operator Id as any  
    
    // of the users being inserted or updated.  
    
    for (User user : [SELECT PSFT_Operator_ID__c FROM User
                      WHERE PSFT_Operator_ID__c IN :userMap.KeySet()]) {
        User newUser = userMap.get(user.PSFT_Operator_ID__c);
        newUser.PSFT_Operator_ID__c.addError('A user with this Operator Id '
                               + 'already exists.');
    }
}