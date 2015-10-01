public  class BBW_DetailArticle {

    private final Solution solution; 
    Profile profileObj;
    public String recordName { get; set; }
    public String redirect {get; set;}
    public Integer KISize {get; set;}
    public Integer RKISize {get; set;}
    public Integer RPSize {get; set;}
    public Integer STSize {get; set;}
    public Transient List<Solution> results;
    public  List<Solution> resultsKI = new List<Solution>();
    
    //for Error show on page
    
    public boolean errorShow;
    public String errorTitle;
    public String errorMessage;
    public String errorSeverity; 
    public String profileName { get; set; }
    public  RecordType recType; 
    
    //Added by Shirish 0n 26 july 11
    public Integer size {get; set;}
    public AWSKeys credentials {get;set;}
    private String AWSCredentialName = 'Amazon Connection'; 
    public string secret { get {return credentials.secret;} }
    public string key { get {return credentials.key;} }
    public S3.AmazonS3 as3 { get; private set; }
    
    // Added by Dominic on April 23, 2012
    public String siteDomain {get{return SalesforceAttributes.getSiteDomain();} private set;} 
    
    //public Boolean IsResult {get; set; }     
    public void setErrorTitle(String errorTitle) {
        this.errorTitle = errorTitle;
    }
    public String getErrorTitle() {
        return this.errorTitle;
    }
    
    public void setErrorShow(boolean errorShow) {
        this.errorShow = errorShow;
    }
    public boolean getErrorShow() {
        return this.errorShow;
    }       
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    public String getErrorMessage() {
        return this.errorMessage;
    }   
    
    public void setErrorSeverity(String errorSeverity) {
        this.errorSeverity = errorSeverity;
    }
    public String getErrorSeverity() {
        return this.errorSeverity;
    }
   
    public BBW_DetailArticle(ApexPages.StandardController controller) {
         System.debug(URL.getCurrentRequestUrl().toExternalForm());
         ArticleCategory articleCategory = new ArticleCategory();
         this.solution = (Solution)controller.getRecord();
         aId = solution.Id;
         rId = solution.RecordTypeId;
         //System.debug('rId >>>>>>>>> ' + rid);
        
         if(rid != null) {
            recType = [Select Name, Id From RecordType where Id = :rId];
            recordName = recType.Name;  
         }
         ////System.debug('solution.RecordType >>>>>>>>> ' + solution.RecordType);
         
         redirect = ApexPages.currentPage().getParameters().get('redirect');
         //IsResult = true;
         //Added by Shirish on 26 july 11 for Attachment
         try{
            credentials = new AWSKeys (AWSCredentialName);
            as3 = new S3.AmazonS3(credentials.key,credentials.secret);
         }catch(AWSKeys.AWSKeysException AWSEx){
             //System.debug('Caught exception ' + AWSEx);
             ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
             ApexPages.addMessage(errorMsg);
         }
         //Added by Shirish on 26 july 11 for Attachment
        profileObj = [Select Name, Id From Profile where Id = : UserInfo.getprofileId()];
    }
    
    public List<ArticleCategory> getArticleCategories() {
        List<CategoryNode> categoryNodeList = new List<CategoryNode>();
        List<ArticleCategory> articleCategoryList = new List<ArticleCategory>();
        Map<Id, Id> mapofCatDataIdOfCatNodeId = new Map<Id, Id>();
        if(null != solution && solution.Id != null) {
                
            List<id> cateNodeIdList = new List<id>();
            //List<CategoryData> categoryDataList = [Select RelatedSobjectId,IsDeleted, Id, CategoryNodeId From CategoryData where  RelatedSobjectId = :solution.Id and IsDeleted = false];
            for(CategoryData catData : [Select RelatedSobjectId,IsDeleted, Id, CategoryNodeId From CategoryData where  RelatedSobjectId = :solution.Id and IsDeleted = false]) {
                    
                //cateNodeIdList.add(catData.CategoryNodeId);
                mapofCatDataIdOfCatNodeId.put(catData.CategoryNodeId, catData.Id);
                
            }
            //System.debug('Map Values>>>>>>' + mapofCatDataIdOfCatNodeId);
            if(mapofCatDataIdOfCatNodeId.size() > 0) {
                ArticleCategory articleCategory = new ArticleCategory();
                categoryNodeList = [Select ParentId, MasterLabel, Id From CategoryNode c where Id IN :mapofCatDataIdOfCatNodeId.keySet()];
                
                for(CategoryNode catNode: categoryNodeList) {
                        
                    articleCategory = new ArticleCategory(mapofCatDataIdOfCatNodeId.get(catNode.Id), catNode.Id, catNode.MasterLabel);
                    articleCategory.categoryId = catNode.Id;
                    articleCategory.categoryNodeId = mapofCatDataIdOfCatNodeId.get(catNode.Id);
                    articleCategory.categoryName = catNode.MasterLabel;
                    articleCategoryList.add(articleCategory);
                }
            }
        }
        //System.debug('articleCategoryList size >>>>>>' + articleCategoryList.size());
        return articleCategoryList;
    }
    
    public String getRecordType() { 
        
        //System.debug('aId >>>>>>> ' + aId);
        //System.debug('rId >>>>>>> ' + rId);
        if(aId == null && rId == null)
            return '';
        RecordType recType;
        if(rId == null && aId != null) {
            Solution sol = [Select Id, RecordTypeId From Solution where Id = :aId];
            rid = sol.RecordTypeId;        
            
        }
        //System.debug('rId >>>>>>> 2 ' + rId);    
        if(rId != null)
            recType = [Select Name, Id From RecordType where Id = :rId];//'012Q00000004YU5']
            
       
        //System.debug('recType >>>>>>> ' + recType);    
        if(null != recType) {
            recordName = recType.Name;
            return recType.Name;
        }
        return '';
    }
    
    //will redirect to edit page
    public PageReference EditArticle() {
        
        //If Article already clone will not allow to edit that
        if(solution.iscopy__c == true) {
            Solution cloneSol = [select Link__c,id from Solution where ParentId__c = :solution.id Limit 1];
            errorTitle = 'Insertion Error!';
            errorMessage = 'This article is being edited. To see the draft version of this published article follow this link:'+ cloneSol.Link__c + cloneSol.Id;
            //errorMessage = 'This article is being edited. To see the draft version of this published article follow this link:'+ solution.Link__c + cloneSol.Id;
            errorSeverity = 'error';
            errorShow = true;  
            return null;            
        }
        PageReference createPage = new PageReference('501/o');
        if(recordName.equals('Announcement')) {
            
                createPage = new PageReference('/apex/BBW_AnnouncementCreateArticle');
                              
            } else if(recordName.equals('Known Issue')) {
                
                createPage = new PageReference('/apex/BBW_KnownIssueCreateArticle');
                
            } else if(recordName.equals('Other Resource')) {
            
                createPage = new PageReference('/apex/BBW_OtherResourceCreateArticle');
                
            } else if(recordName.equals('Process/Procedure')) {
            
                createPage = new PageReference('/apex/BBW_ProcessProcedureCreateArticle');
                
            } else if(recordName.equals('Product Documentation')) {
                
                createPage = new PageReference('/apex/BBW_ProductDocCreateArticle');
               
            } else if(recordName.equals('Question/Answer')) {
            
                createPage = new PageReference('/apex/BBW_QACreateArticle');
               
            } else if(recordName.equals('Release')) {
                
                createPage = new PageReference('/apex/BBW_ReleaseCreateArticle');
               
            } else if(recordName.equals('Maintenance Release')) {
            
                createPage = new PageReference('/apex/BBW_ServicePackCreateArticle');
                
            } else if(recordName.equals('General Article')) {
            
                createPage = new PageReference('/apex/BBW_GeneralCreateArticle');
               
            } else if(recordName.equals('Support Bulletin/Security Advisory')) {
            
                createPage = new PageReference('/apex/BBW_SBSACreateArticle');
               
            } else if(recordName.equals('Supported Technologies Information')) {
            
                createPage = new PageReference('/apex/BBW_SupportedTechCreateArticle');
                
            } else if(recordName.equals('Troubleshooting/Informational')) {
            
                createPage = new PageReference('/apex/BBW_TSGCreateArticle');
                
            } else if(recordName.equals('Blackboard Client Program')) {
            
                createPage = new PageReference('/apex/BBW_BCProgramCreateArticle');
                
            }
        createPage.getParameters().put('Id', solution.Id);
        createPage.getParameters().put('RecordType', rId);
        
        createPage.setRedirect(true);
        return createPage; 
    }
    
    /*Method will check logged in user profile and match with article record type then 
    ** redirect detail page on the basis of record type 
    */
    public PageReference redirectToPage() { 
    
        string recordName = getRecordType();
        PageReference detailPage;        
        if(solution.Id != null) {
        
         
        profileName = profileObj.Name; 
        if(profileName.contains('BTBB')) {
            detailPage = new PageReference('/apex/btbb_articleview');
            detailPage.getParameters().put('Id', solution.id);                          
            detailPage.setRedirect(true);
            return detailPage; 
        }
           else{
            if(recordName.equals('Announcement')) {
        
                detailPage = new PageReference('/apex/BBW_AnnouncementDetailArticle');
                          
            } else if(recordName.equals('Known Issue')) {
                
                detailPage = new PageReference('/apex/BBW_KnownIssueDetailArticle');
                
            } else if(recordName.equals('Other Resource')) {
            
                detailPage = new PageReference('/apex/BBW_OtherResourceDetailArticle');
                
            } else if(recordName.equals('Process/Procedure')) {
            
                detailPage = new PageReference('/apex/BBW_ProcessProcedureDetailArticle');
                
            } else if(recordName.equals('Product Documentation')) {
                
                detailPage = new PageReference('/apex/BBW_ProductDocDetailArticle');
               
            } else if(recordName.equals('Question/Answer')) {
            
                detailPage = new PageReference('/apex/BBW_QADetailArticle');
               
            } else if(recordName.equals('Release')) {
                
                detailPage = new PageReference('/apex/BBW_ReleaseDetailArticle');
               
            } else if(recordName.equals('Maintenance Release')) {
            
                detailPage = new PageReference('/apex/BBW_ServicePackDetailArticle');
                
            } else if(recordName.equals('General Article')) {
            
                detailPage = new PageReference('/apex/BBW_GeneralDetailArticle');
               
            } else if(recordName.equals('Support Bulletin/Security Advisory')) {
            
                detailPage = new PageReference('/apex/BBW_SBSADetailArticle');
               
            } else if(recordName.equals('Supported Technologies Information')) {
            
                detailPage = new PageReference('/apex/BBW_SupportedTechDetailArticle');
                
            } else if(recordName.equals('Troubleshooting/Informational')) {
            
                detailPage = new PageReference('/apex/BBW_TSGDetailArticle');
                
            } else if(recordName.equals('Blackboard Client Program')) {
            
                detailPage = new PageReference('/apex/BBW_BCProgramDetailArticle');
                
            }
            detailPage.getParameters().put('Id', solution.Id);
            detailPage.getParameters().put('RecordType', rId);
            detailPage.setRedirect(true);
            return detailPage;
            }       
        }        
        return null;
                
    }
   
    //Will check if cloned article published then redirect to original article and delete the cloned article
    public PageReference originalArticle() {
        //System.debug('solution.summary__c >>>>>>>>>'+solution.summary__c);
        if(solution.Isrejected__c == 1) {
            
            for(ProcessInstance approval : [Select p.TargetObjectId,p.Status, p.LastModifiedDate, (Select  StepStatus, ActorId, Comments From StepsAndWorkitems where Comments != null and ActorId = :userInfo.getUserId() order by Comments) From ProcessInstance p where p.TargetObjectId = :solution.Id order by p.LastModifiedDate DESC LIMIT 1]) {
              
                List<ProcessInstanceHistory> procInstList = approval.StepsAndWorkitems;//new List<ProcessInstanceHistory>();
                if(null != procInstList && procInstList.size() > 0) {
                    
                    solution.Approval_Comments__c = procInstList[0].comments;
                    solution.Approver_Name__c = userInfo.getName();
                    solution.Isrejected__c = 2;
                   
                }
            }   
            update solution;
        }
        
        
        profileName = profileObj.Name; 
        if(profileName.equalsIgnoreCase('SRV – BTBB User')) {
            PageReference detailPage = new PageReference('/apex/btbb_articleview');
            detailPage.getParameters().put('Id', solution.id);                          
            detailPage.setRedirect(true);
            return detailPage; 
        }
        //if copy article loaded and if its already published or archived then redirect to original article
        if(solution.ParentId__c != null && (solution.Status == 'Published' || solution.Status == 'Archived')) {
            //System.debug('<<<<<<<<<<<  In originalArticle >>>>>>>>>>>>>>>> ');
            
            //PageReference detailPage = new PageReference('/apex/BBW_DetailArticle');
            PageReference detailPage;                
            
            if(recordName.equals('Announcement')) {
        
                detailPage = new PageReference('/apex/BBW_AnnouncementDetailArticle');
                          
            } else if(recordName.equals('Known Issue')) {
                
                detailPage = new PageReference('/apex/BBW_KnownIssueDetailArticle');
                
            } else if(recordName.equals('Other Resource')) {
            
                detailPage = new PageReference('/apex/BBW_OtherResourceDetailArticle');
                
            } else if(recordName.equals('Process/Procedure')) {
            
                detailPage = new PageReference('/apex/BBW_ProcessProcedureDetailArticle');
                
            } else if(recordName.equals('Product Documentation')) {
                
                detailPage = new PageReference('/apex/BBW_ProductDocDetailArticle');
               
            } else if(recordName.equals('Question/Answer')) {
            
                detailPage = new PageReference('/apex/BBW_QADetailArticle');
               
            } else if(recordName.equals('Release')) {
                
                detailPage = new PageReference('/apex/BBW_ReleaseDetailArticle');
               
            } else if(recordName.equals('Maintenance Release')) {
            
                detailPage = new PageReference('/apex/BBW_ServicePackDetailArticle');
                
            } else if(recordName.equals('General Article')) {
            
                detailPage = new PageReference('/apex/BBW_GeneralDetailArticle');
               
            } else if(recordName.equals('Support Bulletin/Security Advisory')) {
            
                detailPage = new PageReference('/apex/BBW_SBSADetailArticle');
               
            } else if(recordName.equals('Supported Technologies Information')) {
            
                detailPage = new PageReference('/apex/BBW_SupportedTechDetailArticle');
                
            } else if(recordName.equals('Troubleshooting/Informational')) {
            
                detailPage = new PageReference('/apex/BBW_TSGDetailArticle');
                
            } else if(recordName.equals('Blackboard Client Program')) {
            
                detailPage = new PageReference('/apex/BBW_BCProgramDetailArticle');
                
            }
            detailPage.getParameters().put('Id', solution.ParentId__c);
            detailPage.getParameters().put('RecordType', rId);                
            detailPage.setRedirect(true);
            return detailPage; 
        //if original article loaded and if it's copy is already published or archived then copy will be deleted 
        }else if(solution.iscopy__c == true) {
                
            //System.debug('<<<<<<<<<<<  Clone Article >>>>>>>>>>>>>>>> ');
            List<Solution> solutionList = [Select Id, SolutionName, ParentId__c, Status From Solution where ParentId__c = :solution.id];
            if(solutionList.size() > 0) {
                if(solutionList[0].Status == 'Published' || solutionList[0].Status == 'Archived') {
                        
                    //List<ProcessInstance> ProcessInstances = solutionList[0].ProcessInstances;
                    //insert ProcessInstances;                    
                    delete solutionList[0];                                           
                }
            }
        }
        return null;
    }
    
    //will create the clone of original article if article is already published
     public PageReference CloneArticle() {
        
        //Variable is created for clone solution
        Solution cloneSol = new Solution();
        //System.debug('Record Type Name  >>>>>>' + recordName);
        if(recordName == 'General Article' || recordName == 'Known Issue' || recordName == 'Question/Answer') {
                
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;
                cloneSol.Version_s__c = solution.Version_s__c;
                cloneSol.Major_Release__c = solution.Major_Release__c;
                cloneSol.Cause__c = solution.Cause__c;
                cloneSol.Best_Practice_Information__c = solution.Best_Practice_Information__c;
                //cloneSol.Disclaimer__c = solution.Disclaimer__c;        
                cloneSol.Issue_Description__c = solution.Issue_Description__c;
                cloneSol.Patch_Available__c = solution.Patch_Available__c;
                cloneSol.Patch_Versions__c = solution.Patch_Versions__c;                
                //cloneSol.Patch_Comments__c = solution.Patch_Comments__c;
                if(recordName.equals('Question/Answer')) {
                    cloneSol.Question__c = solution.Question__c;
                    cloneSol.Answer__c = solution.Answer__c;
                }
                cloneSol.Symptoms__c = solution.Symptoms__c;
                cloneSol.Resolution_Workaround__c = solution.Resolution_Workaround__c;
                cloneSol.Internal_Only_Notes__c = solution.Internal_Only_Notes__c;
                cloneSol.Patch_Comments__c = solution.Patch_Comments__c; 
                cloneSol.Support_Incident__c = solution.Support_Incident__c;                
                if(recordName.equals('Known Issue')){ 
                        cloneSol.Steps_to_Reproduce__c = solution.Steps_to_Reproduce__c;
                        
                }
                cloneSol.Number_of_Clients_Reporting__c = solution.Number_of_Clients_Reporting__c;      
                
                
        } else if(recordName == 'Troubleshooting/Informational') {
                //System.debug('<<<<<<<   In Troubleshooting/Informational  >>>>>>');
                cloneSol.SolutionName = solution.SolutionName; 
                cloneSol.Product__c = solution.Product__c;
                cloneSol.Version_s__c = solution.Version_s__c;
                cloneSol.Major_Release__c = solution.Major_Release__c;
                //cloneSol.Disclaimer__c = solution.Disclaimer__c;        
                cloneSol.How_is_the_component_designed_to_work__c = solution.How_is_the_component_designed_to_work__c;
                cloneSol.Resources_use_to_troubleshoot_this_cp__c = solution.Resources_use_to_troubleshoot_this_cp__c; 
                cloneSol.Evaluation_of_logs_information__c = solution.Evaluation_of_logs_information__c;
                cloneSol.Files_collection_to_troubleshoot_cpnent__c = solution.Files_collection_to_troubleshoot_cpnent__c;      
                cloneSol.Causes_of_the_common_issues_with_this_cp__c = solution.Causes_of_the_common_issues_with_this_cp__c;
                cloneSol.Internal_Only_Notes__c = solution.Internal_Only_Notes__c;            
                
        } else if(recordName == 'Process/Procedure') {
                
                cloneSol.SolutionName = solution.SolutionName;       
               // cloneSol.Product__c = solution.Product__c;        
                cloneSol.Team_s__c = solution.Team_s__c;
                cloneSol.Process_Flow__c = solution.Process_Flow__c;
                cloneSol.Process_Details__c = solution.Process_Details__c;              
                
        } else if(recordName == 'Support Bulletin/Security Advisory') {
                
                cloneSol.Type__c = solution.Type__c; 
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;                
                cloneSol.Bulletin_Advisory_Information__c = solution.Bulletin_Advisory_Information__c;
                cloneSol.Internal_Only_Notes__c = solution.Internal_Only_Notes__c;                
                cloneSol.Patch_Available__c = solution.Patch_Available__c; 
                cloneSol.Patch_Comments__c = solution.Patch_Comments__c;               
        } else if(recordName == 'Other Resource') {
                //System.debug('<<<<<<<   In Other Resources  >>>>>>');
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;        
                cloneSol.Resource_Description__c = solution.Resource_Description__c;
                cloneSol.Important_Information__c = solution.Important_Information__c;
                cloneSol.Resource_Link__c = solution.Resource_Link__c;
                cloneSol.ResourceType__c = solution.ResourceType__c;
                cloneSol.Download__c = solution.Download__c;               
        } else if(recordName == 'Product Documentation') {
                
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;
                cloneSol.Version_s__c = solution.Version_s__c;
                cloneSol.Major_Release__c = solution.Major_Release__c;        
                cloneSol.Document_Summary__c = solution.Document_Summary__c;
                cloneSol.Document_Details__c = solution.Document_Details__c;
                cloneSol.Document_Link__c = solution.Document_Link__c; 
                cloneSol.Document_Type__c = solution.Document_Type__c;                         
        } else if(recordName == 'Release') {
                
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;
                //cloneSol.Version_s__c = solution.Version_s__c;
                cloneSol.Major_Release__c = solution.Major_Release__c;      
                cloneSol.Other_Information__c = solution.Other_Information__c;
                cloneSol.Available_Versions__c = solution.Available_Versions__c;
                cloneSol.Upgrade_Information__c = solution.Upgrade_Information__c;   
                //Commented for issue 1567 cloneSol.Product_Documentation__c = solution.Product_Documentation__c;
                cloneSol.Download__c = solution.Download__c;
                cloneSol.Upgrade_Paths__c = solution.Upgrade_Paths__c;
                cloneSol.Reference_Material__c = solution.Reference_Material__c;
                cloneSol.Product_Documentation_New__c = solution.Product_Documentation_New__c;
                cloneSol.Support_Policy__c = solution.Support_Policy__c;                    
        }else if(recordName == 'Blackboard Client Program') {
                        
                        System.debug('<<<<<<<   In Blackboard Client Program  >>>>>>');
                        cloneSol.SolutionName = solution.SolutionName;       
                        cloneSol.Product__c = solution.Product__c;
                        cloneSol.Field_1__c = solution.Field_1__c;
                        cloneSol.Field_2__c = solution.Field_2__c;    
                        cloneSol.Field_3__c = solution.Field_3__c;
                        cloneSol.Field_4__c = solution.Field_4__c;                                 
         }else if(recordName == 'Maintenance Release') {
                
                cloneSol.SolutionName = solution.SolutionName;      
                cloneSol.Product__c = solution.Product__c;
                cloneSol.Version_s__c = solution.Version_s__c;
                cloneSol.Release_Date__c = solution.Release_Date__c;
                cloneSol.Major_Release__c = solution.Major_Release__c;        
                //cloneSol.Download__c = solution.Download__c;
                cloneSol.Upgrade_Paths__c = solution.Upgrade_Paths__c;
                cloneSol.Announcing__c = solution.Announcing__c;
                cloneSol.Related_Resources__c = solution.Related_Resources__c;
                cloneSol.Accessing_the_Build__c = solution.Accessing_the_Build__c;
                cloneSol.Release_Notes__c = solution.Release_Notes__c;
                cloneSol.Supported_Technologies__c = solution.Supported_Technologies__c;    
                cloneSol.Resolved_Issues__c = solution.Resolved_Issues__c;
                cloneSol.Known_Issues__c = solution.Known_Issues__c;                     
        } else if(recordName == 'Supported Technologies Information') {
                
                //System.debug('<<<<<<<   In Supported Technologies Information  >>>>>>');
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;
                cloneSol.Version_s__c = solution.Version_s__c;
                cloneSol.Major_Release__c = solution.Major_Release__c;    
                cloneSol.Platform_Technologies__c = solution.Platform_Technologies__c;
                cloneSol.Client_Technologies__c = solution.Client_Technologies__c;
                cloneSol.Upgrade_Paths__c = solution.Upgrade_Paths__c;                  
        } else if(recordName == 'Announcement') {
                    
                cloneSol.SolutionName = solution.SolutionName;       
                cloneSol.Product__c = solution.Product__c;        
                cloneSol.Announcement_Detail__c = solution.Announcement_Detail__c;
                cloneSol.Related_Link_s__c = solution.Related_Link_s__c;                
        }
        if(recordName != 'Process/Procedure') {
            cloneSol.Visible_in_Customer_Portal__c = solution.Visible_in_Customer_Portal__c;
            cloneSol.Visible_in_Partner_Portal__c = solution.Visible_in_Partner_Portal__c;
            cloneSol.IsPublishedInPublicKb = solution.IsPublishedInPublicKb;
        }
        cloneSol.IsRunFromTestClass__c = solution.IsRunFromTestClass__c;
        cloneSol.summary__c = solution.summary__c;        
        cloneSol.RecordTypeId = solution.RecordTypeId;
        cloneSol.ParentId__c = solution.Id;
        cloneSol.Status = 'Draft';
        
        insert cloneSol;
        //System.debug('cloneSol  >>>>>>' + cloneSol.Id);
        List<CategoryData> categoryDataList = new List<CategoryData>();
        CategoryData categoryData;
        //CategoryData categoryData = [Select RelatedSobjectId, IsDeleted,Id, CategoryNodeId From CategoryData where RelatedSobjectId = :solution.Id];
        for(CategoryData catData : [Select RelatedSobjectId,IsDeleted, Id, CategoryNodeId From CategoryData where  RelatedSobjectId = :solution.Id and IsDeleted = false]) {
                //System.debug('In Data Category Loop  >>>>>>' + catData.CategoryNodeId);
                categoryData = new categoryData();
                categoryData.RelatedSobjectId = cloneSol.Id;
                categoryData.CategoryNodeId = catData.CategoryNodeId;
                categoryDataList.add(categoryData);     
                
        }
        //System.debug('categoryDataList Size  >>>>>>' + categoryDataList.size());
        if(categoryDataList.size() > 0)
                insert categoryDataList;
        solution.iscopy__c = true;
        update solution;
        PageReference createPage;
        if(recordName.equals('Announcement')) {            
                createPage = new PageReference('/apex/BBW_AnnouncementCreateArticle');                              
            } else if(recordName.equals('Known Issue')) {                
                createPage = new PageReference('/apex/BBW_KnownIssueCreateArticle');                
            } else if(recordName.equals('Other Resource')) {            
                createPage = new PageReference('/apex/BBW_OtherResourceCreateArticle');                
            } else if(recordName.equals('Process/Procedure')) {            
                createPage = new PageReference('/apex/BBW_ProcessProcedureCreateArticle');                
            } else if(recordName.equals('Product Documentation')) {                
                createPage = new PageReference('/apex/BBW_ProductDocCreateArticle');               
            } else if(recordName.equals('Question/Answer')) {            
                createPage = new PageReference('/apex/BBW_QACreateArticle');               
            } else if(recordName.equals('Release')) {                
                createPage = new PageReference('/apex/BBW_ReleaseCreateArticle');               
            } else if(recordName.equals('Maintenance Release')) {            
                createPage = new PageReference('/apex/BBW_ServicePackCreateArticle');                
            } else if(recordName.equals('General Article')) {            
                createPage = new PageReference('/apex/BBW_GeneralCreateArticle');              
            } else if(recordName.equals('Support Bulletin/Security Advisory')) {            
                createPage = new PageReference('/apex/BBW_SBSACreateArticle');              
            } else if(recordName.equals('Supported Technologies Information')) {            
                createPage = new PageReference('/apex/BBW_SupportedTechCreateArticle');                
            } else if(recordName.equals('Troubleshooting/Informational')) {            
                createPage = new PageReference('/apex/BBW_TSGCreateArticle');                
            } else if(recordName.equals('Blackboard Client Program')) {            
                createPage = new PageReference('/apex/BBW_BCProgramCreateArticle');                
            }  
        //PageReference createPage = new PageReference('/apex/CreateArticle');
        createPage.getParameters().put('Id', cloneSol.Id);
        createPage.getParameters().put('RecordType', rId);
        
        createPage.setRedirect(true);
        return createPage; 
    }
    
    public PageReference selectCategory() {
        
        PageReference categoryPage = new PageReference('/ui/category/CategoryTreeMultiSelectPage?');
            categoryPage.getParameters().put('pid', solution.Id);
        categoryPage.getParameters().put('retURL', solution.Id);
        categoryPage.setRedirect(true);
        return categoryPage; 
    }
    
     public PageReference deleteCategory() {
      
      return null; 
    }
    
    public void CustomerView() {
        /*PageReference PortalView = new PageReference('/apex/btbb_articleview');
        PortalView.getParameters().put('id', solution.Id);
        PortalView.setRedirect(true);
        return PortalView;  */        
    }
    
    public PageReference DeleteArticle() {
        
        
        delete solution;
        PageReference homePage = new PageReference('/501/o');
                
        homePage.setRedirect(true);
        return homePage; 
        
        //return new ApexPages.StandardController(c).view();
    }
        
    public Id rId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('RecordType') != null) {
                rId = ApexPages.currentPage().getparameters().get('RecordType');
            }
            return rId;
        }
        set { 
            if(value != null) rId = value;
        }
    }
    public Id aId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('Id') != null) {
                aId = ApexPages.currentPage().getparameters().get('Id');
            }
            return aId;
        }
        set { 
            if(value != null) aId = value;
        }
    }
    
    class ArticleCategory {
        
        public Id categoryId { get; set; }
        public Id categoryNodeId { get; set; }
        public String categoryName { get; set; } 
        public ArticleCategory(){}
        public ArticleCategory(Id categoryId, Id categoryNodeId, String categoryName) {
                
                this.categoryId   = categoryId;
                this.categoryName = categoryName;
                this.categoryNodeId = categoryNodeId;       
                }
    }
        
    class Article{
        public Id articleId { get; set; }
        public String SolutionNumber { get; set; }
        public String SolutionName { get; set; }
        public Date ReleaseDate { get; set; }
        public String Major { get; set; }
        public String Versions { get; set; }
        public String categoriesName { get; set; }
        public String IssueDescription { get; set; }
        public String TargetFixRelease { get; set; }
        public String PatchAvailable { get; set; }
        public Article(){} 
    }
    List<Article> articleList;
    
    public List<Article> getKIArticleList()
    {
      articleList = new List<Article>();
      Article article = new Article();
      String[] majorReleaseArray;
      String[] versionArray;
      if(recordName.equals('Maintenance Release') || recordName.equals('Release')) {
          results = new List<Solution>();          
          results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and status='Published' Order by Number_of_Clients_Reporting__c DESC ];
          
          System.debug('results>>>>>>>>>>>>> '+ results.size());
          
         /* if(null != results && results.size() > 0) {
                Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
                
                if(solution.Major_Release__c != null) 
                    majorReleaseArray = solution.Major_Release__c.split(';',-1);
                if(recordName.equals('Maintenance Release') && solution.Version_s__c != null) 
                    versionArray = solution.Version_s__c.split(';',-1);
                
                System.debug('majorReleaseArray >>>>>>>>>>>>' +majorReleaseArray);
                System.debug('versionArray >>>>>>>>>>>>' +versionArray);
                //tempSolList = results;
                //results = new List<Solution>();
                if(recordName.equals('Release')) {
                                
                    for(Solution sol : results) {
                        
                        if(null != majorReleaseArray) {
                            for(String major : majorReleaseArray) {
                            
                                if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major)) {
                                    tempSolMap.put(sol.Id,sol);
                                    break;
                                    //results.add(sol);
                                }
                            }
                        }
                    }
                } else {
                    
                    for(Solution sol : results) {
                        
                        if(null != majorReleaseArray) {
                            for(String major : majorReleaseArray) {
                                
                                if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major)) {
                                    if(null != versionArray) {
                                        for(String version : versionArray) {
                                            
                                            if(null != sol.Version_s__c && sol.Version_s__c.contains(version)) {
                                                tempSolMap.put(sol.Id,sol);
                                                break;      //if one version match then break the loop
                                            }
                                        }
                                        //if one major release match then break the loop
                                        break;
                                    }
                                }
                            }
                        }                       
                    }
                }
                if(tempSolMap.size() > 0)
                    results = tempSolMap.values();
                else
                    results = new List<Solution>();
          } */
          if(null != results && results.size() > 0) {              
            
            Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         

            for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                            ORDER BY MasterLabel DESC]) {            
                //will add value in to map
                mapOfCatNodeWithId.put(catNode.Id, catNode);
              
            }
            //IsResult = true;    //Result Found
            //Map variable store the list of CategoryData on the basis of solution Id
            Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
            //Set variable store the solution ids
            Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
            List<CategoryData> catDataList = new List<CategoryData>();
            CategoryNode catNode;
            String categoryName = '';
            Set<Id> cateTopNodeIdSet = new Set<Id>(); 
            Set<Id> cateNodeIdSet = new Set<Id>();
            Set<Id> tempCateNodeIdSet = new Set<Id>(); 
            //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
             
            
            articleList = new List<Article>(); 
            Solution solObj;
            
            for(Solution sol : results) {
                    
                    //solIdSet.add(sol.id);
                    mapOfSolutionWithId.put(sol.id, sol);
            }
            //System.debug('mapOfSolutionWithId >>>>>>>> ' + mapOfSolutionWithId.size());
            for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                    //System.debug('catData.RelatedSobjectId >>>>>>>>1 ' +catData.RelatedSobjectId);
                    if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 2' +catData.RelatedSobjectId);
                            catDataList = new List<CategoryData>();  
                            catDataList.add(catData);                       
                            mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                    } else {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 3' +catData.RelatedSobjectId);
                            mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                    }                       
            }
            //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
            for(Id id : mapOfDataCatWithSol.keySet()) {
                    //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                    article = new Article();
                    cateTopNodeIdSet = new set<id>();
                    cateNodeIdSet = new set<id>();            
                    catDataList = new List<CategoryData>();
                    //System.debug('mapOfDataCatWithSol.get(id) >>>>>>>> ' + mapOfDataCatWithSol.get(id));
                    //System.debug('mapOfDataCatWithSol.get(id) Size>>>>>>>> ' + mapOfDataCatWithSol.get(id).size());
                    for(CategoryData catData : mapOfDataCatWithSol.get(id)) {                            
                            catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);
                          
                            if(catNode.ParentId != null) {
                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                   
                                    cateNodeIdSet.add(catNode.Id); 
                            } else {
                                    cateTopNodeIdSet.add(catNode.Id);
                            }
                    }                   
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                    //Will check category till 4 level to find out the top level category
                    if(cateNodeIdSet.size() > 0) {
                                                            
                            for(Integer i = 0; i < 4; i++) {
                                    tempCateNodeIdSet = cateNodeIdSet;
                                    //System.debug('tempCateNodeIdSet values >>>>>>>> ' + tempCateNodeIdSet);
                                    //catDataList = new List<CategoryData>();
                                    cateNodeIdSet = new Set<Id>();
                                    for(Id tId : tempCateNodeIdSet) {                                            
                                            catNode = mapOfCatNodeWithId.get(tId);                                           
                                            if(catNode.ParentId != null) {
                                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);                                                   
                                                    cateNodeIdSet.add(catNode.Id);                                                     
                                            } else {
                                                    cateTopNodeIdSet.add(catNode.Id);
                                            }
                                    }
                                    if(cateNodeIdSet.size() == 0)
                                            break;
                            }
                    }
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    if(cateTopNodeIdSet.size() > 0) {
                            //article.categoriesName = '';
                            for(Id catId : cateTopNodeIdSet) {
                                catNode = mapOfCatNodeWithId.get(catId);
                                if(article.categoriesName == null) {
                                        article.categoriesName = catNode.MasterLabel;
                                } else {
                                        article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                                }
                            }
                    }
                   
                    solObj = mapOfSolutionWithId.get(id); 
                    string product = (solution.Product__c == 'Blackboard Learn'?'Learn':solution.Product__c);
                    if(article.categoriesName.contains(product)  )
                    {                             
                    article.articleId = solObj.id;
                    article.SolutionNumber=solObj.SolutionNumber;
                    article.Major=solObj.Major_Release__c; 
                    article.Versions=solObj.Version_s__c;
                    article.IssueDescription=solObj.Issue_Description__c;
                    article.PatchAvailable=solObj.Patch_Available__c;
                    article.TargetFixRelease=solObj.Target_Release_New__c;         
                    articleList.add(article);
                    }  
                    if(articleList.size() == 10)
                        break;
            } 
       } else {
            articleList = new List<Article>();
            //isResult = false;   //Result Not Found
       }
    }
        if(null != articleList && articleList.size() == 0)
            KISize = 0;
        else 
            KISize = articleList.size();
      //System.debug('articleList>>>>>>>>>>>>> '+ articleList.size());
     
      return articleList;
    }
    public List<Article> getReleasePageArticleList()
    {
      articleList = new List<Article>();
      Article article = new Article();
      String[] majorReleaseArray;

      if(recordName.equals('Release')) {

          results = new List<Solution>();          
          results = [select id,Product__c, SolutionNumber,SolutionName,Release_Date__c,Major_Release__c,Version_s__c from Solution where RecordType.Name = 'Maintenance Release' and status='Published' and Major_Release__c != null Order By Release_Date__c LIMIT 1000];
         
          //results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and  major_Release__c = :solution.Major_Release__c and Version_s__c = : solution.Version_s__c and status='Published'];
          
          System.debug('results>>>>>>>>>>>>> '+ results.size());
          
          if(null != results && results.size() > 0) {
                Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
                
                if(solution.Major_Release__c != null) 
                    majorReleaseArray = solution.Major_Release__c.split(';',-1);
                
                System.debug('majorReleaseArray >>>>>>>>>>>>' +majorReleaseArray);
              
                for(Solution sol : results) {
                
                    if(null != majorReleaseArray) {
                        for(String major : majorReleaseArray) {
                        
                            if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major) && solution.Product__c == sol.Product__c) {
                                tempSolMap.put(sol.Id,sol);
                                break;
                                //results.add(sol);
                            }
                        }
                    }
                if(tempSolMap.size() > 0)
                    results = tempSolMap.values();
                else
                    results = new List<Solution>();
                }
            
            }
            
            if(null != results && results.size() > 0) {              
            
                Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         
    
                for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                                ORDER BY MasterLabel DESC]) {            
                    //will add value in to map
                    mapOfCatNodeWithId.put(catNode.Id, catNode);
                  
                }
                //IsResult = true;    //Result Found
                //Map variable store the list of CategoryData on the basis of solution Id
                Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
                //Set variable store the solution ids
                Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
                List<CategoryData> catDataList = new List<CategoryData>();
                CategoryNode catNode;
                String categoryName = '';
                Set<Id> cateTopNodeIdSet = new Set<Id>(); 
                Set<Id> cateNodeIdSet = new Set<Id>();
                Set<Id> tempCateNodeIdSet = new Set<Id>(); 
                //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
             
            
                articleList = new List<Article>(); 
                Solution solObj;
            
                for(Solution sol : results) {
                        
                        //solIdSet.add(sol.id);
                        mapOfSolutionWithId.put(sol.id, sol);
                }
                //System.debug('mapOfSolutionWithId >>>>>>>> ' + mapOfSolutionWithId.size());
                for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                    //System.debug('catData.RelatedSobjectId >>>>>>>>1 ' +catData.RelatedSobjectId);
                    if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 2' +catData.RelatedSobjectId);
                            catDataList = new List<CategoryData>();  
                            catDataList.add(catData);                       
                            mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                    } else {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 3' +catData.RelatedSobjectId);
                            mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                    }                       
                }
                //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
                for(Id id : mapOfDataCatWithSol.keySet()) {
                    //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                    article = new Article();
                    cateTopNodeIdSet = new set<id>();
                    cateNodeIdSet = new set<id>();            
                    catDataList = new List<CategoryData>();
                    //System.debug('mapOfDataCatWithSol.get(id) >>>>>>>> ' + mapOfDataCatWithSol.get(id));
                    //System.debug('mapOfDataCatWithSol.get(id) Size>>>>>>>> ' + mapOfDataCatWithSol.get(id).size());
                    for(CategoryData catData : mapOfDataCatWithSol.get(id)) {                            
                            catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);
                          
                            if(catNode.ParentId != null) {
                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                   
                                    cateNodeIdSet.add(catNode.Id); 
                            } else {
                                    cateTopNodeIdSet.add(catNode.Id);
                            }
                    }                   
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                    //Will check category till 4 level to find out the top level category
                    if(cateNodeIdSet.size() > 0) {
                                                            
                        for(Integer i = 0; i < 4; i++) {
                                tempCateNodeIdSet = cateNodeIdSet;
                                //System.debug('tempCateNodeIdSet values >>>>>>>> ' + tempCateNodeIdSet);
                                //catDataList = new List<CategoryData>();
                                cateNodeIdSet = new Set<Id>();
                                for(Id tId : tempCateNodeIdSet) {                                            
                                        catNode = mapOfCatNodeWithId.get(tId);                                           
                                        if(catNode.ParentId != null) {
                                                catNode = mapOfCatNodeWithId.get(catNode.ParentId);                                                   
                                                cateNodeIdSet.add(catNode.Id);                                                     
                                        } else {
                                                cateTopNodeIdSet.add(catNode.Id);
                                        }
                                }
                                if(cateNodeIdSet.size() == 0)
                                        break;
                        }
                    }
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    if(cateTopNodeIdSet.size() > 0) {
                        //article.categoriesName = '';
                        for(Id catId : cateTopNodeIdSet) {
                            catNode = mapOfCatNodeWithId.get(catId);
                            if(article.categoriesName == null) {
                                    article.categoriesName = catNode.MasterLabel;
                            } else {
                                    article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                            }
                        }
                    }
                    solObj = mapOfSolutionWithId.get(id);                                
                    article.articleId = solObj.id;
                    article.SolutionNumber=solObj.SolutionNumber;
                    article.Major=solObj.Major_Release__c; 
                    article.Versions=solObj.Version_s__c;
                    article.SolutionName=solObj.SolutionName;
                    article.ReleaseDate=solObj.Release_Date__c;
                    //article.IssueDescription=solObj.Issue_Description__c;
                    //article.PatchAvailable=solObj.Patch_Available__c;
                    //article.TargetFixRelease=solObj.Target_Release_New__c;
                    articleList.add(article); 
                   // if(articleList.size() == 5)
                     //   break;
                }       
            } else {
                
                articleList =  new List<Article>(); 
            }  
        } 
        System.debug('articleList>>>>>>>>>>>>> '+ articleList);
        if(null != articleList && articleList.size() == 0)
                RPSize = 0;
        else 
                RPSize = articleList.size();     
       articleList = ArticleSort(articleList);
        return articleList;
    }
    public List<Article> getSupportTechArticleList()
    {
      articleList = new List<Article>();
      Article article = new Article();
      String[] majorReleaseArray;
      String[] versionArray;
      if(recordName.equals('Maintenance Release')) {
      //if(recordName.equals('Version Information') || recordName.equals('Product Release Information')) {
          results = new List<Solution>();          
          results = [select id,SolutionNumber,Major_Release__c,Version_s__c from Solution where RecordType.Name = 'Supported Technologies Information' and status='Published'];
         
          //results = [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c,Patch_Available__c from Solution where RecordType.Name = 'Known Issue' and  major_Release__c = :solution.Major_Release__c and Version_s__c = : solution.Version_s__c and status='Published'];
          
          System.debug('results>>>>>>>>>>>>> '+ results.size());
          
          if(null != results && results.size() > 0) {
                Map<Id, Solution> tempSolMap = new Map<Id, Solution>(); 
                
                if(solution.Major_Release__c != null) 
                    majorReleaseArray = solution.Major_Release__c.split(';',-1);
                if(solution.Version_s__c != null) 
                    versionArray = solution.Version_s__c.split(';',-1);
                
                System.debug('majorReleaseArray >>>>>>>>>>>>' +majorReleaseArray);
                System.debug('versionArray >>>>>>>>>>>>' +versionArray);
                //tempSolList = results;
                //results = new List<Solution>();       
                    
                    for(Solution sol : results) {
                        if(null != majorReleaseArray) {
                            for(String major : majorReleaseArray) {
                                
                                if(null != sol.Major_Release__c && sol.Major_Release__c.contains(major)) {
                                    if(null != versionArray) {
                                        for(String version : versionArray) {
                                            
                                            if(null != sol.Version_s__c && sol.Version_s__c.contains(version)) {
                                                tempSolMap.put(sol.Id,sol);
                                                break;      //if one version match then break the loop
                                            }
                                        }
                                    }
                                    //if one major release match then break the loop
                                    break;
                                    //results.add(sol);
                                }
                            } 
                        }                      
                    }
                
                if(tempSolMap.size() > 0)
                    results = tempSolMap.values();
                else
                    results = new List<Solution>();
          }
          if(null != results && results.size() > 0) {              
            
            Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         

            for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                            ORDER BY MasterLabel DESC]) {            
                //will add value in to map
                mapOfCatNodeWithId.put(catNode.Id, catNode);
              
            }
            //IsResult = true;    //Result Found
            //Map variable store the list of CategoryData on the basis of solution Id
            Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
            //Set variable store the solution ids
            Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
            List<CategoryData> catDataList = new List<CategoryData>();
            CategoryNode catNode;
            String categoryName = '';
            Set<Id> cateTopNodeIdSet = new Set<Id>(); 
            Set<Id> cateNodeIdSet = new Set<Id>();
            Set<Id> tempCateNodeIdSet = new Set<Id>(); 
            //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
             
            
            articleList = new List<Article>(); 
            Solution solObj;
            
            for(Solution sol : results) {
                    
                    //solIdSet.add(sol.id);
                    mapOfSolutionWithId.put(sol.id, sol);
            }
            //System.debug('mapOfSolutionWithId >>>>>>>> ' + mapOfSolutionWithId.size());
            for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                    //System.debug('catData.RelatedSobjectId >>>>>>>>1 ' +catData.RelatedSobjectId);
                    if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 2' +catData.RelatedSobjectId);
                            catDataList = new List<CategoryData>();  
                            catDataList.add(catData);                       
                            mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                    } else {
                            //System.debug('catData.RelatedSobjectId >>>>>>>> 3' +catData.RelatedSobjectId);
                            mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                    }                       
            }
            //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
            for(Id id : mapOfDataCatWithSol.keySet()) {
                    //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                    article = new Article();
                    cateTopNodeIdSet = new set<id>();
                    cateNodeIdSet = new set<id>();            
                    catDataList = new List<CategoryData>();
                    //System.debug('mapOfDataCatWithSol.get(id) >>>>>>>> ' + mapOfDataCatWithSol.get(id));
                    //System.debug('mapOfDataCatWithSol.get(id) Size>>>>>>>> ' + mapOfDataCatWithSol.get(id).size());
                    for(CategoryData catData : mapOfDataCatWithSol.get(id)) {                            
                            catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);
                          
                            if(catNode.ParentId != null) {
                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                   
                                    cateNodeIdSet.add(catNode.Id); 
                            } else {
                                    cateTopNodeIdSet.add(catNode.Id);
                            }
                    }                   
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                    //Will check category till 4 level to find out the top level category
                    if(cateNodeIdSet.size() > 0) {
                                                            
                            for(Integer i = 0; i < 4; i++) {
                                    tempCateNodeIdSet = cateNodeIdSet;
                                    //System.debug('tempCateNodeIdSet values >>>>>>>> ' + tempCateNodeIdSet);
                                    //catDataList = new List<CategoryData>();
                                    cateNodeIdSet = new Set<Id>();
                                    for(Id tId : tempCateNodeIdSet) {                                            
                                            catNode = mapOfCatNodeWithId.get(tId);                                           
                                            if(catNode.ParentId != null) {
                                                    catNode = mapOfCatNodeWithId.get(catNode.ParentId);                                                   
                                                    cateNodeIdSet.add(catNode.Id);                                                     
                                            } else {
                                                    cateTopNodeIdSet.add(catNode.Id);
                                            }
                                    }
                                    if(cateNodeIdSet.size() == 0)
                                            break;
                            }
                    }
                    //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                    if(cateTopNodeIdSet.size() > 0) {
                            //article.categoriesName = '';
                            for(Id catId : cateTopNodeIdSet) {
                                catNode = mapOfCatNodeWithId.get(catId);
                                if(article.categoriesName == null) {
                                        article.categoriesName = catNode.MasterLabel;
                                } else {
                                        article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                                }
                            }
                    }
                    solObj = mapOfSolutionWithId.get(id);                                
                    article.articleId = solObj.id;
                    article.SolutionNumber=solObj.SolutionNumber;
                    article.Major=solObj.Major_Release__c; 
                    article.Versions=solObj.Version_s__c;
                    //article.IssueDescription=solObj.Issue_Description__c;
                    //article.PatchAvailable=solObj.Patch_Available__c;
                    //article.TargetFixRelease=solObj.Target_Release_New__c;         
                    articleList.add(article);  
                    if(articleList.size() == 5)
                        break;
            } 
       } else {
            articleList = new List<Article>();
            //isResult = false;   //Result Not Found
       }
    }            
      //System.debug('articleList>>>>>>>>>>>>> '+ articleList.size());
      if(null != articleList && articleList.size() == 0)
                STSize = 0;
        else 
                STSize = articleList.size();
      return articleList;
    }
    public List<Article> getKIResolvedArticleList() {
        
        System.debug('<<<<<<<<< getKIResolvedArticleList >>>>>>>>');
        Set<String> targetReleaseSet = new Set<String>();
        Map<String, String> ServicePackTarReleaseMap = new Map<String, String>();
        List<Solution> solList = new List<Solution>(); 
        articleList = new List<Article>();
        String[] versionArray;
        if(null != recordName && recordName.equals('Maintenance Release')) {
          
            String versionTemp;
            if(solution.Version_s__c != null)
                versionArray = solution.Version_s__c.split(';',-1);
            String targetRelease;
            for(Solution solObj: [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c from Solution where RecordType.Name = 'Known Issue' and status='Published' and Target_Release_New__c != null]) {
                solList.add(solObj);                
                targetReleaseSet.add(solObj.Target_Release_New__c);
            }
            for(TargetReleaseMap__c tarRel : [Select Service_Pack__c, Name From TargetReleaseMap__c where Name IN : targetReleaseSet]) { 
                ServicePackTarReleaseMap.put(tarRel.Name, tarRel.Service_Pack__c);
            }  
            System.debug('ServicePackTarReleaseMap >>>>>>>>' + ServicePackTarReleaseMap);
            for(Solution solObj: solList) {
                    if(null != versionArray) {
                        for(String version : versionArray) {
                                
                            versionTemp = ServicePackTarReleaseMap.get(solObj.Target_Release_New__c);
                            System.debug('versionTemp >>>>>>>>' + versionTemp);
                            if(version.equals(versionTemp)) {              
                                resultsKI.add(solObj);
                                break;
                            }
                        }
                    }
                
            }                
            
            /*for(Solution solObj: [select id,SolutionNumber,Major_Release__c,Version_s__c,Issue_Description__c,Target_Release_New__c from Solution where RecordType.Name = 'Known Issue' and status='Published' and Target_Release_New__c != null]) {
                    if(null != versionArray) {
                        for(String version : versionArray) {
                            
                            versionTemp = version.replaceAll(' ', '');
                            targetRelease = solObj.Target_Release_New__c.replaceAll(' ', '');
                            if(targetRelease.contains(versionTemp) || targetRelease.equals(versionTemp)) {              
                                resultsKI.add(solObj);
                                break;
                            }
                        }
                    }
                
            } */
            //System.debug('getKIResolvedArticleList resultsKI>>>>>>>>>>>>> '+ resultsKI.size());
            if(null != resultsKI && resultsKI.size() > 0) {
                
                Map<Id, CategoryNode> mapOfCatNodeWithId = new Map<Id, CategoryNode>();         
    
                for(CategoryNode catNode : [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId FROM CategoryNode
                                                ORDER BY MasterLabel DESC]) {            
                      //will add value in to map
                        mapOfCatNodeWithId.put(catNode.Id, catNode);
                  
                }
                //IsResult = true;    //Result Found
                //Map variable store the list of CategoryData on the basis of solution Id
                Map<Id, List<CategoryData>> mapOfDataCatWithSol = new Map<Id, List<CategoryData>>();
                //Set variable store the solution ids
                Map<Id, Solution> mapOfSolutionWithId = new Map<Id, Solution>();
                List<CategoryData> catDataList;
                CategoryNode catNode;
                String categoryName = '';
                Set<Id> cateTopNodeIdSet = new Set<Id>(); 
                Set<Id> cateNodeIdSet = new Set<Id>();
                Set<Id> tempCateNodeIdSet = new Set<Id>(); 
                //List<CategoryData> tempCateDataList = new List<CategoryData>(); 
                catDataList = new List<CategoryData>();
                Article article;
                articleList = new List<Article>(); 
                Solution solObj;
                
                for(Solution sol : resultsKI) {
                        
                        //solIdSet.add(sol.id);
                        mapOfSolutionWithId.put(sol.id, sol);
                }  
                for(CategoryData catData : [Select RelatedSobjectId, CategoryNodeId From CategoryData where RelatedSobjectId  IN : mapOfSolutionWithId.keySet()]) {
                        
                        if(!mapOfDataCatWithSol.containsKey(catData.RelatedSobjectId)) {                           
                                catDataList = new List<CategoryData>();  
                                catDataList.add(catData);                       
                                mapOfDataCatWithSol.put(catData.RelatedSobjectId, catDataList);
                        } else {
                                
                                mapOfDataCatWithSol.get(catData.RelatedSobjectId).add(catData);
                        }                       
                }
                //System.debug('mapOfDataCatWithSol >>>>>>>> ' + mapOfDataCatWithSol.size());
                for(Id id : mapOfDataCatWithSol.keySet()) {
                        //System.debug('<<<<<<<<  In Map for loop >>>>>>>> ');
                        article = new Article();                       
                        catDataList = new List<CategoryData>();                   
                        for(CategoryData catData : mapOfDataCatWithSol.get(id)) {
                                
                                catNode = mapOfCatNodeWithId.get(catData.CategoryNodeId);                           
                                if(catNode.ParentId != null) {
                                        catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                        cateNodeIdSet.add(catNode.Id); 
                                } else {
                                        cateTopNodeIdSet.add(catNode.Id);
                                }
                        }
                        //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                        //System.debug('cateNodeIdSet >>>>>>>> ' + cateNodeIdSet.size());
                        //Will check category till 4 level to find out the top level category
                        if(cateNodeIdSet.size() > 0) {
                                                                
                                for(Integer i = 0; i < 4; i++) {
                                        tempCateNodeIdSet = cateNodeIdSet;
                                        cateNodeIdSet = new Set<Id>();
                                        catDataList = new List<CategoryData>();
                                        for(Id tId : tempCateNodeIdSet) {
                                                
                                                catNode = mapOfCatNodeWithId.get(tId);
                                                if(catNode.ParentId != null) {
                                                        catNode = mapOfCatNodeWithId.get(catNode.ParentId);
                                                        cateNodeIdSet.add(catNode.Id); 
                                                } else {
                                                        cateTopNodeIdSet.add(catNode.Id);
                                                }
                                        }
                                        if(cateNodeIdSet.size() == 0)
                                                break;
                                }
                        }
                        //System.debug('cateTopNodeIdSet >>>>>>>> ' + cateTopNodeIdSet.size());
                        if(cateTopNodeIdSet.size() > 0) {
                                //article.categoriesName = '';
                                for(Id catId : cateTopNodeIdSet) {
                                    catNode = mapOfCatNodeWithId.get(catId);
                                    if(article.categoriesName == null) {
                                            article.categoriesName = catNode.MasterLabel;
                                    } else {
                                            article.categoriesName = article.categoriesName + ', '+ catNode.MasterLabel;
                                    }
                                }
                        }
                        solObj = mapOfSolutionWithId.get(id);                    
                        article.articleId = solObj.id;
                        article.SolutionNumber=solObj.SolutionNumber;
                        article.Major=solObj.Major_Release__c; 
                        article.Versions=solObj.Version_s__c;
                        
                        article.IssueDescription=solObj.Issue_Description__c;
                        article.TargetFixRelease=solObj.Target_Release_New__c;
                                
                        articleList.add(article);  
                      //  if(articleList.size() == 5)
                          //  break; 
                    } 
               } else {
                    articleList = new List<Article>();
                    //isResult = false;   //Result Not Found
               }  
        }
      //System.debug('articleList>>>>>>>>>>>>> '+ articleList.size());
      if(null != articleList && articleList.size() == 0)
                RKISize = 0;
        else 
                RKISize = articleList.size();
      return articleList;
    }  
    
    //Added by Shirish 0n 26 July for attchement display with download link in table
     
     public List<Case_Attachment__c> getArticleAttach(){
        System.debug('aid value >>>>>>>>>>>>>>>>>>'+ aid);
        List<Case_Attachment__c> artattlist = new List<Case_Attachment__c>();
        
        if(aid != null)       
            artattlist = new List<Case_Attachment__c>([Select c.Id, c.File_Name_URL__c, c.Related_To_Article__c, c.Notes__c, c.File_Name__c, c.CreatedDate, c.Bucket_Name__c, c.File_Name_w_ext__c, c.CreatedBy.Name, c.CreatedById From Case_Attachment__c c where Related_To_Article__c =: aId ORDER BY CreatedDate DESC]);
        //System.debug('artattlist >>>>>>>>>' + artattlist);
        if(null == artattlist || artattlist.size() == 0)
                size = 0;
        else 
                size = artattlist.size();
        //System.debug('size >>>>>>>>>' + size);
        return artattlist; 
    } 
    
    public PageReference AddAttachment() {
        
        PageReference articleAttached = new PageReference('/apex/ArticleAttachment');
        articleAttached.getParameters().put('articleID', solution.Id);
        String urlused = URL.getCurrentRequestUrl().toExternalForm();
        if(urlused.contains('isdtp')) 
           articleAttached.getParameters().put('console', 'true');           
        else 
           articleAttached.getParameters().put('console', 'false');           
        articleAttached.setRedirect(true);
        return articleAttached;         
    }
    
    public void deleteAttachment() {
        
        //Case_Attachment__c attach = new Case_Attachment__c(Id=)
        //delete        
    }
   //Method Written on 29th Feb by Abhinav for sorting articles list by date
    public List<Article> ArticleSort(List<Article> alist){      
      
       Article temp = new Article();
            
        for(Integer i=0;i<alist.size();i++){
        
            for(Integer j=1;j<alist.size()-i;j++)
            {               
             
                if(alist[j-1].ReleaseDate < alist[j].ReleaseDate || alist[j-1].ReleaseDate == null){
                    temp = alist[j-1];
                    alist[j-1] = alist[j] ;
                    alist[j] = temp;
                }
             }
        }
        return alist;
    } 
}