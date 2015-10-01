public without sharing class btbbCreateCase {

    private ApexPages.StandardController controller {get; set;}
    transient GlobalComponent gc = new GlobalComponent();
    transient public String originalver,originalbuild; 
    private Case cas;
    public boolean displayeditasset {get;set;}
    public boolean checkserv {get;set;}
    public boolean editSB {get;set;}
    public Account acct {get; set;}
    transient public boolean errorShow{ get; set; }
    transient public String errorTitle{ get; set; }
    transient public String errorMessage{ get; set; } 
    transient public String errorSeverity{ get; set; } 
    public string asset {get; set;}
    public string contact {get; set;}
    
    //public account acc {get;set;}
    public boolean servcheck {get;set;}
    
    public string Pyramidversion{get;set;}
    public string module {get; set;}
    public string functionalarea {get; set;}
    public string category {get; set;}
    public string version{get;set;}
    public id acountid{get;set;}
    public string account{get;set;}
    public string sourcebuild {get; set;}
    transient String v;
    String sev = '3';
    public boolean displayfuncarea {get;set;}
    public boolean displaycategory {get;set;}
    public boolean premiumsupport {get;set;}
    
    //modified for Moodleroom
    public String clvalues{get;set;}
    public String browservalues {get;set;}
    public String mrcasetypevalues {get;set;}
    public boolean modelroom{get;set;}
    
    //collab
    public boolean collab {get;set;}
    public string cmsvalue{get;set;}
    public string usrrolevalue{get;set;}
    public string instancevalue{get;set;}
    public string ccemail{get;set;}
    
    //Learn SAAS

    public boolean isLearnSAAS{get;set;}
    
    // Analytics

    public boolean isAnalytics{get;set;}

    //xpLor
    public boolean isxplor{get;set;}

    public Pagereference updateasset(){
    
        transient List<Asset> updasset = new List<Asset>([select ID,Name,Version__c,Version_Build__c from Asset where ID =: asset limit 1]);
        if(updasset.size() > 0){
            Asset_Version_History__c AVH= new Asset_Version_History__c();
            AVH.Asset__c=updasset[0].id;
            AVH.Current_Version__c=version;
            if(sourcebuild != '-None-')
            AVH.Current_Build__c=sourcebuild;
            AVH.Effective_Date__c=system.now();
            
            insert AVH;
            /*updasset[0].Version__c = version;
            if(sourcebuild != '-None-')
                updasset[0].Version_Build__c = sourcebuild;
            else    
                updasset[0].Version_Build__c = '';
            Update updasset[0];*/
        }
    
        displayeditasset = false;
        
        editSB = false;
        originalver = version;
        if(sourcebuild != '-Please Select-')
            originalbuild = sourcebuild;
        else 
            originalbuild = '';
            updasset.clear();
        return null;
        

    }
    
    public Pagereference cancelupdate(){
        displayeditasset = false;
        return null;
    }
    
    public Pagereference changeEdit(){
        
        if(version != null){
            if(version != originalver){
                displayeditasset = true;                
                sourcebuild = '-Please Select-';
            }else{
                displayeditasset = false;
                sourcebuild = originalbuild;
            }
        }
        
        editSB = true;
        return null;
     }
     
     public Pagereference changeversion(){
        String sbld = ApexPages.CurrentPage().getParameters().get('sbuild');
        sourcebuild = sbld;
        if(sourcebuild != null){
            if(sourcebuild != originalbuild || version != originalver)
                displayeditasset = true;                
            else
                displayeditasset = false;
        }
        return null;
     }
     
     
     public Pagereference modulechange(){
        String m = ApexPages.CurrentPage().getParameters().get('mod');
        module = m;  
        functionalarea = null;  
        category = null; 
        return null;
     }
        
    public String getsev() {
               return sev;
    }
    
    public void setsev(String sev ) { this.sev = sev ;}
    
    public List<selectOption> accounts {
        get {
                List<selectOption> options = new List<selectOption>();
                List<User> u = new List<User>([select ID,ContactID from USer where ID =: Userinfo.getUserID()]);
                Set<Id> accId = new Set<ID>();
                for(Contact_Role__c cr : [Select c.Role__c, c.Expire_Role__c, c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND c.Expire_Role__c = false AND Contact__c!= NULL and AccessCode__c ='7']){
                        accId.add(cr.Account__c);    
                } 
                
                User loginUser = [Select AccountId,contactId from user where id =:Userinfo.getUserid()];
                accId.add(loginUser.AccountId);
 
                for (account at : [SELECT id,name FROM Account WHERE ID IN: accId ORDER BY name])
                {if((at.id!=null)||(at.name!=null))
                    {
                         options.add(new SelectOption(at.id,at.name));
                            
                    }

                }
 
            return options;           
        }
        set;
    }  
   
    public boolean getdisplayInstance(){
        List<Asset> a = new List<Asset>([SELECT id, name, version__c ,Core_License__r.Name,Core_License__r.product__c FROM Asset a WHERE a.id =: asset]);
        if(a.size() > 0 && (a[0].Core_License__r.Name.contains('ANGEL')||(a[0].Core_License__r.Name.contains('Learn')&&a[0].Core_License__r.product__c.contains('Learn SAAS')))){
            a.clear();
            return true;
            
        }
        else{
        a.clear();
            return false;   
        }     
        
    }
    
    public boolean isAssetSelect {
        
        get {
            if(asset != null && asset != '')            
                return false;
            else
                return true;
            
        }
        set;
    }
    
    public Pagereference selectAccount(){
       
        isAssetSelect = true;
        asset = null;   
        module = null;
        functionalarea = null; 
        displayeditasset = false;   
        return null;
     }
     
    public Pagereference selectAsset(){
         
        module = null;
        functionalarea = null;  
        displayeditasset = false;
        category = null;  
        isLearnSAAS=false;
        isxplor = false;
        modelroom=false;
        collab = false;
        isAnalytics = false; 
        if(asset != null){
            Asset a = [select Id,Version__c,Version_Build__c,Core_License__r.Name,Core_License__r.Product__c from Asset where ID =: asset];
            originalver = a.Version__c;
            originalbuild = a.Version_Build__c;
            version = a.Version__c;
            sourcebuild = a.Version_Build__c; 
            System.debug('********'+sourcebuild);
            if(a.Core_License__r.Name=='Moodlerooms')
            {
             modelroom=true;  
            }
           else if(a.Core_License__r.Name.contains('Collaborate'))
               {
                 collab = true;
               }
           else if(a.Core_License__r.Name.contains('Analytics'))
               {
                 isAnalytics = true;
               }
            else if(a.Core_License__r.Name.contains('xpLor'))
               {
                 isxplor = true;
                 cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.xpLor);
               }   
          /* else
           {
                modelroom=false;
                collab = false;
                isAnalytics = false; 
                isxplor = false;

           } */
            if(a.Core_License__r.Name == 'ANGEL LMS')
                {
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Angel);
                }
                else if(a.Core_License__r.Name == 'Learn' && a.Core_License__r.Product__c=='Learn SAAS')
                {
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                    isLearnSAAS=true;
                }
            
        }
          
        return null;
     }
      
    public List<selectOption> assets {
        get {
            List<selectOption> options = new List<selectOption>();
           
            if (account != null) {
            
                    options.add(new SelectOption( '' ,'-- Select an Environment --'));

                    }

            List<User> u = new List<User>([select ID,ContactID from USer where ID =: Userinfo.getUserID()]);
            
            Map<ID,Set<String>> accountmap = new Map<ID,Set<String>>();

       for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND Expire_Role__c = false AND Contact__c!= NULL and AccessCode__c ='7']){
              
           for(Contact_Role__c cr1 : cr){                  
               if(null != accountmap && (accountmap.size() == 0 || !accountmap.containsKey(cr1.Account__c))){
                   
                   Set<String> role = new Set<String>();
                   if(null != cr1.Code__c) {
                        role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
               }else if(null != accountmap){
                   
                   Set<String> role = new Set<String>();
                   role = accountmap.get(cr1.Account__c);
                   if(null != cr1.Code__c) {
                       role.add(cr1.Code__c);
                   }
                   accountmap.put(cr1.Account__c,role);
               }               
            }
         }   
         
         Set<ID> casID = new Set<ID>();
 
         for (Asset a : [SELECT id,name,AccountID, Core_License__r.Name,Core_License__r.Product__c, Product2Id, Product2.Name, isBtbbEligible__c,External_Asset_Name__c,Software_URL__c FROM Asset a WHERE (a.accountid = :account AND a.core_license__c != null AND a.isBtbbEligible__c = true) OR (a.accountid = :account AND a.Force_Btbb_Visibility__c = true AND a.core_license__c != null) Order By External_Asset_Name__c]){
             // teting bit bucket
             Set<String> roles = new Set<String>();
             roles = accountmap.get(a.AccountID);  
             System.debug(a.Core_License__r.Name);
             if(a.Core_License__r.Name != null)
             
             if(roles != null && roles.contains('LEARN')){
                 if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Learn') && !a.Core_License__r.Product__c.contains('Learn SAAS')){
                    if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
                    }
                 }
                 else if (a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Learn') && a.Core_License__r.Product__c.contains('Learn SAAS'))
                 {
                    if((a.name!=null)&&(a.id!=null)){
                    options.add(new SelectOption(a.Id,a.name));
                     }
                 }   
             }
             if(roles != null && roles.contains('ANGEL')){
                 if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('ANGEL')){
                     if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
                     }
                 }  
             }if(roles != null && roles.contains('TRANSACT')){
                 if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Transact')){
                    if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
                     }
                 }  
              }if(roles != null && roles.contains('XYTHOS')){
                   if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Xythos')){
                     if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
                     }
                  }   
              }if(roles != null && roles.contains('CEVISTA')){
                   if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('CE') && a.Core_License__r.Name.contains('Vista')){
                     if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
                     }
                  }   
              }if(roles != null && roles.contains('Moodlerooms')){
                   if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Moodlerooms')){
                     if((a.name!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.name+' '+a.Software_URL__c));
                     }
                  }   
              }if(roles != null && roles.contains('COLLABORATE')){
                   if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Collaborate')){
                     if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.Product2.Name+' '));
                     }
                  }   
              }if(roles != null && roles.contains('Analytics')){
                   if(a.Core_License__r.Name !=null && a.Core_License__r.Name.contains('Analytics')){
                     if((a.Product2.Name!=null)&&(a.id!=null)){

                         options.add(new selectoption(a.Id,a.Product2.Name));    
                    }     
                  }
              }if(roles != null && roles.contains('xpLor')){
                   if(a.Core_License__r.Name !=null && a.Core_License__r.Name.contains('xpLor')){
                     if((a.Product2.Name!=null)&&(a.id!=null)){

                         options.add(new selectoption(a.Id,a.Product2.Name));    
                    }     
                  }
              }
         }     
         accountmap.clear(); 
         return options;           
        }
        set;
    }
    
    public boolean managedhostingasset{
        
        get {
            if(asset != null){
                Asset a = [select ID,Managed_Hosting__c from Asset where ID =: asset];
                if(a.Managed_Hosting__c == 'ANGEL - Managed Hosting' || a.Managed_Hosting__c == 'Learn - Managed Hosting')
                    return true;
                else 
                    return false;    
            }else    
                return true; 
       }
        set;
        
    }


    // new versions code
    
     public List<selectOption> versions {
        get{
                system.debug('ver++ ');
                List<selectOption> options = new List<selectOption>();
                String v1;
                if (asset != null) {
                
            
                    for (Asset a : [SELECT version__c,Product2.GKEY_Product_Group__c  FROM Asset a WHERE a.id =: asset limit 1] ) {
                         if(a.version__c != null ) {
                               if(version == null || (version != null && version != a.version__c))
                                    version = a.version__c;
                                     options.add(new SelectOption(a.version__c,a.version__c));
                          }
                           set<string> versionset= new set<string>(); 
                           for (Version_Build_Tree__c v : [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE Version__c !=: a.version__c AND GKEY_Product_Group__c =: a.Product2.GKEY_Product_Group__c AND Active_Flag__c = true  ORDER BY Version__c ]){
                                if(v.version__c != null && !versionset.contains(v.version__c))
                                {
                                versionset.add(v.version__c);
                                options.add(new SelectOption(v.version__c,v.version__c));
                                }
                             }
                    }
                  
                }
                if(options.size()>0)
                for(integer i = 0; i<(options.size()-1);i++)
                {
                    for(integer y=i+1;y<=options.size()-1;y++)
                    {
                        try{                    
                            list<string> a=options[i].getValue().splitByCharacterTypeCamelCase();
                            list<string> b=options[y].getValue().splitByCharacterTypeCamelCase();
                            integer loop_length;
                            if(a.size()<b.size())
                                loop_length=a.size();
                            else
                                loop_length=b.size();
                            integer k=0;
                            while(k<loop_length)
                            {
                                if(((a[k]).isNumeric() && (b[k]).isNumeric() &&Integer.valueof(a[k])<integer.valueof(b[k]))||((a[k]).isAlpha() && (b[k]).isAlpha()&&a[k]<b[k]))
                                {
                                    selectoption temp;
                                    temp=options[i];
                                    options[i]=options[y];
                                    options[y]=temp;
                                    break;
                                } 
                                else if(a[k]==b[k])
                                {
                                    k++;    
                                }
                                else
                                {
                                    break;
                                }
                            }

                        }
                        catch (exception e)
                        {
                        }    
                    }
                }
            
            return options;
        }
        set;    
    }
    
    // end new versions code
    

    // new source build code
     
     public List<selectOption> sblist{
        
        get {
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            Set<String> tmp = new Set<String>();
            if(asset != null) {
                if(sourcebuild == '-Please Select-')
                    options.add(new SelectOption('','-Please Select-'));
                if(sourcebuild != '-Please Select-' && sourcebuild != null)
                    options.add(new SelectOption(sourcebuild,sourcebuild));
                for (Asset a : [SELECT version__c,Version_Build__c,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: asset limit 1]) {
                /*  
                    if(a.Version__c!=version)
                        {
                        sourcebuild=null;
                        }  */
                       if(a.Version_Build__c != null) {
                         if(sourcebuild == null || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-None-'))
                            sourcebuild  = a.Version_Build__c;
                         if(sourcebuild != a.Version_Build__c)   
                               options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c)); 
                      }
                             
               for (Version_Build_Tree__c v : [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c WHERE /*Version_Build__c!= :a.Version_Build__c AND **/ GKEY_Product_Group__c =:a.Product2.GKEY_Product_Group__c AND Version__c =:version AND version_build__c !=:sourcebuild AND Active_Flag__c =true ORDER BY Version_Build__c DESC]){           
                    if(v.Version_Build__c != null)
                    {
                    options.add(new SelectOption(v.Version_Build__c,v.Version_Build__c));
                    }
                }
                }
                      

            }
            
            if(options.size()>0)
              for(integer i = 0; i<(options.size()-1);i++)
              {
                for(integer y=i+1;y<=options.size()-1;y++)
                {
                    try{                    
                    list<string> a=options[i].getValue().splitByCharacterTypeCamelCase();
                    list<string> b=options[y].getValue().splitByCharacterTypeCamelCase();
                    integer loop_length;
                    if(a.size()<b.size())
                      loop_length=a.size();
                    else
                      loop_length=b.size();
                      integer k=0;
                        while(k<loop_length)
                        {
                            if(((a[k]).isNumeric() && (b[k]).isNumeric() &&Integer.valueof(a[k])<integer.valueof(b[k]))||((a[k]).isAlpha() && (b[k]).isAlpha()&&a[k]<b[k]))
                            {
                                selectoption temp;
                                temp=options[i];
                                options[i]=options[y];
                                options[y]=temp;
                                break;
                            } 
                            else if(a[k]==b[k])
                            {
                            k++;    
                            }
                            else
                            {
                             break;
                            }
                        }
                
                    }
                catch (exception e)
                   {
                   }    
                }
              }
            return options;
        }
        set;
    }
    // end source build code
