/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          bb_contact_workflow_test
    @abstract       Unit Test for Contact triggers
    @since          2011.0715
    @discussion     Test Class for Contact triggers
*/

@isTest
private class bb_contact_workflow_test 
{

    static testMethod void updateLastInteractionFields() 
    {

        Id apiProfileId = [SELECT Id FROM Profile WHERE Name = 'Bb - API User'].Id;

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', Total_of_Annual_Student_FTE__c = Double.valueOf('3000'), Total_of_Teachers_or_Employees__c = Double.valueOf('3000'), BillingStreet = 'Street', BillingCity = 'City', BillingState = 'State', BillingPostalCode = '11211', BillingCountry = 'USA', CMS_Type__c = 'Bb');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        //Create TEST Contact
        Contact contact = new Contact(FirstName = 'FirstName', LastName = 'LastName', Email = 'updateLastInteractionFields@email.com', AccountId = account.Id);
        insert contact;
        System.assertNotEquals(contact.Id, null);

        contact = [Select Id, last_interaction_flag__c, last_interaction_user__c From Contact Where Id = :contact.Id];

        if(UserInfo.getProfileId() == apiProfileId)
        {
            System.assertEquals( null, contact.last_interaction_user__c );
        }
        else
        {
            System.assertEquals( UserInfo.getUserId(), contact.last_interaction_user__c );
            System.assertEquals( True, contact.last_interaction_flag__c );
        }
    }
}