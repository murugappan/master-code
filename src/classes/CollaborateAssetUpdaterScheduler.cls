global class CollaborateAssetUpdaterScheduler implements Schedulable{
    global void execute(SchedulableContext sc) {
        /* commenting out 
        Map<Id,Asset> assets = new Map<Id,Asset>([SELECT Id FROM Asset WHERE Status NOT IN ('Obsolete', '') AND Instance_URL__c != null AND Product2.Product_Category__c IN ('Wimba Classroom','Wimba Voice') AND Type__c = 'ASP']);
        CollaborateAssetUpdater.main(new List<Id>(assets.keySet())); 
        commenting out */      
    }
}