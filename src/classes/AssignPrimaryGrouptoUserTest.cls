/*
TestClass for AssignPrimaryGrouptoUser
Date:20.05.2013
*/
@isTest
private class AssignPrimaryGrouptoUserTest {

    static testMethod void myUnitTest() {
        
        
        Profile p = [select ID from Profile where Name = 'SRV - BTBB User'];
        
        User u  = [select ID from User where ProfileID =: p.ID limit 1];
        
        ApexPages.CurrentPage().getParameters().Put('id',u.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(u);
        AssignPrimaryGrouptoUser aq = new AssignPrimaryGrouptoUser(controller);
        aq.getQueues();
        aq.assigntoUser();      
        
    }
}