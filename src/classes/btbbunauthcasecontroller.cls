public  class btbbunauthcasecontroller {

    public void actionFunMethod() {
        system.debug('Murugappan');
        list<Contact> clist = [Select id, email from Contact where email =: email];
        list<Contact_Role__c> crlist = [ Select id from Contact_Role__c where Contact__r.email =: email and AccessCode__c = '7' and contact__c!= Null and Expire_Role__c = false ];

        if(crlist.size() > 0){
          emailerror = 'You have been identified as a Collaborate contact, please log in via authenticated portal!';  
          hidecasebutton = true;    
        }
        else{
            emailerror = '';  
            hidecasebutton = false;
        }
    }

    public string name {get;set;}
    public string emailerror{get;set;}
    public boolean hidecasebutton{get;set;}
    public string email {get;set;}
    public string reenteremail {get;set;}
    public string EndUSerOrganization {get;set;}
    public string phone {get;set;}
    public string subject {get;set;}
    public string description {get;set;}
    public string clientOSversion {get;set;}
    public string Browserversion {get;set;}
    public string javaversion {get;set;}
    public String clvalues{get;set;}
    public String browservalues {get;set;}
    public string module {get; set;}
    public string functionalarea {get; set;}
    public string category {get; set;}
    public string orgid{get;set;}
    public string cmsvalue{get;set;}
    public string cmsurl{get;set;}
    public string usrrolevalue{get;set;}
    transient public boolean errorShow{ get; set; }
    transient public String errorTitle{ get; set; }
    transient public String errorMessage{ get; set; } 
    transient public String errorSeverity{ get; set; } 
    public string product{get;set;}
    public boolean displayfuncarea {get;set;}
    public boolean displaycategory {get;set;}
    public list<selectoption> productlist{get;set;}
    public string ccemail{get;set;}
    public map<string,Core_License__c> corelicensemap= new map<string,Core_License__c>();
    
    public EndUser__c enduserrecord      {get;set;}
    public Case caserecord      {get;set;}

     public btbbunauthcasecontroller(){
          hidecasebutton = false;
          enduserrecord = new EndUser__c();
          caserecord = new Case();
          cmsvalue = 'No CMS / LMS';
           if(Apexpages.currentpage().getparameters().get('subject')!=null)
          {
                subject=Apexpages.currentpage().getparameters().get('subject');
          }
         // productlist=new list<selectoption>();
          
          for(Core_License__c cr : [select id,name,product__c from Core_License__c where name like 'Collaborate'] )
            {
                corelicensemap.put(cr.product__c,cr);
               // productlist.add(new selectoption(cr.product__c,cr.product__c));
            }  
     }

     public pagereference saveObjects(){
        caserecord = new Case();
        errorShow = false;
        enduserrecord.Name=name;
        enduserrecord.Email__c=email;
        enduserrecord.Phone__c=phone;
        enduserrecord.Product_Suite__c=product;
        enduserrecord.Institution_text__c=EndUSerOrganization;
        enduserrecord.Institution_Role__c=usrrolevalue;
        caserecord.End_User_Institution__c=EndUSerOrganization;
        caserecord.Subject=subject;
        caserecord.Description=description;
        caserecord.End_User_Product__c =product;
        caserecord.Browser__c=browservalues;
        caserecord.Browser_Version__c=Browserversion;
        caserecord.Client_OS__c=clvalues;
        caserecord.Client_OS_Version__c=clientOSversion;
        caserecord.Java_Version__c=javaversion;
        caserecord.CMS_LMS__c=cmsvalue;
        caserecord.CMS_LMS_URL__c=cmsurl;
     if(corelicensemap.keyset().contains(product))
        {
            caserecord.Core_License__c=corelicensemap.get(product).id;
        }
        else if(product.contains('SAS')||product.contains('Plan')||product.contains('Publish')||product.contains('ELM'))
        {
            caserecord.Core_License__c=corelicensemap.get('Web Conferencing').id;
        }
        if(EndUSerOrganization == Null|| EndUSerOrganization=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Organization Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
       else if((email==null)||(!Pattern.matches('^[_A-Za-z0-9-\']+(\\.[_A-Za-z0-9-\']+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z-]{2,})$',email)))
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Email: You must enter a valid email';
            errorSeverity = 'error';
            return null;
        }
         else if(email!=reenteremail)
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Email: Emails does not match.';
            errorSeverity = 'error';
            return null;
        }
        else if(ccemail != null && ccemail!='')
        {
            ServiceCloudUtility.ValidateEmailResults ccErrorResult= ServiceCloudUtility.validateccemails(ccemail);
            if(ccErrorResult != null && ccErrorResult.isSuccess==false)
            {
                errorShow = true;
                errorTitle = 'Error:';
                errorMessage = ccErrorResult.errormessage;
                errorSeverity = 'error';
                return null;
            }
            else
            {
                integer x=1;
                 for(string s: ccemail.split(';'))
                {
                    if(x==1)
                        {
                            caserecord.ccemail1__c=s;
                        }
                        else if(x==2)
                        {
                            caserecord.ccemail2__c=s;
                        }
                        else if(x==3)
                        {
                            caserecord.ccemail3__c=s;
                        }
                        else if(x==4)
                        {
                            caserecord.ccemail4__c=s;
                        }
                        else if(x==5)
                        {
                            caserecord.ccemail5__c=s;
                        }
                     x++;   
                }
            }
        }
        else if(phone ==null || phone =='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Phome: You must enter a value.';
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
        system.debug('orgid---'+orgid);
        if(orgid != null && orgid != '' && orgid.startswith('001'))
        {
        caserecord.AccountId=Id.valueof(orgid);
        enduserrecord.Account__c=Id.valueof(orgid);
        }
        try {
        list<endUser__c> enduserlist=[select id from enduser__c where email__c=:email limit 1]  ;
        if(enduserlist != null && enduserlist.size()>0)
        {
            caserecord.End_User__c=enduserlist[0].id;
        } 
        else
        { 
            insert enduserrecord;
            endUser__c enduserrecord2 =[select id,name from EndUser__c where id=:enduserrecord.Id];
            caserecord.End_User__c=enduserrecord2.Id;
        }
        
        insert caserecord;

       } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        pagereference pageref=Page.btbb_publiccaseconfirmation; 
        pageref.getparameters().put('id',caserecord.id);
        pageref.setredirect(true);
        return pageref;
     }
     
     public List<selectOption>getproductlists()
     {
        productlist = new list<selectoption>();
        productlist.add(new selectoption('none','--Select Product--'));
        Schema.DescribeFieldResult ProductSuite = Case.End_User_Product__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ProductSuite.getPicklistValues())
              {
                productlist.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                
              }
            return productlist;  
        
     }
     
     public List<SelectOption> getclos() {
        List<SelectOption> options = new List<SelectOption>();
             Schema.DescribeFieldResult ClienetOSDecribe = Case.Client_OS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ClienetOSDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                clvalues=picklistEntry.getvalue();      
                }
              }
            return options;  
        }

    public List<SelectOption> getusrroleoptions() {
     
        List<SelectOption> options = new List<SelectOption>();
             Schema.DescribeFieldResult ClienetOSDecribe = Case.User_Role__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ClienetOSDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                usrrolevalue=picklistEntry.getvalue();  
                }
              }
            return options; 
        }
       public List<SelectOption> getbrowsop() {
        List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult BrowserDecribe = Case.Browser__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                browservalues=picklistEntry.getvalue(); 
                }
              }
             return options;    
        }
     public List<SelectOption> getcmsoptions() {
     
        List<SelectOption> options = new List<SelectOption>();
             Schema.DescribeFieldResult ClienetOSDecribe = Case.CMS_LMS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ClienetOSDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                cmsvalue=picklistEntry.getvalue();  
                }
              }
            return options; 
    }
 //test comment added
    public void changeproduct()
    {
        if(corelicensemap.keyset().contains(product))
        {
            caserecord.Core_License__c=corelicensemap.get(product).id;
        }
        else if(product.contains('SAS')||product.contains('Plan')||product.contains('Publish')||product.contains('ELM'))
        {
            caserecord.Core_License__c=corelicensemap.get('Web Conferencing').id;
        }
        
    }
     
