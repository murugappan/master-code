@isTest
private class testSupportIncidentArticle{

    private static testmethod void testSupportIncident(){
        
        Case aCase = BbTestUtility.createTestSev1Case();    
        Test.StartTest();
        learnJIRA__c si = new learnJIRA__c(Name = 'NewSI', OriginCaseID__c = aCase.id, Summary__c = 'si summary', isChanged__c = true);
        insert si;
        /*Solution newArticle = [Select Id, Target_Release__c, SolutionName, Support_Incident__c, Issue_Description__c From Solution Where Support_Incident__c = :si.id];
        System.Assert(newArticle != null);
        System.Assert(newArticle.SolutionName == si.Summary__c);*/
        Related_Bug__c bug = new Related_Bug__c(Name = 'testbug', Support_Incident__c = si.Id, Status__c = 'Pending Target');
        insert bug;
        Test.StopTest();
        
    }
 
}