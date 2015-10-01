public class BBW_Escalation {
    public String esccom { get; set;}      
     public boolean a{get; set; }        
     public Case cse;        
     public boolean errorShow{ get; set; }        
     public String errorTitle{ get; set; }        
     public String errorMessage{ get; set; }         
     public String errorSeverity{ get; set; }         
     public Boolean closeWin {get;set;}        
     public string Qv1{ get; set; }        
     public string Qv2{ get; set; }        
     public string Qv3{ get; set; }        
     public string Qv4{ get; set; }        
     public string Qv5{ get; set; }        
     public string Qv6{ get; set; }        
     public string Qv7{ get; set; }        
     public string Qv8{ get; set; }        
     public string Qv9{ get; set; }        
     public string Qv10{ get; set; }         
     public string cid{get; set;}             
     public boolean chkEsc{get; set;}        
     public string TemplateName{get; set;}        
     public boolean temp_flag{get;set;}        
     public Template__c temp,temp_name;        
     public integer i=0;        
     List<String> str=new List<String>();          

     public PageReference QuestionTemplate() {              
         temp_flag=false;   
         system.debug('Test');
         //If(TemplateName!=null)           
         try{                  
             if(TemplateName!='--None--')    
             {    
                Template__c theTemplate= [Select Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,Q6__c,Q7__c,Q8__c,Q9__c,Q10__c, id from Template__c where ID=: TemplateName];                    
                system.debug('Template Name'+TemplateName);           
                temp_flag=true;                    
                Qv1=theTemplate.Q1__c;                    
                Qv2=theTemplate.Q2__c;                    
                Qv3=theTemplate.Q3__c;                    
                Qv4=theTemplate.Q4__c;                     
                Qv5=theTemplate.Q5__c;                    
                Qv6=theTemplate.Q6__c;                     
                Qv7=theTemplate.Q7__c;                    
                Qv8=theTemplate.Q8__c;                     
                Qv9=theTemplate.Q9__c;                    
                Qv10=theTemplate.Q10__c;                      
                cse=[select Template__c,Q1__c,A1__c,Q2__c,A2__c,Q3__c,A3__c,Q4__c,A4__c,Q5__c,A5__c,Q6__c,A6__c,Q7__c,A7__c,Q8__c,A8__c,Q9__c,A9__c,Q10__c,A10__c, Esca_Com_4m_2to3__c, Escalated_Tier_2__c from Case where id=:ApexPages.currentPage().getParameters().get('id')];                    
                cse.Template__c= TemplateName;   
                cse.Q1__c=theTemplate.Q1__c;      
                cse.Q2__c=theTemplate.Q2__c;    
                cse.Q3__c=theTemplate.Q3__c;    
                cse.Q4__c=theTemplate.Q4__c;    
                cse.Q5__c=theTemplate.Q5__c; 
                cse.Q6__c=theTemplate.Q6__c;   
                cse.Q7__c=theTemplate.Q7__c;    
                cse.Q8__c=theTemplate.Q8__c;    
                cse.Q9__c=theTemplate.Q9__c;    
                cse.Q10__c=theTemplate.Q10__c;    
               // cse.Q1__c=theTemplate.Q1__c;                   
                esccom=cse.Esca_Com_4m_2to3__c;       
                system.debug('Singhal');             
             }
             else
             {
                Qv1=Null;                    
                Qv2=Null;                             
                Qv3=Null;                          
                Qv4=Null;                               
                Qv5=Null;                                    
                Qv6=Null;                          
                Qv7=Null;                                    
                Qv8=Null;                    
                Qv9=Null;                    
                Qv10=Null;                    
                cse.Q1__c=Null;                     
                cse.Q2__c=Null;                    
                cse.Q3__c=Null;                    
                cse.Q4__c=Null;                    
                cse.Q5__c=Null;  
                cse.Q6__c=Null;                  
                cse.Q7__c=Null;                    
                cse.Q8__c=Null;                    
                cse.Q9__c=Null;                    
                cse.Q10__c=Null;                    
             }
                return null; 
                                
         }catch(Exception e){  
         System.debug('Template Name'+TemplateName);                   
            temp_flag=false;  
            system.debug('Temp flag'+temp_flag);                                           
            return null;                
         }
         //return null;
     }            
     
     public BBW_Escalation(){               
        cse=[select Template__c,Replication_in_the_Case__c,Request_Creation_of_Internal_Knowledge__c,Done_above_steps_and_require_an_escalate__c,Is_this_a_Support_Managers_escalation__c,Observed_only_in_the_client_s_env__c,Observed_via_WebEx__c,Escalated_Tier_2__c from Case where id=:ApexPages.currentPage().getParameters().get('id')];           
       //string str=cse.Replication_in_the_Case__c;
        if(cse.Template__c!=null){                
              TemplateName=cse.Template__c;                
              QuestionTemplate();                
              a=cse.Escalated_Tier_2__c;            
        }            
        cid = ApexPages.currentPage().getParameters().get('id');            
        temp_flag=true;                
     }                     
     
     public Case getCase(){            
       return cse;        
     }                    
     
     public void setTemplate(Template__c temp){                  
        this.temp=temp;                  
     }              
     
     public Template__c getTemplate(){           
        return temp;        
     }            
     
     public PageReference save() {            
         //update cse;            
        // closeWin=true;            
       /*  if(ApexPages.currentPage().getParameters().get('isdtp')!=null)
        {
            Pagereference pageRef = new Pagereference('/'+ cid); 
            pageRef.SetRedirect(true); 
            update cse;  
            return pageRef;
        }*/
        update cse;
        closeWin=true;
        return null;     
     }        
     
     public List<SelectOption> getTemplateList(){             
        List<SelectOption> optionsFieldName = new List<SelectOption>();              
        List<Template__c> ListUserName=new List<Template__c>();               
        String qryString;              
        optionsFieldName.Add(new SelectOption('--None--','--None--'));              
        qryString='Select t.Name,t.Core_License__c, t.Id From Template__c t order by t.Name';                              
        ListUserName=Database.query(qryString );
      Case  cse1=[select Core_License__c from Case where id=:ApexPages.currentPage().getParameters().get('id')];           
                   
        for(Template__c U1 : ListUserName){ 
        string str=U1.Core_License__c;    
        System.debug('Core'+str);              
               // if(str==ApexPages.currentPage().getParameters().get('rm')){
               if(U1.Core_License__c==cse1.Core_License__c){
                system.debug('True');                        
                     optionsFieldName.Add(new SelectOption(U1.Id,U1.Name));                     
                }                                     
        }              
        return optionsFieldName;        
     }               

     public PageReference cancel(){                 
        return null; 
     }            

     public PageReference Escalate(){            
       Set<ID> qID = new Set<ID>();     
       User u = [select FirstName,LastName,Primary_Group__c from User where ID =: UserInfo.getUserID()];       
       Map<String,String> qmap = new Map<String,String>();            
       for(List<QueueSobject> qs : [select SobjectType,QueueId from QueueSobject where SobjectType = 'Case']){               
             for(QueueSobject qs1 : qs){                 
                  qId.add(qs1.QueueId);              
             }           
       }            
       for(List<Group> grp  : [select Name,Type from Group where ID IN: qID Order By Name]){              
              for(Group g1 : grp){                   
                    qmap.put(g1.Name,g1.ID);               
              }           
       }                        
       errorShow=false;            
       update cse;           
       closeWin=true;            
       cse=[select Primary_Group_Name__c,Q1__c,Q2__c,Q3__c,Q4__c,Q5__c,Q6__c,Q7__c,Q8__c,Q9__c,Q10__c,A1__c,A2__c,A3__c,A4__c,A5__c,A6__c,A7__c,A8__c,A9__c,A10__c, Esca_Com_4m_2to3__c,isEscalated,Escalated_Tier_3__c,Escalated_Tier_2__c,Replication_in_the_Case__c,Request_Creation_of_Internal_Knowledge__c,Done_above_steps_and_require_an_escalate__c,Is_this_a_Support_Managers_escalation__c,Observed_only_in_the_client_s_env__c,Observed_via_WebEx__c from Case where id=:ApexPages.currentPage().getParameters().get('ID')];            
       string strPrg=cse.Primary_Group_Name__c;
       if(cse.Replication_in_the_Case__c==Null || cse.Replication_in_the_Case__c=='')
       {
           errorTitle = 'Updating Error!';                  
           errorMessage ='Issue Replication must have a value.';                 
           errorSeverity = 'error';                  
           errorShow = true;                  
           closeWin=false;
       }
      else if(TemplateName==null||TemplateName=='--None--')
       {
           errorTitle = 'Updating Error!';                  
           errorMessage ='Please Choose a Template.';                 
           errorSeverity = 'error';                  
           errorShow = true;                  
           closeWin=false;
       }

      else if((cse.Q1__c !=null && cse.A1__c == null)||(cse.Q2__c!=null && cse.A2__c == null)|| (cse.Q3__c != null && cse.A3__c == null) || (cse.Q4__c != null && cse.A4__c==null) || (cse.Q5__c!=null && cse.A5__c==null) || (cse.Q6__c!=null && cse.A6__c==null) || (cse.Q7__c!=null && cse.A7__c==null) || (cse.Q8__c!=null && cse.A8__c == null) || (cse.Q9__c!=null && cse.A9__c==null) || (cse.Q10__c!=null && cse.A10__c==null)){                 
              errorTitle = 'Updating Error!';                  
              errorMessage ='Answer field can not be left blank.';                 
              errorSeverity = 'error';                  
              errorShow = true;                  
              closeWin=false;
              system.debug('error title'+errorTitle);           
       } 
   /*    else if((cse.Escalated_Tier_2__c==false)&&((strPrg.contains('L2'))||(strPrg.contains('L2'))||(strPrg.contains('Level 2'))||(strPrg=='ANGEL - Managed Hosting')||(strPrg=='ANGEL - Software Solutions'))){              
             Case objCase=[select Has_been_Escalated__c,Escalated_Time__c,Previous_Owner__c,Access_Info__c,Replication_Steps__c,Escalation_Template__c,Work_Performed__c,Primary_Group_Name__c,ownerid,IsEscalated,Status,Customer_Portal_Status__c from Case where id=:ApexPages.currentPage().getParameters().get('ID')];            
      if(objCase.Previous_Owner__c == null)                    
              objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c); 
       objCase.isEscalated=true; 
       objCase.Status='Escalating';
       objCase.Portal_Status__c='Work In Progress';
       objCase.Access_Info__c=true;
       objCase.Replication_Steps__c=true;
       objCase.Escalation_Template__c=true;
       objCase.Work_Performed__c=true;
       objCase.Is_TSM_provide_a_internal_knowledge__c=true;
       objCase.Escalated_Tier_2__c = true;
       objCase.IsEscalated=true;
       if(objCase.Escalated_Time__c ==  null)
           objCase.Escalated_Time__c = System.now();
       objCase.Has_been_Escalated__c = true;   
       objCase.Escalated_by__c = u.ID;
        update objCase;      
      }
    
  else if((cse.Escalated_Tier_3__c==false)&&((strPrg=='ANGEL - Development')||(strPrg=='Transact - Development')||strPrg.contains('Level3'))){              
             Case objCase=[select Previous_Owner__c,Access_Info__c,Replication_Steps__c,Escalation_Template__c,Work_Performed__c,Primary_Group_Name__c,ownerid,IsEscalated,Status,Portal_Status__c,Escalated_Tier_2__c,Escalated_Tier_3__c from Case where id=:ApexPages.currentPage().getParameters().get('ID')];            
      if(objCase.Previous_Owner__c == null)                    
              objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c); 
      objCase.isEscalated=true; 
       objCase.Status='Escalating';
       objCase.Portal_Status__c='Work In Progress';
       objCase.Access_Info__c=true;
       objCase.Replication_Steps__c=true;
       objCase.Escalation_Template__c=true;
       objCase.Work_Performed__c=true;
       objCase.Is_TSM_provide_a_internal_knowledge__c=true;
       objCase.IsEscalated=true;
       objCase.Escalated_Tier_2__c = true;
       objCase.Escalated_Tier_3__c = true;
       if(objCase.Escalated_Time__c ==  null)
           objCase.Escalated_Time__c = System.now();
       objCase.Has_been_Escalated__c = true; 
       objCase.Escalated_by__c = u.ID;
        update objCase;

      }*/
                 
      else{         
       Case objCase=[select Previous_Owner__c,Access_Info__c,Replication_Steps__c,Escalation_Template__c,Work_Performed__c,Primary_Group_Name__c,ownerid,IsEscalated,Escalated_Tier_2__c,Status,Customer_Portal_Status__c from Case where id=:ApexPages.currentPage().getParameters().get('ID')];            
       System.debug(objCase.Primary_Group_Name__c);
       objCase.isEscalated=true; 
       objCase.Status='Escalated';
     //  objCase.Portal_Status__c='Work In Progress';
       objCase.Access_Info__c=true;
       objCase.Replication_Steps__c=true;
       objCase.Escalation_Template__c=true;
       objCase.Work_Performed__c=true;
       objCase.Is_TSM_provide_a_internal_knowledge__c=true;
       if(objCase.Escalated_Time__c ==  null)
           objCase.Escalated_Time__c = System.now();
       objCase.Has_been_Escalated__c = true; 
       objCase.Escalated_by__c = u.ID;
       //update objCase;           
       if(objCase.Primary_Group_Name__c == 'ANGEL - Midwest Engagement Team' || objCase.Primary_Group_Name__c.contains('K12') || objCase.Primary_Group_Name__c == 'ANGEL - Custom Services Engagement Team'){               
           if(objCase.Previous_Owner__c == null)                    
              objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
           else                            
              objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
           objCase.ownerid = qmap.get('ANGEL - Software Solutions');               
           objCase.Escalated_Tier_2__c = true;                
           objCase.Primary_Group_Name__c = 'ANGEL - Software Solutions';                            
           System.debug('Inside Assignment');
           if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
           objCase.Has_been_Escalated__c = true;
           objCase.Escalated_by__c = u.ID; 
           update objCase;               
           closeWin=true;                                             
       }else if(objCase.Primary_Group_Name__c == 'ANGEL - Software Solutions' || objCase.Primary_Group_Name__c == 'ANGEL - Managed Hosting'){               
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);               
            objCase.ownerid = qmap.get('ANGEL - Development');               
            objCase.Escalated_Tier_3__c = true;                
            objCase.Primary_Group_Name__c = 'ANGEL - Development';    
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;   
            objCase.Escalated_by__c = u.ID;            
            update objCase;
            closeWin=true;            
       }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - CognosOnline' || objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - Grupo A'){
           if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L1 - LAC');                
                         
            objCase.Primary_Group_Name__c = 'Learn - L1 - LAC';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true; 
       }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - BMEHolding'){
           if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L1 - EMEA');                
                          
            objCase.Primary_Group_Name__c = 'Learn - L1 - EMEA';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true; 
       }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - AssistMicro' || objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - BEENET' || objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - Eiffel'){
           if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - ANZSEA');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - ANZSEA';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true; 
       }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Windows' || ((objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers' || objCase.Primary_Group_Name__c == 'Learn - L1 - Indianapolis') && (objCase.Asset_Database__c != null && (objCase.Asset_Database__c.contains('WINDOWS') || objCase.Asset_Database__c.contains('Win'))))){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - Windows');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - Windows';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Unix' || ((objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers' || objCase.Primary_Group_Name__c == 'Learn - L1 - Indianapolis') && (objCase.Asset_Database__c == null || (objCase.Asset_Database__c != null && !(objCase.Asset_Database__c.contains('WINDOWS') && objCase.Asset_Database__c.contains('Win')))))){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - Unix');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - Unix';       
            objCase.Escalated_by__c = u.ID;                     
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - EMEA' || objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - EMEA'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - EMEA');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - EMEA';      
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
           objCase.Has_been_Escalated__c = true;           
           objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }
      else if(objCase.Primary_Group_Name__c == 'Learn - L1 - ANZSEA' || objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - ANZSEA'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - ANZSEA');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - ANZSEA'; 
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
           objCase.Has_been_Escalated__c = true;                
           objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - LAC' || objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - LAC'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c); 
                             
            objCase.ownerid = qmap.get('Learn - L2 - LAC');  
            
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - LAC'; 
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;                
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Mobile'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Mobile - L2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Mobile - L2';   
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;              
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Mobile'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Mobile - L2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Mobile - L2';    
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;             
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Managed Hosting' || objCase.Primary_Group_Name__c == 'Learn - L1 - Managed Hosting - LAC'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - Managed Hosting');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting'; 
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;                
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Managed Hosting - EMEA'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - Managed Hosting - EMEA');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - EMEA';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Managed Hosting - Complex' || objCase.Primary_Group_Name__c == 'Learn - L1 - MH - Complex - LAC' ){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - Managed Hosting - Complex');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - Complex';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1' || objCase.Primary_Group_Name__c == 'ANGEL - South/West Engagement Team' || objCase.Primary_Group_Name__c == 'ANGEL - Northeast Engagement Team'){         //Added extra for TP#2213
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - MH - Complex - EMEA'){     
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - MH - Complex - EMEA');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - MH - Complex - EMEA';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Learn - L1 - MH - Complex - APAC'){     
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L2 - MH - Complex - APAC');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Learn - L2 - MH - Complex - APAC';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }
      else if(objCase.Primary_Group_Name__c == 'Learn - L1 - Resellers - protOS')
      {
      if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Learn - L1 - EMEA');                
                          
            objCase.Primary_Group_Name__c = 'Learn - L1 - EMEA';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase; 
            closeWin=true;
      
      }else if(objCase.Primary_Group_Name__c == 'CE/Vista - L1'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('CE/Vista - L2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'CE/Vista - L2';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'CE/Vista - L1 - Managed Hosting'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('CE/Vista - L2 - Managed Hosting');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'CE/Vista - L2 - Managed Hosting';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;

            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Transact - Unix - Harco - Level 1'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Transact - Unix - Harco - Level 2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Transact - Unix - Harco - Level 2';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Transact - Windows -Decepticons -Level 1'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Transact -Windows - Decepticons -Level 2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Transact -Windows - Decepticons -Level 2';                
            if(objCase.Escalated_Time__c ==  null)
                objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;            
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Transact - Windows - Plan B - Level 1'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Transact - Windows - Plan B - Level 2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Transact - Windows - Plan B - Level 2';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;            
      }else if(objCase.Primary_Group_Name__c == 'Transact - Unix - Harco - Level 2' || objCase.Primary_Group_Name__c == 'Transact -Windows - Decepticons -Level 2'|| objCase.Primary_Group_Name__c == 'Transact - Windows - Plan B - Level 2'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c); 
            if(objCase.Primary_Group_Name__c == 'Transact - Unix - Harco - Level 2')
            {objCase.ownerid = qmap.get('Transact - UNIX - Harco - Level 3');                
            objCase.Escalated_Tier_3__c = true;              
            objCase.Primary_Group_Name__c = 'Transact - UNIX - Harco - Level 3';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;            
            update objCase;
            closeWin=true;
            }
           else if(objCase.Primary_Group_Name__c == 'Transact - Windows - Plan B - Level 2')
            {objCase.ownerid = qmap.get('Transact - WIN - Plan B - Level 3');                
            objCase.Escalated_Tier_3__c = true;              
            objCase.Primary_Group_Name__c = 'Transact - WIN - Plan B - Level 3';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID; 
            update objCase;
            closeWin=true;
            }
            
            
              else
              {                           
            objCase.ownerid = qmap.get('Transact - Development');                
            objCase.Escalated_Tier_3__c = true;              
            objCase.Primary_Group_Name__c = 'Transact - Development';                
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true; 
            objCase.Escalated_by__c = u.ID;
            update objCase;
            closeWin=true;   
            }
            }
             //modified by avik 
      

       else if(objCase.Primary_Group_Name__c == 'Moodlerooms: Territory 1 Engagement Team'|| objCase.Primary_Group_Name__c == 'Moodlerooms: Territory 2 Engagement Team' || objCase.Primary_Group_Name__c == 'Moodlerooms: Territory 3 Engagement Team' || objcase.Primary_Group_Name__c == 'Moodlerooms: Territory LAC')
      {
      if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('ANGEL - Software Solutions');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'ANGEL - Software Solutions';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true;
      
      }
      
      

