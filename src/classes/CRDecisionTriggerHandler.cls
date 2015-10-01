public with sharing class CRDecisionTriggerHandler 
{
    public static Boolean hasTriggerRun = false;
    
    public CRDecisionTriggerHandler()
    {
        hasTriggerRun = true;
    }
    
    public void beforeInsert(list<CR_Decision__c> newList)
    {
        
    }
    
    public void afterInsert(list<CR_Decision__c> newList)
    {
        list<CR_Approver_Group_Member__c> approverList = new list<CR_Approver_Group_Member__c>();
        list<CR_Approver_Group_Member__c> memberList = new list<CR_Approver_Group_Member__c>();
        list<CR_Decision_Email__c> emailList = new list<CR_Decision_Email__c>();
        set<Id> groupIds = new set<Id>();
        set<Id> changeRequestIds = new set<Id>();
        String emailSubject, emailBody;
        String instanceURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        for (CR_Decision__c cd : newList)
        {
            if (cd.CR_Approver_Group__c != null)
            {
                groupIds.add(cd.CR_Approver_Group__c);
            }
            if (cd.Change_Request__c != null)
            {
                changeRequestIds.add(cd.Change_Request__c);
            }
        }
        
        map<Id, Change_Request__c> changeRequestMap = new map<Id, Change_Request__c>([Select Id, Name, CreatedById, CreatedBy.Name, Summary__c, Description__c From Change_Request__c Where Id IN : changeRequestIds]);
        
        for (CR_Approver_Group_Member__c cagm : [Select Id, User__c, User__r.Name, Type__c, CR_Approver_Group__c, CR_Approver_Group__r.Name
                                                 From CR_Approver_Group_Member__c 
                                                 Where CR_Approver_Group__c IN : groupIds])
        {
            if (cagm.Type__c != null)
            {
                if (cagm.Type__c.contains('Approver'))
                {
                    approverList.add(cagm);
                }
                else
                {
                    memberList.add(cagm);
                }
            }
        }
        
        Change_Request__c changeRequest;
        // Task: create a list of follows to add each chatter follow
        List<EntitySubscription> followerslist = new List<EntitySubscription>();

       for (CR_Decision__c cd : newList)
        {
            for (CR_Approver_Group_Member__c cagm : approverList)
            {
                if (cd.CR_Approver_Group__c == cagm.CR_Approver_Group__c && changeRequestMap != null && changeRequestMap.containsKey(cd.Change_Request__c))
                {
                    changeRequest = changeRequestMap.get(cd.Change_Request__c);
                    //emailSubject = 'SFDC CM: ' + changeRequest.Name + ' has been submitted';
                    emailSubject = 'SFDC CM: New Request ' + changeRequest.Name + ' has been submitted by ' + changeRequest.CreatedBy.Name;
                    emailBody = 'Hello ' + cagm.User__r.Name + ',<br /><br />' + 
                        changeRequest.CreatedBy.Name + ' has submitted a request that requires approval from your group. ' + 
                        'Please follow the link below to view request details and approve/reject their request.<br /><br />' + '** ACTION BY YOU IS REQUIRED BECAUSE YOU ARE MARKED AS APPROVER **<br/><br/>' + 
                        'Request Name: ' + changeRequest.Name + '<br />Summary: ' + changeRequest.Summary__c + '<br />Link: ' + 
                        '<a href="' + instanceURL + '/' + cd.Change_Request__c + '">' + instanceURL + '/' + cd.Change_Request__c + '</a><br /><br />Thank you,<br /><br />' + 
                        'SFDC Change Management Team';
                    emailList.add(new CR_Decision_Email__c(User__c = cagm.User__c, Subject__c = emailSubject, Body__c = emailBody));
                    // Task: Add a chatter follow for the variable changeRequest.Id to be followed by the vairable cagm.User__c
                
                    EntitySubscription follow = new EntitySubscription(parentId = changeRequest.Id,subscriberid = cagm.User__c); 
                    followerslist.add(follow);
                               
                 }
            }
            
            for (CR_Approver_Group_Member__c cagm : memberList)
            {
                if (cd.CR_Approver_Group__c == cagm.CR_Approver_Group__c && changeRequestMap != null && changeRequestMap.containsKey(cd.Change_Request__c))
                {
                    changeRequest = changeRequestMap.get(cd.Change_Request__c);
                    //emailSubject = 'SFDC CM: ' + changeRequest.Name + ' has been submitted';
                    emailSubject = 'SFDC CM: New Request ' + changeRequest.Name + ' has been submitted by ' + changeRequest.CreatedBy.Name;
                    emailBody = 'Hello ' + cagm.User__r.Name + ',<br /><br />' + 
                        changeRequest.CreatedBy.Name + ' has submitted a request that requires approval from your group. ' + 
                        'has submitted a request that requires approval from your group. The Primary Approvers in your team ' + 
                        'have been notified and asked to approve/reject this request. You can follow the link below to view request details..<br /><br />' + 
                        'Request Name: ' + changeRequest.Name + '<br />Summary: ' + changeRequest.Summary__c + '<br />Link: ' + 
                        '<a href="' + instanceURL + '/' + cd.Change_Request__c + '">' + instanceURL + '/' + cd.Change_Request__c + '</a><br /><br />Thank you,<br /><br />' + 
                        'SFDC Change Management Team';
                    emailList.add(new CR_Decision_Email__c(User__c = cagm.User__c, Subject__c = emailSubject, Body__c = emailBody));
                    // Task: Add a chatter follow for the variable changeRequest.Id to be followed by the vairable cagm.User__c
                    EntitySubscription follow = new EntitySubscription(parentId = changeRequest.Id,subscriberid = cagm.User__c); 
                    followerslist.add(follow);
                }
            }
        }
        
        // Task: insert follow list from above, use code below for email list as a guide
        if (!followersList.isEmpty())
        {
            try
            {
                database.insert(followersList,false);
            }
            catch (Exception e)
            {
                system.debug('Chatter Folower Insert Failed!');
            }
        }
        
        if (!emailList.isEmpty())
        {
            try
            {
                insert emailList;
            }
            catch (Exception e)
            {
                system.debug('CR Decision Email Insert Failed!');
            }
        }
    }
    
    public void beforeUpdate(list<CR_Decision__c> newList, list<CR_Decision__c> oldList)
    {
        map<Id, CR_Decision__c> oldMap = createMap(oldList);
        
        for (CR_Decision__c cd : newList)
        {
            
        }
    }
    
    public void afterUpdate(list<CR_Decision__c> newList, list<CR_Decision__c> oldList)
    {
        map<Id, CR_Decision__c> oldMap = createMap(oldList);
        list<Change_Request__c> requestUpdateList = new list<Change_Request__c>();
        
        for (CR_Decision__c cd : newList)
        {
            if (oldMap.containsKey(cd.Id) && cd.Change_Request__c != null && oldMap.get(cd.Id).Status__c != cd.Status__c)
            {
                requestUpdateList.add(new Change_Request__c(Id = cd.Change_Request__c));
            }
        }
        
        if (!requestUpdateList.isEmpty())
        {
            try
            {
                update requestUpdateList;
            }
            catch (Exception e)
            {
                system.debug('Change Request Update Failed!');
            }
        }
    }
    
    private map<Id, CR_Decision__c> createMap(list<CR_Decision__c> sObjectList)
    {
        map<Id, CR_Decision__c> sObjectMap = new map<Id, CR_Decision__c>();
        
        if (sObjectList != null && !sObjectList.isEmpty())
        {
            for (CR_Decision__c s : sObjectList)
            {
                if (s.Id != null)
                {
                    sObjectMap.put(s.Id, s);
                }
            }
        }
        
        return sObjectMap;
    }
}