/* ************************************************* modules picklist ****************************************************************** */     
    public List<selectOption> modules {
        
        get {
            
            List<selectOption> options = new List<selectOption>();
                options.add(new SelectOption('','-- Select an Issue Topic --'));
            if (product != null) {
                
                for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : caserecord.Core_License__c AND Name != 'Technical Services Request (ICM)' AND Name != 'Integrations' AND Name != 'Report System / Service Disruption' AND Name != 'Request Upgrade' ORDER BY Name ASC]) {
                       options.add(new SelectOption(m.Id,m.Name));
                       if(product==m.Name)
                       {
                        options = new List<selectOption>();
                        options.add(new SelectOption(m.Id,m.Name));
                        module=m.id;
                       }
                   }
               }
            
            return options;           
        }
     set;
    }   
/* ************************************************* functional areas picklist ****************************************************************** */     
    public List<selectOption> functionalareas {
       get {
            List<selectOption> options = new List<selectOption>();
                       options.add(new SelectOption('','-- Select Functional Area --'));
            /*system.debug('hi--'+module);*/
            System.debug(module);
            if (module != null) {
                for (Functional_Area__c fa : [select Id, Name from Functional_Area__c Where Module__c = :module AND Name != 'Technical Services Request (ICM)' AND Name != 'Integrations' Order By Name])
                        options.add(new SelectOption(fa.Id,fa.Name));
            }
            System.debug(module);
            System.debug(options);
            if(options.size() > 1)
                displayfuncarea = false;
            else
                displayfuncarea = true;
            System.debug('AAAAAAAAAAA' + displayfuncarea );     
            return options;           
        }
        set;
    }  
/* ************************************************* categories picklist ****************************************************************** */     
     public List<selectOption> categories {
        get {
            List<selectOption> options = new List<selectOption>();
                options.add(new SelectOption('','-- Choose a Category --'));
            if (functionalarea != NULL) {
                
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
     
            
             
           
       
           
       
      
      
      
      
      
      
      
      
      
      
      
      
      
      
}