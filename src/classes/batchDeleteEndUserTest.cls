@isTest 
private class batchDeleteEndUserTest {
   static testMethod void myUnitTest() {
       
       
        test.starttest();
        Datetime days = system.now().addDays(-365);

        Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';         
        ac.BillingPostalCode = 'Testing Code';
        insert ac;

        EndUser__c EU=new EndUser__c();
        EU.Time_of_Last_Initiated_Chat__c=days;
        EU.Time_of_Last_Created_Case__c=null;
        EU.Account__c=ac.ID;
        EU.Phone__c='9640133885';
        EU.Email__c='sai@gmail.com';
        insert EU;

         SchedulableContext sc;
         batchDeleteEndUser b=new batchDeleteEndUser();
        /*Datetime dt = system.now().addMinutes(1);
        String CRON_EXP = '0 '+ dt.minute() + ' * ' + dt.day() + ' ' + dt.month() + ' ? ' + dt.year();
        String jobId = System.schedule('Delete Batch User', CRON_EXP, b ); */
         b.execute(sc);

         test.stoptest();
    } 
     
}