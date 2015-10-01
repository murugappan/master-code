@isTest
private class articleSearchControllerTest {

  static testmethod void articleSearchControllerTest()
    {
    Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
        List<RecordType> recList = new List<recordType>(); 
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'limit 10])
        {
            recList.add(recType);
            mapOfRecIdName.put(recType.Name, recType.Id);           
        }    
      articleSearchController controller = new articleSearchController();
      controller.catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                                FROM CategoryNode
                                                WHERE ParentId = Null
                                                ORDER BY MasterLabel DESC];   
      
      Id  subCat = [Select ParentId, MasterLabel, Id From CategoryNode Limit 1].Id;  
      
      //controller.product = controller.catNodeList.get(0).Id;
      
      controller.errorShow = false;
      controller.errorTitle = 'Test Error';
      controller.errorMessage = 'Test Error Message';
      controller.errorSeverity = 'Test Severity';
      controller.btbbCatList =  new List<BTBB_KBCategory__c>();
      controller.aType = 'Release';
      
      controller.selectProduct();   
      controller.defaultProfileCategory = 'Learn';
      
      system.currentpagereference().getParameters().put('aType','Downloads');
      controller.isXythosOnly = true;
      String defaultProfileCategory = controller.defaultProfileCategory;      
      controller = new articleSearchController();
      system.currentpagereference().getParameters().put('searchText','t');
      system.currentpagereference().getParameters().put('cid',controller.catNodeList.get(1).Id);      
      system.currentpagereference().getParameters().put('page','selfservice');  
    
      controller.isXythosOnly = false;
      controller.subCategoryName = 'Test';
      String test1 = controller.subCategoryName;     
      system.currentpagereference().getParameters().put('searchText',null);  
    
      controller.isXythosOnly = true;
      system.currentpagereference().getParameters().put('aType',null);
    
      system.currentpagereference().getParameters().put('searchTextPage','t');
      system.currentpagereference().getParameters().put('subCat','');
      system.currentpagereference().getParameters().put('childCat','');
      system.currentpagereference().getParameters().put('articleTypes','');
      system.currentpagereference().getParameters().put('patchValue','Yes');
      system.currentpagereference().getParameters().put('topFilterPage','');
      system.currentpagereference().getParameters().put('tarRelease','1.0');
      system.currentpagereference().getParameters().put('servPack','9.1 SP 7 (9.1.70081.0)');
     
      controller.Versions = null;
      Boolean isProdSel = controller.isProdSel;
      controller.Versions = new List<SelectOption>();
      controller.Products = new List<SelectOption>();
      List<SelectOption> producList = controller.Products;
      List<SelectOption> versionList = controller.Versions;
      isProdSel = controller.isProdSel;
      controller.product = null;
      String defaultCategory = controller.defaultCategory;
      controller.defaultCategory = 'Learn';
      system.currentpagereference().getParameters().put('page','selfservice');
      String defaultPoduct = controller.defaultProduct;
      controller.defaultProduct = 'Learn';     
      controller.searchText = 'Test';
      controller.selectMajor();
      controller.version = '9.0';
      controller.selectMajor();
       Test.startTest();
      controller.runSearch();
      controller.getRecordTypeList();
      Integer i = controller.getResultSize();
      //controller.product = controller.catNodeList.get(2).Id;
      controller.product = 'a2470000000Taw4AAC';
     
      controller.selectProduct();
      controller.getChildCategories();
      controller.getSubChildCategories();
      controller.exportToExcel();
      controller.exportToPDF();
      controller.printKBSearch();
      controller.getMinVersion();
      controller.getTargetRelease();
       Test.stopTest();
     
     
      
    }
 static testmethod void articleSearchControllerTest2(){
 
 
    Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
        List<RecordType> recList = new List<recordType>(); 
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'limit 10])
        {
            recList.add(recType);
            mapOfRecIdName.put(recType.Name, recType.Id);           
        }    
      articleSearchController controller = new articleSearchController();
      controller.catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                                FROM CategoryNode
                                                WHERE ParentId = Null
                                                ORDER BY MasterLabel DESC];   
      
      Id  subCat = [Select ParentId, MasterLabel, Id From CategoryNode Limit 1].Id;
 
  system.currentpagereference().getParameters().put('searchTextPage','t');
      system.currentpagereference().getParameters().put('subCat','');
      system.currentpagereference().getParameters().put('childCat','');
      system.currentpagereference().getParameters().put('articleTypes','');
      system.currentpagereference().getParameters().put('patchValue','Yes');
      system.currentpagereference().getParameters().put('topFilterPage','');
      system.currentpagereference().getParameters().put('tarRelease','1.0');
      system.currentpagereference().getParameters().put('servPack','9.1 SP 7 (9.1.70081.0)');
    
       system.currentpagereference().getParameters().put('subCat',subCat);
      system.currentpagereference().getParameters().put('topFilterPage','Product');
        test.starttest();
      controller.runSearch();
      system.currentpagereference().getParameters().put('topFilterPage','Major Release');
      controller.runSearch();
      system.currentpagereference().getParameters().put('topFilterPage','Patch Available');
      controller.runSearch();  
      controller.Redirect();  
      system.currentpagereference().getParameters().put('childCat',subCat);
      controller.getSubChildCategories();
      controller.runSearch();
      list<selectoption> temp_op = controller.DocumentTypes;
     list<selectoption> temp_op2=  controller.ResourceTypes;
      test.stoptest();
  }  
  
  static testmethod void articleSearchControllerTest3(){
  
       Profile p =[select id from Profile where Name='BTBB Profile'];
       
       User u =TestMethodUtility.createUser(p);
       insert u;
       
       // Solution
        Solution s  = new Solution();
        s.SolutionName = 'Test';
        s.Major_Release__c='9.1,9.0';
        Insert s; 
       
       System.runas(u)
        {
        
        
        ApexPages.currentPage().getparameters().Put('isKISearch','true');
        Apexpages.currentPage().getParameters().put('sourceID',s.id);
        
        articleSearchController controller = new articleSearchController();
     
        List<SelectOption> Lsel = controller.bulletinadvisoryTypes;
        controller.selectDocType();
        controller.selectResType();
        controller.selectSBSAType();
        controller.Redirect();
  
      }
  
  
  
  
  
  }
 
  
}