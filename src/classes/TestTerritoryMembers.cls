/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          TestTerritoryMembers
    @abstract       Unit Test TestTerritoryMembers
    @since          2008.0916
    @discussion     Test Class for TestTerritoryMembers
*/

@isTest
private class TestTerritoryMembers {


    private static testMethod void displaySandboxMembers() {

        //Create TEST Account
        Account account = new Account(Name = 'Name', Industry = 'Higher Ed.', BillingStreet = 'Street', BillingCity = 'City', BillingState = 'New York', BillingPostalCode = '11211', BillingCountry = 'India');
        insert account;            
        System.assertNotEquals(account.Id, null);            

        ApexPages.StandardController sc = new ApexPages.StandardController(account);
        TerritoryMembers ctm = new TerritoryMembers(sc);

        for(TerritoryMembers.TerritoryMember tm : ctm.getMembers())
        {
            System.assertEquals(account,tm.getAccount());
            tm.getUser();
        }
    }
}