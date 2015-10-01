public with sharing class BBW_CaseHandOff{
        public String GroupName{get; set;}
        public string UserComment{ get; set; }
        Case theCase {get;set;}
        public id Caseid;
        public String RecName{ get; set;} 
        Case cse {get;set;}
        public boolean errorShow{ get; set; }
        public String errorTitle{ get; set; }
        public String errorMessage{ get; set; } 
        public String errorSeverity{ get; set; } 
        public Boolean closeWin {get;set;} 
  
    public PageReference SaveOwner() 
    {
        
            try{   
            if ( usercomment != Null && !usercomment.isWhiteSpace() && usercomment != '') // Added for TP 5067
            { 
                Case CaseTemp =[Select status, id From case where Id = : (Caseid)];
                system.debug('------------------------->>>>>>>>>>' +CaseTemp.Status);
                
                if(CaseTemp.Status=='New' || CaseTemp.Status=='Assigned' || CaseTemp.Status=='Pending User' || CaseTemp.Status=='Escalating' || CaseTemp.Status=='Escalated' ||CaseTemp.Status=='Escalated'|| CaseTemp.Status=='Reopened'){
                    theCase.Status='Needs Attention';
                   // theCase.Portal_Status__c='Work In Progress';                 
                }                    
                  
                 theCase.OwnerId=GroupName; 
                 theCase.Primary_Group_Name__c = [select Id,Name from Group where ID =: GroupName].Name;
                theCase.AssignTo_Comment__C = UserComment;
                 
                Case_Note__c note = new Case_Note__c();
                note.Case__c = Caseid;
                note.Public__c = false;
                note.From_Type__c = 'Employee';
                note.Details__c = 'Support Case handed off to <b>' + theCase.Primary_Group_Name__c + '</b><br/>' + UserComment;
                note.Type__c = 'Case Hand Off';

                insert note;
                     
         update theCase; 
          
         closeWin=true;       
               
                 return null;
            } 
            else{  // Added for TP 5067
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, ' Please enter a value in User Comment field to save record ' );
            system.debug('------'+msg+'closewin--'+closewin);
            ApexPages.addMessage(msg);
            closeWin = false;
            return null;
         }
            }  
                
            catch (Exception e){
                  /*system.debug('Atul-----------' + e.getMessage());
                  errorTitle = 'Updating Error!';
                  errorMessage = e.getMessage();
                  errorSeverity = 'error';
                  errorShow = true;            
                  return null;*/ 
                 
            return null;
            }
           

    } 
    public BBW_CaseHandOff(ApexPages.StandardController controller) {
        theCase = (Case)controller.getRecord(); 
        Caseid = System.currentPageReference().getParameters().get('id');
        errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
            
        cse=[select Case_Record__c,Primary_Group_Name__c from Case where id=:ApexPages.currentPage().getParameters().get('id')];  
        system.debug('casedata'+ ApexPages.currentPage().getParameters().get('id'));         
        System.debug('hi-->primarygrpnam'+cse.Primary_Group_Name__c);
                if(cse.Primary_Group_Name__c!=null && cse.Case_Record__c!=null && cse.Case_Record__c!= '' )
                {
                    if(cse.Primary_Group_Name__c.contains('Transact'))
                    {
                    RecName='Transact';
                    }
                    else  if(cse.Primary_Group_Name__c.contains('Learn') && cse.Case_record__c!='xpLor')
                    {
                    RecName='Learn';
                    }
                   else if(cse.Primary_Group_Name__c.contains('Xythos'))
                   {
                    RecName='Xythos';
                    }
                   else if(cse.Primary_Group_Name__c.contains('ANGEL'))
                   {
                    RecName='ANGEL';
                    }
                    else if(cse.Primary_Group_Name__c.contains('Collaborate'))
                   {
                    RecName='Collaborate';
                    }
                    else if(cse.Primary_Group_Name__c.contains('Moodlerooms') && cse.Case_record__c!='xpLor')
                   {
                    RecName='Moodlerooms';
                    }
                    else if(cse.Primary_Group_Name__c.contains('Analytics'))
                   {
                    RecName='Analytics';
                    }
                    else if( (cse.Primary_Group_Name__c.contains('Learn') || cse.Primary_Group_Name__c.contains('Moodlerooms')) && (cse.Case_record__c.contains('xpLor')) )
                    {

                    RecName='xpLor';
                    system.debug('RecName1'+RecName);
                    }
                    else
                    {
                        RecName = 'ALL';
                    }
                 }
        if(cse.Primary_Group_Name__c!=null){                
              GroupName=cse.Primary_Group_Name__c; 
              system.debug('hi-->GroupName'+GroupName);                           
                        
        }            
                    
      
            if(closeWin!=true) 
        closeWin=false;
        //case cs=[Select c.id,c.RecordType.Name, c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
   // RecName=cs.RecordType.Name;

    }
    public List<SelectOption> getRecordName(){
    List<SelectOption> op=new List<SelectOption>();
    
    case cs=[Select c.id,c.RecordType.Name, c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
    //RecName=cs.RecordTypeId;
    op.clear();
op.add(new SelectOption('ALL','ALL'));
 op.add(new SelectOption('CE/Vista','CE/Vista'));
//System.debug('id'+cs.RecordTypeId+'Name' +cs.RecordType.Name);
       // for(case ct : [select c.id,c.RecordType.Name,c.RecordTypeId from Case c])
    //{
    //s.add(ct.RecordTypeId,ct.RecordType.Name);
    integer a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0;
    for(recordtype rt: [Select r.Name, r.Id From RecordType r where sobjecttype='Case' /* and (r.Name='Angel' or r.Name='Transact' or r.Name='Learn' or r.Name='Xythos')*/]){
    //if(cs.RecordType.Name!=rt.Name)
    {
    
    //string str
   // system.debug('hi-->Record Type Name'+ rt.Name+'RecordId'+rt.Id);
        //op.add(new SelectOption(rt.Name,rt.Name));
        if(rt.Name.contains('Angel'))
        {
        if(a==0)
        op.add(new SelectOption('ANGEL','ANGEL'));
        a++;
        }
        else if(rt.Name.contains('Transact'))
        {
        if(b==0)
        op.add(new SelectOption('Transact','Transact'));
        b++;
        }
        else if(rt.Name.contains('Learn'))
        {
        if(c==0)
        op.add(new SelectOption('Learn','Learn'));
        c++;
        }
        else if(rt.Name.contains('Xythos'))
        {
        if(d==0)
        op.add(new SelectOption('Xythos','Xythos'));
        d++;
        }
        else if(rt.Name.contains('Moodlerooms'))
        {
        if(e==0)
        op.add(new SelectOption('Moodlerooms','Moodlerooms'));
        e++;
        }
        
        else if(rt.Name.contains('Analytics'))
        {
        if(f==0)
        op.add(new SelectOption('Analytics','Analytics'));
        f++;
        }
        else if(rt.Name.contains('Collaborate'))
        {
        if(g==0)
        op.add(new SelectOption('Collaborate','Collaborate'));
        g++;
        }
        else if(rt.Name.contains('xpLor'))
        {
        if(h==0)
        op.add(new SelectOption('xpLor','xpLor'));
        h++;
        }
        else
        {}
        }
    }
        return op;

    }
    
   
   public string getRecName()
    {    
    //case cs=[Select c.id,c.RecordType.Name, c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
    //RecName=cs.RecordType.Name;
    return this.RecName;
    }
    public void setRecName(string RecName){
    this.RecName=RecName;
    }
    public pagereference Values()
    {
    getQueueName();
    return null;
    }
    
  public List<SelectOption> getQueueName() 
  {
        system.debug('getQN-->'+GroupName);
                List<SelectOption> optionsFieldName = new List<SelectOption>();
                List<Group> ListGroupName=new List<Group>(); 
                String qryString;
               //recordtype rtp=[Select r.Name, r.Id From RecordType r where sobjecttype='Case' and rtp.Name=:RecName];
               //recordtype rtp=[Select r.Name, r.Id From RecordType r where sobjecttype='Case' and id=:RecName]; 

                case c=[Select c.id,c.RecordType.Name, c.RecordTypeId,c.Primary_Group_Name__c From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
                System.debug('--RecName-->getQueueName-'+RecName);
                qryString='Select g.Name, g.Id From Group g where type=\'Queue\' ORDER BY g.Name'; 
                //qryString='Select g.Name, g.Id From Group g ;
                ListGroupName=Database.query(qryString );
                /*for(Group G1 : ListGroupName)
                {
                        optionsFieldName.Add(new SelectOption(G1.Id,G1.Name));
                }*/
                System.debug('AAAAAAAAAAAAAAAA' + RecName);
                for(List<Group> grp  : [select Id,Name,Type,(Select SobjectType From QueueSobjects where SobjectType='Case') from Group where Type = 'Queue' ORDER BY Name]){
                    for(Group g1 : grp){
                        if(!g1.QueueSobjects.isEmpty())
                        {
                            if(RecName!=Null)
                            {   
                              if(RecName!='ALL')
                                { 
                                    if(g1.Name.contains(RecName))
                                    {
                                      optionsFieldName.add(new SelectOption(g1.Id,g1.Name));
                                      if(g1.name == cse.Primary_Group_Name__c)
                                      {
                                       GroupName=g1.id;   
                                      }
                                    }
                                    else if(RecName == 'xpLor')
                                    {
                                      if(g1.Name.contains('Learn') || g1.Name.contains('Moodlerooms'))
                                        optionsFieldName.add(new SelectOption(g1.Id,g1.Name)); 
                                        if(g1.name == cse.Primary_Group_Name__c)
                                          {
                                             GroupName=g1.id;   
                                          }
                                    }
                                 }
                                 else if(RecName=='ALL')
                                 {
                                 optionsFieldName.add(new SelectOption(g1.Id,g1.Name));
                                 }  
                                 else
                                 {
                                 } 
                            }
                            else
                                 optionsFieldName.add(new SelectOption(g1.Id,g1.Name));
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