public with sharing class BBW_CasePrimaryGroup{
        public String GroupName{ get; set; }
        public string UserComment{ get; set; }
        Case theCase {get;set;}
        public id Caseid;
        public boolean errorShow{ get; set; }
        public String errorTitle{ get; set; }
        public String errorMessage{ get; set; } 
        public String errorSeverity{ get; set; } 
        public Boolean closeWin {get;set;} 
   
  
    public PageReference ChangePrimaryGroup() 
    {
        try{
               
                theCase.Primary_Group_Name__c = GroupName;
                System.debug(theCase);
            
                update theCase;  
                closeWin=true;   
                
                Case_Note__c note = new Case_Note__c();
                note.Case__c = Caseid;
                note.Public__c = false;
                note.From_Type__c = 'Employee';
                note.Details__c = 'Support Case handed off to <b>' + theCase.Primary_Group_Name__c + '</b><br/>' + UserComment;
                note.Type__c = 'Primary Group Assignment';

                insert note; 
           
         /*errorTitle = 'Update.';
                 errorMessage = 'Case owner has been updated successfully.';
                 errorSeverity = 'confirm';
                 errorShow = true;*/            
                 return null;
            }       
            catch (Exception e){
                  system.debug('Atul-----------' + e.getMessage());
                  errorTitle = 'Updating Error!';
                  errorMessage = e.getMessage();
                  errorSeverity = 'error';
                  errorShow = true;            
                  return null;
            }
    } 
    public BBW_CasePrimaryGroup(ApexPages.StandardController controller) {
        theCase = (Case)controller.getRecord(); 
        Caseid = System.currentPageReference().getParameters().get('id');
        theCase = [select Id,Primary_Group_Name__c from Case where Id =: Caseid];
        errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
            if(closeWin!=true) 
        closeWin=false;
    }
    public List<SelectOption> getQueueName() {
                List<SelectOption> optionsFieldName = new List<SelectOption>();
                List<Group> ListGroupName=new List<Group>(); 
                String qryString;
                qryString='Select g.Name, g.Id From Group g where type=\'Queue\' ORDER BY g.Name'; 
                //qryString='Select g.Name, g.Id From Group g ;
                ListGroupName=Database.query(qryString );
                /*for(Group G1 : ListGroupName)
                {
                        optionsFieldName.Add(new SelectOption(G1.Id,G1.Name));
                }*/
                for(List<Group> grp  : [select Name,Type,(Select SobjectType From QueueSobjects where SobjectType='Case') from Group where Type = 'Queue' ORDER BY Name]){
                    for(Group g1 : grp){
                        if(!g1.QueueSobjects.isEmpty())
                        {
                            optionsFieldName.add(new SelectOption(g1.Name,g1.Name));
                        }
                        /*QueueSobject QsB=g1.QueueSobjects;
                        system.debug('------------------>>>>' + QsB.SobjectType);
                        if(QsB.SobjectType!=null && QsB.SobjectType!='')
                        {                       
                            optionsFieldName.add(new SelectOption(g1.Name,g1.Name));
                        }*/
                    }               
                }
                return optionsFieldName;
        }
}