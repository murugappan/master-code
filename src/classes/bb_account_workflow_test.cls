/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          bb_account_workflow_test
    @abstract       Unit Test for Account triggers
    @since          2011.0715
    @discussion     Test Class for Account triggers
*/

@isTest
private class bb_account_workflow_test 
{

    static testMethod void updateLastInteractionFields() 
    {

        Id apiProfileId = [SELECT Id FROM Profile WHERE Name = 'Bb - API User'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        account = [Select Id, last_interaction_flag__c, last_interaction_user__c From Account Where Id = :account.Id];

        if(UserInfo.getProfileId() == apiProfileId)
        {
            System.assertEquals( null, account.last_interaction_user__c );
        }
        else
        {
            System.assertEquals( UserInfo.getUserId(), account.last_interaction_user__c );
            System.assertEquals( True, account.last_interaction_flag__c );
        }
    }
}