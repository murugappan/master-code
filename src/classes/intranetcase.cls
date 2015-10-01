public class intranetcase {

    private ApexPages.StandardController controller {get; set;}
   GlobalComponent gc = new GlobalComponent();
    public String originalver,originalbuild; 
    Public Case cas{get;set;}
    public boolean displayeditasset {get;set;}
    public boolean editSB {get;set;}
    public Account acct {get; set;}
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; } 
    public String errorSeverity{ get; set; } 
    public string asset {get; set;}
    public string contact {get; set;}
    public string module {get; set;}
    public string functionalarea {get; set;}
    public string category {get; set;}
    public string version{get;set;}
    public id acountid{get;set;}
    public string account{get;set;}
    public string accountname{get;set;}
    public string sourcebuild {get; set;}
    public string Name{get;set;}
    public string email{get;set;}
    public string subject{get;set;}
    public string description{get;set;}
    public string steps_to_replicate{get;set;}
    String v;
    String sev = '3';
    public boolean displayfuncarea {get;set;}
    public boolean displaycategory {get;set;}
    public boolean premiumsupport {get;set;}
    public string message{get;set;}
    public id Blackboard_queue= [select Name,Type from Group where Type= 'Queue' and name like 'Blackboard Intranet' limit 1].id;
    public Pagereference updateasset(){
        System.debug('<<<<<< In updateasset >>>>>>>');
        System.debug('asset  >>>>>>>' + asset); 
        List<Asset> updasset = new List<Asset>([select ID,Name,Version__c,Version_Build__c from Asset where ID =: asset limit 1]);
        System.debug('updasset Value >>>>>>>' + updasset); 
        System.debug(' version>>>>>>>> '+version);
        System.debug(' sourcebuild>>>>>>>> '+sourcebuild);
        if(updasset.size() > 0){
            updasset[0].Version__c = version;
            if(sourcebuild != '-None-')
                updasset[0].Version_Build__c = sourcebuild;
            else    
                updasset[0].Version_Build__c = '';
            Update updasset[0];
        }
        System.debug('updasset[0]>>>>>>>> '+updasset[0]);
        displayeditasset = false;
        System.debug('EEEEEEEEEEEEE' + displayeditasset );
        editSB = false;
        originalver = version;
        if(sourcebuild != '-Please Select-')
            originalbuild = sourcebuild;
        else 
            originalbuild = '';
        return null;

    }
    
    public Pagereference cancelupdate(){
        displayeditasset = false;
        return null;
    }
    
    public Pagereference changeEdit(){
        System.debug('sourcebuild >>>>>>>>>>'+ version );
        if(version != null){
            if(version != originalver){
                displayeditasset = true;                
                sourcebuild = '-Please Select-';
            }else{
                displayeditasset = false;
                sourcebuild = originalbuild;
            }
        }
        
        System.debug('EEEEEEEEEEEEE' + displayeditasset );
        editSB = true;
        return null;
     }
     
     public Pagereference changeversion(){
        System.debug('version >>>>>>>>>>>>>>'+sourcebuild+'<<<<<<<<');
        System.debug('version >>>>>>>>>>>>>>'+originalbuild+'<<<<<<');
        String sbld = ApexPages.CurrentPage().getParameters().get('sbuild');
        sourcebuild = sbld;
        if(sourcebuild != null){
            if(sourcebuild != originalbuild || version != originalver)
                displayeditasset = true;                
            else
                displayeditasset = false;
        }
        System.debug('EEEEEEEEEEEEE' + displayeditasset );
        return null;
     }
     
     
     public Pagereference modulechange(){
        String m = ApexPages.CurrentPage().getParameters().get('mod');
        System.debug(m);
        module = m;  
        System.debug('QQQQQQQQQQ'+module);
        functionalarea = null;  
        category = null; 
        System.debug(sourcebuild);
        return null;
     }
        
    public String getsev() {
               return sev;
    }
    
    public void setsev(String sev ) { this.sev = sev ;}
    
  
    public boolean getdisplayInstance(){
        List<Asset> a = new List<Asset>([SELECT id, name, version__c ,Core_License__r.Name FROM Asset a WHERE a.id =: asset]);
        if(a.size() > 0 && a[0].Core_License__r.Name.contains('ANGEL'))
            return true;
        else
            return false;    
        
    }
    
    public boolean isAssetSelect {
        
        get {
            System.debug('Asset Value >>>>>>> '+ asset);
            if(asset != null && asset != '')            
                return false;
            else
                return true;
            
        }
        set;
    }
    
    public Pagereference selectAccount(){
        //System.debug('version >>>>>>>>>>>>>> '+version);
        isAssetSelect = true;
        asset = null;   
        module = null;
        functionalarea = null; 
        displayeditasset = false;   
        return null;
     }
     
    public Pagereference selectAsset(){
         //System.debug('version >>>>>>>>>>>>>> '+version);
        module = null;
        functionalarea = null;  
        displayeditasset = false;
        category = null;  
        if(asset != null){
            Asset a = [select Id,Version__c,Version_Build__c from Asset where ID =: asset];
            originalver = a.Version__c;
            originalbuild = a.Version_Build__c;
            version = a.Version__c;
            sourcebuild = a.Version_Build__c; 
            System.debug('********'+sourcebuild);
        }
            
        return null;
     }
 
 
 //-------------------------------Contact--------------------------------
 
