public with sharing class BBW_CaseAssignTo{
        public String GroupName{ get; set; } 
        public string UserComment{ get; set; }
        Case theCase {get;set;} 
        public id Caseid;
        public String RecName{ get; set;}
        public string prg;
        Case cse {get;set;}
        public boolean errorShow{ get; set; }
        public String errorTitle{ get; set; }
        public String errorMessage{ get; set; } 
        public String errorSeverity{ get; set; } 
        public Boolean closeWin {get;set;} 
        public string usn;
        public boolean temp_flag{get;set;}
        String prevowner;
        public string getusn()
        {
        return this.usn;
        }
        public void setusn(string s)
        { 
        this.usn=s;
        }
  
    public Pagereference SaveOwner() 
    {
        
        try{
                Case CaseTemp =[Select status, id From case where Id = : (Caseid)];
                system.debug('------------------------->>>>>>>>>>' +CaseTemp.Status);
                //if(CaseTemp.Status=='New')
              //  {
                    theCase.Status='Assigned';
                 //   theCase.Portal_Status__c='Work In Progress';                 
             //   }
           /*     else if(CaseTemp.Status=='Assigned')
                {
                    theCase.Status='Needs Attention';
                    theCase.Portal_Status__c='Work In Progress';                 
                }
                else if(CaseTemp.Status=='Pending User')
                {
                    theCase.Status='Pending User';
                    theCase.Portal_Status__c='Pending User';                 
                }
                else if(CaseTemp.Status=='Escalating')
                {
                     theCase.Status='Needs Attention';
                    theCase.Portal_Status__c='Work In Progress';                 
                }
                else if(CaseTemp.Status=='Reopened' || CaseTemp.Status=='ReOpened')
                {
                     theCase.Status='Needs Attention';
                    theCase.Portal_Status__c='Work In Progress';                 
                }*/
                /*if(CaseTemp.Status=='New' || CaseTemp.Status=='Escalating' || CaseTemp.Status=='Pending User' || CaseTemp.Status=='Escalating' || CaseTemp.Status=='Reopened'){
                    theCase.Status='Needs Attention';
                    theCase.Portal_Status__c='Work In Progress';                 
                } */                   
                 theCase.AssignTo_Comment__C = UserComment; 
                 theCase.OwnerId=usn; 
              //   theCase.Previous_Owner__c = prevowner;  TP2683
                 System.debug(cse.AssignTo_Count__c);
                 if(cse.AssignTo_Count__c == null)// Added by Lalitha for 1621
                        theCase.AssignTo_Count__c = 0;
                 else
                        theCase.AssignTo_Count__c = cse.AssignTo_Count__c + 1;
                        
                 if(usn == null || usn == '-No User-' || usn == ''){
                     closeWin=false;
                     errorTitle = 'Updating Error!';
                     errorMessage ='Choose a valid User';
                      errorSeverity = 'error';
                      errorShow = true;  
                      System.debug(errorShow);
                    return null;
                 }
                        
                 User u1 = [select Primary_group__c from User where ID =: usn];       
                 theCase.Primary_Group_Name__c = u1.Primary_group__c;// [select Id,Name from Group where ID =: GroupName].Name;
         /*        Task[] newTask = new Task[0];               
                 newTask.add(new Task(Description = UserComment,
                 Priority = 'Normal',
                 Status = 'Completed',
                 Type='Assign To',
                  External__c = false,
                 Subject = 'Assign To',//email.subject,         
                 whatid=Caseid
         ));*/
    
        Case_Note__c note = new Case_Note__c();
        note.Case__c = Caseid;
        note.Public__c = false;
        note.From_Type__c = 'Employee';
        //note.Details__c = 'Support Case Assigned to <b>' + theCase.Primary_Group_Name__c + '</b><br/>' + UserComment;
        note.Details__c = UserComment;
        note.Type__c = 'Case Assign To';

       insert note;
    // Insert the new Task and it will be created and appended to the contact record
         

        // insert newTask;
         
         update theCase;  
         closeWin=true;       
         /*errorTitle = 'Update.';
                 errorMessage = 'Case owner has been updated successfully.';
                 errorSeverity = 'confirm';
                 errorShow = true;*/   
                 if(temp_flag==true)
                 {
                  closeWin=false;
                 errorTitle = 'Updating Error!';
                  errorMessage ='Choose a primary Group then User Name to save';
                  errorSeverity = 'error';
                  errorShow = true;  
                            
                 }  
                                        
                 return null;
            }       
            catch (Exception e){
                  system.debug('Atul-----------' + e.getMessage());
                  errorTitle = 'Updating Error!';
                  errorMessage = e.getMessage();
                  errorSeverity = 'error';
                  errorShow = true;  
                  closeWin=false;          
                  return null;
            }
    } 
    public BBW_CaseAssignTo(ApexPages.StandardController controller) {
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=8');
        theCase = (Case)controller.getRecord(); 
        Caseid = System.currentPageReference().getParameters().get('id');
        errorShow = false;
            errorTitle = '';
            errorMessage = '';
            errorSeverity = ''; 
             cse=[select AssignTo_Count__c,Owner.Name, Primary_Group_Name__c,Case_record__c,RecordType.Name from Case where id=:ApexPages.currentPage().getParameters().get('id')];           
         prevowner = cse.Owner.id;
        System.debug('hi-->primarygrpnam'+cse.Primary_Group_Name__c);
        /*if(cse.AssignTo_Count__c == null)// Added by Lalitha for 1621
            cse.AssignTo_Count__c = 0;
        else
            cse.AssignTo_Count__c = cse.AssignTo_Count__c + 1;*/
        if(cse.Primary_Group_Name__c!=null)
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
                    RecName='Angel';
                    }
                    else if(cse.Primary_Group_Name__c.contains('Collaborate'))
                   {
                    RecName='Collaborate';
                    }
                    else if(cse.Primary_Group_Name__c.contains('CE/Vista')){
                        RecName = 'CE/Vista';
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
                    }

                    else
                    {
                    }
                 }
        if(cse.Primary_Group_Name__c!=null){                
              prg=cse.Primary_Group_Name__c;                
                        
        }            
                    
       
            if(closeWin!=true) 
        closeWin=false;
        //case cs=[Select c.id,c.RecordType.Name, c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
   // RecName=cs.RecordType.Name;

    }
    public List<SelectOption> getRecordName(){
    List<SelectOption> op=new List<SelectOption>();
    
    case cs=[Select c.id,c.RecordType.Name, c.Primary_Group_Name__c,c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
    //RecName=cs.RecordTypeId;
    op.clear();
//op.add(new SelectOption(cs.RecordTypeId,cs.RecordType.Name));
//System.debug('id'+cs.RecordTypeId+'Name' +cs.RecordType.Name);
       // for(case ct : [select c.id,c.RecordType.Name,c.RecordTypeId from Case c])
    //{
    //s.add(ct.RecordTypeId,ct.RecordType.Name);
    op.add(new SelectOption('ALL','ALL'));
    op.add(new SelectOption('CE/Vista','CE/Vista'));

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
        else if(rt.Name.contains('Learn') || rt.Name.contains('CE/Vista'))
        {
        if(c==0)
        op.add(new SelectOption('Learn','Learn'));
        c++;
        system.debug('learnlooooop');
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
        {

        }
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
     public string getprg()
    {    
    //case cs=[Select c.id,c.RecordType.Name, c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
    //RecName=cs.RecordType.Name;    
    return this.prg;
    }
    public void setprg(string p){
    this.prg=p;
    }
    
    public pagereference Values()
    {
    //if(RecName=='ALL')
    prg='--Select Primary Group--';
    //usn='--select a Primary Group--';
    getQueueName();
    temp_flag=true;
    usn='--First select a Primary Group--';
    //getUSName();
    return null;
    }

    public List<SelectOption> getQueueName() 
    {
                List<SelectOption> optionsFieldName = new List<SelectOption>();
                List<Group> ListGroupName=new List<Group>(); 
                String qryString;
                string qryString1;
               
                case c = [Select c.id,c.RecordType.Name, c.RecordTypeId From Case c where c.id=:ApexPages.currentPage().getParameters().get('ID')];
                System.debug('--RecName-->getQueueName-'+RecName);
                qryString='Select g.Name, g.Id From Group g where type=\'Queue\' ORDER BY g.Name'; 
                //qryString='Select g.Name, g.Id From Group g ;
                ListGroupName=Database.query(qryString );
                           optionsFieldName.Add(new SelectOption('-Select Primary Group-','--Select Primary Group--'));
                        optionsFieldName.Add(new SelectOption('ALL','ALL'));
                        //optionsFieldName.Add(new SelectOption('Moodlerooms','Moodlerooms'));
                
                for(List<Group> grp  : [select Name,Type,(Select SobjectType From QueueSobjects where SobjectType='Case') from Group where Type = 'Queue' ORDER BY Name]){
                    if(grp.size()>0)
                    {
                    for(Group g1 : grp){
                     system.debug('Atul Singhal----------1');
                        if(!g1.QueueSobjects.isEmpty())
                        {
                         system.debug('Atul Singhal----------2');
                         if(RecName!=Null)
                         {
                            if(RecName!='ALL')
                            {                                
                                if(g1.Name.contains(RecName))
                                    {
                                   optionsFieldName.add(new SelectOption(g1.Name,g1.Name));
                                    } 
                                 else if(RecName == 'xpLor')
                                 {
                                   if(g1.Name.contains('Learn') || g1.Name.contains('Moodlerooms') )
                                   optionsFieldName.add(new SelectOption(g1.Name,g1.Name));                                  
                                 }   

                            }

                            else
                                optionsFieldName.add(new SelectOption(g1.Name,g1.Name));
                         }
                         else
                             optionsFieldName.add(new SelectOption(g1.Name,g1.Name));
                        }
                        system.debug('Atul Singhal----------4');
                        }
                        system.debug('Atul Singhal----------3');               
                    }
                }
                
                system.debug('Atul Singhal----------');
                return optionsFieldName;
        }
        public pagereference USValue()
        {
        getUSName();
        temp_flag=false;
        return null;
        }
        
        
         public List<SelectOption> getUSName() {
        List<SelectOption> optionsFieldName = new List<SelectOption>();
        optionsFieldName.add(new SelectOption('','---Please Select---'));
        List<User> ListUserName=new List<User>(); 
        String qryString;
        //optionsFieldName.Add(new SelectOption('--select a Primary Group--','--select a Primary Group--'));
        //qryString='Select u.Name, u.Id,u.Primary_Group__c From User u where IsActive=true /*and u.Profile.Name=\'Bb - Service Tech Support\'*/ and IsPortalEnabled=false order by u.Name'; 
        //qryString='Select u.Name, u.Id,u.Primary_Group__c From User u where IsActive=true and IsPortalEnabled=false and u.Primary_Group__c=: prg order by u.Name'; 
        qryString='Select u.Name, u.Id,u.Primary_Group__c From User u where IsActive=true and u.Primary_Group__c!=null and u.Primary_Group__c=: prg order by u.Name'; 
        system.debug('Manish Kumar--------------------------' + prg);
        //qryString='Select g.Name, g.Id From Group g ;
        ListUserName=Database.query(qryString );
        if(prg!='ALL')
        for(User U1 : ListUserName)
        {
          /*  if(U1.Primary_Group__c.contains(prg))
            if(usn == null)
            usn = U1.Id;*/
            optionsFieldName.Add(new SelectOption(U1.Id,U1.Name));
                                          
                        
        }
        else if(prg=='ALL' && RecName=='ALL')
        {
        qryString='Select u.Name, u.Id,u.Primary_Group__c From User u where IsActive=true and u.Primary_Group__c!=null  order by u.Name'; 
        //system.debug('Manish Kumar--------------------------' + prg);
        
        ListUserName=Database.query(qryString );
        if(ListUserName.size()>0)
         for(User U1 : ListUserName)
        {
        system.debug('Manish Kumar-------ALL Primary Group-------------------' + RecName);            
            

            optionsFieldName.Add(new SelectOption(U1.Id,U1.Name));                                     
                        
        }
        }
        else{
        
        qryString='Select u.Name, u.Id,u.Primary_Group__c From User u where IsActive=true and u.Primary_Group__c!=null order by u.Name'; 
        system.debug('Manish Kumar--------------------------' + prg);
        
        ListUserName=Database.query(qryString );
        if(ListUserName.size()>0)
         for(User U1 : ListUserName)
        {
        system.debug('Manish Kumar-------ALL Primary Group-------------------' + RecName);
            //if(U1.Primary_Group__c!=null)
            
               
             
            optionsFieldName.Add(new SelectOption(U1.Id,U1.Name));
                                      
                        
        }
        
        }
        if(optionsFieldName.size()<=1){
            optionsFieldName= new List<SelectOption>();
            optionsFieldName.Add(new SelectOption('-No User-','-No User-'));
            usn = '-No User-';
        }
                //optionsFieldName.Add(new SelectOption('test','test'));
        return optionsFieldName;
   }
}