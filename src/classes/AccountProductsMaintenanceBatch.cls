/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          AccountProductsMaintenanceBatch
    @abstract       updates Accounts with information about active products from Assets
    @since          2011.0715
    @discussion     Class to update Accounts with Collborate product information
*/

global class AccountProductsMaintenanceBatch implements Database.Batchable<sObject>{

    public String query = 'SELECT Id, LastModifiedDate FROM Account WHERE CustomerofCollaborate__c = True ORDER BY LastModifiedDate';

    // The start method is called at the beginning of a sharing recalculation. 
    // This methods returns a SOQL query locator containing the records to be recalculated.     
    // This method must be global. 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
   
   
    // The executeBatch method is called for each chunk of records returned from start.   
    // This method must be global. 
    global void execute(Database.BatchableContext BC, List<sObject> scope){
      
        for(sObject s: scope)
        {
            Account account = (Account)s;
            Set<String> products = new Set<String>();
            
            Asset[] assets= [SELECT Id, Product2.Product_Category__c, Product2.Name, PurchaseDate FROM Asset WHERE Psft_Product_Id__c = null AND AccountId = : account.Id AND Type__c != 'POC' AND Status in ('Installed and Verified','Delivered')];
            if (assets != null && assets.size() > 0)
            {
                for(Asset asset:assets)
                {
                    if(asset.Product2.Product_Category__c == 'Wimba Classroom')
                    {
                        if(asset.Product2.Name.indexOf('Express') > 0) products.add('Classroom Express');
                        else products.add('Classroom');
                    }
                    else if(asset.Product2.Product_Category__c == 'Voice Authoring')
                    {
                        if(asset.Product2.Name.indexOf('Express') > 0) products.add('Voice Express');
                        else products.add('Voice');
                    }
                    else if(asset.Product2.Product_Category__c == 'Web Conferencing') products.add('Web Conferencing');
                    else if(asset.Product2.Product_Category__c == 'Enterprise IM') products.add('Enterprise IM');
                    else if(asset.Product2.Product_Category__c == 'Enterprise IM Basic') products.add('Enterprise IM Basic');
                    else if(asset.Product2.Product_Category__c == 'Wimba Create') products.add('Create');
                    else if(asset.Product2.Product_Category__c == 'LearnCentral') products.add('LearnCentral');
                  //else if(asset.Product2.Product_Category__c == 'vSpaces') products.add('vSpaces');
                }
            }
            
            String result = '';
            for(String product:products)
            {
                result += product;
                result += ';';
            }
            if(result.endsWith(';')) result = result.substring(0,result.lastIndexOf(';'));
            account.Products__c = result;
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC){
    
       // Get the ID of the AsyncApexJob representing this batch job 
       // from Database.BatchableContext.         
       // Query the AsyncApexJob object to retrieve the current job's information. 
       AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
       
       // Send an email to the Apex job's submitter notifying of job completion. 
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {a.CreatedBy.Email};
       mail.setToAddresses(toAddresses);
       mail.setSubject('Batch Apex AccountProductsMaintenanceBatch ' + a.Status);
       mail.setPlainTextBody
       ('The batch Apex job processed ' + a.TotalJobItems +
       ' batches with '+ a.NumberOfErrors + ' failures.');
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}