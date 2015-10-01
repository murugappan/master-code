//Trigger on CPQ Cameleon QuoteContent (CPQ Cameleon QuoteContent has lookup to Cameleon Quote)
 Trigger CPQQuoteContentOnAfterUpdate on CameleonCPQ__QuoteContent__c (after update) {

    CPQQuoteMgr mgr = new CPQQuoteMgr();
    
    //All logic will excute in class, List and Map has been passed to class
     mgr.processAfterSyncUpdate(Trigger.New,Trigger.NewMap);
}