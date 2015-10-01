trigger patchRequest on Patch_Request__c (after insert, after delete, after update) {

    PatchRequestTriggerHandler handler = new PatchRequestTriggerHandler();

    // Before Triggers
    if (trigger.isBefore)
    {
        
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
            
        }
        // After Delete
        else if (trigger.isDelete)
        {
           
        }
    }
}