else if(objCase.Primary_Group_Name__c == 'Moodlerooms-L1-Resellers-AssistMicro')
      {
      if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Moodlerooms: APAC');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Moodlerooms: APAC';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true;
      
      }
      else if(objCase.Primary_Group_Name__c == 'Moodlerooms: EMEA')
      {
      if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Moodlerooms: Tier 2 EMEA');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Moodlerooms: Tier 2 EMEA';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true;
      
      }


else if(objCase.Primary_Group_Name__c == 'Moodlerooms -System Administration - Tech' || objCase.Primary_Group_Name__c == 'Moodlerooms -Product Strategy' || objCase.Primary_Group_Name__c == 'Moodlerooms -Client Development Support' || objCase.Primary_Group_Name__c == 'Moodlerooms -Product Development' || objCase.Primary_Group_Name__c == 'Moodlerooms: APAC')
      {
      if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Moodlerooms: Advanced Support - Tech Ops');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Moodlerooms: Advanced Support - Tech Ops';  
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
            objCase.Has_been_Escalated__c = true;
            objCase.Escalated_by__c = u.ID;                             
            update objCase;
            closeWin=true;
      
      }


//collab code by Murugappan
            
            else if(objCase.Primary_Group_Name__c == 'Collaborate: Orders Fulfillment' || objCase.Primary_Group_Name__c == 'Collaborate: Technical Services' || objCase.Primary_Group_Name__c == 'Collaborate: Tier 2 Support' || objCase.Primary_Group_Name__c == 'Collaborate: Tier 1 Support' || objCase.Primary_Group_Name__c == 'Collaborate: Tier 1 Admin - EMEA' || objCase.Primary_Group_Name__c == 'Collaborate: Tier 1 Admin - ANZSEA' || objCase.Primary_Group_Name__c == 'Collaborate: Tier 1 Admin'){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Collaborate: Tier 2 Support');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Collaborate: Tier 2 Support';      
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
               objCase.Has_been_Escalated__c = true;           
               objCase.Escalated_by__c = u.ID;
               update objCase;
               closeWin=true;            
      }
            
