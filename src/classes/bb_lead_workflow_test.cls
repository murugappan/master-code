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
private class bb_lead_workflow_test {

    static testMethod void lead_fill_owner_rltnshp() 
    {
        Lead l = new Lead();
        l.LastName = 'LastName';
        l.Company = 'Company';
        l.Industry = 'Higher Ed.';
        l.LeadSource = 'Marketing';
        l.Country = 'USA';        
        insert l;
        system.assertEquals (l.OwnerId, l.Owner__c); 


        // verify that Queues are not filled in owner__c
     
        QueueSobject queue = [Select Id, QueueId From QueueSobject Where SobjectType = 'Lead' Limit 1][0];
        l.OwnerId = queue.QueueId;  
        update l;       
        system.assertEquals (l.Owner__c, null);
    }
}