//------------------------------------------------------------------------------------ 
 
 
 
 
 
 
 
 
 
 //------------------------------------Assets------------------     
    public List<selectOption> assets {
        get {
        errorShow = false;
            List<selectOption> options = new List<selectOption>();
 
                options.add(new SelectOption('','-- Choose a Product --'));
                for (Asset a : [SELECT id, name, core_license__c, External_Asset_Name__c FROM Asset a WHERE a.accountid = :account AND a.status ='Installed' AND a.core_license__c != null Order By External_Asset_Name__c]){
                    if(a.External_Asset_Name__c != null)
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));/*SHIRISH PLEASE USE THE FOLLOWING FOR LABELING PICKLIST a.Core_License__c+' - '+a.Version__c*/
                } 
            return options;           
        }
        set;
    }
 // -------------------------------------------------------------  
    
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

/* ************************************************* versions picklist ****************************************************************** */         
  
    public List<selectOption> versions {
        get{
                List<selectOption> options = new List<selectOption>();
                String v1;
                //System.debug('asset >>>>>>>>>>>' + asset);
                    
                    if (asset != null) {
                
                    //System.debug('Vsersion Value >>>>>>> 111 ' + version+ '  ' + editSB); 
                
                    for (Asset a : [SELECT version__c FROM Asset a WHERE a.id =: asset]) {
                       System.debug(a.version__c);
                       if(a.version__c != null ) {
                         System.debug(version);
                         if(version == null || (version != null && version != a.version__c && displayeditasset == false))
                            version = a.version__c;
                         options.add(new SelectOption(a.version__c,a.version__c));
                      }
                   }
                   System.debug(version);
                    
                   for (Version__c v : [SELECT Version__c FROM Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:asset].Psft_Product_Id__c AND v.version__c != :[SELECT version__c FROM Asset WHERE id =: asset].version__c ORDER BY Version__c DESC]){
                      if(v.version__c != null) {
                         System.debug(version);  
                         if(version== null)
                             version = v.version__c;                      
                         options.add(new SelectOption(v.version__c,v.version__c));
                      }
                  
                   System.debug(version);
                }
            }
            //System.debug('Vsersion Value >>>>>>>222' + version);
            return options;
        }
        set;    
    }
    
