/* - JLAL - 10/22/2010 - Altiris:162361                                 */ 
/* Update 2010-10-25 - Additional fields to populate on Account Header  */
trigger bb_update_account_learn_rep on Bb_Account_Team_Role__c (before insert, before update) 
{   

    
    /* --------------------------------------------------------------------
    
    Role_Code__c    Account Field
    ------------    -----------------
            D       PSFT_Transact_RSM__c 
            G       PSFT_Transact_RAE__c
            6       PSFT_Transact_CM__c
            C       PSFT_Learn_RSM__c
                    PSFT_Learn_CM__c
            3       PSFT_Learn_Account_Rep__c
    -------------------------------------------------------------------- */

            
    // Create an empty array of Account Ids
    Set<Id> account_list = new Set<Id>();
    

    for(Bb_Account_Team_Role__c role:Trigger.new )
    {
        if ( role.Account__c != null)
        {
            String c = role.Role_Code__c;
            
            // qualified role types (only some roles go to header)
            if( c == 'D' || c == 'G' || c == '6' || c == 'C'/* || c == '3' */)
            {
                
                account_list.add(role.Account__c);
            }       
        }       
    }
    
    // no null pointers
    if(account_list.size() > 0)
    {
        Map<Id,Account> accounts = new Map<Id,Account>([SELECT Id, PSFT_Transact_RSM__c,PSFT_Transact_RAE__c,PSFT_Transact_CM__c,PSFT_Learn_RSM__c,PSFT_Learn_Account_Rep__c FROM Account WHERE Id in :account_list Limit 5000]);
        

        for(Bb_Account_Team_Role__c role:Trigger.new )
        {
            String m = role.Member__c;
            String c = role.Role_Code__c;
            
            if ( c == 'D')  accounts.get(role.Account__c).PSFT_Transact_RSM__c = m;
            if ( c == 'G')  accounts.get(role.Account__c).PSFT_Transact_RAE__c = m;
            if ( c == '6')  accounts.get(role.Account__c).PSFT_Transact_CM__c = m;
            if ( c == 'C')  accounts.get(role.Account__c).PSFT_Learn_RSM__c = m;
            // Below line is  commented By Nikhil 
           // if ( c == '3')  accounts.get(role.Account__c).PSFT_Learn_Account_Rep__c = m;
        }
        
        update accounts.values();
    }

}