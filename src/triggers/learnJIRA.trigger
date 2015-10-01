trigger learnJIRA on learnJIRA__c (after insert, after update,  before insert, before update) 
{
    user currentuser= [select id, Integration_User__c from User where id = :UserInfo.getUserId() limit 1];
   
   if(currentuser.Integration_User__c != true)
   { 
    LearnJIRATriggerHandler handler = new LearnJIRATriggerHandler();
    
    // Before Triggers
    if (trigger.isBefore)
    {
        // Before Insert
        if (trigger.isInsert)
        {
            handler.beforeInsert(trigger.new);
        }
        // Before Update
        else if (trigger.isUpdate)
        {
            handler.beforeUpdate(trigger.new, trigger.old);
        }
    }
    // After Triggers
    else
    {
        // After Insert
        if (trigger.isInsert)
        {
            handler.afterInsert(trigger.new);
        }
        // After Update
        else if (trigger.isUpdate)
        {
            handler.afterUpdate(trigger.new, trigger.old);
        }
    
  }
  }
}