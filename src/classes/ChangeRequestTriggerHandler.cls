public with sharing class ChangeRequestTriggerHandler 
{
    public static Boolean hasTriggerRun = false;
    
    public ChangeRequestTriggerHandler()
    {
        hasTriggerRun = true;
    }
    
    public void beforeInsert(list<Change_Request__c> newList)
    {
        for (Change_Request__c cr : newList)
        {
            cr.Status__c = 'Pending Approval';
        }
    }
    
    public void afterInsert(list<Change_Request__c> newList)
    {
        set<Id> salesforceObjectIds = new set<Id>();
        list<CR_Decision__c> newApprovers = new list<CR_Decision__c>();
        list<CR_Approver_Group__c> groups = [Select Id, Name From CR_Approver_Group__c];
        list<Salesforce_Object_Approver__c> approvers = [Select Id, CR_Approver_Group__c, Salesforce_Object__c
                                                         From Salesforce_Object_Approver__c];
        
        for (Salesforce_Object_Approver__c soa : approvers)
        {
            for (Change_Request__c cr : newList)
            {
                if (cr.Salesforce_Object__c == soa.Salesforce_Object__c)
                {
                    newApprovers.add(new CR_Decision__c(Change_Request__c = cr.Id, 
                        CR_Approver_Group__c = soa.CR_Approver_Group__c));
                }
            }
        }
        
        for (Change_Request__c cr : newList)
        {
            if (cr.Salesforce_Object__c == null)
            {
                for (CR_Approver_Group__c crag : groups)
                {
                    newApprovers.add(new CR_Decision__c(Change_Request__c = cr.Id, 
                        CR_Approver_Group__c = crag.Id));
                }
            }
        }
        
        if (newApprovers != null && !newApprovers.isEmpty())
        {
            try
            {
                insert newApprovers;
            }
            catch (Exception e)
            {
                system.debug('Change Request Approver Insert Failed!');
            }
        }
    }
    
    public void beforeUpdate(list<Change_Request__c> newList, list<Change_Request__c> oldList)
    {
        map<Id, list<CR_Decision__c>> requestDecisionMap = new map<Id, list<CR_Decision__c>>();
        set<Id> changeRequestIds = new set<Id>();
        
        for (Change_Request__c cr : newList)
        {
            if (cr.Id != null)
            {
                changeRequestIds.add(cr.Id);
            }
        }
        
        for (CR_Decision__c cd : [Select Id, Status__c, CR_Approver_Group__c, CR_Approver_Group__r.Name, Change_Request__c
                                  From CR_Decision__c 
                                  Where Change_Request__c IN : changeRequestIds])
        {
            if (cd.Change_Request__c != null)
            {
                if (requestDecisionMap.containsKey(cd.Change_Request__c))
                {
                    requestDecisionMap.get(cd.Change_Request__c).add(cd);
                }
                else
                {
                    requestDecisionMap.put(cd.Change_Request__c, new CR_Decision__c[]{cd});
                }
            }
        }
        
        Integer completedDecisions;
        Boolean isRejected;
        
        for (Change_Request__c cr : newList)
        {
            if (requestDecisionMap.containsKey(cr.Id))
            {
                completedDecisions = 0;
                isRejected = false;
                
                for (CR_Decision__c cd : requestDecisionMap.get(cr.Id))
                {
                    if (cd.Status__c == 'Rejected')
                    {
                        cr.Status__c = 'Rejected By ' + cd.CR_Approver_Group__r.Name;
                        isRejected = true;
                        break;
                    }
                    else if (cd.Status__c != null && !cd.Status__c.contains('Pending'))
                    {
                        completedDecisions++;
                    }
                }
                
                if (!isRejected)
                {
                    if (completedDecisions == requestDecisionMap.get(cr.Id).size())
                    {
                        cr.Status__c = 'Approved';
                    }
                    else
                    {
                        cr.Status__c = 'Pending Approval (' + completedDecisions + ' of ' + requestDecisionMap.get(cr.Id).size() + ')';
                    }
                }
            }
        }
    }
    
    public static testMethod void testHandler()
    {
        Salesforce_Object__c s = new Salesforce_Object__c();
        s.Name = 'Test';
        insert s;
        
        CR_Approver_Group__c g = new CR_Approver_Group__c();
        g.Name = 'Test';
        insert g;
        
        Salesforce_Object_Approver__c sa = new Salesforce_Object_Approver__c();
        sa.CR_Approver_Group__c = g.Id;
        sa.Salesforce_Object__c = s.Id;
        insert sa;
        
        Change_Request__c cr = new Change_Request__c();
        //cr.Attribute__c = 'Trigger';
        cr.Summary__c = 'Test';
        cr.Impact__c = '1';
        cr.Urgency__c = '2';
        //cr.Name = 'Test';
        cr.Status__c = 'Test';
        cr.Salesforce_Object__c = s.Id;
        insert cr;
    }
}