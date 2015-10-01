@istest
Private class ArticleListControllerTest
{
    Private static Testmethod void ArticleListControllerTest()
    {       
        Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
         
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
        {
            mapOfRecIdName.put(recType.Name, recType.Id);
        }            
        Solution sol = new Solution();
        sol.SolutionName='TestArticle';
        sol.Major_Release__c='9.0;ANGEL 7.3';
        sol.Issue_Description__c='abc';
        sol.Version_s__c='9.0;9.0 HF1;7.3;7.3SP 12';
        sol.Patch_Available__c='yes';
        sol.RecordTypeId = mapOfRecIdName.get('General Article');
        insert sol;
        
        system.currentpagereference().getParameters().put('id',sol.id);
        system.currentpagereference().getParameters().put('recType','KI');
        ArticleListController controller = new ArticleListController();  
        String test = controller.recType;
        test = controller.articleListType; 
        controller.articleListType = test;  
        controller.aId = sol.Id;
        system.currentpagereference().getParameters().put('recType','RKI');
        test = controller.articleListType;
        controller.articleListType = test;  
        
        system.currentpagereference().getParameters().put('recType','RP');
        test = controller.articleListType;
        controller.BindData(1);
        system.currentpagereference().getParameters().put('recType','ST');
        test = controller.articleListType;
        controller.BindData(1);
        controller.getSize();
        controller.getPageArticleList();
        controller.getPageNumber();
        controller.getPageSize();
        controller.getPreviousButtonEnabled();
        controller.getNextButtonDisabled();
        controller.getTotalPageNumber();
        controller.nextBtnClick();
        controller.previousBtnClick();
        controller.recType = 'ST';
        
    }
}