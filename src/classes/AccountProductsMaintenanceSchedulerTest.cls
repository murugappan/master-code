/*
    @author         Nikhil Kumar <nikhil.kumar6@wipro.com>
    @discussion     This is the test Class on  class  'AccountProductsMaintenanceBatchScheduler'
*/

@isTest
private class AccountProductsMaintenanceSchedulerTest {
    static testMethod void myUnitTest() {
    test.startTest();
    AccountProductsMaintenanceBatchScheduler nightlyUpdate = new AccountProductsMaintenanceBatchScheduler();
    String schedule = '0 0 23 * * ?';
    system.schedule('Nightly Update', schedule, nightlyUpdate);
    test.stopTest();
    }
}