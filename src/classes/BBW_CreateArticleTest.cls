@istest
private class BBW_CreateArticleTest {
    
    static testmethod void BBW_CreateArticleTest()
    {
        string s= 'The qick brown fox jumpedd over the lazy dog';
        for(;s.length()<32720;)
        {
        s=s+s;
        }
        
        
        //Solution solTest = [select RecordTypeId,id from Solution Where SolutionName Like '%a%' Limit 1];
        Solution sol = new Solution();
        sol.SolutionName='TestArticle';
        sol.Type__c='abc';
        sol.Status='Draft';
        sol.Product__c='Angel';
        sol.Document_Link__c='abc';
        sol.Upgrade_Information__c='abc';
        sol.Major_Release__c='9.0';
        sol.Document_Summary__c='abc';
        sol.Document_Details__c='abc';
        Sol.Related_Link_s__c='abc';
        sol.Version_s__c='abc';
        sol.Issue_Description__c='abc';
        sol.Patch_Available__c='yes';
        sol.Support_Policy__c='abc';
        sol.Resource_Description__c='test description';
        sol.Platform_Technologies__c='SFDC';
        sol.Change_Status_12_months__c = false;
        //sol.RecordTypeId = solTest.RecordTypeId;
        //sol.ParentId__c= parentSol.Id;
        sol.Team_s__c='Test';
        sol.Process_Details__c='abc';
        sol.Client_Technologies__c='abc';             
        string i = 'Sample text to cross the limit size of field type.';
        integer j;
        for(j=0;j < 5; ){
        i= i+i;
        j=j+1;
        }
        sol.Upgrade_Information__c = i ;
        Map<String, Id>  mapOfRecIdName = new Map<String, Id>();  
         
        for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
        {
            mapOfRecIdName.put(recType.Name, recType.Id);
        }
        system.currentpagereference().getParameters().put('redirect',mapOfRecIdName.get('Process/Procedure'));
        
        
        ApexPages.StandardController stdcon = new ApexPages.StandardController(sol);
        BBW_CreateArticle controller = new BBW_CreateArticle(stdcon);  
        //Error code coverage
        controller.setErrorTitle('Error');
        controller.getErrorTitle();
        controller.setErrorShow(true);
        controller.getErrorShow();
        controller.setErrorMessage('Error');
        controller.getErrorMessage();
        controller.setErrorSeverity('Error');
        controller.getErrorSeverity();
        controller.getRecordType();
        controller.profileName = 'SRV - Process Author';
        controller.getRecordType();
        controller.profileName = 'SRV - SBSA Authors';
        controller.getRecordType();
        controller.profileName = 'SRV - Product Documentation Team';
        controller.getRecordType();
        controller.isPatchSel = true;
        boolean test = controller.isPatchSel;
        
        for(String recName : mapOfRecIdName.keySet()) {
            System.currentpagereference().getparameters().put('RecordType',mapOfRecIdName.get(recName));
            controller.redirectToPage();
        }
        controller.recordName = 'General Article';
        
        controller.rId = mapOfRecIdName.get('General Article');
        controller.getRecordType(); 
        controller.saveArticle(); 
        sol.Change_Status_12_months__c = true;
        sol.IsRunFromTestClass__c = true;
        sol.Patch_Available__c = 'No';   
        
        update sol;
        
        controller.aId = sol.Id;
        test = controller.isPatchSel;
        System.debug('aID Value >>>>>>>>>' + controller.aId);
        controller.rId = null;
         System.debug('rId Value >>>>>>>>>' + controller.rId);
        controller.getRecordType();
        system.currentpagereference().getParameters().put('id',sol.id);
        system.currentpagereference().getParameters().put('recordType',sol.RecordTypeId);
        system.currentpagereference().getparameters().put('save_new', '2');
        controller.aId = sol.Id;
        controller.recordName = 'Known Issue';
        controller.rId = mapOfRecIdName.get('Known Issue');
        sol.Change_Status_12_months__c = false;
        controller.saveArticle(); 
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId = mapOfRecIdName.get('Known Issue');
        sol.IsRunFromTestClass__c = true;
        update sol;
        
        sol.Document_Summary__c = null;
        controller.recordName = 'Product Documentation';
        controller.rId = mapOfRecIdName.get('Product Documentation');
        controller.saveArticle();       
        sol.Document_Summary__c = 'test';
        sol.Document_Details__c = null;         
        controller.saveArticle();       
        sol.Document_Details__c = 'test';
        sol.Document_Link__c = null;        
        sol.Change_Status_12_months__c = false; 
        controller.saveArticle(); 
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId= mapOfRecIdName.get('Product Documentation');
        sol.IsRunFromTestClass__c = true;
        update sol;     
        controller.recordName = 'Other Resource';       
        sol.Resource_Description__c = null;
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Resource_Description__c = 'test';
        sol.Download__c = null;
        controller.saveArticle();
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId= mapOfRecIdName.get('Other Resource');
        sol.IsRunFromTestClass__c = true;
        update sol;
        controller.recordName = 'Release';      
        sol.Upgrade_Information__c = null;
        controller.saveArticle();
        sol.Upgrade_Information__c = 'Test';
        sol.Support_Policy__c = null;
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId = mapOfRecIdName.get('Release');
        System.debug('Status >>>> ' +sol.Status);
        System.debug('RecordTypeId >>>> ' +sol.RecordTypeId);
        sol.IsRunFromTestClass__c = true;
        update sol;
        controller.recordName = 'Support Bulletin/Security Advisory';       
        sol.Product__c = null;
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Type__c = null;
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId = mapOfRecIdName.get('Support Bulletin/Security Advisory');
        sol.IsRunFromTestClass__c = true;
        update sol;
        controller.recordName = 'Supported Technologies Information';       
        sol.Platform_Technologies__c = null;
        controller.saveArticle();
        sol.Platform_Technologies__c = 'Test';
        sol.Client_Technologies__c = null;
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId = mapOfRecIdName.get('Supported Technologies Information');
        sol.IsRunFromTestClass__c = true;
        update sol;
        controller.recordName = 'Maintenance Release';      
        sol.Upgrade_Paths__c = null;
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Upgrade_Paths__c  = 'test';
        sol.Announcing__c = null;
        controller.saveArticle();
        sol.Announcing__c  = 'test';
        sol.Release_Notes__c = null;
        controller.saveArticle();
        sol.Release_Notes__c  = 'test';
        sol.Related_Resources__c = null;        
        controller.saveArticle();
        sol.Related_Resources__c  = 'test';
        sol.Accessing_the_Build__c = null;        
        controller.saveArticle();
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId = mapOfRecIdName.get('Maintenance Release');
        sol.IsRunFromTestClass__c = true;
        update sol;
        controller.recordName = 'Troubleshooting/Informational'; 
        sol.Change_Status_12_months__c = false;
        controller.saveArticle();
        sol.Change_Status_12_months__c = true;
        sol.RecordTypeId = mapOfRecIdName.get('Troubleshooting/Informational');
        sol.Product__c = 'Angel';
        sol.IsRunFromTestClass__c = true;
        update sol;       
        controller.recordName = 'Announcement';    
        controller.saveArticle();  
        controller.recordName = 'Blackboard Client Program';    
        controller.saveArticle();
        controller.recordName = 'Question/Answer';    
        controller.saveArticle(); 
        controller.recordName = 'Process/Procedure';        
        sol.Team_s__c = null;
        controller.saveArticle();       
        sol.Team_s__c = 'CE/Vista';
        sol.Process_Details__c = null;
        sol.Change_Status_12_months__c = false;
        //System.debug('solution Id 111>>>> ' +sol.Id);
        controller.saveArticle(); 
        /*sol.Change_Status_12_months__c = true;
        sol.RecordTypeId='012Q00000004Zl2'; 
        update sol;*/
        controller.saveNew = '2';
        controller.redirect = null;
        controller.profileName = 'System Administrator';
        //controller.redirectOnRights();
        controller.profileName = 'System';
        //controller.redirectOnRights();
        controller.saveNew = '1';
        controller.redirect = null;
        controller.selectPatch();
        List<SelectOption> patchListOption = controller.patchList;
        sol.status = 'In review';
        //controller.saveArticle();
        sol.status='Published';
        sol.Is_SME_Reviewed__c = false;
        sol.IsRunFromTestClass__c = true;
        update sol;
        
        for(String recName : mapOfRecIdName.keySet()) {
            System.currentpagereference().getparameters().put('RecordType',mapOfRecIdName.get(recName));
            controller.redirectToPage();
        }
        
        system.currentpagereference().getParameters().put('rid',mapOfRecIdName.get('General Article')); 
    
 ApexPages.StandardController stdcon1 = new ApexPages.StandardController(sol);
        BBW_CreateArticle controller1 = new BBW_CreateArticle(stdcon1);  
        controller1.recordName = 'General Article';
        sol.Symptoms__c =s + s ;        
        controller1.saveArticle();
        sol.Cause__c =s + s ;        
        controller1.saveArticle();
        sol.Best_Practice_Information__c =s + s ;        
        controller1.saveArticle();
        sol.Resolution_Workaround__c =s + s ;        
        controller1.saveArticle();
        sol.Patch_Comments__c =s + s ;        
        controller1.saveArticle();
        sol.Internal_Only_Notes__c =s + s ;        
        controller1.saveArticle();
        controller1.recordName = 'Known Issue';
        sol.Symptoms__c =s + s ;        
        controller1.saveArticle();
        sol.Cause__c =s + s ;        
        controller1.saveArticle();
        sol.Best_Practice_Information__c =s + s ;        
        controller1.saveArticle();
        sol.Resolution_Workaround__c =s + s ;        
        controller1.saveArticle();
        sol.Patch_Comments__c =s + s ;        
        controller1.saveArticle();
        sol.Internal_Only_Notes__c =s + s ;        
        controller1.saveArticle();
        sol.Steps_to_Reproduce__c =s + s ;        
        controller1.saveArticle();
        controller1.recordName = 'Announcement';
        sol.Announcement_Detail__c =s + s ;        
        controller1.saveArticle();
        controller1.recordName = 'Troubleshooting/Informational';
        sol.How_is_the_component_designed_to_work__c =s + s ;        
        controller1.saveArticle();
        sol.Files_collection_to_troubleshoot_cpnent__c =s + s ;        
        controller1.saveArticle();
        sol.Evaluation_of_logs_information__c =s + s ;        
        controller1.saveArticle();
        sol.Causes_of_the_common_issues_with_this_cp__c =s + s ;        
        controller1.saveArticle();
        sol.Resources_use_to_troubleshoot_this_cp__c =s + s ;        
        controller1.saveArticle();
        sol.Internal_Only_Notes__c =s + s ;        
        controller1.saveArticle();
        controller1.recordName = 'Process/Procedure';
        sol.Process_Flow__c =s + s ;        
        controller1.saveArticle();
        controller1.recordName = 'Support Bulletin/Security Advisory';
        sol.Bulletin_Advisory_Information__c =s + s ;        
        controller1.saveArticle();
        sol.Internal_Only_Notes__c =s + s ;        
        controller1.saveArticle();
        sol.Patch_Comments__c =s + s ;        
        controller1.saveArticle();
       controller1.recordName = 'Other Resource';
        sol.Important_Information__c =s + s ;        
        controller1.saveArticle();
        sol.Resource_Link__c =s + s ;        
        controller1.saveArticle();
        sol.Download__c=s + s ;        
        controller1.saveArticle();
       controller1.recordName = 'Release';
        sol.Product_Documentation_New__c =s + s ;        
        controller1.saveArticle();
        sol.Upgrade_Paths__c =s + s ;        
        controller1.saveArticle();
        sol.Reference_Material__c=s + s ;        
        controller1.saveArticle();
        sol.Other_Information__c =s + s ;        
        controller1.saveArticle();
        sol.Download__c=s + s ;        
        controller1.saveArticle();   
        controller1.recordName = 'Maintenance Release';
        sol.Accessing_the_Build__c =s + s ;        
        controller1.saveArticle();
        sol.Related_Resources__c =s + s ;        
        controller1.saveArticle();
        sol.Release_Notes__c=s + s ;        
        controller1.saveArticle();
        sol.Announcing__c =s + s ;        
        controller1.saveArticle();
        sol.Upgrade_Paths__c=s + s ;        
        controller1.saveArticle(); 
       controller1.recordName = 'Blackboard Client Program';
        sol.Field_1__c =s + s ;        
        controller1.saveArticle();
        sol.Field_2__c =s + s ;        
        controller1.saveArticle();
        sol.Field_3__c=s + s ;        
        controller1.saveArticle();
        sol.Field_4__c =s + s ;   
       controller1.recordName = 'Question/Answer';
        sol.Question__c =s + s ;        
        controller1.saveArticle();
        sol.Answer__c =s + s ;        
        controller1.saveArticle();
        sol.Internal_Only_Notes__c=s + s ;        
        controller1.saveArticle();        
}
}