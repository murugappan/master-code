@isTest
private class CaseConfirmationControllerTest {
    static testmethod void CaseRelevantArticlesControllerTest()
    {
        Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
         
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
        {
            mapOfRecIdName.put(recType.Name, recType.Id);
        }
        Solution solTest = new Solution(SolutionName = 'Test',IsRunFromTestClass__c = true, Visible_in_Customer_Portal__c = true, Status = 'Published', RecordTypeId = mapOfRecIdName.get('Release'));
        Case caseTest = New Case(Status='Closed',Subject='Test');
        insert solTest;
        insert caseTest;
        System.debug('solTest and caseTest>>>>>'+ solTest.Id + '<<<<>>>>>' + caseTest.Id);
        system.currentpagereference().getParameters().put('Id',caseTest.id);        
        CaseConfirmationController controller = new CaseConfirmationController();   
        controller.solIdSet.add(solTest.Id);
        controller.caseId = caseTest.id;
        //controller.RelevantArticles = null;   
        controller.getArticleId();
        controller.getCaseNumber();
        //controller.getNoResult();
        controller.getRelevantArticles();
        //controller.getNoResult();
        controller.getResults();
        controller.getSearchText();     
        controller.setArticleId(solTest.Id);
        controller.setCaseNumber(caseTest.CaseNumber);
        controller.setSearchText('Test Article');
        //controller.searchText = 'Test Article';
        controller.selectArticle();
        controller = new CaseConfirmationController();
        System.debug('Search Text >>>1' +controller.searchText);        
        //Solution solTest1 = new Solution(SolutionName = 'Test Article1',Visible_in_Customer_Portal__c = true, Status = 'Published');
        //insert solTest1;
        //System.debug('solTest1>>>>>>'+ solTest1);
        //controller.solIdSet = new Set<Id>();
        //controller.solIdSet.add(solTest1.Id);
        //controller.AddRelevantArticles('Test');
    }
}