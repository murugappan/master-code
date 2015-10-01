/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestMaintenanceBatch
    @abstract       Unit Test for all maintenance code (Batch Apex and Scheduled Jobs)
    @since          2011.0715
    @discussion     Test Class for Batch Apex and Scheduled Jobs
*/
@isTest
private class TestMaintenanceBatch {

    static testMethod void accountProductsMaintenanceBatchTest(){
       
       // Instantiate the class implementing Database.Batchable interface. 
        AccountProductsMaintenanceBatch am = new AccountProductsMaintenanceBatch();

        //List of products
        List<Product2> Lpro = New List<Product2>();

        Product2 pro=TestMethodUtility.createProduct();
        pro.isActive = true;
        pro.Product_Category__c = 'Web Conferencing';
        Lpro.Add(pro);
        
        Product2 pro2=TestMethodUtility.createProduct();
        pro2.isActive = true;
        pro2.Product_Category__c = 'Voice Authoring';
        Lpro.Add(pro2);
        
        Product2 pro3=TestMethodUtility.createProduct();
        pro3.isActive = true;
        pro3.Product_Category__c = 'Enterprise IM';
        Lpro.Add(pro3);
        
        Product2 pro4=TestMethodUtility.createProduct();
        pro4.isActive = true;
        pro4.Product_Category__c = 'Wimba Create';
        Lpro.Add(pro4);
        
        insert Lpro;
        
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        
        //Create TEST Account with no Assets
        Account account1 = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account1;            
        System.assertNotEquals(account1.Id, null);            

        //Create TEST Account with Assets
        Account account2 = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'Canada', CMS_Type__c = 'Bb');
        insert account2;            
        System.assertNotEquals(account2.Id, null);       
        
        //List of Assets
        
        List<Asset> Lasset = new List<Asset>();
        
        Asset asset1=TestMethodUtility.createAsset(account2,cl);
        asset1.AccountId = account2.Id;
        asset1.Product2Id=pro.id;
        Lasset.Add(asset1);
        //insert assest1;
        
        Asset asset2=TestMethodUtility.createAsset(account2,cl);
        asset2.AccountId = account2.Id;
        asset2.Product2Id = pro2.id;
        Lasset.Add(asset2);
        //insert assest2;  
        
        //Asset asset1 = new Asset( AccountId = account2.Id, Name = 'Test Asset', CMS_Type__c = 'Bb', CMS_Version__c = '8.0', Version__c = '1.5', Type__c = 'ASP', Status = 'Installed and Verified');
        //asset1.Product2Id = [Select Id from Product2 where Product_Category__c = 'Web Conferencing' AND isActive = true limit 1 ].Id;
       
        //insert asset1;
        
        //Asset asset2 = new Asset( AccountId = account2.Id, Name = 'Test Asset', CMS_Type__c = 'Bb', CMS_Version__c = '8.0', Version__c = '1.5', Type__c = 'ASP', Status = 'Installed and Verified');
        //asset2.Product2Id = [Select Id from Product2 where Product_Category__c = 'Voice Authoring' AND isActive = true limit 1 ].Id;
        //asset2.Product2Id = pro2.id;
        //insert asset2;
        
        Asset asset3=TestMethodUtility.createAsset(account2,cl);
        asset3.AccountId = account2.Id;
        asset3.Product2Id = pro3.id;
        Lasset.Add(asset3);
        
       //Asset asset3 = new Asset( AccountId = account2.Id, Name = 'Test Asset', CMS_Type__c = 'Bb', CMS_Version__c = '8.0', Version__c = '1.5', Type__c = 'ASP', Status = 'Installed and Verified');
       //asset3.Product2Id = [Select Id from Product2 where Product_Category__c = 'Enterprise IM' AND isActive = true limit 1 ].Id;
       //asset3.Product2Id = pro3.id;
       //insert asset3;
       
       Asset asset4=TestMethodUtility.createAsset(account2,cl);
       asset4.AccountId = account2.Id;
       asset4.Product2Id = pro4.id;
       Lasset.Add(asset4);

        //Asset asset5 = new Asset( AccountId = account2.Id, Name = 'Test Asset', CMS_Type__c = 'Bb', CMS_Version__c = '8.0', Version__c = '1.5', Type__c = 'ASP', Status = 'Installed and Verified');
       //asset5.Product2Id = [Select Id from Product2 where Product_Category__c = 'Wimba Create' AND isActive = true limit 1 ].Id;
       //asset5.Product2Id = pro4.id;
       //insert asset5;
       Asset asset5=TestMethodUtility.createAsset(account2,cl);
       asset5.AccountId = account2.Id;
       asset5.Product2Id = pro.id;
       Lasset.Add(asset5);

        //Asset asset7 = new Asset( AccountId = account2.Id, Name = 'Test Asset', CMS_Type__c = 'Bb', CMS_Version__c = '8.0', Version__c = '1.5', Type__c = 'ASP', Status = 'Installed and Verified');
       //asset7.Product2Id = [Select Id from Product2 where Product_Category__c = 'Web Conferencing' AND isActive = true limit 1 ].Id;
        //asset7.Product2Id = pro.id;
        //insert asset7;
        insert Lasset;
        
        Test.startTest();
            am.query = 'SELECT Id, LastModifiedDate FROM Account WHERE Id IN (\'' + account1.Id + '\',\'' + account2.Id + '\') ORDER BY LastModifiedDate';
            ID batchprocessid = Database.executeBatch(am);
        Test.stopTest();
        
    }
}