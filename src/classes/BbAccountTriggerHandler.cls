/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardAccountTriggerHandler
    @abstract       handles all the logic for triggers on Account
    @since          2011.0915
    @discussion     Class to execute Account triggers logic
*/
public with sharing class BbAccountTriggerHandler {
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbAccountTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Account[] newAccounts){
    	// Updated by Dominic Baker on November 2, 2012
        updateAccountFields(newAccounts);
    }
    
    public void OnAfterInsert(Account[] newAccounts, Map<ID, Account> insertedAccountMap){
        
    }
        
    public void OnBeforeUpdate(Account[] oldAccounts, Account[] updatedAccounts, Map<ID, Account> oldAccountMap, Map<ID, Account> updatedAccountMap){
        // Update by Dominic Baker on November 2, 2012
        updateAccountFields(updatedAccounts);
    }
    
    public void OnAfterUpdate(Account[] oldAccounts, Account[] updatedAccounts, Map<ID, Account> oldAccountMap, Map<ID, Account> updatedAccountMap){
        updateReferencesWhenTypeofSchoolIsUpdated(oldAccounts,updatedAccounts,oldAccountMap,updatedAccountMap);        
    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------    
    private void updateReferencesWhenTypeofSchoolIsUpdated(Account[] oldAccounts, Account[] updatedAccounts, Map<ID, Account> oldAccountMap, Map<ID, Account> updatedAccountMap) {

        List<Bb_References__c> referencesToUpdate = new List<Bb_References__c>();
    
        Set<Id> accountIds = new Set<Id>();
    
        for(Account account:updatedAccounts) 
        {
            if(updatedAccountMap.get(account.Id).Type_of_School__c != oldAccountMap.get(account.Id).Type_of_School__c) accountIds.add(account.Id);
        }
    
        if(accountIds.size() > 0)
        {         
            for(Account account : [SELECT Id, Type_of_School__c, (SELECT Id, Type_of_School__c FROM Bb_References__r) FROM Account WHERE Id IN :accountIds])
            {
                for (Bb_References__c reference: account.Bb_References__r)
                {
                    reference.Type_of_School__c = account.Type_of_School__c;
                    referencesToUpdate.add(reference);
                }
            }
            update referencesToUpdate;
        }
    }

 
    //Updates the Last Interaction fields on Account
    // Updated by Dominic Baker on November 2, 2012
    private void updateAccountFields(Account[] accounts) {
    
        // Bb API User Profile
        Id apiProfile = '00e70000000zlf8AAA';       
        
        for(Account account : accounts)
        {
            if(account.last_interaction_flag__c == False && UserInfo.getProfileId() != apiProfile)
            {
                account.last_interaction_dttm__c = System.now();
                account.last_interaction_flag__c = True;  
                account.last_interaction_user__c = UserInfo.getUserId();
            }
            if (account.Id == null)
            {
	            account.ShippingStreet = account.BillingStreet;
	            account.ShippingCity = account.BillingCity;
	            account.ShippingState = account.BillingState;
	            account.ShippingPostalCode = account.BillingPostalCode;
	            account.ShippingCountry = account.BillingCountry;
            }
        }
    }
}