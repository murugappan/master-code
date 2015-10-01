public  class createliveagentcontroller {
    
    public case caserecord{get;set;}
    public map<string,Core_License__c> corelicensemap= new map<string,Core_License__c>();
    public list<selectoption> productlist{get;set;}
    public string module {get; set;}
    public string functionalarea {get; set;}
    public string category {get; set;}
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; } 
    public String errorSeverity{ get; set; }
    public boolean displayfuncarea {get;set;}
    public boolean displaycategory {get;set;}
    public boolean enduseridboolean {get;set;}
    private User CurrentUser;
    
    public createliveagentcontroller(ApexPages.StandardController controller)
    {
        this.caserecord=(case)controller.getrecord();
        this.caserecord.recordtypeid=RT.getId(Case.SObjectType, RT.Name.End_User_Case_Open); 
        
        
          productlist=new list<selectoption>();
            productlist.add(new selectoption('none','--Select Product--'));
            for(Core_License__c cr : [select id,name,product__c from Core_License__c where name like 'Collaborate'] )
            {
                corelicensemap.put(cr.product__c,cr);
            } 
            Schema.DescribeFieldResult ProductSuite = Case.End_User_Product__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ProductSuite.getPicklistValues())
              {
                productlist.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                
              }
        string chatcaseid=Apexpages.Currentpage().getParameters().get('chatid');
        string enduserid=Apexpages.Currentpage().getParameters().get('enduserid');
        
        
        if(enduserid == null){
            caserecord.Origin = 'Live Agent Chat';
        }
        else{
            caserecord.Origin = '--None--';
        }
        
        
        
        if(chatcaseid != null &&  chatcaseid != '')
        {
            chatcase__c chatrecord=[select id,description__c,email__c, Java_Version__c, Client_OS__c, Client_OS_Version__c,institution__c,name__c,phone__c,product__c,
                                        role__c,subject__c, Browser__c, CMS_LMS_URL__c,CMS_LMS__c, URL_Accessed__c, Browser_Version__c,Account__c from chatcase__c where id =:chatcaseid limit 1];
            
            caserecord.Browser__c = chatrecord.Browser__c;
            caserecord.Client_OS__c = chatrecord.Client_OS__c; 
            caserecord.Client_OS_Version__c = chatrecord.Client_OS_Version__c; 
            caserecord.Browser_Version__c = chatrecord.Browser_Version__c;
            caserecord.URL_Access__c = chatrecord.URL_Accessed__c; 
            caserecord.Java_Version__c = chatrecord.Java_Version__c;
            caserecord.CMS_LMS__c = chatrecord.CMS_LMS__c;
            caserecord.CMS_LMS_URL__c = chatrecord.CMS_LMS_URL__c;
            caserecord.End_User_Institution__c = chatrecord.institution__c;
             caserecord.Chatcase__c=chatcaseid;
            //If Account was captured by the agent                          
            if(chatrecord.Account__c != null)   
            {
                caserecord.accountid=chatrecord.Account__c;
            }
            else  //If Account was not captured by the agent    
            {
                                        
                list<Account> acclist=[select id,name from account where name=:chatrecord.institution__c];
                if(acclist!= null && acclist.size()>0 )
                {                           
                    caserecord.accountid=acclist[0].id;
                }
            }
            
            // Update the subject and description from the chat session into the Case record.
             
                caserecord.subject=chatrecord.subject__c;
                caserecord.Description=chatrecord.description__c;
                
            //Find the related End User ccreated or found during the chat session.  
            List<EndUser__c > Enduserlist = new List<EndUser__c >();
            EndUserList=[Select id from EndUser__c where Email__c= :chatrecord.email__c limit 1];
            if(EndUserList != null && EndUserList.size()>0)
            {
                caserecord.End_User__c=EndUserList[0].id;
            }
            
            
            
           if(corelicensemap != null && chatrecord.product__c != null)
            {
                if(corelicensemap.keyset().contains(chatrecord.product__c) )
                {   
                    caserecord.End_User_Product__c=chatrecord.product__c;
                    caserecord.Core_License__c=corelicensemap.get(chatrecord.product__c).id;
                }
                else if(chatrecord.product__c.contains('SAS')||chatrecord.product__c.contains('Plan')||chatrecord.product__c.contains('Publish')||chatrecord.product__c.contains('ELM'))
                {
                    caserecord.Core_License__c=corelicensemap.get('Web Conferencing').id;
                    caserecord.End_User_Product__c=chatrecord.product__c;
                }
            } 
        }       
        else if(enduserid != null && enduserid!= '')
        {
        
        
        enduseridboolean = true;
        
        EndUser__c enduserrecord=[select id, Account__c, Email__c, Institution_Role__c, Institution_text__c, Phone__c, 
                                  Product_Suite__c, Time_of_Last_Created_Case__c, Time_of_Last_Initiated_Chat__c from EndUser__c where id =:enduserid limit 1];
            
         caserecord.Accountid = enduserrecord.Account__c;
         caserecord.End_User_Product__c = enduserrecord.Product_Suite__c;
         caserecord.End_User__c = enduserrecord.id;
         caserecord.User_Role__c = enduserrecord.Institution_Role__c;
         caserecord.End_User_Institution__c = enduserrecord.Institution_text__c;
         caserecord.Type = 'Standard Support Ticket';
         
             if(corelicensemap != null)
                {
                    if(corelicensemap.keyset().contains(enduserrecord.Product_Suite__c) )
                    {   
                        caserecord.End_User_Product__c=enduserrecord.Product_Suite__c;
                        caserecord.Core_License__c=corelicensemap.get(enduserrecord.Product_Suite__c).id;
                    }
                }
        }
    }
    
    
    
    public void changeproduct()
    {
        if(corelicensemap.keyset().contains(caserecord.End_User_Product__c))
        {
         caserecord.Core_License__c=corelicensemap.get(caserecord.End_User_Product__c).id;
        }
        else if(caserecord.End_User_Product__c.contains('SAS')||caserecord.End_User_Product__c.contains('Plan')||caserecord.End_User_Product__c.contains('Publish')||caserecord.End_User_Product__c.contains('ELM'))
        {
            caserecord.Core_License__c=corelicensemap.get('Web Conferencing').id;
        }
        
    }
    /*--------------------------------- MODULE SELECT LIST ---------------------------------*/


        public List<selectOption> modules {
            get {
                errorShow = false;
                List<selectOption> options = new List<selectOption>();
    
                if (caserecord.Core_License__c != null) {
                    options.add(new SelectOption('','-- Choose an Issue Topic --'));
                    for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : caserecord.Core_License__c  order by name] )
                    {
                        options.add(new SelectOption(m.Id,m.Name));
                        if(caserecord.End_User_Product__c==m.Name)
                       {
                        module=m.id;
                       }
                    }
                }
    
                return options;           
            }
            set;
        }   

    /*--------------------------------- FUNCTIONAL AREAS SELECT LIST ---------------------------------*/

        public List<selectOption> functionalareas {
            get {
                errorShow = false;
                List<selectOption> options = new List<selectOption>();
    
                if (module != NULL) {
                    options.add(new SelectOption('','-- Choose a Functional Area --'));
                    for (Functional_Area__c fa : [select Id, Name from Functional_Area__c Where Module__c = :module  Order By Name])
                        options.add(new SelectOption(fa.Id,fa.Name));
                }
                if(options.size() > 1)
                    displayfuncarea = false;
                else
                    displayfuncarea = true;
                return options;           
            }
            set;
        }  

    /*--------------------------------- CATEGORIES SELECT LIST ---------------------------------*/

        public List<selectOption> categories {
            get {
                errorShow = false;
                List<selectOption> options = new List<selectOption>();
    
                if (functionalarea != NULL) {
                    options.add(new SelectOption('','-- Choose a Category --'));
                    for (Category__c cat : [select Id, Name from Category__c Where Functional_Area__c = :functionalarea Order By Name])
                        options.add(new SelectOption(cat.Id,cat.Name));
                }
                if(options.size() > 1)
                    displaycategory = false; 
                else
                    displaycategory = true;
                return options;           
            }
            set;
        }     

      public PageReference savecase()
      {
         errorShow = false;
        if(caserecord.accountid == Null)
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Account Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }

        else if(caserecord.End_User__c == Null && enduseridboolean == false )
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'EndUSer Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
       else if(caserecord.End_User_Product__c == Null || caserecord.End_User_Product__c=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Product: You must enter a value';
            errorSeverity = 'error';
            return null;
        } 
        else if(module==Null || module=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Issue Topic: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
         else if(caserecord.Subject==Null || caserecord.Subject=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Subject: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(caserecord.Description==Null || caserecord.Description=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Description: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        caserecord.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.End_User_Case_Open); 
        caserecord.Module__c = module;
        caserecord.Functional_Area__c = functionalarea;
        caserecord.Category__c = category;
        
        try {
            upsert(caserecord);

        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return new Pagereference('/'+caserecord.id);
      }
     /*--------------------------------- SAVE AND GRAB PAGE REFERENCE ---------------------------------*/ 
      public PageReference saveandgrabcase()
      {
         errorShow = false;
         CurrentUser = [Select Id,Primary_Group__c, Name, FirstName, LastName From User Where Id =: Userinfo.getUserID()];
        if(caserecord.accountid == Null)
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Account Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }

        else if(caserecord.End_User__c == Null && enduseridboolean == false )
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'EndUSer Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
       else if(caserecord.End_User_Product__c == Null || caserecord.End_User_Product__c=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Product: You must enter a value';
            errorSeverity = 'error';
            return null;
        } 
        else if(module==Null || module=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Issue Topic: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
         else if(caserecord.Subject==Null || caserecord.Subject=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Subject: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(caserecord.Description==Null || caserecord.Description=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Description: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
         
         else if(CurrentUser.Primary_Group__c=='' || CurrentUser.Primary_Group__c == null || CurrentUser.Primary_Group__c == '-None-')
         {
          errorShow = true;
          errorTitle = 'Error:';                  
          errorMessage = 'You do not have Primary Group assigned. Please Contact your System Administrator to assign a Primary group or Click on Create New Case button to Create a Case';
          errorSeverity = 'error';
          return null;
         
         }                
        caserecord.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.End_User_Case_Open); 
        caserecord.Module__c = module;
        caserecord.Functional_Area__c = functionalarea;
        caserecord.Category__c = category;
        
        try {
            upsert(caserecord);

        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        case c = [select id,ownerid from Case where id=:caserecord.id];
        c.ownerId = CurrentUser.Id;
        update c;
        
        
        
        return new Pagereference('/'+caserecord.id);
      }
     
      
}