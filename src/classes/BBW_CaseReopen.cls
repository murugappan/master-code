public without sharing class BBW_CaseReopen{
        
        public string UserComment{ get; set; }
        public String ReasonforReopen {get;set;}
        public Case theCase {get;set;}
        public id Caseid;
        public boolean errorShow{ get; set; }
        public String errorTitle{ get; set; }
        public String errorMessage{ get; set; } 
        public String errorSeverity{ get; set; } 
        public Boolean closeWin {get;set;}
        public Boolean chkExternal{ get; set; }
        public Boolean tempExcalation;
        
        public PageReference SaveOwner() {
            try{
                errorShow = false;
                system.debug('aaaa');
                if(UserComment==Null || UserComment==''){
                    errorShow = true;
                    errorTitle = 'Updating Error!';
                    errorMessage = 'User Comment should not be blank.';
                  errorSeverity = 'error';
                  return null;
                }
                theCase.Status='Reopened';
            //    theCase.Portal_Status__c='Work In Progress';  
                theCase.Reopen_comment__c = UserComment;   
                theCase.Case_Reopened__c = true;
                theCase.Reopened_Time__c = System.now();    
                system.debug('cccc');
                if(tempExcalation)
                {
                    theCase.IsEscalated=true;   
                }
                
                Case_Note__c note = new Case_Note__c();
                note.Case__c = Caseid;
                note.Details__c = 'Reason for Reopening : ' + theCase.Reason_for_Reopen__c + '\n\n\n\n' +UserComment;
                note.Type__c = 'Case Reopened';
                note.From_Type__C = 'Employee';
                note.Public__c = chkExternal;
                
                insert note;                    
                update theCase;                         
                closeWin=true;                
                   
                 return null;
            }       
            catch (Exception e){                  
                  errorTitle = 'Updating Error!';
                  errorMessage = e.getMessage();
                  errorSeverity = 'error';
                  errorShow = true;            
                  return null;
            }
    } 
    public BBW_CaseReopen(ApexPages.StandardController controller) {
        theCase = (Case)controller.getRecord(); 
        Caseid = System.currentPageReference().getParameters().get('id');
        theCase=[Select Reason_for_Reopen__c,Customer_Portal_Status__c,Status,IsEscalated,Escalated_Tier_2__c,Escalated_Tier_3__c from Case where Id=:Caseid ];
        theCase.Reason_for_Reopen__c = null;
        Case tempCase=[Select Reason_for_Reopen__c,Escalated_Tier_2__c,Escalated_Tier_3__c from Case where id=:Caseid ];
        if(tempCase.Escalated_Tier_2__c || tempCase.Escalated_Tier_3__c)
            tempExcalation=true;
        else
            tempExcalation=false;
        errorShow = false;
        errorTitle = '';
        errorMessage = '';            
        errorSeverity = ''; 
        if(closeWin!=true) {
            closeWin=false;
      }
    }
 }