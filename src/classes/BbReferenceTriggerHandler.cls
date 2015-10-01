/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardReferenceTriggerHandler
    @abstract       handles all the logic for triggers on Reference
    @since          2011.0915
    @discussion     Class to execute Reference triggers logic
*/
public with sharing class BbReferenceTriggerHandler {
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbReferenceTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Bb_References__c[] newReferences){
        prepopulatesReferenceTypeOfSchool(newReferences);
        preventReferenceDuplicate(newReferences);
    }
    
    public void OnAfterInsert(Bb_References__c[] newReferences, Map<ID, Bb_References__c > insertedReferenceMap){
        
    }
        
    public void OnBeforeUpdate(Bb_References__c[] oldReferences, Bb_References__c[] updatedReferences, Map<ID, Bb_References__c > oldReferenceMap, Map<ID, Bb_References__c > updatedReferenceMap){
        preventReferenceProductKeyFieldsEdit(oldReferences,updatedReferences,oldReferenceMap,updatedReferenceMap);
    }
    
    public void OnAfterUpdate(Bb_References__c[] oldReferences, Bb_References__c[] updatedReferences, Map<ID, Bb_References__c > oldReferenceMap, Map<ID, Bb_References__c > updatedReferenceMap){
        updatesAccountTypeOfSchool(oldReferences,updatedReferences,oldReferenceMap,updatedReferenceMap);
    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------
    
    
    
    //Pre-populates field Type_of_School__c on Reference
    private void prepopulatesReferenceTypeOfSchool(Bb_References__c[] newReferences) {
        Set<Id> newReferenceAccountIds = new Set<Id>();
        
        for(Bb_References__c reference : newReferences)
        {
           if(reference.Account__c != null) newReferenceAccountIds.add(reference.Account__c);
        }

        if(newReferenceAccountIds.size() > 0)
        {
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, Type_of_School__c FROM Account WHERE Id IN :newReferenceAccountIds]);

            for (Bb_References__c reference : newReferences) if(reference.Account__c != null && accountMap.get(reference.Account__c) != null) reference.Type_of_School__c = accountMap.get(reference.Account__c).Type_of_School__c;
        }
    }

    //Updates field Type_of_School__c on Account
    private void updatesAccountTypeOfSchool(Bb_References__c[] oldReferences, Bb_References__c[] updatedReferences, Map<ID, Bb_References__c > oldReferenceMap, Map<ID, Bb_References__c > updatedReferenceMap) {
        Set<Id> newReferenceAccountIds = new Set<Id>();
        
        for(Bb_References__c reference : updatedReferences)
        {
           if(reference.Account__c != null && updatedReferenceMap.get(reference.Id).Type_of_School__c != oldReferenceMap.get(reference.Id).Type_of_School__c) newReferenceAccountIds.add(reference.Account__c);
        }

        if(newReferenceAccountIds.size() > 0)
        {
            Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, Type_of_School__c FROM Account WHERE Id IN :newReferenceAccountIds]);

            for (Bb_References__c reference : updatedReferences) if(reference.Account__c != null && accountMap.get(reference.Account__c) != null) accountMap.get(reference.Account__c).Type_of_School__c = reference.Type_of_School__c;
            
            update accountMap.values();
        }
    }


    //Prevents from creating duplicate References
    private void preventReferenceDuplicate(Bb_References__c[] newReferences){

        Set<Id> newReferenceAccountIds = new Set<Id>();
        Set<Id> recordTypeIds = new Set<Id>();
        
        for(Bb_References__c reference : newReferences)
        {
           if(reference.Account__c != null) newReferenceAccountIds.add(reference.Account__c);
        }

        if(newReferenceAccountIds.size() > 0)
        {
            List<Bb_References__c> references = new List<Bb_References__c>([SELECT Id, Account__c, RecordTypeId FROM Bb_References__c WHERE Account__c IN :newReferenceAccountIds]);

            Set<String> existingReferences = new Set<String>();

            for (Bb_References__c reference : newReferences)
            {
                for(Bb_References__c r : references)
                {
                    if(reference.Account__c == r.Account__c &&  reference.RecordTypeId == r.RecordTypeId)
                    {
                        existingReferences.add(String.valueOf(r.Account__c) + String.valueOf(r.RecordTypeId));
                        recordTypeIds.add(r.RecordTypeId);
                    }
                }
            }
            
            Map<Id,RecordType> recordTypeMap = new Map<Id,RecordType>([Select Name FROM RecordType WHERE Id IN :recordTypeIds]);
            for (Bb_References__c reference : newReferences)
            {
                if(existingReferences.contains(String.valueOf(reference.Account__c) + String.valueOf(reference.RecordTypeId))) reference.addError('There is already a Reference object for ' + recordTypeMap.get(reference.RecordTypeId).Name + ' for this Account');
            } 
        }
    }
    
    //Prevents from updated key fields that could result in duplicate References
    private void preventReferenceProductKeyFieldsEdit(Bb_References__c[] oldReferences, Bb_References__c[] updatedReferences, Map<ID, Bb_References__c > oldReferenceMap, Map<ID, Bb_References__c > updatedReferenceMap){
        for (Bb_References__c reference : updatedReferences)
        {
            if(updatedReferenceMap.get(reference.Id).Account__c != oldReferenceMap.get(reference.Id).Account__c) reference.Account__c.addError('You cannot change the Account of this Reference');
            if(updatedReferenceMap.get(reference.Id).RecordTypeId != oldReferenceMap.get(reference.Id).RecordTypeId) reference.addError('You cannot change the Record Type of this Reference');
        
        }
    }
}