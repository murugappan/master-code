@istest(seealldata=True)
Private class UpdateLastFacultyDateTriggerHandlerTest
 {
    static testMethod void myUnitTest() 
    {
        Account a = TestMethodUtility.createAccount();
        insert a;

        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true limit 1];
    
        Pricebook2 pb = [select Id from pricebook2 where Name='CPQ' limit 1];
        
        Opportunity opp = TestMethodUtility.createOpportunity(a,pb);
        insert opp;
        
        Date dt = System.today();
        Event evnt = new Event(Type ='Faculty Engagement',Event_Status__c='Completed',ActivityDateTime=dt,DurationInMinutes = 10,Whatid = a.id );
        insert evnt;

        Event evnt2 = new Event(Type ='Faculty Engagement',Event_Status__c='Completed',ActivityDateTime=dt,DurationInMinutes = 10,Whatid = opp.id );
        insert evnt2;
    }
 }