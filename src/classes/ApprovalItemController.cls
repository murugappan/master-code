public with sharing class ApprovalItemController 
{

    public String relatedRecordId {get;set;}
    public String RecordId {get;set;}
    //public String caseID {get; set;}  
    
    public String urlStr{     
    get  
    {  
     return generateApprovalURL(relatedRecordId);  
    }
    }
    public String stepname{
    get
    {
        return associatedStepname(RecordId );
    }
    }  
    Public Static String associatedStepname(String recordID)
    {
        String stepname='';
        List<ProcessInstanceNode> pinstepname = [SELECT Id,ProcessInstanceId,ProcessNodeName,ProcessNodeid,NodeStatus from ProcessInstanceNode where processInstance.TargetObjectId =:recordId and NodeStatus = 'Pending'];
        If(pinstepname.size() > 0)
        {
            stepname=pinstepname[0].ProcessNodeName;
        }
        return stepname;
    }
    
    public static String generateApprovalURL(String recordID)  
    {  
      String url='';  
        
      List<ProcessInstanceWorkitem> workItemLst = [ SELECT id FROM ProcessInstanceWorkitem  WHERE processInstance.TargetObjectId=:recordID];   
      If(workItemLst.size() > 0)  
      {  
        
        url='https://'+ System.URL.getSalesforceBaseUrl().getHost() +   
          '/p/process/ProcessInstanceWorkitemWizardStageManager?id=' + workItemLst[0].id;      
      }  
      return url;  
    } 

    
}