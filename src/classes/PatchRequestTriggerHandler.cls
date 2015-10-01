public with sharing class PatchRequestTriggerHandler
{

    public PatchRequestTriggerHandler(){
    
    }
    
    public void afterInsert(list<Patch_Request__c> newList){
        Email__c em = null;
        List<Email__c> emaillist = null;
        string userid;
        List<GroupMember> queueUsers=[Select UserOrGroupId, GroupId FROM GroupMember];
        string queueGroupId;
              
       //List<Patch_Request__c> plist = new List<Patch_Request__c>();
        set<Id> prSupportIncidentIdset = new set<Id>();
        for(Patch_Request__c ptch: newList){
            prSupportIncidentIdset.add(ptch.Support_Incident__c);
        }
    
       //List<Case> clist = new List<Case>();
        Map<ID, List<Case>> casemap = new Map<ID, List<Case>>();
        set<Id> CaseOwnerIdSet = new set<Id>();
        for(Case c: [Select LearnJIRA_SI__c, LearnJIRA_SI__r.Name, OwnerId, CaseNumber from Case where LearnJIRA_SI__c IN: prSupportIncidentIdset ]){
            CaseOwnerIdSet.add(c.OwnerId);
            List<Case> tempList = new List<Case>();
           
            if(caseMap.containsKey(c.LearnJIRA_SI__c))
            {
                //Fetch the list of case and add the new case in it
                tempList = caseMap.get(c.LearnJIRA_SI__c) ;
                tempList.add(c);
                //Putting the refreshed case list in map
                casemap.put(c.LearnJIRA_SI__c, tempList) ;
            }
            else
            {
                //Creating a list of case and outting it in map
                caseMap.put(c.LearnJIRA_SI__c, new List<Case>{c}) ;
            }
        }
        
        for(Patch_Request__c pr: newList){
        
            if(casemap.containsKey(pr.Support_Incident__c)){
                
                 List<Case> allCases = casemap.get(pr.Support_Incident__c);
                 emaillist = new List<Email__c>();
                 for(Case cs : allCases){
                 //string userid;
                 userid = cs.OwnerId;
                 if(userid != null && userid.startswith('005')){
                 em = new Email__c();
                 em.Subject__c = 'New Patch Notification';
                 em.Body__c  = 'Your case ' + cs.CaseNumber + ', attached to the support incident ' + cs.LearnJIRA_SI__r.Name + ' has a new Codeline Patch being developed. The Codeline Patch is for version ' + pr.Name + ' and currently has a status of ' + pr.Status__c +'.' ;
                 em.User__c = cs.OwnerId;
                 emaillist.add(em);
                 }
                   
                 //queueGroupId= [Select Id from Group where type='Queue' and id= :userid].Id;
                 //List<GroupMember> queueUsers=[Select UserOrGroupId FROM GroupMember WHERE GroupId =:queueGroupId];
                                 
                 if(!userid.startswith('005')){
//                   List<GroupMember> queueUsers = getLists(userid);
                     for (GroupMember u:queueUsers){
                     if(u.GroupId==userid)
                     {
                     em = new Email__c();
                     em.Subject__c = 'New Patch Notification';
                     em.Body__c  = 'Your case ' + cs.CaseNumber + ', attached to the support incident ' + cs.LearnJIRA_SI__r.Name + ' has a new Codeline Patch being developed. The Codeline Patch is for version ' + pr.Name + ' and currently has a status of ' + pr.Status__c +'.' ;
                     em.User__c = u.UserOrGroupId;
                     emaillist.add(em);
                     }
                     }     
                 }
                 }
                 
                 
            }
                
       
       }
       insert emaillist;
    }
/*    public List<GroupMember> getLists(String ids){
    queueGroupId= [Select Id from Group where type='Queue' and id= :userid].Id;
    List<GroupMember> queueUsers=[Select UserOrGroupId FROM GroupMember WHERE GroupId =:queueGroupId];
    return queueUsers;
    
    }*/
     public static testMethod void testHandler(){
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
        Test.startTest();           
            learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
            insert lj;
            Case c2 = TestMethodUtility.createCase(con, cl, a, m);
            c2.LearnJIRA_SI__c = lj.Id;
            insert c2;
            update lj;
            Patch_Request__c ptch = TestMethodUtility.createPatchRequest(lj);
            insert ptch; 
        Test.stopTest();
     
     }
}