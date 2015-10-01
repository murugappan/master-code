@istest
private class BBW_DetailArticleTest

{
    private static testmethod void testKBInternalArticleLink(){
        Solution sol = new Solution(SolutionName = 'Test');
        insert sol;
        System.debug('sol Number >>>>>' + sol.SolutionNumber);
        KB_Internal_Article_Link__c internalKBLink = new KB_Internal_Article_Link__c(Name = sol.SolutionNumber, Related_Article__c = sol.Id, IsRunFromTestClass__c = true);
        insert internalKBLink;
    }
    static testmethod void BBW_DetailArticleTest()
    {
        List<Solution> solList = new List<Solution>();
        
        Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
         
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
        {
            mapOfRecIdName.put(recType.Name, recType.Id);
        }
        Solution parentSol = new Solution();
        parentSol.SolutionName = 'Test Parent Solution';
        parentSol.RecordTypeId = mapOfRecIdName.get('General Article');
        parentSol.Status = 'Published';
        parentSol.IsRunFromTestClass__c = true;
        insert parentSol;
        
        Solution sol = new Solution();
        sol.SolutionName='TestArticle';
        sol.Type__c='abc';
        sol.Product__c='ANGEL';
        sol.Document_Link__c='abc';
        sol.Upgrade_Information__c='abc';
        sol.Major_Release__c='9.0;ANGEL 7.3;ANGEL 7.4';
        sol.Document_Summary__c='abc';
        sol.Field_1__c='abc';
        sol.Field_2__c='abc';
        sol.Field_3__c='abc';
        sol.Field_4__c='abc';
        sol.Document_Details__c='abc';
        sol.Version_s__c='9.0;7.3;7.3 SP 12;7.3 SP 13;7.4 SP 5;7.4';
        sol.Issue_Description__c='abc';
        sol.Patch_Available__c='yes';
        sol.Support_Policy__c='abc';
        sol.Resource_Description__c='test description';
        sol.Platform_Technologies__c='SFDC';//
        sol.RecordTypeId = mapOfRecIdName.get('Release');//'012Q00000004Zl5';
        sol.ParentId__c = null;
        sol.Status = 'Archived';
        sol.Team_s__c = 'Test';
        sol.Process_Details__c='abc';
        sol.Client_Technologies__c='abc'; 
        sol.Isrejected__c = 1;
        sol.IsRunFromTestClass__c = true;
        sol.iscopy__c = false;        
        system.debug('solution id'+sol.id);
        solList.add(sol);
        insert sol;
        //parentSol.iscopy__c = true;
        //sol.ParentId__c = sol.id;
        //update sol;
        parentSol.ParentId__c = sol.Id;
        update ParentSol;
        system.currentpagereference().getParameters().put('id',sol.id);
        system.currentpagereference().getParameters().put('RecordType',sol.RecordTypeId);
        system.currentpagereference().getParameters().put('redirect',mapOfRecIdName.get('Process/Procedure'));
        
        ApexPages.StandardController stdcon = new ApexPages.StandardController(sol);
        BBW_DetailArticle controller = new BBW_DetailArticle(stdcon);             
        controller.results = solList;       //   
        controller.setErrorTitle('Error');
        controller.getErrorTitle();
        controller.setErrorShow(true);
        controller.getErrorShow();
        controller.setErrorMessage('Error');
        controller.getErrorMessage();
        controller.setErrorSeverity('Error');
        controller.getErrorSeverity();
        //controller.getCloneId();
        controller.getArticleCategories();
        controller.getRecordType();
        controller.aId = null;
        controller.rId = null;
        controller.recType = null;
        controller.getRecordType();
        controller.profileName = 'SRV - SBSA Authors';
        controller.aId = sol.Id;
        controller.rId = null;
        controller.getRecordType();
        controller.redirect = 'true';
        for(String recName : mapOfRecIdName.keySet()) {
            System.currentpagereference().getparameters().put('RecordType',mapOfRecIdName.get(recName));
            controller.recordName = recName;            
            controller.EditArticle();
            }
        controller.EditArticle();
        controller.originalArticle();
        controller.redirectToPage();
        
        controller.selectCategory();
        controller.deleteCategory();
        controller.CloneArticle();
        //controller.DeleteArticle();
        controller.getSupportTechArticleList();
        controller.getKIResolvedArticleList();
        controller.getReleasePageArticleList();
        controller.AddAttachment();
        controller.deleteAttachment();
        controller.CustomerView();
        controller.getArticleAttach();
        
        
        sol.ParentId__c = sol.id;
        sol.iscopy__c = true;
        sol.Isrejected__c = 0;
        update sol;
        stdcon = new ApexPages.StandardController(sol);
        controller = new BBW_DetailArticle(stdcon); 
        Test.startTest();
        for(String recName : mapOfRecIdName.keySet()) {
            System.currentpagereference().getparameters().put('RecordType',mapOfRecIdName.get(recName));
            controller.recordName = recName;
            controller.CloneArticle();
            controller.redirectToPage();
            controller.getSupportTechArticleList();
            controller.getKIResolvedArticleList();
            controller.getReleasePageArticleList();
            //controller.EditArticle();
            controller.originalArticle();
            if(recName.Equals('Release') || recName.Equals('Maintenance Release'))
                controller.getKIArticleList();
             if(recName.Equals('Maintenance Release')) {
                controller.getSupportTechArticleList();
                controller.getKIResolvedArticleList();
             }
        }
        Test.stopTest();
    }
      
}