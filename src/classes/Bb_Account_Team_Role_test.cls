/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Bb_Account_Team_Role_test {

    static testMethod void myUnitTest() {
        Account a = [Select Id From Account Limit 1][0];
        Bb_Account_Team_Role__c r = New Bb_Account_Team_Role__c( );
        r.Account__c = a.Id;
        r.Member__c = 'Test Test';
        r.Role_Code__c = '3';
        r.PSFT_Person_Id__c = '10101';
        r.Start_Date__c =  System.today();
        try 
 		{
			insert a;
			delete a;
 		}
		 catch (DmlException e)
		{
			a.addError (e);
		}
        
    }
}