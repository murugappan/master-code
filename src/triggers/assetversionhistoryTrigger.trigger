trigger assetversionhistoryTrigger on Asset_Version_History__c(before insert, before update, after insert, after update) {

BbAssetVersionHistoryTriggerHandler handler = new BbAssetVersionHistoryTriggerHandler();

if (trigger.isBefore)
    {
        // Before Update
        if (trigger.isInsert)
        {
            handler.OnBeforeInsert(trigger.new);
        }
    }
    
       else if(trigger.isInsert)
       {
           handler.OnafterInsert(trigger.new);
       }    
            



}