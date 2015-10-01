/*
This is test class for AddUsersController.
Date:21.05.2013
Author:Nikhil Kumar
*/
@isTest
private class AddUsersControllerTest {

    static testMethod void myUnitTest() {
        
        Account ac=TestMethodUtility.createAccount();
        ac.Name='bucknell university';
        ac.BillingCity='abc';
        ac.BillingCountry='USA';
        ac.BillingPostalCode='abc';
        ac.BillingState='abc';
        ac.BillingStreet='abc';
        insert ac;
        
        Contact ct= TestMethodUtility.createContact(ac);
        ct.AccountId=ac.id;
        ct.Account=ac;
        ct.LastName='abc';
        insert ct;
        
        Survey__c sur = TestMethodUtility.CreateSurvey();
        insert sur;
        
        Core_License__c crl= TestMethodUtility.createCoreLicense();
        insert crl;
        
        Module__c md = TestMethodUtility.createModule(crl) ;
        insert md;
        
        Asset aset= TestMethodUtility.createAsset(ac,crl);
        insert aset;
        
        Case cse= TestMethodUtility.createCase(ct,crl,ac,md);
        insert cse;
        
        System.assert(AddUsersController.addUser(ct.id,sur.id, cse.id) == 'true');
        System.assert(AddUsersController.addUser('arf','arf','arf')== 'false');
        System.assert(AddUsersController.removeUser(ct.id) == 'true');  
        
        AddUsersController sc = new AddUsersController();
        
        sc.InsertNewSurveyTaker(ct.id,sur.id,'Testdata',cse.id);  
        
    }
}