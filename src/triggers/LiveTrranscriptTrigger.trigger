trigger LiveTrranscriptTrigger on LiveChatTranscript (before insert,after insert) {
    LiveTranscriptTriggerHandler handler= new LiveTranscriptTriggerHandler();
    if(Trigger.isbefore)
    {
        if(Trigger.isinsert)
        {
            handler.beforeInsert(Trigger.newmap,Trigger.new);
        }
    }
    
    
    if(Trigger.isafter)
    {
        if(Trigger.isinsert)
        {
            handler.afterInsert(Trigger.newmap);
            
        }
    }
    
}