/* ************************************************* source build picklist ****************************************************************** */         
     public List<selectOption> sblist{
        
        get {
            
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            System.debug('version>>>>>>>' + sourcebuild);
            System.debug('version>>>>>>>' + displayeditasset );            
            if(asset != null) {
                if(sourcebuild == '-Please Select-')
                    options.add(new SelectOption('-Please Select-','-Please Select-'));
                if(sourcebuild != '-Please Select-' && sourcebuild != null)
                    options.add(new SelectOption(sourcebuild,sourcebuild));
                    for (Asset a : [SELECT version__c,Version_Build__c FROM Asset a WHERE a.id =: asset]) {
                           if(a.Version_Build__c != null) {
                             if(sourcebuild == null  || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-Please Select-' && displayeditasset == false))
                                sourcebuild  = a.Version_Build__c;
                             if(sourcebuild != a.Version_Build__c)   
                               options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));
                       
                        }
                    }
                
                for (Bb_Prod_Version__c v : [SELECT id, source_build__c FROM Bb_Prod_Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:asset].Psft_Product_Id__c AND v.Version__c = :version AND v.source_build__c != :sourcebuild ORDER BY Source_Build__c DESC]){           
    //            for(List<Actual_Source_Build__c> sb : [select Id,Version__c,Name from Actual_Source_Build__c where Version__c =: version ORDER BY Name]){
    //              for(Bb_Prod_Version__c vr1: vr1) {
                        if(v.source_build__c != null){
                         options.add(new SelectOption(v.source_build__c,v.source_build__c));
                         System.debug('>>>>>>>'+v.source_build__c+'<<<<<<<<');
                         }
                     }           
/*                    for(Actual_Source_Build__c sb1 : sb) {
                                     
                            options.add(new SelectOption(sb1.Name,sb1.Name));
                
                    }*/
                        
               // }
               System.debug('hello sb ' + sourcebuild);
               System.debug('hello sb ' + options);
            }
            return options;
        }
        set;
    }
/* ************************************************* modules picklist ****************************************************************** */     
    public List<selectOption> modules {
        
        get {
            
            List<selectOption> options = new List<selectOption>();
                options.add(new SelectOption('','-- Select an Issue Topic --'));
            if (asset != null) {
                
                
                
                //system.debug('asas');
                
                for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : [select core_license__c from asset where id =:asset].core_license__c ORDER BY Name ASC]) {
                   //system.debug('1---' + m.Id + ' ' + m.Name);
                       options.add(new SelectOption(m.Id,m.Name));
                   }
                               }
            
            system.debug('1111111111111 ' +options);
            
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
                for (Functional_Area__c fa : [select Id, Name from Functional_Area__c Where Module__c = :module Order By Name])
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
    
    
 
    public intranetcase(){
    cas = new case();
        displayeditasset = false;
        premiumsupport = false;
        System.debug('EEEEEEEEEEEEE' + displayeditasset);
        editSB = false;
       // this.controller = controller;
        
        // load the record
       // this.cas = (Case)controller.getRecord();
        
        User loginUser = [Select AccountId,contactId from user where id =:Userinfo.getUserid()];
        acct=[select id,name from Account where name like 'Blackboard Intranet' limit 1];
        account=acct.id;
        accountname=acct.name;
        system.debug('account name'+account);
        version = cas.Version_On_Case__c;
        
        contact = cas.ContactId;
        asset = cas.AssetId;
        module = cas.Module__c;
        functionalarea = cas.Functional_Area__c;
        category = cas.Category__c;
         displayfuncarea = true;
        displaycategory = true;
        
    }    
        public List<SelectOption> getSeverities() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1','Severity Level 1: Blackboard Production System is down. System is not functioning, system disabled or non-responsive.'));
        options.add(new SelectOption('2','Severity Level 2: Blackboard Product is functioning, but major components are unavailable/unusable.'));
        options.add(new SelectOption('3','Severity Level 3: Blackboard Product is operating close to normal; however minor components are functioning abnormally.'));
        options.add(new SelectOption('4','Severity Level 4: Product enhancement request or instructional assistance is needed.'));
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
    
    message = null;
    String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
    
