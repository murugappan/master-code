public with sharing class BBW_CreateArticle {
    
    private final Solution solution; 
    public String recordName { get; set; }
    public boolean errorShow;
    public String errorTitle;
    public String errorMessage;
    public String errorSeverity; 
    public String profileName { get; set; }   
    public String redirect {get; set;}    
    public String saveNew {get; set;}
    Map<Id, String>  mapOfRecIdName = new Map<Id, String>();  
        
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
    
    public BBW_CreateArticle(ApexPages.StandardController controller) {
         this.solution = (Solution)controller.getRecord();
         Profile profileObj = [Select Name, Id From Profile where Id = : UserInfo.getprofileId()];
         profileName = profileObj.Name; 
         if(ApexPages.currentPage().getparameters().get('redirect') != null) {
            redirect = ApexPages.currentPage().getparameters().get('redirect');
         }        
         
         if(ApexPages.currentPage().getparameters().get('save_new') != null) {
            saveNew = ApexPages.currentPage().getparameters().get('save_new');
         }  
         for(RecordType recType : [select Id, Name from RecordType where sobjectType='Solution'])
        {
            
            mapOfRecIdName.put(recType.Id,recType.Name);
        }
        if(ApexPages.currentPage().getparameters().get('RecordType') != null)
             this.solution.recordTypeId = ApexPages.currentPage().getparameters().get('RecordType'); 
            
    }
    
     public List<SelectOption> patchList { 
        get { 
            List<SelectOption> patchList = new List<SelectOption>();
            patchList.add(new SelectOption('','-None-'));
            patchList.add(new SelectOption('No','No'));
            patchList.add(new SelectOption('Yes','Yes'));              
            return patchList;
        }
        set;
    }
    
    public String patchValue { get; set; }
    
    public PageReference selectPatch() {
        return null;    
    }
    
    public Boolean isPatchSel {
        get {
                
                if(Solution.Patch_Available__c == 'Yes')       
                    return true;
                else
                    return false;
        }
        set;
    }
    
    public String getRecordType() { 
       
        if(aId == null && rId == null) {
            
            Profile profileObj = [Select Name, Id From Profile where Id = : UserInfo.getprofileId()];
            if(profileObj.Name == 'SRV - Process Author') {
                
                RecordType recordTypeObj = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Solution' And Name = 'Process/Procedure'];
                rId = recordTypeObj.Id;
            } else if(profileObj.Name == 'SRV - SBSA Authors') {
                
                RecordType recordTypeObj = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Solution' And Name = 'Support Bulletin/Security Advisory'];
                rId = recordTypeObj.Id;
            } else if(profileObj.Name == 'SRV - Product Documentation Team') {
                
                RecordType recordTypeObj = [Select SobjectType, Name, Id From RecordType where SobjectType = 'Solution' And Name = 'Product Documentation'];
                rId = recordTypeObj.Id;
            } else {
                if(ApexPages.currentPage().getparameters().get('RecordType') != null)
                    rId = ApexPages.currentPage().getparameters().get('RecordType');                
            }
                                
        }
            
        RecordType recType;
        if(rId == null && aId != null) {
            Solution sol = [Select Id, RecordTypeId From Solution where Id = :aId];
            rid = sol.RecordTypeId;        
            
        }
            
        if(rId != null)
            recType = [Select Name, Id From RecordType where Id = :rId];//'012Q00000004YU5']
            
        if(null != recType) {
            recordName = recType.Name;
            return recType.Name;
        }
        return '';
    }
    
    /* Action method for navigating the user to Article detail page. */
    public PageReference saveArticle() {
        
        String errorField;
        PageReference detailPage;        
        String tempString;
        Integer sizeFlag = 0;
        if(recordName.equals('General Article')) {     
        
        	if(null != solution.Symptoms__c) {
            	tempString =  solution.Symptoms__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Symptoms';  
            	}
             }
             if(null != solution.Cause__c) {
            	tempString =  solution.Cause__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Cause';  
            	}
             }
             if(null != solution.Best_Practice_Information__c) {
            	tempString =  solution.Best_Practice_Information__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Best Practice Information';  
            	} 
             }
             if(null != solution.Resolution_Workaround__c) {
            	tempString =  solution.Resolution_Workaround__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Resolution/Workaround';  
            	}
             }	
             if(null != solution.Patch_Comments__c) {
            	tempString =  solution.Patch_Comments__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Patch Comments';  
            	}  
             }
             if(null != solution.Internal_Only_Notes__c) {
            	tempString =  solution.Internal_Only_Notes__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Internal Only Notes';  
            	}  
             }	
            detailPage = new PageReference('/apex/BBW_GeneralDetailArticle');
        } else if(recordName.equals('Known Issue')) {
            
            
        	 if(null != solution.Symptoms__c) {
            	tempString =  solution.Symptoms__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Symptoms';  
            	}  
             }
             if(null != solution.Cause__c) {
            	tempString =  solution.Cause__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Cause';  
            	}
             }
             if(null != solution.Best_Practice_Information__c) {
            	tempString =  solution.Best_Practice_Information__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Best Practice Information';  
            	}
             }
             if(null != solution.Resolution_Workaround__c) {
            	tempString =  solution.Resolution_Workaround__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Resolution/Workaround';  
            	} 
             }	
             if(null != solution.Patch_Comments__c) {
            	tempString =  solution.Patch_Comments__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Patch Comments';  
            	}
            }
             if(null != solution.Internal_Only_Notes__c) {
            	tempString =  solution.Internal_Only_Notes__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Internal Only Notes';  
            	}  
             }
             if(null != solution.Steps_to_Reproduce__c) {
            	tempString =  solution.Steps_to_Reproduce__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Step to Replicate';  
            	}  
             }            
             
            detailPage = new PageReference('/apex/BBW_KnownIssueDetailArticle');
        } else if(recordName.equals('Announcement')) {
            
            
            //Check for field length
            if(null != solution.Announcement_Detail__c) {
            	tempString =  solution.Announcement_Detail__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Announcement Detail';  
            	}  
            }
             if(null != solution.Related_Link_s__c) {
            	tempString =  solution.Related_Link_s__c;
            	if(tempString.length() > 255) {
            		sizeFlag = 2;
            		errorField = 'Related Link';  
            	} 
            }         
			            
            detailPage = new PageReference('/apex/BBW_AnnouncementDetailArticle');
        } else if(recordName.equals('Troubleshooting/Informational')) {  

            if(null != solution.How_is_the_component_designed_to_work__c) {
            	tempString =  solution.How_is_the_component_designed_to_work__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Introduction';  
            	}  
             }
             if(null != solution.Files_collection_to_troubleshoot_cpnent__c) {
            	tempString =  solution.Files_collection_to_troubleshoot_cpnent__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Functionality';  
            	}  
             }
             if(null != solution.Evaluation_of_logs_information__c) {
            	tempString =  solution.Evaluation_of_logs_information__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Related System Information';  
            	}  
             }
             if(null != solution.Causes_of_the_common_issues_with_this_cp__c) {
            	tempString =  solution.Causes_of_the_common_issues_with_this_cp__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Evaluating Related System Information';  
            	}  
             }	
             if(null != solution.Resources_use_to_troubleshoot_this_cp__c) {
            	tempString =  solution.Resources_use_to_troubleshoot_this_cp__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Common Issues';  
            	}  
             }
             if(null != solution.Internal_Only_Notes__c) {
            	tempString =  solution.Internal_Only_Notes__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Internal Only Notes';  
            	}  
             }
            
            detailPage = new PageReference('/apex/BBW_DetailArticle');               
        } else if(recordName.equals('Process/Procedure')) {
            
            if(solution.Team_s__c == null)          
                errorField = 'Team';
            if(solution.Process_Details__c == null || solution.Process_Details__c == '')
                errorField = 'Process Detail'; 
             
            if(null != solution.Process_Flow__c) {
            	tempString =  solution.Process_Flow__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Process Flow';  
            	} 
             }	
             if(null != solution.Process_Details__c) {
            	tempString =  solution.Process_Details__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Process Details';  
            	}  
             }    
            detailPage = new PageReference('/apex/BBW_ProcessProcedureDetailArticle');     
                
        } else if(recordName.equals('Support Bulletin/Security Advisory')) {
            
            if(solution.Type__c == null)          
                errorField = 'Type';
             if(solution.Product__c == null)
                errorField = 'Product';
             if(solution.Bulletin_Advisory_Information__c == null || solution.Bulletin_Advisory_Information__c == '' )
                errorField = 'Bulletin/Advisory Information';   
                
             if(null != solution.Bulletin_Advisory_Information__c) {
            	tempString =  solution.Bulletin_Advisory_Information__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Bulletin/Advisory Information';  
            	}
             }	
             if(null != solution.Internal_Only_Notes__c) {
            	tempString =  solution.Internal_Only_Notes__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Internal Only Notes';  
            	}
             }
             if(null != solution.Patch_Comments__c) {
            	tempString =  solution.Patch_Comments__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Patch Comments';  
            	}
             }   
                
             detailPage = new PageReference('/apex/BBW_SBSADetailArticle');         
                
        } else if(recordName.equals('Other Resource')) {
            
            if(solution.Resource_Description__c == null || solution.Resource_Description__c == '')          
                errorField = 'Resource Description';  
            
            if(null != solution.Resource_Description__c) {
            	tempString =  solution.Resource_Description__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Resource Description';  
            	}
             }
             if(null != solution.Important_Information__c) {
            	tempString =  solution.Important_Information__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Important Information';  
            	}
             }
             if(null != solution.Resource_Link__c) {
            	tempString =  solution.Resource_Link__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Resource Link';  
            	}
             }
             if(null != solution.Download__c) {
            	tempString =  solution.Download__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Download';  
            	}
             }
            detailPage = new PageReference('/apex/BBW_OtherResourceDetailArticle');                      
            
        } else if(recordName.equals('Product Documentation')) {
            
          
             if(solution.Document_Summary__c == null || solution.Document_Summary__c == '')
                errorField = 'Document Summary';          
			 if(null != solution.Document_Summary__c) {
            	tempString =  solution.Document_Summary__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Document Summary';  
            	}
             }
             if(null != solution.Document_Details__c) {
            	tempString =  solution.Document_Details__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Document Details';  
            	}
             }
             if(null != solution.Document_Link__c) {
            	tempString =  solution.Document_Link__c;
            	if(tempString.length() > 255) {
            		sizeFlag = 2;
            		errorField = 'Document Link';  
            	}
             }
            detailPage = new PageReference('/apex/BBW_ProductDocDetailArticle');
            
        } else if(recordName.equals('Release')) {
            
            if(solution.Upgrade_Information__c == null || solution.Upgrade_Information__c == '')
                errorField = 'About';
            else if(solution.Download__c == null || solution.Download__c == '')
                errorField = 'Download';
            
            //Check length should not more than 32768
            if(null != solution.Upgrade_Information__c) {
            	tempString =  solution.Upgrade_Information__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'About';  
            	}
         	}
         	if(null != solution.Product_Documentation_New__c) {
        		tempString =  solution.Product_Documentation_New__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Highlights';  
            	}
         	}
        	if(null != solution.Upgrade_Paths__c) {
	        	tempString =  solution.Upgrade_Paths__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Upgrade Paths';  
            	}  
         	}
         	if(null != solution.Reference_Material__c) {
            	tempString =  solution.Reference_Material__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Reference Material';  
            	}
         	}
         	if(null != solution.Other_Information__c) {
        		tempString =  solution.Other_Information__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Support Policy';  
            	}
         	}
        	if(null != solution.Download__c) {
	        	tempString =  solution.Download__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Download';  
            	}
         	}
             
            detailPage = new PageReference('/apex/BBW_ReleaseDetailArticle');
                
        } else if(recordName.equals('Maintenance Release')) {
            
			if(solution.Upgrade_Paths__c == null || solution.Upgrade_Paths__c == '')
				errorField = 'Upgrade Paths';
			else if(solution.Announcing__c == null || solution.Announcing__c == '')
				errorField = 'Announcing';
			else if(solution.Release_Notes__c == null || solution.Release_Notes__c == '')
			   errorField = 'Release Highlights';
			else if(solution.Related_Resources__c == null || solution.Related_Resources__c == '')
			   errorField = 'Related Resources'; 
			else if (solution.Accessing_the_Build__c == null || solution.Accessing_the_Build__c == '')
                errorField = 'Accessing the Build';          
            
            //Check length should not more than 32768    
            if(null != solution.Accessing_the_Build__c) {
            	tempString =  solution.Accessing_the_Build__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Accessing the Build';  
            	} 
         	}
         	if(null != solution.Related_Resources__c) {
        		tempString =  solution.Related_Resources__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Related Resources';  
            	}
         	}
        	if(null != solution.Release_Notes__c) {
	        	tempString =  solution.Release_Notes__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Release Highlights';  
            	}
         	}
         	if(null != solution.Announcing__c) {
            	tempString =  solution.Announcing__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Announcing';  
            	}
         	}
         	if(null != solution.Upgrade_Paths__c) {
        		tempString =  solution.Upgrade_Paths__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Upgrade Paths';  
            	}
         	}    
            detailPage = new PageReference('/apex/BBW_ServicePackDetailArticle');
             
        } else if(recordName.equals('Supported Technologies Information')) {    
            
            if(solution.Platform_Technologies__c == null || solution.Platform_Technologies__c == '')
                errorField = 'Platform Technologies';
          
            else if(solution.Client_Technologies__c == null || solution.Client_Technologies__c == '')
                errorField = 'Client Technologies';  
            
            //check length  should not more than 32768  
            if(null != solution.Platform_Technologies__c) {
            	tempString =  solution.Platform_Technologies__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Platform Technologies';  
            	}
         	}
         	if(null != solution.Client_Technologies__c) {
        		tempString =  solution.Client_Technologies__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Client Technologies';  
            	}
         	}
        	if(null != solution.Upgrade_Paths__c) {
	        	tempString =  solution.Upgrade_Paths__c;
	        	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Upgrade Paths';  
            	}
         	}    
            
            detailPage = new PageReference('/apex/BBW_SupportedTechDetailArticle');               
        }else if(recordName.equals('Blackboard Client Program')) {             
            
            //Check for field length
            if(null != solution.Field_1__c) {
            	tempString =  solution.Field_1__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Field 1';  
            	}
            }
            if(null != solution.Field_2__c) {
            	tempString =  solution.Field_2__c;
            if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Field 2';  
            	}
            }
            if(null != solution.Field_3__c) {
            	tempString =  solution.Field_3__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Field 3';  
            	}
            }
            if(null != solution.Field_4__c) {
            	tempString =  solution.Field_4__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Field 4';  
            	}
            } 
            detailPage = new PageReference('/apex/BBW_BCProgramDetailArticle');    
            
        } else if(recordName.equals('Question/Answer')) { 
        	
        	
        	if(null != solution.Question__c) {
            	tempString =  solution.Question__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Question';  
            	}
            }
            if(null != solution.Answer__c) {
            	tempString =  solution.Answer__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Answer';  
            	}
            }
            if(null != solution.Internal_Only_Notes__c) {
            	tempString =  solution.Internal_Only_Notes__c;
            	if(tempString.length() > 32768) {
            		sizeFlag = 1;
            		errorField = 'Internal Only Notes';  
            	}
            } 
            
            detailPage = new PageReference('/apex/BBW_QADetailArticle');    
        }
        
        if(errorField != null) {
            
            if(sizeFlag == 1) {
            	
	            errorTitle = 'Insertion Error!';
	            errorMessage = errorField + ' value exceed the limit of 32768 ';
	            errorSeverity = 'error';
	            errorShow = true;
            } else if(sizeFlag == 2) {
            	
            	errorTitle = 'Insertion Error!';
	            errorMessage = errorField + ' value exceed the limit of 255 ';
	            errorSeverity = 'error';
	            errorShow = true;
            } else {
	            errorTitle = 'Insertion Error!';
	            errorMessage = 'Please Enter ' + errorField + ' value';
	            errorSeverity = 'error';
	            errorShow = true;  
            }         
            return null;
        }
      if(solution.status=='Published')
      {
      solution.last_updated__c= system.today();	
      } 
        solution.RecordTypeId = rId;
        if(solution.id != null) 
            update solution;
        else {
            solution.Status = 'Draft';
            insert solution ;
        }
        
        detailPage.getParameters().put('Id', solution.Id);
        detailPage.getParameters().put('RecordType', rId);
        detailPage.getParameters().put('redirect', 'true');
        detailPage.setRedirect(true);
        return detailPage; 
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
    /*Method will check logged in user profile and match with article record type then 
    ** redirect create Article page otherwise will redirect to detail page on the basis of record type 
    */
    public PageReference redirectToPage() { 
    
        string recordName = mapOfRecIdName.get(rid);
        PageReference createPage = new PageReference('501/o');      
        if(solution.Id == null) {
            
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
            createPage.getParameters().put('RecordType', rId);
            createPage.setRedirect(true);
            return createPage;
        } else if(solution != null && solution.Id != null) {         
            Integer adminFlag = 0;
            
            if(profileName.equals('System Administrator')|| profileName.equals('SRV - System Administrator')
                || profileName.equals('SRV - KM Administrators') || profileName.equals('SRV - APAC User - KM')
                || profileName.equals('SRV - KM USR - Publisher'))
                    adminFlag = 1;
                    
            if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && profileName.equals('SRV - Process Author'))) && recordName.equals('Process/Procedure')) {
                
                createPage = new PageReference('/apex/BBW_ProcessProcedureCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review')) 
                && recordName.equals('Question/Answer')) {
                
                createPage = new PageReference('/apex/BBW_QACreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && profileName.equals('SRV - SBSA Authors'))) && recordName.equals('Support Bulletin/Security Advisory')) {
                
                createPage = new PageReference('/apex/BBW_SBSACreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && profileName.equals('SRV - Maintenance Experience Team'))) && recordName.equals('Release')) { 
            
                createPage = new PageReference('/apex/BBW_ReleaseCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && profileName.equals('SRV - Process Author'))) && recordName.equals('Product Documentation')) { 
            
                createPage = new PageReference('/apex/BBW_ProductDocCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && (profileName.equals('SRV - Client Ops') || profileName.equals('SRV - Service Manager') 
                || profileName.equals('SRV - Support Tech')))) && recordName.equals('General')) { 
            
                createPage = new PageReference('/apex/BBW_GeneralCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && (profileName.equals('SRV - Maintenance Experience Team') || profileName.equals('SRV - Client Ops')
                || profileName.equals('SRV - Service Manager') || profileName.equals('SRV - Support Tech')))) 
                && recordName.equals('Annoncement')) { 
            
                 createPage = new PageReference('/apex/BBW_AnnouncementCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && (profileName.equals('SRV - Client Ops') || profileName.equals('SRV - Service Manager') 
                || profileName.equals('SRV - Support Tech')))) && recordName.equals('Troubleshooting/Informational')) { 
            
                createPage = new PageReference('/apex/BBW_TSGCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review'))
                && recordName.equals('Known Issue')) { 
            
                createPage = new PageReference('/apex/BBW_KnownIssueCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && profileName.equals('SRV - Maintenance Experience Team'))) && recordName.equals('Maintenance Release')) { 
            
                 createPage = new PageReference('/apex/BBW_ServicePackCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review' 
                && profileName.equals('SRV - Maintenance Experience Team'))) && recordName.equals('Supported Technologies Information')) { 
            
                createPage = new PageReference('/apex/BBW_SupportedTechCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review')) 
                && recordName.equals('Other Resource')) { 
            
                 createPage = new PageReference('/apex/BBW_OtherResourceCreateArticle');
            } else if((adminFlag == 1 || (solution.status !='Published' && solution.status != 'In review')) 
                && recordName.equals('Blackboard Client Program')) { 
            
                 createPage = new PageReference('/apex/BBW_BCProgramCreateArticle');
            } else {
                
                if(recordName.equals('Announcement')) {
            
                createPage = new PageReference('/apex/BBW_AnnouncementDetailArticle');
                              
                } else if(recordName.equals('Known Issue')) {
                    
                    createPage = new PageReference('/apex/BBW_KnownIssueDetailArticle');
                    
                } else if(recordName.equals('Other Resource')) {
                
                    createPage = new PageReference('/apex/BBW_OtherResourceDetailArticle');
                    
                } else if(recordName.equals('Process/Procedure')) {
                
                    createPage = new PageReference('/apex/BBW_ProcessProcedureDetailArticle');
                    
                } else if(recordName.equals('Product Documentation')) {
                    
                    createPage = new PageReference('/apex/BBW_ProductDocDetailArticle');
                   
                } else if(recordName.equals('Question/Answer')) {
                
                    createPage = new PageReference('/apex/BBW_QADetailArticle');
                   
                } else if(recordName.equals('Release')) {
                    
                    createPage = new PageReference('/apex/BBW_ReleaseDetailArticle');
                   
                } else if(recordName.equals('Maintenance Release')) {
                
                    createPage = new PageReference('/apex/BBW_ServicePackDetailArticle');
                    
                } else if(recordName.equals('General Article')) {
                
                    createPage = new PageReference('/apex/BBW_GeneralDetailArticle');
                   
                } else if(recordName.equals('Support Bulletin/Security Advisory')) {
                
                    createPage = new PageReference('/apex/BBW_SBSADetailArticle');
                   
                } else if(recordName.equals('Supported Technologies Information')) {
                
                    createPage = new PageReference('/apex/BBW_SupportedTechDetailArticle');
                    
                } else if(recordName.equals('Troubleshooting/Informational')) {
                
                    createPage = new PageReference('/apex/BBW_TSGDetailArticle');
                    
                } else if(recordName.equals('Blackboard Client Program')) {
                
                    createPage = new PageReference('/apex/BBW_BCProgramDetailArticle');
                    
                }               
            }   
            createPage.getParameters().put('Id', solution.Id);
            createPage.getParameters().put('RecordType', rId);
            createPage.setRedirect(true);
            return createPage;       
        }        
        return null;
                
    }
    
}