/* ************************************************* modules picklist ****************************************************************** */     
    public List<selectOption> modules {
        
        get {
            
            List<selectOption> options = new List<selectOption>();
                options.add(new SelectOption('','-- Select an Issue Topic --'));
            if (asset != null) {
                 
                 for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : [select core_license__c from asset where id =:asset].core_license__c ORDER BY Order__c,Name ASC]) {
                   //system.debug('1---' + m.Id + ' ' + m.Name);
                       options.add(new SelectOption(m.Id,m.Name));
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
            
            if (module != null) {
                for (Functional_Area__c fa : [select Id, Name from Functional_Area__c Where Module__c = :module Order By Order__c,Name])
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
   /************* pyramid version****************/
    public List<SelectOption> getPyramidversions() {
     
        List<SelectOption> options = new List<SelectOption>();
       
             Schema.DescribeFieldResult PyramidVersionDecribe = Case.Pyramid_Version__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: PyramidVersionDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                Pyramidversion = picklistEntry.getvalue();  
                }
              }
            return options; 
    }
/************* pyramid version  end****************/  
    
    
 /* ************************************************* categories picklist ****************************************************************** */     
     public List<selectOption> categories {
        get {
            List<selectOption> options = new List<selectOption>();
                options.add(new SelectOption('','-- Choose a Category --'));
            if (functionalarea != NULL) {
                
                for (Category__c cat : [select Id, Name from Category__c Where Functional_Area__c = :functionalarea Order By Order__c,Name])
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
/***************************************************Moodleroom Picklists************/
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

 public List<SelectOption> getmrcsop() {
        List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult MrcasetypeDecribe = Case.MR_Case_Type__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: MrcasetypeDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                mrcasetypevalues=picklistEntry.getvalue();      
                }
              }
           
            return options;
        }
        
        
        //collab
        
        
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
    
        
        public List<SelectOption> getinstanceoptions() {
     
        List<SelectOption> options = new List<SelectOption>();
             Schema.DescribeFieldResult ClienetOSDecribe = Case.Instance__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ClienetOSDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                instancevalue=picklistEntry.getvalue();  
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

 /***********************************************/    
     
    public btbbCreateCase(ApexPages.StandardController controller) {
        collab = false;
        modelroom=false;
        isAnalytics = false; 
        isxplor = false;
        displayeditasset = false;
        premiumsupport = false;
        editSB = false;
        this.controller = controller;
        
        // load the record
        this.cas = (Case)controller.getRecord();
        
        User loginUser = [Select AccountId,contactId,Btbb_Case_Cc__c from user where id =:Userinfo.getUserid()];
        
        account=loginUser.AccountId;
        version = cas.Version_On_Case__c;
        Account ass=[Select name,id from Account limit 1];
        //acc=[select id,Severity_1_6__c from account where id=:account];
        contact = cas.ContactId;
        asset = cas.AssetId;
        module = cas.Module__c;
        functionalarea = cas.Functional_Area__c;
        category = cas.Category__c;
        displayfuncarea = true;
        displaycategory = true;
        // cmsvalue = 'Blackboard Learn';
        ccemail=loginUser.Btbb_Case_Cc__c;
        cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
    }    
        public List<SelectOption> getSeverities() {
        list<account> acc= new list<account>();
        acc=[select id,Severity_1_6__c from account where id=:account];
        List<SelectOption> options = new List<SelectOption>();
        if(acc != null && acc.size() > 0 && acc[0].Severity_1_6__c == false ){
        servcheck = false;
        options.add(new SelectOption('1','Severity Level 1:  Emergency – Production System is down.  System is not functioning, disabled or non-responsive.'));
        options.add(new SelectOption('2','Severity Level 2:  High – Product is functioning, but major components are unavailable/unusable.'));
        options.add(new SelectOption('3','Severity Level 3:  Medium – Product is operating close to normal; however minor components are functioning abnormally.'));
        options.add(new SelectOption('4','Severity Level 4:  Low – Product enhancement request or instructional assistance is needed.'));
        }
        else if(acc != null && acc.size() > 0 && acc[0].Severity_1_6__c == true){
        servcheck = true;
        options.add(new SelectOption('1','Severity Level 1: Emergency – Production System is down. System is not functioning, disabled or non-responsive, users can’t access their courses.'));
        options.add(new SelectOption('2','Severity Level 2: High – Production System is functioning, but major components are unavailable/unusable including Mobile features.'));
        options.add(new SelectOption('3','Severity Level 3: Medium – Production System is operating close to normal; however minor components of at least one course are functioning abnormally.'));
        options.add(new SelectOption('4','Severity Level 4: Staging System is functioning abnormally.'));
        options.add(new SelectOption('5','Severity Level 5: Testing System is functioning abnormally. (Any hardware or software component of the Test environment is not working properly.)'));
        options.add(new SelectOption('6','Severity Level 6: Low – Product enhancement request or instructional assistance is needed. (General questions about functionality of the platform or clarification about available tools.)'));
        }
        
        return options;
    }
   
    public boolean getpremiumsupport1(){
          Boolean retvar;
        List<Entitlement> e = new List<Entitlement>([select ID,Name,Support_Level__c from Entitlement where AssetID =: asset AND Support_Level__c = 'ANGEL Premium Support']);
        if(e.size() > 0 && (Sev == '1' || Sev == '2'))
              return true;
        else
             return false;
                   
   }
 
    public PageReference save() {
    
        errorShow = false;
        if(asset==Null || asset==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Installed Product: You must enter a value';
            errorSeverity = 'error';
            return null;
        }else if(module==Null || module==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Issue Topic : You must enter a value';
            errorSeverity = 'error';
            return null;
         } else if(ccemail != null && ccemail!='')
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
                            cas.ccemail1__c=s;
                        }
                        else if(x==2)
                        {
                            cas.ccemail2__c=s;
                        }
                        else if(x==3)
                        {
                            cas.ccemail3__c=s;
                        }
                        else if(x==4)
                        {
                            cas.ccemail4__c=s;
                        }
                        else if(x==5)
                        {
                            cas.ccemail5__c=s;
                        }
                    x++;    
                }
            }
           /* list<string> ccemaillist=ccemail.split(';');
            if(ccemaillist.size()>5)
            {
                errorShow = true;
                errorTitle = 'Error:';
                errorMessage = 'ccemail: Maximum 5 emails allowed.';
                errorSeverity = 'error';
                return null;
            }
            else
            {
                integer x=1;
                for(string s: ccemaillist)
                {
                    if(!Pattern.matches('^[_A-Za-z0-9-\']+(\\.[_A-Za-z0-9-\']+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$',s))
                    {
                        errorShow = true;
                        errorTitle = 'Error:';
                        errorMessage = 'ccemail: '+s+' is not valid email address';
                        errorSeverity = 'error';
                        return null;
                    }
                    else
                    {
                        if(x==1)
                        {
                            cas.ccemail1__c=s;
                        }
                        else if(x==2)
                        {
                            cas.ccemail2__c=s;
                        }
                        else if(x==3)
                        {
                            cas.ccemail3__c=s;
                        }
                        else if(x==4)
                        {
                            cas.ccemail4__c=s;
                        }
                        else if(x==5)
                        {
                            cas.ccemail5__c=s;
                        }
                    }
                    x++;
                }
            }*/
        }else if(cas.Subject==Null || cas.Subject==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Subject: You must enter a value';
            errorSeverity = 'error';
            return null;
         }else if(cas.Description==Null || cas.Description==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Description: You must enter a value';
            errorSeverity = 'error';
            return null;
         }
 
        Asset a = [Select Core_License__c, Core_License__r.Name From Asset Where Id =:asset];
                if(a != null){
                if(a.Core_License__r.Name == 'ANGEL LMS')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Angel);
                else if(cas.Asset.Core_License__r.Name == 'Learn')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                else if(cas.Asset.Core_License__r.Name == 'CE/Vista')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                else if(cas.Asset.Core_License__r.Name == 'Xythos')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Xythos);
                else if(a.Core_License__r.Name == 'Moodlerooms')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Moodlerooms);   
                else if(a.Core_License__r.Name == 'Collaborate')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Collaborate); 
                else if(a.Core_License__r.Name == 'Analytics')        
                    cas.RecordTypeId = RT.getId(case.SObjectType, RT.Name.Analytics);
                else if(a.Core_License__r.Name == 'xpLor')        
                    cas.RecordTypeId = RT.getId(case.SObjectType, RT.Name.xpLor);   
                else
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                }            
         if(a.Core_License__r.Name == 'Moodlerooms'&& (cas.URL_Access__c==null || cas.URL_Access__c=='' ))           
         {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'URL Access type: You must enter a value';
            errorSeverity = 'error';
            return null;
         }
         if(a.Core_License__r.Name == 'xpLor'&& (cas.CMS_LMS__c==null || cas.CMS_LMS__c=='' ))           
         {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'CMS/ LMS: You must enter a value';
            errorSeverity = 'error';
            return null;
         }
         if(a.Core_License__r.Name == 'xpLor'&& (cas.Site_URL__c==null || cas.Site_URL__c=='' ))           
         {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Site URL: You must enter a value';
            errorSeverity = 'error';
            return null;
         }
        cas.Core_License__c = a.Core_License__c;
        User loginUser = [Select AccountId,contactId from user where id =:Userinfo.getUserid()];
        // set the selected values to the record before saving
        cas.ContactId = loginUser.contactId ;
        //cas.AccountId= loginUser.AccountId;
        cas.AccountId=account;
        //cas.ContactId=contact;
        cas.AssetId = asset;
        cas.Module__c = module;
        cas.Functional_Area__c = functionalarea;
        cas.Category__c = category;
        cas.Case_Severity__c = sev;
        cas.Version_on_Case__c = version;
        cas.Source_Build_on_Case__c = sourcebuild;
        cas.Invoke_Premium_Support__c = premiumsupport;
        cas.Origin = 'Portal';
        cas.Type = 'Standard Support Ticket';
        cas.Browser__c = browservalues;
        cas.Client_OS__c = clvalues;
        if(a.Core_License__r.name == 'Collaborate')
        {
          cas.CMS_LMS__c = cmsvalue;
        } 
        try {
            upsert(cas);
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
            pagereference pageRedirect=new pagereference('/apex/btbb_caseConfirmation?id='+cas.id);        
            pageRedirect.setRedirect(true);
            return pageRedirect;
        }           
 
        public PageReference Cancel() {
            PageReference pageRedirect = new PageReference('/');
            pageRedirect.setRedirect(true);
            return pageRedirect ;
        }
        
        public PageReference redirect() {
            if(gc.userRedirect == true){
                PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
                pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
                pageRedirect.setRedirect(true);
                return pageRedirect;
            } else {
            return null;
            }
        }

}