Pattern emailPattern = Pattern.compile(emailRegex);
Matcher emailMatcher;
if(null != email)
emailMatcher = emailPattern.matcher(email);

        errorShow = false;
        if(name == Null || name == '')
        {
         errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(email == Null || email == '' || !emailmatcher.matches())
        {
         errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Email: You must enter a valid email address';
            errorSeverity = 'error';
            return null;
       
       
        }else if(subject==Null || subject==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Subject: You must enter a value';
            errorSeverity = 'error';
            return null;
         }else if(Description==Null || Description==''){
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Description: You must enter a value';
            errorSeverity = 'error';
            return null;
         }
         
         cas.subject =subject;
         cas.description = description;
         cas.Steps_to_Replicate__c=steps_to_replicate;
    /*    Asset a = [Select Core_License__c, Core_License__r.Name From Asset Where Id =:asset];
                if(a != null){
                if(a.Core_License__r.Name == 'ANGEL LMS')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Angel);
                else if(cas.Asset.Core_License__r.Name == 'Learn')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                else if(cas.Asset.Core_License__r.Name == 'CE/Vista')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                else if(cas.Asset.Core_License__r.Name == 'Xythos')
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Xythos);
                else
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                    } 
        cas.Core_License__c = a.Core_License__c;*/
        cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
        User loginUser = [Select AccountId,contactId from user where id =:Userinfo.getUserid()];
        // set the selected values to the record before saving
        cas.ContactId = contact ;
        //cas.AccountId= loginUser.AccountId;
        cas.AccountId=account;
        //cas.ContactId=contact;
        cas.AssetId = asset;
        cas.Module__c = module;
        cas.Functional_Area__c = functionalarea;
        cas.Category__c = category;
        cas.Case_Severity__c = '3';
        cas.Version_on_Case__c = version;
        cas.Source_Build_on_Case__c = sourcebuild;
        cas.Invoke_Premium_Support__c = premiumsupport;
        cas.Description = cas.Description +'\n Case Submitted by: '+name+'\n Email: '+email;
        cas.Origin = 'Portal';
        system.debug('helloss');
      //  try {
      
      case case1 = cas.clone(false,true,false,false);
      case1.ownerid=Blackboard_queue;
            insert case1;
            
            message= 'Your case has been submitted. The Case number is '+[select casenumber from case where id =:case1.id limit 1].casenumber;
     /*   } catch(System.DMLException e) {
            system.debug(sourcebuild);
            ApexPages.addMessages(e);
            return null;*/
       // }
        system.debug('----------------------------' +cas.id );
          
            return null;
        }           
 
        public PageReference Cancel() {
            PageReference pageRedirect = new PageReference('/');
            pageRedirect.setRedirect(true);
            return pageRedirect ;
        }
        
      
 
    static testmethod void intranetcasetest(){
    Account ac = new Account();
    ac.Name = 'Blackboard Intranet';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = new Contact();
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    c1.PS_Person_Id__c='1234567';
    insert c1;
    
    Contact_Role__c crole = new Contact_Role__c();
    crole.Contact__c=c1.id;
    crole.Account__c=ac.id;
    crole.role__c='LEARN (Bb) - Admin';
    insert crole;    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset = new Asset();
    aset.Name = 'Test Asset 111';
    aset.Core_License__c = cr.ID;
    aset.AccountID = ac.ID;
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
        
    Case cassoftsol = new Case();        //for angel software solutions
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset.ID;
    insert cassoftsol;
    
    Module__c m = new Module__c();
    m.Name = 'MH Request';
    m.Core_Licence__c = cr.ID;    
    insert m;
    
    Functional_Area__c f = new Functional_Area__c();
    f.Name = 'Upgrades';
    f.Module__c = m.ID;  
    insert f;
 
    ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
    Intranetcase ca = new Intranetcase();
    ca.errorTitle = null;
    ca.errorMessage = null;
    ca.errorSeverity = '1';
    ca.acountid = ac.ID;
    ca.acct = ac;
    ca.contact  = c1.ID;
    ca.asset = aset.ID;
    ca.version = '9.1';
    ca.module = m.ID;
    ca.functionalarea = f.ID;
    ca.originalver = '9.2';
    ca.originalbuild = '9.1.X';
    ca.sourcebuild  = '9.1.X';
        
       
    List<SelectOption> ast = new List<SelectOption>();
    ast  = ca.assets;
      ca.asset = aset.id;
    List<SelectOption> ver = new List<SelectOption>();
    ver = ca.versions;
    
    List<SelectOption> mod = new List<SelectOption>();
    mod = ca.modules;
    
    List<SelectOption> fa = new List<SelectOption>();
    fa = ca.functionalareas;
        
    List<SelectOption> cat = new List<SelectOption>();
    cat = ca.categories;
    
    List<SelectOption> sb = new List<SelectOption>();
    sb = ca.sblist;
    
    ca.save();
    ca.setsev('1');
    ca.getsev();
    
    ApexPages.currentPage().getparameters().put('mod','Upgrades');
    ca.modulechange();
    
    ApexPages.currentPage().getparameters().put('sbuild','9.1.1.0');
    ca.changeversion();
    
    ca.changeEdit();
    ca.updateasset();
    ca.getdisplayInstance();
    Boolean t = ca.isAssetSelect;
    ca.selectAccount();
  ca.asset = aset.id;
    ca.selectAsset();
    Boolean t2 = ca.managedhostingasset;
    ca.getSeverities();
    ca.getpremiumsupport1();
    ca.Cancel();
//    ca.Redirect();
    
}

