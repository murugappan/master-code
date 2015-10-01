public with sharing class LearnJIRANoteTriggerHandler 
{
    public LearnJIRANoteTriggerHandler()
    {
        
    }
    
    public void afterInsert(list<learnJIRANote__c> ljnNew)
    {
        updateIsChanged(ljnNew);
    }
    
    public void afterUpdate(list<learnJIRANote__c> ljnNew, list<learnJIRANote__c> ljnOld)
    {
        updateIsChanged(ljnNew);
    }
    
    private void updateIsChanged(list<learnJIRANote__c> ljns)
    {
        set<Id> supportIncidentIds = new set<Id>();
        list<learnJIRA__c> supportIncidents = new list<learnJIRA__c>();
        
        for (learnJIRANote__c ljn : ljns)
        {
            if (ljn.Support_Incident__c != null)
            {
                supportIncidentIds.add(ljn.Support_Incident__c);
            }
        }
        
        for (learnJIRA__c lj : [Select Id, isChanged__c,RecordTypeId, RecordType.Name From learnJIRA__c Where Id IN : supportIncidentIds And isChanged__c != true])
        {
            if(lj.RecordType.Name == 'Learn' && !Userinfo.getusername().containsignorecase('pddireleads@blackboard.com')){
            lj.isChanged__c = true;
            supportIncidents.add(lj);
            }
            
        }
        
        try
        {
            update supportIncidents;
        }
        catch (DMLException e)
        {
            
        }
    }
    
    public static testMethod void testHandler()
    {
        Account a = TestMethodUtility.createAccount();
        insert a;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        
        Test.startTest();
            
            system.assert(lj.IsChanged__c == false);
            
            learnJIRANote__c ljn = TestMethodUtility.createSupportIncidentNote(lj);
            insert ljn;
            lj = [Select Id, IsChanged__c From learnJIRA__c Where Id =: lj.Id];
            //system.assert(lj.IsChanged__c == true);
            
            ljn = [Select Id, Created_By_Name__c From learnJIRANote__c Where Id =: ljn.Id];
            system.assert(ljn.Created_By_Name__c == UserInfo.getName());
            
            lj.isChanged__c = false;
            update lj;
            update ljn;
            lj = [Select Id, IsChanged__c From learnJIRA__c Where Id =: lj.Id];
            //system.assert(lj.IsChanged__c == true);
                    
        Test.stopTest();
    }
}