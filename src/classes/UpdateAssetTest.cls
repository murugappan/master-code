@istest
Private class UpdateAssetTest{

    static testMethod void myUnitTest(){
   
    Core_License__c test_corelicense = new Core_License__c(Name = 'Learn');
    insert test_corelicense;
    Account test_account = new Account(
          Name = 'TestClass University',
          BillingCity = 'Vienna',
          BillingCountry = 'US',
          BillingPostalCode = '22066',
          BillingState = 'VA',
          BillingStreet = '123 Miller Road',
          Learn_Queue__c = 'Learn Primary Group');
          insert test_account;
      Asset test_asset = new Asset(
      Name = 'TestAsset',
      Core_License__c = test_corelicense.id,
      Status = 'Installed',
      AccountId = test_account.id);
      insert test_asset; 
    Asset__c as1 = new Asset__c();
    as1.Asset_Name__c='testr';
    as1.Application_Server_OS__c='Linux 3';
    as1.Product_ID__c = test_asset.ID;
    as1.Nickname__c='hdjshd';
    as1.Asset_Name__c='Test';
    as1.account__c=test_account.id;
    UpdationAsset.insertFlag = false;
    insert as1;
    as1.Nickname__c='hdjshhd';
    UpdationAsset.updateFlag=false;
    update as1;
    updationAsset.deletionFlag=false;
    delete as1;
    Account test_account1 = new Account(
          Name = 'TestClass Universi',
          BillingCity = 'Vienna',
          BillingCountry = 'US',
          BillingPostalCode = '22066',
          BillingState = 'VA',
          BillingStreet = '123 Miller Road',
          Learn_Queue__c = 'Learn Primary Group');
          insert test_account1;
 
    Asset test_asset1 = new Asset(
      Name = 'TestAsset1',
      Core_License__c = test_corelicense.id,
      Status = 'Installed',
      AccountId = test_account1.id);
      insert test_asset1;

    updationAsset.deletionFlag=false;
    delete test_asset1;   
     }
  }