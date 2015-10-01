@isTest
private class LicenseKeyGeneratorExtTest {
    
    static testMethod void myUnitTest() {
        
        test.startTest();
        
        //Insert Account
        Account acc=TestMethodUtility.createAccount();
        Insert acc;
        
        //Insert Core license
        Core_License__c  cr=TestMethodUtility.createCoreLicense();
        Insert cr;
        
        //Insert Asset
        
        Asset Aset=TestMethodUtility.createAsset(acc,cr);
        insert Aset;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(Aset); 
        LicenseKeyGeneratorExt con = New LicenseKeyGeneratorExt(controller ); 
        
        con.doGenerate();
        con.getChildAssets();
        con.getEligibleChildAssets();
        
         
      
        
        
        
        test.stopTest();
    }
}