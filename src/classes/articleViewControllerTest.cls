@istest
private class articleViewControllerTest {
    static testmethod void articleViewControllerTest()
    {
        //Case cs=new Case(id='5007000000J3n8J');
        Case cs = new Case(status = 'Closed');
        insert cs;
        System.debug('id >>>>>>>>>>'+ cs.id);
        cs.status = 'Closed';
       // cs.Portal_Status__c = 'Closed';
        cs.IsSelfServiceClosed = true;
        cs.IsClosedByRelevantArticle__c = true;
        system.currentpagereference().getParameters().put('cId',cs.id);
        system.currentpagereference().getParameters().get('cId');
        update cs ;
        
        Map<String, Id> mapOfRecIdWithName = new Map<String, Id>();
        for(RecordType recObj : [select id, name from RecordType where SobjectType = 'Solution' and name != 'Process/Procedure']) {
            
            mapOfRecIdWithName.put(recObj.Name, recObj.Id);
        }
   /*         Map<Id, CategoryNode> mapOfCatNodWithId = new Map<Id, CategoryNode>();         
    
                for(CategoryNode catNod : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                                ORDER BY MasterLabel DESC]) {            
                 
                        mapOfCatNodWithId.put(catNod.Id, catNod);
                        }
     */   
        Solution parentSol = [select id from Solution Where SolutionName Like '%a%' Limit 1];
        Solution sol = new Solution();
        sol.SolutionName='TestArticle';
        sol.Type__c='abc';
        sol.Product__c='ANGEL';
        sol.Document_Link__c='abc';
        sol.Upgrade_Information__c='abc';
        sol.Major_Release__c='9.0;1.0';
        sol.Document_Summary__c='abc';
        sol.Document_Details__c='abc';
        sol.Version_s__c = '9.0;SP 9.10';
        sol.Issue_Description__c='abc';
        sol.Patch_Available__c='yes';
        sol.Support_Policy__c='abc';
        sol.Resource_Description__c='test description';
        sol.Platform_Technologies__c='SFDC';//
        sol.ParentId__c = parentSol.Id;
        sol.Team_s__c = 'Test';
        sol.Process_Details__c='abc';
        sol.Client_Technologies__c='abc'; 
        sol.RecordTypeId = mapOfRecIdWithName.get('Release');
        sol.status='Published';
        sol.Visible_in_Customer_Portal__c = true;
        sol.IsRunFromTestClass__c = true;
        //sol.iscopy__c = true;
        system.debug('solution id'+sol.id);
        insert sol;
        parentSol.iscopy__c = true;
        system.currentpagereference().getParameters().put('id',null);
        System.currentpagereference().getparameters().put('RecordType',null);

          Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
                 
                for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
                {
                    mapOfRecIdName.put(recType.Name, recType.Id);
                }
        
        
        pagereference   detailPage = new PageReference('/apex/btbb_ReleaseArticleView');   
          test.setCurrentPage(detailpage);
          test.setcurrentpagereference(detailpage) ;
              Apexpages.currentpage().getParameters().put('id',sol.id);
              Apexpages.currentpage().getParameters().put('cid',cs.id);
        ApexPages.StandardController stdcon = new ApexPages.StandardController(sol);
        articleViewController controller = new articleViewController(stdcon);
        controller.getRecordType();
             Test.startTest(); 
        controller.getRecordType();
        controller.closeCase();
        controller.selArticle();
        controller.notHelpful();
        controller.addFeedback();
        controller.redirect();
        controller.getArticleAttach();
        controller.getItems();
        Boolean test1 = controller.isFBExist;
        controller.isFBExist = test1;
       Apexpages.currentpage().getParameters().put('pId',sol.Id);
        controller.ParentarticleId = sol.id;
        Id id = controller.ParentarticleId;
        controller.runFromTest = true;
        controller.getKIArticleList();
        controller.getKIResolvedArticleList();
        controller.getReleasePageArticleList();
        controller.getSupportTechArticleList();
        controller.caseId = cs.Id;        
        controller.runFromTest = true;
        controller.redirect();
        controller.redirectToPage();
        controller.redirectToPublicPage();
     
 
       
        Test.stopTest();
        /*User u1 = [SELECT Id FROM User WHERE Profile.Name='BTBB Profile' and IsActive = true Limit 1];
        System.RunAs(u1){
            controller.redirect() ;
            controller.redirectToPage();
        }*/
}
static testmethod void articleViewControllerTest2()
{
 //Case cs=new Case(id='5007000000J3n8J');
        Case cs = new Case(status = 'Closed');
        insert cs;
        System.debug('id >>>>>>>>>>'+ cs.id);
        cs.status = 'Closed';
       // cs.Portal_Status__c = 'Closed';
        cs.IsSelfServiceClosed = true;
        cs.IsClosedByRelevantArticle__c = true;
        system.currentpagereference().getParameters().put('cId',cs.id);
        system.currentpagereference().getParameters().get('cId');
        update cs ;
        
        Map<String, Id> mapOfRecIdWithName = new Map<String, Id>();
        for(RecordType recObj : [select id, name from RecordType where SobjectType = 'Solution' and name != 'Process/Procedure']) {
            
            mapOfRecIdWithName.put(recObj.Name, recObj.Id);
        }
        Solution parentSol = [select id from Solution Where SolutionName Like '%a%' Limit 1];
        Solution sol = new Solution();
        sol.SolutionName='TestArticle';
        sol.Type__c='abc';
        sol.Product__c='ANGEL';
        sol.Document_Link__c='abc';
        sol.Upgrade_Information__c='abc';
        sol.Major_Release__c='9.0;1.0';
        sol.Document_Summary__c='abc';
        sol.Document_Details__c='abc';
        sol.Version_s__c = '9.0;SP 9.10';
        sol.Issue_Description__c='abc';
        sol.Patch_Available__c='yes';
        sol.Support_Policy__c='abc';
        sol.Resource_Description__c='test description';
        sol.Platform_Technologies__c='SFDC';//
        sol.ParentId__c = parentSol.Id;
        sol.Team_s__c = 'Test';
        sol.Process_Details__c='abc';
        sol.Client_Technologies__c='abc'; 
        sol.RecordTypeId = mapOfRecIdWithName.get('Release');
        sol.status='Published';
        sol.Visible_in_Customer_Portal__c = true;
        sol.IsRunFromTestClass__c = true;
        //sol.iscopy__c = true;
        system.debug('solution id'+sol.id);
        insert sol;
        parentSol.iscopy__c = true;
        system.currentpagereference().getParameters().put('id',null);
        System.currentpagereference().getparameters().put('RecordType',null);

          Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
                 
                for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
                {
                    mapOfRecIdName.put(recType.Name, recType.Id);
                }
                 pagereference   detailPage = new PageReference('/apex/btbb_ReleaseArticleView');   
          test.setCurrentPage(detailpage);
          test.setcurrentpagereference(detailpage) ;
              Apexpages.currentpage().getParameters().put('id',sol.id);
              Apexpages.currentpage().getParameters().put('cid',cs.id);
        ApexPages.StandardController stdcon = new ApexPages.StandardController(sol);
        articleViewController controller = new articleViewController(stdcon);
         for(String recName : mapOfRecIdWithName.keySet()) {
            System.currentpagereference().getparameters().put('RecordType',mapOfRecIdWithName.get(recName));
            controller.runFromTest = false;
            controller.redirectToPage();
            controller.redirectToPublicPage();
            
        }
        
        sol.RecordTypeId = mapOfRecIdWithName.get('Maintenance Release');
        System.currentpagereference().getparameters().put('RecordType',mapOfRecIdWithName.get('Maintenance Release'));
        update sol;
        
        Test.startTest();
        stdcon = new ApexPages.StandardController(sol);
        controller = new articleViewController(stdcon);
        controller.runFromTest = true;
        controller.getKIArticleList();
        controller.getKIResolvedArticleList();
        controller.getReleasePageArticleList();
        controller.getSupportTechArticleList();
        controller.ArticleSort(controller.articleList);
        controller.getSearchKI();
        controller.getSearchKI_targetReleaseURL();
        Test.stopTest();
}