static testmethod void intranetcasetest2(){

// test for errors

    Account ac = new Account();
    ac.Name = 'Blackboard Intranet';
    ac.BillingStreet = 'Testing1 Street';
    ac.BillingCity = 'Testing1 City';
    ac.BillingState = 'Testing1 State';
    ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
    ac.BillingPostalCode = 'Testing Code';
    ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';
    
    insert ac;
    
    Contact c1 = new Contact();
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    c1.AccountID = ac.ID;
    c1.PS_Person_Id__c='1234567';
    insert c1;
    
    Contact_Role__c crole = new Contact_Role__c();
    crole.Contact__c=c1.id;
    crole.Account__c=ac.id;
    crole.role__c='LEARN (Bb) - Admin';
    insert crole;    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'ANGEL';
    insert cr;    
    
    Asset aset = new Asset();
    aset.Name = 'Test Asset 111';
    aset.Core_License__c = cr.ID;
    aset.AccountID = ac.ID;
    aset.Installed_Product_ID__c = '123';
    aset.Status = 'Installed'; 
    aset.version__c = '9.1';
    aset.Psft_Product_Id__c = 'AS-LS';
    aset.Version_Build__c = '9.1.X';
    insert aset;
        
    Case cassoftsol = new Case();        //for angel software solutions
    cassoftsol.AccountID = ac.ID;
    cassoftsol.ContactID = c1.ID;
    cassoftsol.Case_Severity__c = '1';
    cassoftsol.Subject = 'test';
    cassoftsol.Description = 'test';
    cassoftsol.assetID = aset.ID;
    insert cassoftsol;
    
    Module__c m = new Module__c();
    m.Name = 'MH Request';
    m.Core_Licence__c = cr.ID;    
    insert m;
    
    Functional_Area__c f = new Functional_Area__c();
    f.Name = 'Upgrades';
    f.Module__c = m.ID;  
    insert f;
 
ApexPages.currentPage().getparameters().put('id',cassoftsol.ID);
    ApexPages.StandardController controller = new ApexPages.StandardController(cassoftsol);
    Intranetcase ca = new Intranetcase();
 ca.name=null;
 ca.save();
 ca.name='abc';
 ca.email=null;
 ca.save();
 ca.email='abc@test.com';
ca.subject=null;
ca.save();
ca.subject='test subject';
ca.description=null;
ca.save();
ca.description = 'Test Descp';
ca.save();   
  }
    
    
}