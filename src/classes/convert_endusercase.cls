public class convert_endusercase {
    
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; } 
    public String errorSeverity{ get; set; } 
    public id Caseid;
    public boolean temp_flag{get;set;}
    

    public boolean closeWin{get;set;}
    private ApexPages.StandardController controller {get; set;}
 
    Case cas{ get; set; } 
    public Case tcas{get;set;}
    public Case tcase{get;set;}
    private Asset casset;
    public account acc{get;set;}    
    public id AccountId {get; set;}
    public id ContactId {get; set;}
 
    public string asset {get; set;}
    public string contact {get; set;}
    public string module {get; set;}
    public string functionalarea {get; set;}
    public string category {get; set;}
    public string version {get; set;}
    public String sourcebuild {get;set;}
    public Case_Note__c notes;
    
    public boolean moodleroom{get;set;}
    public String clientOs{get;set;}
    public String browser{get;set;}
    //public boolean Mrcasetype{get;set;}
    public String urlaccess{get;set;}
    public String SelectListValue{get;set;}
    public String clvalues{get;set;}
    public String browservalues {get;set;}
    //public String mrcasetypevalues {get;set;}
    
    private integer contactCount;
    private integer contactCountMax;
    public boolean showNextContacts{get;set;}
    public boolean showPreviousContacts{get;set;}
    
    Map<Id,String> contactmap = new Map<Id,String>();
    Map<Id,String> assetmap = new Map<Id,String>();
    Map<Id,String> issuetopicmap = new Map<Id,String>();
    Map<Id,String> funcareamap = new Map<Id,String>();
    Map<Id,String> categorymap = new Map<Id,String>();
    
    public boolean collab {get;set;}
    public boolean collabe {get;set;}
    public string eucontact {get; set;}
    public map<string,Core_License__c> corelicensemap= new map<string,Core_License__c>();
    public list<selectoption> productlist{get;set;}
    
    
     
 
       /* Added by Lalitha for TP 2045*/  
    public string getRecordTypeId() {
        return RT.getId(Case.SObjectType, RT.Name.Angel);
    }
    
     public List<selectOption> contacts {
        get {
            List<selectOption> options = new List<selectOption>();
            
            set <id> contactrolelist= new set<id>();
          
                 for(Contact_Role__c acr: [select id,account__c,contact__c from Contact_Role__c  where  account__c = :cas.accountid  AND Contact__c!= NULL and role__c like '%admin%' limit 50000])  
                 {
                
                 contactrolelist.add(acr.contact__c);    
                 }
 
                options.add(new SelectOption('','-- Select a Contact --'));
               
                list<contact> contact_list= [SELECT id, name FROM Contact ct WHERE /*ct.accountid = :cas.accountid and TP4437*/  id in :contactrolelist Order By Name];
                contactCountMax=contact_list.size();
                if(contactCountMax<=999)
                {
                    for (Contact ct : contact_list)
                    {
                        options.add(new SelectOption(ct.Id,ct.Name));
                        contactmap.put(ct.Id,ct.Name); 
                    }    
                        
                }
                else{
                    showNextContacts=true;
                    integer listcount=contactCount*999;
                    integer listlimit=listcount+999;

                    for(integer i=listcount ;i<listlimit-1;i++)
                    {
                        if(i>=contact_list.size())
                        {
                            showNextContacts=false;
                            break;
                        }
                        else
                        {

                            options.add(new SelectOption(contact_list[i].id,contact_list[i].Name)); 
                            contactmap.put(contact_list[i].id,contact_list[i].Name);
                        }
                    }
                } 
                if(!contactmap.keyset().contains(tcas.ContactId)&& tcas.ContactId!=null)
                {
                    options.add(new SelectOption(tcas.Contactid,tcas.Contact.Name));
                }
           return options;           
        }
        set;
    } 
    
     
    
    public List<selectOption> assets {
        get {
        errorShow = false;
            List<selectOption> options = new List<selectOption>();
 
                options.add(new SelectOption('','-- Choose a Product --'));
                //for (Asset a : [SELECT id, name, core_license__c, External_Asset_Name__c FROM Asset a WHERE a.accountid = :cas.accountid AND a.status ='Installed' AND a.core_license__c != null Order By External_Asset_Name__c]){
                    for (Asset a : [SELECT id, name, core_license__c, External_Asset_Name__c FROM Asset a WHERE (a.accountid = :cas.accountid AND a.isBtbbEligible__c = True AND a.core_license__c != null) OR (a.accountid = :cas.accountId AND a.Force_Btbb_Visibility__c = true AND a.core_license__c != null) Order By External_Asset_Name__c]){
                    options.add(new SelectOption(a.Id,a.External_Asset_Name__c));/*SHIRISH PLEASE USE THE FOLLOWING FOR LABELING PICKLIST a.Core_License__c+' - '+a.Version__c*/
                    assetmap.put(a.ID,a.External_Asset_Name__c);
                }
            return options;           
        }
        set;
    }

    public void InstanceDisplay(){
        temp_flag=false;
        if(asset!=null){

            Asset a=[Select a.id,a.name,a.Core_License__r.Name, a.Core_License__c From Asset a where a.id=:asset];
            if(a.Core_License__r.Name.Contains('ANGEL')){
                 temp_flag= true;
            }
             
               if(a.Core_License__r.Name.Contains('Moodlerooms')){
                   moodleroom = true;
                   system.debug('I am within Instancedisplay');
               }
            
            
            else{
                moodleroom = false;
                 temp_flag= false;
            }

        }
        
        else if(asset==null){
        
        tcas= [select Id, AccountId, Account.Name, End_User__c, End_User_Product__c, Asset.External_Asset_Name__c, Core_License__c,Core_License__r.Name, ContactId, Contact.Name, AssetId, Asset.Name, Module__r.Name, Version_on_Case__c, Source_Build_on_Case__c,Browser__c,Client_OS__c,URL_Access__c, Functional_Area__r.Name, Category__r.Name from Case where id=:Caseid ];
          
        
         if(corelicensemap.keyset().contains(tcas.End_User_Product__c))
           {
                 tcas.Core_License__c=corelicensemap.get(tcas.End_User_Product__c).id;
                 system.debug('Murugappan'+tcas.Core_License__c+'Alagappan');
                 
           }   
        
        }
        else
          moodleroom = false;
          
    }
    
    
       
    /*public List<selectOption> versions {
        get{
                List<selectOption> options = new List<selectOption>();
                String v1;
                if (asset != null) {
                
            
                    for (Asset a : [SELECT version__c FROM Asset a WHERE a.id =: asset]) {
                         if(a.version__c != null ) {
                               if(version == null || (version != null && version != a.version__c))
                                    version = a.version__c;
                                     options.add(new SelectOption(a.version__c,a.version__c));
                          }
                    }
                   
                   for (Version__c v : [SELECT id, version__c FROM Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:asset].Psft_Product_Id__c AND v.Version__c != :[SELECT version__c FROM Asset WHERE id =: asset].version__c ORDER BY Version__c DESC]){
                        if(v.version__c!=null){
                            options.add(new SelectOption(v.version__c,v.version__c));
                       }
                   }
    
                }
            
            return options;
        }
        set;    
    }*/
    
    // new versions code
     public List<selectOption> versions {
        get{
                system.debug('ver++ ');
                List<selectOption> options = new List<selectOption>();
                String v1;
                if(tcas.AssetId != asset)
                {
                version= null;  
                sourcebuild=null;
                }
                if (asset != null) {
                
            
                    for (Asset a : [SELECT version__c,Product2.GKEY_Product_Group__c  FROM Asset a WHERE a.id =: asset limit 1] ) {
                         if(a.version__c != null ) {
                               if(version == null /*|| (version != null && version != a.version__c)*/)
                                    version = a.version__c;
                                  //   options.add(new SelectOption(a.version__c,a.version__c));
                          }
                           set<string> versionset= new set<string>(); 
                           for (Version_Build_Tree__c v : [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE /*Version__c !=: a.version__c AND*/ GKEY_Product_Group__c =: a.Product2.GKEY_Product_Group__c AND Active_Flag__c = true  ORDER BY Version__c ]){
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
    public void nextcontacts()
    {
        contactCount++;   
        showPreviousContacts=true;
    }
    public void previouscontacts()
    {
        if(contactCount!=0)
            contactCount--;   
        if(contactCount ==0)
            showPreviousContacts=false;
    }
   public List<selectOption> modules {
        get {
            errorShow = false;
            List<selectOption> options = new List<selectOption>();
 
            if (asset != null) {
                options.add(new SelectOption('','-- Choose an Issue Topic --'));
                for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : [select core_license__c from asset where id =:asset].core_license__c order by name]){
                    options.add(new SelectOption(m.Id,m.Name));
                    issuetopicmap.put(m.Id,m.Name);
                   /* if(module==null||module=='')
                    { 
                      module=m.id;
                    }*/
                }
            }
            else if(asset == null && tcas.Core_License__c != null)
            {
                 options.add(new SelectOption('','-- Choose an Issue Topic --'));
                    for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : tcas.Core_License__c order by name] ){
                        options.add(new SelectOption(m.Id,m.Name));
                        issuetopicmap.put(m.Id,m.Name);
                        
                     }
            }
            else{
              module=null;
              functionalarea=null;
            }
            
 
            return options;           
        }
        set;
    }   
    
     /*public List<selectOption> sblist{
        
        get {
            if(tcas.Version_On_Case__c!=version)
            sourcebuild='-None-';
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            Set<String> tmp = new Set<String>();
            if(asset != null) {
                if(sourcebuild == '-None-')
                    options.add(new SelectOption('-None-','-None-'));
                for (Asset a : [SELECT version__c,Version_Build__c FROM Asset a WHERE a.id =: asset]) {
                       if(a.Version_Build__c != null) {
                         if(sourcebuild == null || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-None-'))
                            sourcebuild  = a.Version_Build__c;
                         options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));
                         tmp.add(a.Version_Build__c); 
                      }
                }
            system.debug('sb--'+sourcebuild);
               for (Bb_Prod_Version__c v : [SELECT id, source_build__c FROM Bb_Prod_Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:asset].Psft_Product_Id__c AND v.Version__c = :version ORDER BY Source_Build__c DESC]){           
                    if(v.source_build__c != null)
                    options.add(new SelectOption(v.source_build__c,v.source_build__c));
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
    }*/
    // new version build code
    
    public List<selectOption> sblist{
        
        get {
            system.debug('Sb++');
            if(tcas.Version_On_Case__c!=version)
            {
            sourcebuild=null;
            }
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            Set<String> tmp = new Set<String>();
            if(asset != null) {
                if(sourcebuild == '-None-'||sourcebuild == null)
                    options.add(new SelectOption('-None-','-None-'));
                for (Asset a : [SELECT version__c,Version_Build__c,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: asset limit 1]) {
                       if(a.Version_Build__c != null) {
                         if(sourcebuild == null || (sourcebuild != null && /*sourcebuild != a.Version_Build__c &&*/ sourcebuild != '-None-'))
                            sourcebuild  = a.Version_Build__c;
                        /* options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));
                         tmp.add(a.Version_Build__c); */
                      }
                       system.debug('sb--'+sourcebuild+'ver--_'+version);
               for (Version_Build_Tree__c v : [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c WHERE /*ersion_Build__c!= :a.Version_Build__c AND */ GKEY_Product_Group__c =:a.Product2.GKEY_Product_Group__c AND Version__c =:version /*AND version_build__c !=:sourcebuild */ AND Active_Flag__c =true ORDER BY Version_Build__c DESC]){           
                    if(v.Version_Build__c != null)
                    options.add(new SelectOption(v.Version_Build__c,v.Version_Build__c));
                    if(sourcebuild == null )
                      sourcebuild = v.Version_Build__c;
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
    // end version build code
 
    public List<selectOption> functionalareas {
        get {
            errorShow = false;
            funcareamap = new Map<Id,String>();
            List<selectOption> options = new List<selectOption>();
           /* if(module != tcas.module__c)
            {
              functionalarea=null;
            }*/
            if (module != null) {
                options.add(new SelectOption('','-- Choose a Functional Area --'));
                for (Functional_Area__c fa : [select Id, Name from Functional_Area__c Where Module__c = :module Order By Name]){
                    options.add(new SelectOption(fa.Id,fa.Name));
                    funcareamap.put(fa.Id,fa.Name); 
                }
            }
            else
            {
            functionalarea =null;  
            }
            if(!funcareamap.keyset().contains(functionalarea))
            {
                functionalarea=null;
            }
            return options;           
        }
        set;
    }  
     
     public List<selectOption> getcategories() {
     //   get {
            errorShow = false;
            List<selectOption> options = new List<selectOption>();
 
            if (functionalarea != NULL) {
                options.add(new SelectOption('','-- Choose a Category --'));
                for (Category__c cat : [select Id, Name from Category__c Where Functional_Area__c = :functionalarea Order By Name]){
                    options.add(new SelectOption(cat.Id,cat.Name));
                    categorymap.put(cat.Id,cat.Name); 
                }   
            } 
 
            return options;           
     //   }
     //   set;
   }     
     public convert_endusercase(ApexPages.StandardController controller) {
 
        this.controller = controller;
        cas = (Case)controller.getRecord();
        showNextContacts=false;
        contactCount=0;
        Caseid = System.currentPageReference().getParameters().get('id');
        tcas= [select Id, AccountId, Account.Name, End_User__c, Asset.External_Asset_Name__c, Core_License__c, ContactId, Contact.Name, AssetId, Asset.Name, Module__r.Name, Version_on_Case__c, Source_Build_on_Case__c,Browser__c,Client_OS__c,URL_Access__c, Functional_Area__r.Name, Category__r.Name from Case where id=:Caseid ];
        
        contact = tcas.ContactId;
        
        euContact = tcas.End_User__c;
        
        
        asset = tcas.AssetId;
        module = tcas.Module__c;
        system.debug('Murugappan'+module);
        functionalarea = tcas.Functional_Area__c;
        category = tcas.Category__c;
        accountid = tcas.AccountId;
        version = tcas.Version_On_Case__c;
        sourcebuild = tcas.Source_Build_on_Case__c;
        clientos=tcas.Client_os__c;
        browser=tcas.browser__c;
        
        if(asset!=null){

            Asset a=[Select a.id,a.name,a.Core_License__r.Name, a.Core_License__c From Asset a where a.id=:asset];
             if(a.Core_License__r.Name.Contains('Moodlerooms')){
                   moodleroom = true;
               }    
          
          }
            else{
          moodleroom = false;
           }
           
           
           
           
            
        if(asset!=null){

            Asset a=[Select a.id,a.name,a.Core_License__r.Name, a.Core_License__c From Asset a where a.id=:asset];
             if(a.Core_License__r.Name.Contains('Collaborate')){
                   collab = true;
               }    
          
          }
            else{
              collab = false;
           }
           
           
           if(asset ==null){

           collabe=true; 
          
          }
            else{
              collabe = false;
           }
           
            productlist=new list<selectoption>();
            productlist.add(new selectoption('none','--Select Product--'));
            for(Core_License__c cr : [select id,name,product__c from Core_License__c where name like 'Collaborate'] )
            {
                corelicensemap.put(cr.product__c,cr);
                productlist.add(new selectoption(cr.product__c,cr.product__c));
            } 
           
       system.debug('mod--'+tcas.Module__c+' --fn--'+tcas.Functional_Area__c+' --cat--'+tcas.Category__c);    
    }          
 
    public PageReference save() {
 

        errorShow = false;
        if(cas.accountid==Null){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Account Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }else if(contact==Null || contact==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Contact Name: You must enter a value';
            errorSeverity = 'error';
            return null;
         }else if(asset==Null || asset==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Installed Product: You must enter a value';
            errorSeverity = 'error';
            return null;
         }else if(module==null || module==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Module: You must enter a value';
            errorSeverity = 'error';
            return null;
         }
         
        Case_Note__c notes = new Case_Note__c();
        
        notes.Case__c = Caseid;
        notes.Public__c = false;
        notes.From_Type__c = 'Employee';
        notes.Type__c = 'Case Detail Change';
         
        if(tcas.AccountId != cas.AccountID){
            Account a = [select Name from Account where Id =: cas.AccountID]; 
            notes.Details__c = 'Account changed from '+ tcas.Account.Name + ' to ' + a.Name;
        }
        
        if(tcas.ContactId != contact)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\nContact changed from '+ tcas.Contact.Name+' to ' +contactmap.get(contact);
            else
                notes.Details__c = 'Contact changed from '+ tcas.Contact.Name +' to ' + contactmap.get(contact);

        if(tcas.AssetId != asset)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Asset changed from '+ tcas.Asset.External_Asset_Name__c +' to '+ assetmap.get(asset);
            else
                notes.Details__c = 'Asset changed from '+ tcas.Asset.External_Asset_Name__c +' to '+ assetmap.get(asset);

        if(tcas.Module__c != module)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Issue Topic changed from '+ tcas.Module__r.Name+' to ' +issuetopicmap.get(module);
            else
                notes.Details__c = 'Issue Topic changed from '+ tcas.Module__r.Name +' to ' +issuetopicmap.get(module);        
        
        if(tcas.Functional_Area__c != functionalarea)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Functional Area changed from '+ tcas.Functional_Area__r.Name +' to ' + funcareamap.get(functionalarea);
            else
                notes.Details__c = 'Functional Area changed from '+ tcas.Functional_Area__r.Name +' to ' + funcareamap.get(functionalarea);    

        if(tcas.Category__c != category)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Category changed from '+ tcas.Category__r.Name +' to ' + categorymap.get(category);
            else
                notes.Details__c = 'Category changed from '+ tcas.Category__r.Name +' to ' + categorymap.get(category);        
            
        if(tcas.Version_On_Case__c != version)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Version changed from '+ tcas.Version_On_Case__c + ' to ' + version;
            else
                notes.Details__c = ' Version changed from '+ tcas.Version_On_Case__c + ' to ' + version;

        if(tcas.Source_Build_on_Case__c != sourcebuild)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Sourcebuild changed from '+ tcas.Source_Build_on_Case__c +' to ' +sourcebuild;       
            else
                notes.Details__c = '\n Sourcebuild changed from '+ tcas.Source_Build_on_Case__c +' to ' +sourcebuild;  
                
         if(tcas.Browser__c != browser)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Browser changed from '+  browser+' to ' +tcas.Browser__c;       
            else
                notes.Details__c = '\n Browser changed from '+ tcas.Browser__c +' to ' +browser;    
                
          if(tcas.Client_OS__c != clientOs)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n Client OS changed from '+ clientOs +' to ' +tcas.Client_OS__c;       
            else
                notes.Details__c = '\n Client OS changed from '+ clientOs +' to ' +tcas.Client_OS__c; 
                
                
           if(tcas.URL_Access__c != urlaccess)
            if(notes.Details__c != null)
                notes.Details__c = notes.Details__c+ '\n URL Access from '+ tcas.URL_Access__c +' to ' +urlaccess;       
            else
                notes.Details__c = '\n URL Access changed from '+ tcas.URL_Access__c +' to ' +urlaccess;                                 
        
        Insert notes;    
        
        /* Added by Lalitha for TP 2045 */
        Asset a = [Select Core_License__c, Core_License__r.Name From Asset Where Id =:asset];
        if(a != null){
          if(a.Core_License__r.Name == 'ANGEL LMS')
              cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Angel);
          else if(a.Core_License__r.Name == 'Learn')
              cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
          else if(a.Core_License__r.Name == 'CE/Vista')
              cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
          else if(a.Core_License__r.Name == 'Xythos')
               cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Xythos);
               
          else if(a.Core_License__r.Name == 'Moodlerooms')
                     cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Moodlerooms);
          else if(a.Core_License__r.Name.Contains('Collaborate'))
                     cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Collaborate);      
           else
               cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
         }  
        
        cas.ContactId = contact;
        cas.AssetId = asset;
        cas.Module__c = module;
        cas.Functional_Area__c = functionalarea;
        cas.Category__c = category;
        system.debug('save version'+version);
        cas.Version_On_Case__c = version;
        if(sourcebuild != '-None-'){
        cas.Source_Build_on_Case__c = sourcebuild;
        }
        cas.Core_License__c = a.Core_License__c;// Added by Lalitha for TP 2045
         cas.Browser__c = tcas.Browser__c;
        cas.Client_OS__c = tcas.Client_OS__c;

        try {
                update(cas);
            } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        closeWin=true;
        try{   
        PageReference pageRef = new PageReference('/' + Caseid);                
        pageRef.setRedirect(true);        
        return pageRef;        
        } catch (Exception e) {            
          ApexPages.addMessages(e);            
          return null;        
       }
       
        return null;
    }           
 
 }