    static testmethod void articleViewControllerEmptyConstructor()
    {
        Map<String, Id> mapOfRecIdWithName = new Map<String, Id>();
        for(RecordType recObj : [select id, name from RecordType where SobjectType = 'Solution' and name != 'Process/Procedure']) {
            
            mapOfRecIdWithName.put(recObj.Name, recObj.Id);
        }
        
        Solution parentSol = [select id from Solution Where SolutionName Like '%a%' Limit 1];
        
        Solution sol = new Solution();
        sol.SolutionName='TestArticle';
        sol.Type__c='abc';
        sol.Product__c='ANGEL';
        sol.Document_Link__c='abc';
        sol.Upgrade_Information__c='abc';
        sol.Major_Release__c='9.0;1.0';
        sol.Document_Summary__c='abc';
        sol.Document_Details__c='abc';
        sol.Version_s__c = '9.0;SP 9.10';
        sol.Issue_Description__c='abc';
        sol.Patch_Available__c='yes';
        sol.Support_Policy__c='abc';
        sol.Resource_Description__c='test description';
        sol.Platform_Technologies__c='SFDC';//
        sol.ParentId__c = parentSol.Id;
        sol.Team_s__c = 'Test';
        sol.Process_Details__c='abc';
        sol.Client_Technologies__c='abc'; 
        sol.RecordTypeId = mapOfRecIdWithName.get('Release');
        sol.status='Published';
        sol.Visible_in_Customer_Portal__c = true;
        sol.IsRunFromTestClass__c = true;
        //sol.iscopy__c = true;
        system.debug('solution id'+sol.id);
        insert sol;
        
        List<CategoryNode> catNodeList =  [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId 
                                           FROM CategoryNode
                                           LIMIT 1];
                                           
        if(catNodeList != null && catNodeList.size() > 0) {
            CategoryData cd = new CategoryData(RelatedSobjectId=sol.Id, CategoryNodeId=catNodeList[0].Id);
            insert cd;
        }
        
        Apexpages.currentpage().getParameters().put('id', sol.id);
        
        articleViewController avc = new articleViewController();
        avc.getCategories();
        avc.getRecordType();
        avc.SearchKI_targetRelease();
        
    }
}