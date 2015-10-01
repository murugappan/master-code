@isTest
public class BBWSISearchControllerTest {
    
    /* static testmethod void BBWSISearchControllerTest()
    {
        Case caseTest = New Case(Status='Closed',Subject='Test');
        insert caseTest;
        System.debug('caseTest >>>>>>>'+ caseTest.Status);
        System.debug('caseTest >>>>>>>'+ caseTest.Id);
        System.debug('caseTest >>>>>>>' + caseTest.CaseNumber);
        learnJIRA__c siObj = new learnJIRA__c(Name='Test', Status__c='Pending',Origin_Case_Number__c = '00001234', Summary__c = 'Test SI');     
        insert siObj;
        
        BBWSISearchController controller = new BBWSISearchController();
        controller.SId = siObj.Id;
        controller.searchText = 'Test';
        system.currentpagereference().getParameters().put('cId',caseTest.Id);
        List<learnJIRA__c> siList = controller.SIList;
        controller.AddSIInCase();
        controller.SearchSI();
        controller.getSize();
        controller.getPageSI();
        controller.getPageNumber();
        controller.getPageSize();
        controller.getPreviousButtonEnabled();
        controller.getNextButtonDisabled();
        controller.getTotalPageNumber();
        controller.nextBtnClick();
        controller.previousBtnClick();
        controller.BindData(2);     
    } */
}