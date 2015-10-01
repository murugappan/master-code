@isTest
private class CaseRelevantArticlesControllerTest {
    static testmethod void CaseRelevantArticlesControllerTest()
    {
        Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
         
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
        {
            mapOfRecIdName.put(recType.Name, recType.Id);
        }
        Solution solTest = new Solution(SolutionName = 'Test',IsRunFromTestClass__c = true, Visible_in_Customer_Portal__c = true, Status = 'Published', RecordTypeId = mapOfRecIdName.get('Release'));
        Case caseTest = New Case(Status='Closed',Subject='Test');
       // caseTest.CoreLicense='Angel';
        insert solTest;
        
        Core_License__c cl=new Core_License__c();
        cl.Name='ANGEL';
        insert cl;
        
        Module__c m=new  Module__c(); 
        m.Name='abc'; 
        m.Core_Licence__c=cl.id; 
        insert m;

        Functional_Area__c fa=new Functional_Area__c();
        fa.Name='abc';
        fa.Module__c=m.id;
        insert fa;

        Category__c c=new Category__c();
        c.Name='abc';
        c.Functional_Area__c=fa.id;
        insert c;
        
        caseTest.Core_License__c = cl.id ;
        caseTest.Functional_Area__c=fa.id;
        caseTest.Module__c=m.id;
        caseTest.Category__c=c.id;
        insert caseTest;
        
        KB_Relevent_Article_Search_Mapping__c solmap = new KB_Relevent_Article_Search_Mapping__c(
                    Core_License__c=cl.id, Functional_Area__c=fa.id, Issue_Topic__c=m.id, KB_Search_3rd_Level_Category__c='Learn',
                    KB_Search_Category__c='Learn',KB_Search_Product__c='Learn',KB_Search_Sub_Category__c='Learn');
                    
             insert solMap;       
                    
        System.debug('solTest and caseTest>>>>>'+ solTest.Id + '<<<<>>>>>' + caseTest.Id);
        system.currentpagereference().getParameters().put('Id',caseTest.id);        
        CaseRelevantArticlesController controller = new CaseRelevantArticlesController(); 
        CaseRelevantArticlesController controller2 = new CaseRelevantArticlesController();  
       // controller.solIdSet.add(solTest.Id);
        controller.caseId = caseTest.id;
        //controller.RelevantArticles = null;   
        controller.getArticleId();
        controller.getCaseNumber();
       // controller.getNoResult();
      //  controller.getRelevantArticles();
     //   controller.getNoResult();
    //    controller.getResults();
        controller.getSearchText();
        controller.getCoreLicense();
        controller.getCaseCategory();
        controller.getCaseFunctionalArea();
        controller.getCaseIssueTopic();
        controller.Redirect();     
        controller.setArticleId(solTest.Id);
        controller.setCaseNumber(caseTest.CaseNumber);
        controller.setSearchText('Test Article');
        //controller.getRelatedArticles();
        //controller.searchText = 'Test Article';
  //      controller.selectArticle();
        controller = new CaseRelevantArticlesController();
        System.debug('Search Text >>>1' +controller.searchText);
        //controller.AddRelevantArticles('Test');
        System.debug('Search Text >>>2' +controller.searchText);
        Solution solTest1 = new Solution(SolutionName = 'Test Article1',Visible_in_Customer_Portal__c = true, Status = 'Published');
        insert solTest1;
        //System.debug('solTest1>>>>>>'+ solTest1);
        //controller.solIdSet = new Set<Id>();
        //controller.solIdSet.add(solTest1.Id);
        //controller.AddRelevantArticles('Test');
        
         Account ac=new Account();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';
    insert ac;
    
    Contact ct= new Contact ();
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
      
    test.starttest();
    Asset a=new Asset();
    a.Name='abc';
    a.Core_License__c=cl.id;
    a.AccountId=ac.id;
    a.Contact=ct;
    a.Account=ac;
    insert a;  
        
        Case cs1=new Case();
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.AccountId=ac.id;
    cs1.Contact=ct;
    cs1.AssetID=a.ID;
    cs1.Description = 'Description for Test Class';
    insert cs1;
    
    Case_Attachment__c casatt = new Case_Attachment__c();
    casatt.Related_To__c = cs1.ID;
    Insert casatt;
    
    Case_Note__c cn = new Case_Note__c();
    cn.Case__c = cs1.ID;
    cn.Type__c = 'Internal Note';
    cn.Public__c = true;
    insert cn;
    
    Responsiveness__c res = new Responsiveness__c();
    res.Case__c = cs1.Id;
    res.start_time__c=system.now();
    insert res;
    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    Apexpages.currentPage().getParameters().put('attachid',casatt.ID);
    
    controller.getCaseNoteAttachments();
    controller.deleteatt1();
     Case_Attachment__c casatt1 = new Case_Attachment__c();
    casatt1.Related_To__c = cs1.ID;
    Insert casatt1;
    controller.Notes = 'Test';
    
    controller.addNote();
    
     controller2.setCoreLicense('TestCorelicense');
     controller2.setCaseCategory('testCasecategory');
      controller2.setCaseFunctionalArea('testfunctionalAres');
      controller2.setCaseIssueTopic('testIssutopic');
      
      
      test.stoptest();
      
    }
}