// Analytics code

            else if(objCase.Primary_Group_Name__c == 'Analytics: L1' ){
            if(objCase.Previous_Owner__c == null)                    
               objCase.Previous_Owner__c = qmap.get(objCase.Primary_Group_Name__c);                
            else                             
               objCase.Previous_Owner__c = objCase.Previous_Owner__c +';'+qmap.get(objCase.Primary_Group_Name__c);                
            objCase.ownerid = qmap.get('Analytics: L2');                
            objCase.Escalated_Tier_2__c = true;                
            objCase.Primary_Group_Name__c = 'Analytics: L2';      
            if(objCase.Escalated_Time__c ==  null)
               objCase.Escalated_Time__c = System.now();
               objCase.Has_been_Escalated__c = true;           
               objCase.Escalated_by__c = u.ID;
               update objCase;
               closeWin=true;            
      }
    
            
                                 
        
        String comment;
      if(objCase.Q1__c != null)
          comment = objCase.Q1__c + '\n\n';
      if(objCase.A1__c != null)    
          comment = comment + objCase.A1__c + '\n\n';
      if(objCase.Q2__c != null)
          comment = comment + objCase.Q2__c + '\n\n';
      if(objCase.A2__c != null)    
          comment = comment + objCase.A2__c + '\n\n';          
      if(objCase.Q3__c != null)
          comment = comment + objCase.Q3__c + '\n\n';
      if(objCase.A3__c != null)    
          comment = comment + objCase.A3__c + '\n\n';
      if(objCase.Q4__c != null)
          comment = comment + objCase.Q4__c + '\n\n';
      if(objCase.A4__c != null)    
          comment = comment + objCase.A4__c + '\n\n';
      if(objCase.Q5__c != null)
          comment = comment + objCase.Q5__c + '\n\n';
      if(objCase.A5__c != null)    
          comment = comment + objCase.A5__c + '\n\n';
      if(objCase.Q6__c != null)
          comment = comment + objCase.Q6__c + '\n\n';
      if(objCase.A6__c != null)    
          comment = comment + objCase.A6__c + '\n\n';
      if(objCase.Q7__c != null)
          comment = comment + objCase.Q7__c + '\n\n';
      if(objCase.A7__c != null)    
          comment = comment + objCase.A7__c + '\n\n';
      if(objCase.Q8__c != null)
          comment = comment + objCase.Q8__c + '\n\n';
      if(objCase.A8__c != null)    
          comment = comment + objCase.A8__c + '\n\n';
      if(objCase.Q9__c != null)
          comment = comment + objCase.Q9__c + '\n\n';
      if(objCase.A9__c != null)    
          comment = comment + objCase.A9__c + '\n\n';
      if(objCase.Q10__c != null)
          comment = comment + objCase.Q10__c + '\n\n';
      if(objCase.A10__c != null)    
          comment = comment + objCase.A10__c + '\n\n';
    
        Case_Note__c Note = new Case_Note__c();
        Note.Type__c = 'Case Escalated';
        Note.Details__c = comment;
        Note.Public__c = true;
        Note.Case__c = ApexPages.currentPage().getParameters().get('id');
        insert Note;   
        
        
      }   
   /*   if(errorShow == true)
      {
       return null; 
      }
      else{
        if(ApexPages.currentPage().getParameters().get('isdtp')!=null)
        {
            Pagereference pageRef = new Pagereference('/'+ cid);    
            return pageRef;
        }
        else{
            return null;
        }
      } */ 
     //return null; 
     
        return null;
    
   }        
     

    private static testmethod void BBW_Escalation(){
        
        
         Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        
        List<case> Lcas = new List<case>();
        Case cas = TestMethodUtility.createCase1(a,aset);
        cas.ContactID = c.ID;
        cas.Case_severity__c =  '1';
        cas.Status = 'New';
        cas.Replication_in_the_Case__c = 'AVBC';
        cas.A1__c = 'Hello';
        cas.A2__c = 'Hello';
        cas.A3__c = 'Hello';
        cas.A4__c = 'Hello';
        cas.A5__c = 'Hello';
        cas.A6__c = 'Hello';
        cas.A7__c = 'Hello';
        cas.A8__c = 'Hello';
        cas.A9__c = 'Hello';
        cas.A10__c = 'Hello';    
        cas.Primary_Group_Name__c = 'ANGEL - Midwest Engagement Team';    
        //Insert cas;
        
        
        /*Me*/
        Case cas1 = TestMethodUtility.createCase1(a,aset);
        cas1.ContactID = c.ID;
        cas1.Case_severity__c =  '1';
        cas1.Status = 'New';
        cas.Replication_in_the_Case__c = '';
        cas1.A1__c = 'Hello';
        cas1.A2__c = 'Hello';
        cas1.A3__c = 'Hello';
        cas1.A4__c = 'Hello';
        cas1.A5__c = 'Hello';
        cas1.A6__c = 'Hello';
        cas1.A7__c = 'Hello';
        cas1.A8__c = 'Hello';
        cas1.A9__c = 'Hello';
        cas1.A10__c = 'Hello';    
        cas1.Primary_Group_Name__c = 'ANGEL - Midwest Engagement Team';    
        //Insert cas1;
        Lcas.add(cas);
        Lcas.add(cas1);
        insert Lcas;

        Test.StartTest();
        
            
        ApexPages.CurrentPage().getParameters().put('id',cas.ID);
        
        BBW_Escalation escal = new BBW_Escalation();
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
         Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
         insert newtemp;                
        Template__c temp =  [select Id from Template__c where name ='Test123' limit 1];
        escal.TemplateName = temp.ID;
        escal.setTemplate(temp);
        escal.getTemplate();
        escal.QuestionTemplate();
        escal.TemplateName = '--None--';
        escal.QuestionTemplate();
        escal.getCase();
        escal.getTemplateList();
        escal.save();
        escal.Cancel();
        escal.TemplateName = temp.ID;
        escal.Escalate();
        
        cas.Primary_Group_Name__c = 'ANGEL - Software Solutions';
         
        ApexPages.CurrentPage().getParameters().put('id',cas.ID);
        
        BBW_Escalation escal1 = new BBW_Escalation();
        escal1.Escalate();
        Test.StopTest();


    }
   private static testmethod void BBW_Escalation1(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        
        List<Case> Lcas = new List<case>();
        Case cas = TestMethodUtility.createCase1(a,aset);
       // Insert cas; 
        
        Case cas1 = TestMethodUtility.createCase1(a,aset);
        cas1.Replication_in_the_Case__c='Replicated only in client env';
       // Insert cas1;
        
        Case cas2 = TestMethodUtility.createCase1(a,aset);
        cas2.Replication_in_the_Case__c='Replicated only in client env';
        cas2.Template__c=newtemp.id;
        //Insert cas2;
        
        Lcas.add(cas);
        Lcas.add(cas1);
        Lcas.add(cas2);
        
        Insert Lcas;
        
             
        ApexPages.CurrentPage().getParameters().put('id',cas.ID);
        BBW_Escalation escal1 = new BBW_Escalation();
        escal1.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas1.ID);
        BBW_Escalation escal2 = new BBW_Escalation();
        escal2.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas2.ID);
        BBW_Escalation escal3 = new BBW_Escalation();
        escal3.Escalate();
   } 
   private static testmethod void BBW_Escalation2(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        List<case> Lcas = New List<case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='Learn - L1 - Resellers - CognosOnline';
        //Insert cas3;
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Learn - L1 - Resellers - Eiffel';
        //Insert cas4; 
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='Learn - L1 - Resellers - AssistMicro';
       // Insert cas5;
       
       Lcas.add(cas3);
        Lcas.add(cas4);
        Lcas.add(cas5);
        Insert Lcas;
            
        
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();
        Test.stopTest();
   }  
 private static testmethod void BBW_Escalation3(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        List<case> Lcas = New List<Case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='Learn - L1 - Windows';
       // Insert cas3;
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Learn - L1 - Unix';
        //Insert cas4; 
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='Learn - L1 - EMEA';
       // Insert cas5;
       
        Lcas.add(cas3);
        Lcas.add(cas4);
        Lcas.add(cas5);
        Insert Lcas;
            
        
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();
        Test.stopTest();
   }    
  private static testmethod void BBW_Escalation4(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        List<Case> Lcas = new List<Case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='Learn - L1 - ANZSEA';
       // Insert cas3;
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Learn - L1 - Resellers - Grupo A';
       // Insert cas4; 
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='Learn - L1 - LAC';
        //Insert cas5;
        
        Lcas.add(cas3);
        Lcas.add(cas4);
        Lcas.add(cas5);
        Insert Lcas;
            
        
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();
        Test.stopTest();
   } 
    private static testmethod void BBW_Escalation5(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        List<case> Lcas= new List<case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='Learn - L1 - Mobile';
        //Insert cas3;
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Learn - L1 - Managed Hosting';
       // Insert cas4; 
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='Learn - L1 - Managed Hosting - EMEA';
        //Insert cas5;
        
        Lcas.add(cas3);
        Lcas.add(cas4);
        Lcas.add(cas5);
        Insert Lcas;
            
        
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();
        Test.stopTest();
   }   
   
   private static testmethod void BBW_Escalation6(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        List<Case> Lcas = new List<case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='Learn - L1 - Managed Hosting - Complex';
       // Insert cas3;
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Learn - L1';
        //Insert cas4; 
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='CE/Vista - L1';
        //Insert cas5;
        
        Lcas.add(cas3);
        Lcas.add(cas4);
        Lcas.add(cas5);
        Insert Lcas;
            
        
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();
        Test.stopTest();
   }     
  private static testmethod void BBW_Escalation7(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 
        
        List<case> Lcas = new List<case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='CE/Vista - L1 - Managed Hosting';
       // Insert cas3;
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Transact - Unix - Harco - Level 1';
        //Insert cas4; 
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='Transact - Windows -Decepticons -Level 1';
        //Insert cas5;
        Lcas.add(cas3);
        Lcas.add(cas4);
        Lcas.add(cas5);
        Insert Lcas;
        
        
            
        
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();
        Test.stopTest();
   }  
  private static testmethod void BBW_Escalation8(){
        
        
        Account a = TestMethodUtility.createAccount();
        a.Name = 'Test Account';
        a.BillingStreet = 'Test Street';
        a.BillingCity = 'Test City';
        a.BillingState = 'Test State';
        a.BillingCountry = 'Test Country';
        a.BillingPostalCode = 'Test Code';
        a.Type = 'Partner';
        
        Insert a;
        
        Contact c = TestMethodUtility.createContact(a);
        c.FirstName = 'Test';
        c.LastName = 'Contact';
        c.Email = 'test@test.com';
        
        Insert c;
        
        Core_License__c cr =TestMethodUtility.createCoreLicense();
        cr.Name = 'ANGEL';
        Insert cr;
        
        Asset aset = TestMethodUtility.createAsset(a,cr);
        aset.Name = 'Test Asset 111';
        aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
        aset.Installed_Product_ID__c = '123';
        insert aset;
        
        template__c newtemp = new template__c(Name='Test123' ,Core_License__c = cr.id,Q1__c='test',Q2__c='test',Q3__c='test',Q4__c='test',Q5__c='test',
        Q6__c='test',Q7__c='Test',Q8__c='test',Q9__c='test',Q10__c='test',Record_Type__c='Angel Case');
        insert newtemp; 

        Core_License__c cr1 =TestMethodUtility.createCoreLicense();
        cr1.Name = 'Moodlerooms';
        Insert cr1;


        Asset aset1 = TestMethodUtility.createAsset(a,cr1);
        aset1.Name = 'Test Asset 111';
        insert aset1;
        
        
        List<case> Lcas = new List<case>();
        Case cas3 = TestMethodUtility.createCase1(a,aset);
        cas3.Replication_in_the_Case__c='Replicated only in client env';
        cas3.Template__c=newtemp.id;
        cas3.A1__c = 'Hello';
        cas3.A2__c = 'Hello';
        cas3.A3__c = 'Hello';
        cas3.A4__c = 'Hello';
        cas3.A5__c = 'Hello';
        cas3.A6__c = 'Hello';
        cas3.A7__c = 'Hello';
        cas3.A8__c = 'Hello';
        cas3.A9__c = 'Hello';
        cas3.A10__c = 'Hello';  
        cas3.Primary_Group_Name__c ='Transact - Windows - Plan B - Level 1';
       // Insert cas3;
       Lcas.add(cas3);
        
        
        Case cas4 = TestMethodUtility.createCase1(a,aset);
        cas4.Replication_in_the_Case__c='Replicated only in client env';
        cas4.Template__c=newtemp.id;
        cas4.A1__c = 'Hello';
        cas4.A2__c = 'Hello';
        cas4.A3__c = 'Hello';
        cas4.A4__c = 'Hello';
        cas4.A5__c = 'Hello';
        cas4.A6__c = 'Hello';
        cas4.A7__c = 'Hello';
        cas4.A8__c = 'Hello';
        cas4.A9__c = 'Hello';
        cas4.A10__c = 'Hello';  
        cas4.Primary_Group_Name__c ='Transact - Unix - Harco - Level 2';
        //Insert cas4; 
        Lcas.add(cas4);
        
        Case cas5 = TestMethodUtility.createCase1(a,aset);
        cas5.Replication_in_the_Case__c='Replicated only in client env';
        cas5.Template__c=newtemp.id;
        cas5.A1__c = 'Hello';
        cas5.A2__c = 'Hello';
        cas5.A3__c = 'Hello';
        cas5.A4__c = 'Hello';
        cas5.A5__c = 'Hello';
        cas5.A6__c = 'Hello';
        cas5.A7__c = 'Hello';
        cas5.A8__c = 'Hello';
        cas5.A9__c = 'Hello';
        cas5.A10__c = 'Hello';  
        cas5.Primary_Group_Name__c ='Transact - Windows - Plan B - Level 2';
        //Insert cas5;
        Lcas.add(cas5);

        Case cas6 = TestMethodUtility.createCase1(a,aset1);
        cas6.Replication_in_the_Case__c='Replicated only in client env';
        cas6.Template__c=newtemp.id;
        cas6.A1__c = 'Hello';
        cas6.A2__c = 'Hello';
        cas6.A3__c = 'Hello';
        cas6.A4__c = 'Hello';
        cas6.A5__c = 'Hello';
        cas6.A6__c = 'Hello';
        cas6.A7__c = 'Hello';
        cas6.A8__c = 'Hello';
        cas6.A9__c = 'Hello';
        cas6.A10__c = 'Hello';  
        cas6.Primary_Group_Name__c ='Moodlerooms: EMEA';
        Lcas.add(cas6);
        
        Insert Lcas;
            
       
        ApexPages.CurrentPage().getParameters().put('id',cas3.ID);
        BBW_Escalation escal4 = new BBW_Escalation();
        escal4.Escalate();
        
        Test.startTest();
        ApexPages.CurrentPage().getParameters().put('id',cas4.ID);
        BBW_Escalation escal5 = new BBW_Escalation();
        escal5.Escalate();
        
        ApexPages.CurrentPage().getParameters().put('id',cas5.ID);
        BBW_Escalation escal6 = new BBW_Escalation();
        escal6.Escalate();

        ApexPages.CurrentPage().getParameters().put('id',cas6.ID);
        BBW_Escalation escal7 = new BBW_Escalation();
        escal7.Escalate();

        Test.stopTest();
   }                  
}