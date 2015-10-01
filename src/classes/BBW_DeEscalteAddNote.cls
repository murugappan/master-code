public with sharing class BBW_DeEscalteAddNote{

    public Case objCase;
    public string SubjectValue{get;set;}
    public boolean errorShow{get;set;}
    public String errorTitle{get;set;}
    public String errorMessage{get;set;} 
    public String errorSeverity{get;set;}
    public Boolean closeWin {get;set;} 
    public string UserComment{ get; set; }
    public string UserSubject{get; set;}

    public PageReference DeEscalateInfo(){
        errorShow=false;
        if(UserComment==Null || UserComment=='')
        {
             errorTitle = 'Updating Error!';
             errorMessage = 'User Comment field is required.  Please add a comment.';
             errorSeverity = 'error';
             errorShow = true;            
             return null;
        }
        else if(SubjectValue==Null || SubjectValue=='')
        {
             errorTitle = 'Updating Error!';
             errorMessage = 'Subject field is required.  Please add a subject.';
             errorSeverity = 'error';
             errorShow = true;            
             return null;
        }
        System.debug(ApexPages.currentPage().getParameters().get('id'));
        objCase=[select Id,Previous_Owner__c,Primary_Group_Name__c,IsEscalated,Escalated_Tier_3__c,Escalated_Tier_2__c from Case where id =: ApexPages.currentPage().getParameters().get('id')];
        if(objCase.Escalated_Tier_3__c == false && objCase.Escalated_Tier_2__c == false && objCase.Previous_Owner__c == null){
             errorTitle = 'Updating Error!';
             errorMessage = 'Case can not be de-escalated since it is already in level 1';
             errorSeverity = 'error';
             errorShow = true;            
             return null;
        }else if(objCase.Escalated_Tier_3__c == true){
             String ownID;
             List<String> oId = new List<String>();
             if(objCase.Previous_Owner__c != null){
                  oId  = objCase.Previous_Owner__c.split(';',-1);
             }
             if(oID != null && oID.size() == 2)
             {
                 objCase.OwnerID = oID[1];
             objCase.Previous_Owner__c = oID[0];
             objCase.Escalated_Tier_3__c = false;

               }  
             else if(oID!=null && oID.size()==1)
             {
             objCase.OwnerID=oID[0];
             objCase.Escalated_Tier_3__c = false;
             objCase.Escalated_Tier_2__c = false;
             objCase.isEscalated = false;

            // objCase.Previous_Owner
             }
                          objCase.status='De-escalated';
             update objCase;
             closeWin=true;
        }else if(objCase.Escalated_Tier_2__c == true){
             String ownID;
             List<String> oId = new List<String>();
             if(objCase.Previous_Owner__c != null){
                 oId = objCase.Previous_Owner__c.split(';',-1);
             }
             if(oID != null && oID.size() == 1)
                 objCase.OwnerID = oID[0];
             else if(oID != null && oID.size() == 2)   
             objCase.OwnerID = oID[1]; 
             objCase.Previous_Owner__c = ' ';
             objCase.Escalated_Tier_2__c = false;
             objCase.isEscalated = false;
             objCase.status='De-escalated';
             update objCase;
             closeWin=true;
        }else if(objCase.Escalated_Tier_2__c == false && objCase.Previous_Owner__c != null){
             String ownID;
             List<String> oId = new List<String>();
             if(objCase.Previous_Owner__c != null){
                 oId = objCase.Previous_Owner__c.split(';',-1);
             }
             if(oID != null && oID.size() == 1)
                 objCase.OwnerID = oID[0];
             else if(oID != null && oID.size() == 2)   
             objCase.OwnerID = oID[1]; 
             objCase.Previous_Owner__c = ' ';
             objCase.Escalated_Tier_2__c = false;
             objCase.isEscalated = false;
             objCase.status='De-escalated';
             update objCase;
             closeWin=true;
        }
        
        Case_Note__c Note = new Case_Note__c();
        Note.Type__c = 'De-Escalated';
        Note.Details__c = UserComment;
        Note.Public__c = false;
        Note.Case__c = ApexPages.currentPage().getParameters().get('id');
        insert Note;   
  
        return null;        
    }
    
    public BBW_DeEscalteAddNote(ApexPages.StandardController controller) {
            SubjectValue='De-Escalation Note';
            errorShow = false;
            errorTitle = '';
            errorMessage = '';
            UserSubject='New Note Added';
            errorSeverity = ''; 
            if(closeWin != true)
                closeWin=false;
    }
}