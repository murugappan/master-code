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
private class VersionBuildUploadTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
         VersionBuildUpload vbu = new VersionBuildUpload();
         Version_Build_Tree__c vbt1 = new Version_Build_Tree__c();
         vbt1.Version__c = '1.1';
         vbt1.Version_Build__c = '1';
         vbt1.GKEY_Product_Group__c = 'SA1';
         insert vbt1;
         /*Version_Build_Tree__c vbt2 = new Version_Build_Tree__c();
         vbt2.Version__c = '1.2';
         vbt2.Version_Build__c = '2';
         vbt2.GKEY_Product_Group__c = 'SA2';
         insert vbt2; */
         vbu.addRow();
         vbu.removeRow();
         vbu.saveRecords();
         
    }
}