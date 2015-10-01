public without sharing class createCase {

    //error Message
    public boolean JSpanel{get;set;}
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; } 
    public String errorSeverity{ get; set; } 
    public boolean displayfuncarea {get;set;}
    public boolean displaycategory {get;set;}
    // reference for the standard controller
    private ApexPages.StandardController controller {get; set;}
    public boolean temp_flag{get;set;}
    public boolean temp_flag1{get;set;}
    public string compare{get;set;}
    public string account{get;set;}
     public boolean servcheck {get;set;}
    // the record that is being edited
    public Case cas{get;set;}
    private Asset casset;

    //the id of the account selected in the account lookup
    public id AccountId {get; set;}
    public id ContactId {get; set;}
    public id AssetId {get; set;}

    // the values of the selected items in the various picklists
    public string asset {get; set;}
    public string contact {get; set;}
    public string module {get; set;}
    public string functionalarea {get; set;}
    public string category {get; set;}
    public string version {get; set;}
    public string sourcebuild {get; set;}
    private integer contactCount;
    private integer contactCountMax;
    public boolean showNextContacts{get;set;}
    public boolean showPreviousContacts{get;set;}
    public boolean moodleroom{get;set;}
    public string hotnote {get;set;}
    public string ccemail{get;set;}
    
    // collab code by Murugappan
    
    public boolean collab {get;set;}
    public string cmsvalue{get;set;}
    public string usrrolevalue{get;set;}
    public string instancevalue{get;set;}

    // Analytics 
    public string Pyramidversion{get;set;}
    
    //modified by avik
    public boolean clientOs{get;set;}
    public boolean browser{get;set;}
    public String SeverityLevelvalues{get;set;}
    public boolean SeverityLevel{get;set;}
    public boolean Mrcasetype{get;set;}
    public boolean urlaccess{get;set;}
    public String SelectListValue{get;set;}
    public String clvalues{get;set;}
    public String browservalues {get;set;}
    public String mrcasetypevalues {get;set;}
    private User CurrentUser;
    //Learn SAAS
    public boolean isLearnSAAS{get;set;}
    //Analytics
    public boolean isAnalytics{get;set;}
    //xpLor
    public boolean isxplor{get;set;}

    public string getRecordTypeId() {
        return RT.getId(Case.SObjectType, RT.Name.Angel);
    }

    public boolean getnextcontacts()
    {
        return  showNextContacts;
    } 
     
    public createCase(ApexPages.StandardController controller) {
        showNextContacts=false;
        moodleroom = false;
        collab = false;
        isLearnSAAS=false;
        isAnalytics=false;
        isxplor=false;
        contactCount=0;
        JSpanel=false;
        //initialize the stanrdard controller
        this.controller = controller;
        // load the record
        this.cas = (Case)controller.getRecord();
        //temp_flag=true;
        // preselect the current values for the record
        if(ApexPages.currentPage().getParameters().get('def_contact_id') != null)
            contact = ApexPages.currentPage().getParameters().get('def_contact_id');
        else   
            contact = cas.ContactId;
        asset = cas.AssetId;
        module = cas.Module__c;
        functionalarea = cas.Functional_Area__c;
        category = cas.Category__c;
        accountid = cas.AccountId;
        version = cas.Version_On_Case__c;
        sourcebuild = cas.Source_Build_on_Case__c;
        displayfuncarea = true;
        displaycategory = true;
        temp_flag1 = false;
        // cmsvalue = 'Blackboard Learn';

        //Load details from Chatcase object
        if(ApexPages.currentPage().getParameters().get('def_chatcase_id') != null)
        {
            id chatcaseid=ApexPages.currentPage().getParameters().get('def_chatcase_id');
            ChatCase__c chatrecord=[select id,Account__c,Asset__c,Browser__c,Browser_Version__c,Client_OS__c,Client_OS_Version__c,CMS_LMS__c,CMS_LMS_URL__c,
                                        Contact__c,description__c,Java_Version__c,phone__c,subject__c,URL_Accessed__c from chatcase__c where id= :chatcaseid];
               this.cas.accountid = chatrecord.Account__c;
               asset = chatrecord.Asset__c;
               contact = chatrecord.contact__c;
               clvalues= chatrecord.Client_OS__c;
               this.cas.Client_OS_Version__c=chatrecord.Client_OS_Version__c;
               browservalues=chatrecord.Browser__c;
               this.cas.Browser_Version__c=chatrecord.Browser_Version__c;
               this.cas.Java_Version__c=chatrecord.Java_Version__c;
               cmsvalue=chatrecord.CMS_LMS__c;
               this.cas.CMS_LMS_URL__c=chatrecord.CMS_LMS_URL__c;
               this.cas.URL_Access__c=chatrecord.URL_Accessed__c;
               this.cas.Subject=chatrecord.subject__c;
               this.cas.Description=chatrecord.description__c;
               this.cas.origin='Live Agent Chat';
               this.cas.Chatcase__c=chatcaseid;
               collab=true;
        }

    }          

    /*--------------------------------- CONTACTS SELECT LIST ---------------------------------*/

    public List<selectOption> contacts {
        get {
            List<selectOption> options = new List<selectOption>();
            set <id> contactrolelist= new set<id>();

            for(Contact_Role__c acr: [select id,account__c,contact__c from Contact_Role__c  where  account__c = :cas.accountid AND Contact__c!= NULL and role__c like '%admin%'])  
            {

                contactrolelist.add(acr.contact__c);  
                 
            } 
            if(ApexPages.currentPage().getParameters().get('def_contact_id') != null){
                Contact c = [select ID,NAme from Contact where ID =: ApexPages.currentPage().getParameters().get('def_contact_id') AND id in:contactrolelist];
                options.add(new SelectOption(ApexPages.currentPage().getParameters().get('def_contact_id'),c.Name));
                for (Contact ct : [SELECT id, name FROM Contact ct WHERE ct.accountid = :cas.accountid  AND ID !=: ApexPages.currentPage().getParameters().get('def_contact_id') AND id in:contactrolelist Order By Name])
                    options.add(new SelectOption(ct.Id,ct.Name));
            }else{
                options.add(new SelectOption('','-- Select a Contact--'));
                system.debug('Accid2 --'+cas.accountid);
                list<contact> contact_list=[SELECT id, name FROM Contact ct WHERE /*ct.accountid = :cas.accountid TP 4437 and */ id IN :contactrolelist Order By Name ];
                contactCountMax=contact_list.size();
                if(contactCountMax<=1000)
                {
                    for (Contact ct : contact_list)
                        options.add(new SelectOption(ct.Id,ct.Name));
                }
                else{
                    showNextContacts=true;
                    integer listcount=contactCount*1000;
                    integer listlimit=listcount+1000;

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
                        }
                    }
                }
            }    



            return options;           
        }
        set;
    }    
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


    /*--------------------------------- ASSET SELECT LIST ---------------------------------*/   
    
    public List<selectOption> assets {
        get {
            list<Account> abc = [Select id, Hot_Note__c, Name from Account where id = :cas.accountid];
                if(abc != null && abc.size() > 0){
                    hotnote = abc[0].Hot_Note__c;
                }
            
            
            errorShow = false;
            List<selectOption> options = new List<selectOption>();

            options.add(new SelectOption('','-- Choose a Product --'));
            for (Asset a : [SELECT id, name, core_license__c,Core_License__r.Name,Core_License__r.Product__c, External_Asset_Name__c,Product2Id, Product2.Name, Software_URL__c FROM Asset a WHERE (a.accountid = :cas.accountid AND a.core_license__c != null AND a.isBtbbEligible__c = true) OR (a.accountid = :cas.accountid AND a.Force_Btbb_Visibility__c = true AND a.core_license__c != null) Order By External_Asset_Name__c]){
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Learn') && !(a.Core_License__r.Product__c.contains('Learn SAAS')) ){
                if((a.External_Asset_Name__c!=null)&&(a.id!=null)){

                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Product__c.contains('Learn SAAS')){
                if((a.name!=null)&&(a.id!=null)){
                    
                        options.add(new SelectOption(a.Id,a.name));
                        system.debug('asset learnsaaa'+a.name);
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Moodlerooms')){
                if((a.name!=null)&&(a.id!=null)){
                    if(a.Software_URL__c !=null)
                        options.add(new SelectOption(a.Id,a.name+' '+ a.Software_URL__c));/*SHIRISH PLEASE USE THE FOLLOWING FOR LABELING PICKLIST a.Core_License__c+' - '+a.Version__c*/
                    else 
                        options.add(new SelectOption(a.Id,a.name));
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('ANGEL')){
                if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Transact')){
                if((a.External_Asset_Name__c!=null)&&(a.id!=null)){ 

                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Xythos')){
                if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('CE') && a.Core_License__r.Name.contains('Vista')){
                if((a.External_Asset_Name__c!=null)&&(a.id!=null)){
                     
                        options.add(new SelectOption(a.Id,a.External_Asset_Name__c));
               } 
                }
                if(a.Core_License__r.Name != null && a.Core_License__r.Name.contains('Collaborate')){
                if((a.Product2.Name!=null)&&(a.id!=null)){
                    
                         options.add(new SelectOption(a.Id,a.Product2.Name+' '));
               } 
                }
                if(a.Core_License__r.Name!=null && a.Core_License__r.Name.contains('Analytics')){
                if((a.Product2.Name!=null)&&(a.id!=null)){

                         options.add(new selectoption(a.Id,a.Product2.Name));    
               }    
                }
                if(a.Core_License__r.Name!=null && a.Core_License__r.Name.contains('xpLor')){
                if((a.Product2.Name!=null)&&(a.id!=null)){

                         options.add(new selectoption(a.Id,a.Product2.Name));    
               }    
                }
            } 
            return options;           
        }
        set;
    }

    /*--------------------------------- INSTANCE DISPLAY FOR ANGEL ASSETS ---------------------------------*/

    public void InstanceDisplay(){
        temp_flag=false;
        temp_flag1=false;
        moodleroom =false;
        collab = false;
        isLearnSAAS=false;
        isAnalytics=false;
        isxplor=false;
        if(asset!=null){
            system.debug('hi'+asset);
            Asset a=[Select a.id,a.Version__c,a.Version_Build__c,a.name,a.Support_Level__c,a.Core_License__r.Name, a.Core_License__c,Core_License__r.product__c From Asset a where a.id=:asset];
            version = a.Version__c;
            sourcebuild = a.Version_Build__c;
            if(a.Core_License__r.Name.Contains('ANGEL')||(a.Core_License__r.Name.contains('Learn')&&a.Core_License__r.product__c.contains('Learn SAAS'))){
                compare='Angel';
                temp_flag= true;
                System.debug(cas.Case_Severity__c);
                if(a.Support_Level__c == 'ANGEL Premium Support' && (cas.Case_Severity__c == '1' || cas.Case_Severity__c == '2')) 
                    temp_flag1= true;
            }
            
            else if(a.Core_License__r.Name.Contains('Collaborate'))
            {
              collab = true;
            }
            
            else{ 
                if(a.Core_License__r.Name.Contains('Moodlerooms'))
                {
                    moodleroom = true;
                }
                else if(a.Core_License__r.Name == 'Analytics') 
                {
                    isAnalytics = true;
                }
                else if(a.Core_License__r.Name == 'xpLor')
                {
                    isxplor=true; 
                }        
                else 
                {
                    temp_flag= false;
                    temp_flag1= false;
                }
               }
           if(a.Core_License__r.Name == 'ANGEL LMS')
               {
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Angel);
                }
                else if(a.Core_License__r.Name == 'Learn' && a.Core_License__r.Product__c=='Learn SAAS')
                {
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
                    isLearnSAAS=true;
                }
                else if(a.Core_License__r.name=='xpLor')
                {
                    cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Xplor);
                } 
            
        }
    }

    /*----------------------------- VERSION SELECT LIST ------------------------------*/

   /*public List<selectOption> versions {


        get {
            List<selectOption> options = new List<selectOption>();
            Set<String> ver = new Set<String>();
            if (asset != null) {

                for (Asset a : [SELECT id, name, version__c FROM Asset a WHERE a.id =: asset]){
                    if(a.version__c!=null)
                        options.add(new SelectOption(a.version__c,a.version__c));
                    // version = a.version__c;
                    ver.add(a.Version__c);
                }

                for (Version__c v : [SELECT id, version__c FROM Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:asset].Psft_Product_Id__c AND v.Version__c != :[SELECT version__c FROM Asset WHERE id =: asset].version__c ORDER BY Version__c DESC])
                {
                    if(v.version__c!=null && !ver.contains(v.version__c)){
                        options.add(new SelectOption(v.version__c,v.version__c));
                        if(version == null)
                            version = v.version__c;
                        ver.add(v.version__c);
                    }
                }
            }
            return options;
        }
        set;
    }*/
// new versions code

public List<selectOption> versions {


        get {
    
            List<selectOption> options = new List<selectOption>();
            Set<String> ver = new Set<String>();
            if (asset != null) {

                for (Asset a : [SELECT id, name, version__c, Product2Id, Product2.GKEY_Product_Group__c FROM Asset a /* WHERE Product2.GKEY_Product_Group__c != null AND Product2.Core_License__c != null AND*/ Where a.id =: asset]){
                    
                   options.add(new selectoption('','-Please Select-'));
                   system.debug('AVERSION' +a.version__c);
                    if(a.version__c!=null)
                    {
                        options.add(new SelectOption(a.version__c,a.version__c));
                     //   ver.add(a.Version__c);
                    }

                }


                
                list<Asset> listAsset = [Select id, name, Product2.GKEY_Product_Group__c from Asset Where Id=: asset ];
                list<Version_Build_Tree__c > availversions;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversions = [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE Version__c != :[SELECT version__c FROM Asset WHERE id =: asset].version__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Active_Flag__c = true ORDER BY Version__c DESC ];
                }
                
                map<String, String> distinctVersions = new map<String, String>();
                for(Version_Build_Tree__c eachVersion : availversions ){
                distinctVersions.put(eachVersion.Version__c,eachVersion.Version__c);
                }
                
                for(String eachDistinctVersion: distinctVersions.keySet() ){
                ver.add(eachDistinctVersion);
                
                }
                // ver is filled with right set now
                for(String eachSelectableVersion: ver){
                if(eachSelectableVersion != null)
                options.add(new SelectOption(eachSelectableVersion,eachSelectableVersion));
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

            system.debug('VERSIONOPTIONS'+options);
            return options;
        }
        set;
    }
    
    
    



// end new versions code

    /* ------------------------- CLEAR SOURCE BUILD ADD '-Please Select-' --------------- */

    public Pagereference clearsb(){
        System.debug('AAAAAAA' +version);
        sourcebuild = '-Please Select-';
        return null;
    }


    /* ------------------------- SOURCE BUILD SELECT LIST ------------------------------- */    
    /*public List<selectOption> sblist{

        get {

            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();

            if(asset != null) {
                if(sourcebuild == '-Please Select-')
                    options.add(new SelectOption('-Please Select-','-Please Select-'));
                if(sourcebuild != '-Please Select-' && sourcebuild != null){
                    options.add(new SelectOption(sourcebuild,sourcebuild));
                    for (Asset a : [SELECT version__c,Version_Build__c FROM Asset a WHERE a.id =: asset]) {
                        if(a.Version_Build__c != null) {
                            if(sourcebuild == null || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-Please Select-'))
                                sourcebuild  = a.Version_Build__c;
                            options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));

                        }
                    }
                }

                System.debug('----- version' + version + '----- asset' + asset + '------ sourcebuild' + sourcebuild);
                for (Bb_Prod_Version__c v : [SELECT id, source_build__c FROM Bb_Prod_Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:asset].Psft_Product_Id__c AND v.Version__c = :version AND v.source_build__c != :sourcebuild ORDER BY Source_Build__c DESC]){           
                    if(v.source_build__c != null){
                        options.add(new SelectOption(v.source_build__c,v.source_build__c));
                        if(sourcebuild == null && sourcebuild != '-Please Select-')
                            sourcebuild = v.source_build__c; 
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
    }*/
    // new version build code
    
    
    public List<selectOption> sblist{

        get {
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            String defaultVersion;
            String defaultVersionBuild;
          /*   if (asset != null) {
             
             for (Asset a : [SELECT version__c,Version_Build__c FROM Asset a WHERE a.id =: asset]) {
              
             defaultVersion = a.version__c;
             if(a.Version_Build__c !=null)
            
             
             defaultVersionBuild = a.Version_Build__c;
             if(a.Version_Build__c !=null)
             if(sourcebuild == null || sourcebuild =='')
             options.add(new SelectOption(defaultVersionBuild ,defaultVersionBuild));
             
             }*/

            if(asset != null) {
                if(sourcebuild == '-Please Select-')
                    options.add(new SelectOption('','-Please Select-'));
                if(sourcebuild != '-Please Select-' && sourcebuild != null){
                    //options.add(new SelectOption(sourcebuild,sourcebuild));
                    options.add(new selectoption('','-Please Select-'));
                    for (Asset a : [SELECT version__c,Version_Build__c,Product2Id,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: asset]) {
                        if(a.Version_Build__c != null) {
                            if(sourcebuild == null || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-Please Select-'))
                                sourcebuild  = a.Version_Build__c;
                            options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));

                        }
                        else
                          {
                            for (Version_Build_Tree__c v : [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c WHERE GKEY_Product_Group__c =:a.Product2.GKEY_Product_Group__c AND Version__c =:version AND Active_Flag__c =true ORDER BY Version_Build__c DESC]){           
                            if(v.Version_Build__c != null)
                            options.add(new SelectOption(v.Version_Build__c,v.Version_Build__c));
                          }
                        }
                     } 
                  }
             
             
             // We need Asset to get Product2 to get the GKEY Product Group
                list<Asset> listAsset = [Select id, name, Version__c, Version_Build__c, Product2.GKEY_Product_Group__c from Asset Where Id=: asset ];
                list<Version_Build_Tree__c > availversionbuilds;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversionbuilds = [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c v WHERE Version_Build__c!= :[SELECT Version_Build__c FROM Asset WHERE id =: asset].Version_Build__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Version__c =: version AND version_build__c !=:sourcebuild AND v.Active_Flag__c = true  ORDER BY Version_Build__c DESC];
                
                }
                
                map<String, String> distinctVersionBuilds = new map<String, String>();
                for(Version_Build_Tree__c eachVersionBuild : availversionbuilds){
                distinctVersionBuilds.put(eachVersionBuild.Version_Build__c ,eachVersionBuild.Version_Build__c );
                
                
                }
                
                for(String eachDistinctVersionBuild: distinctVersionBuilds.keySet() ){
                options.add(new SelectOption(eachDistinctVersionBuild,eachDistinctVersionBuild));
                 //sourcebuild=  eachDistinctVersionBuild;                          
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
                system.debug('SBOPTIONS'+options);
            return options;
        }
        set;
    }
    
    // end new version build code
    
   

    /*--------------------------------- MODULE SELECT LIST ---------------------------------*/


    public List<selectOption> modules {
        get {
            errorShow = false;
            List<selectOption> options = new List<selectOption>();

            if (asset != null) {
                options.add(new SelectOption('','-- Choose an Issue Topic --'));
                for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : [select core_license__c from asset where id =:asset].core_license__c order by Order__c,name] )
                    options.add(new SelectOption(m.Id,m.Name));
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

    /*--------------------------------- CATEGORIES SELECT LIST ---------------------------------*/

    public List<selectOption> categories {
        get {
            errorShow = false;
            List<selectOption> options = new List<selectOption>();

            if (functionalarea != NULL) {
                options.add(new SelectOption('','-- Choose a Category --'));
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


    /*--------------------------------- SAVE PAGE REFERENCE ---------------------------------*/

    public PageReference save() {
        JSpanel=false;
        // set the selected values to the record before saving
        system.debug('-----------------------------1');
        errorShow = false;
        if(cas.accountid==Null)
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Account Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }

        else if(contact==Null || contact=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Contact Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(asset==Null || asset=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Installed Product: You must enter a value';
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
        
        else if(SeverityLevelvalues==Null || SeverityLevelvalues=='' )
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Case Severity: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(cas.Subject==Null || cas.Subject=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Subject: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(cas.Description==Null || cas.Description=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Description: You must enter a value';
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
                cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Analytics);
            else if(a.Core_License__r.Name == 'xpLor')
                cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.xpLor);          
            else
                cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
           
        }
        //validation for moodleroom fields.
        if(a.Core_License__r.Name == 'Moodlerooms'&&(cas.URL_Access__c==Null || cas.URL_Access__c==''))
        {            errorShow = true;
        errorTitle = 'Error:';
        errorMessage = 'Case URL Access: You must enter a value';
        errorSeverity = 'error';
        return null;
        }
        if(a.Core_License__r.Name == 'Moodlerooms'&&(mrcasetypevalues==Null || cas.MR_Case_Type__c==''))
        {            errorShow = true;
        errorTitle = 'Error:';                  
        errorMessage = 'Case MR Case Type: You must enter a value';
        errorSeverity = 'error';
        return null;
        }                 
        // validation for Xplor fields
        if(a.Core_License__r.Name == 'xpLor' && (cas.Site_URL__c == Null || cas.Site_URL__c == ''))
        {            
        errorShow = true;
        errorTitle = 'Error:';
        errorMessage = 'Site URL: You must enter a value';
        errorSeverity = 'error';
        return null;
        }
        if(a.Core_License__r.Name == 'xpLor' && (cas.CMS_LMS__c == Null || cas.CMS_LMS__c == ''))
        {
        errorShow = true;
        errorTitle = 'Error:';
        errorMessage = 'CMS/LMS: You must enter a value';
        errorSeverity = 'error';
        return null;  
        }
        cas.ContactId = contact;
        cas.AssetId = asset;
        cas.MR_Case_Type__c = mrcasetypevalues;
        cas.Browser__c = browservalues;
        cas.Client_OS__c = clvalues;
        cas.Case_Severity__c = SeverityLevelvalues;
        cas.Module__c = module;
        cas.Functional_Area__c = functionalarea;
        cas.Category__c = category;
        cas.AccountId = cas.Accountid;
        cas.Version_On_Case__c = version;
        cas.Source_Build_on_Case__c = sourcebuild;
        cas.Core_License__c = a.Core_License__c;
        cas.Case_Severity__c=SeverityLevelvalues;
        cas.Type = 'Standard Support Ticket';
        cas.User_Role__c = usrrolevalue;
        if(a.Core_License__r.name == 'Collaborate')
        {
         cas.CMS_LMS__c = cmsvalue;
        } 
        //Added by Atul
        cas.Manual_Grade_Selection_by_exception_only__c='A';

        try {
            upsert(cas);
            system.debug('-----------------------------1');
            JSpanel=true;

        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        return null;
        //return (new ApexPages.StandardController(cas)).view();  Page redirect moved to page TP2914
    } 
    
    /*--------------------------------- SAVE AND GRAB PAGE REFERENCE ---------------------------------*/

    public PageReference saveandgrab() {
        JSpanel=false;
        // set the selected values to the record before saving
        system.debug('-----------------------------1');
        errorShow = false;
        if(cas.accountid==Null)
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Account Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }

        else if(contact==Null || contact=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Contact Name: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(asset==Null || asset=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Installed Product: You must enter a value';
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
        
        else if(SeverityLevelvalues==Null || SeverityLevelvalues=='' )
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Case Severity: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(cas.Subject==Null || cas.Subject=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Subject: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(cas.Description==Null || cas.Description=='')
        {
            errorShow = true;
            errorTitle = 'Error:';
            errorMessage = 'Description: You must enter a value';
            errorSeverity = 'error';
            return null;
        }
        else if(ccemail != null && ccemail!='')
        {
            list<string> ccemaillist=ccemail.split(';');
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
                    if(!Pattern.matches('^\\s*[_A-Za-z0-9-]+(\\.[_A-Za-z0-9-\']+)*@[A-Za-z0-9]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$',s))
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
            }
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
                cas.RecordTypeId = RT.getID(Case.SObjectType, RT.Name.Analytics); 
            else if(a.Core_License__r.Name == 'xpLor')
                cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.xpLor);      
            else
                cas.RecordTypeId = RT.getId(Case.SObjectType, RT.Name.Learn);
        }
       
        //validation for moodleroom fields.
        if(a.Core_License__r.Name == 'Moodlerooms'&&(cas.URL_Access__c==Null || cas.URL_Access__c==''))
        {            errorShow = true;
        errorTitle = 'Error:';
        errorMessage = 'Case URL Access: You must enter a value';
        errorSeverity = 'error';
        return null;
        }
        if(a.Core_License__r.Name == 'Moodlerooms'&&(mrcasetypevalues==Null || cas.MR_Case_Type__c==''))
        {            errorShow = true;
        errorTitle = 'Error:';                  
        errorMessage = 'Case MR Case Type: You must enter a value';
        errorSeverity = 'error';
        return null;
        } 
        // validation for Xplor fields
        if(a.Core_License__r.Name == 'xpLor' && (cas.Site_URL__c == Null || cas.Site_URL__c == ''))
        {            
        errorShow = true;
        errorTitle = 'Error:';
        errorMessage = 'Site URL: You must enter a value';
        errorSeverity = 'error';
        return null;
        }
        if(a.Core_License__r.Name == 'xpLor' && (cas.CMS_LMS__c == Null || cas.CMS_LMS__c == ''))
        {
        errorShow = true;
        errorTitle = 'Error:';
        errorMessage = 'CMS/LMS: You must enter a value';
        errorSeverity = 'error';
        return null;  
        }
         CurrentUser = [Select Id,Primary_Group__c, Name, FirstName, LastName From User Where Id =: Userinfo.getUserID()];
         if(CurrentUser.Primary_Group__c=='' || CurrentUser.Primary_Group__c == null || CurrentUser.Primary_Group__c == '-None-')
         {
         
          errorShow = true;
          errorTitle = 'Error:';                  
          errorMessage = 'You do not have Primary Group assigned. Please Contact your System Administrator to assign a Primary group or Click on Createcase button to Create a Case';
          errorSeverity = 'error';
          return null;
         
         }                

        cas.ContactId = contact;
        cas.AssetId = asset;
        cas.MR_Case_Type__c = mrcasetypevalues;
        cas.Browser__c = browservalues;
        cas.Client_OS__c = clvalues;
        cas.Case_Severity__c = SeverityLevelvalues;
        cas.Module__c = module;
        cas.Functional_Area__c = functionalarea;
        cas.Category__c = category;
        cas.AccountId = cas.Accountid;
        cas.Version_On_Case__c = version;
        cas.Source_Build_on_Case__c = sourcebuild;
        cas.Core_License__c = a.Core_License__c;
        cas.Case_Severity__c=SeverityLevelvalues;
        cas.Type = 'Standard Support Ticket';
        cas.User_Role__c = usrrolevalue;
        cas.CMS_LMS__c = cmsvalue;
        //Added by Atul
        cas.Manual_Grade_Selection_by_exception_only__c='A';

        try {
            upsert(cas);
            system.debug('-----------------------------1');
            JSpanel=true;

        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        }
        
        //return (new ApexPages.StandardController(cas)).view();  Page redirect moved to page TP2914
        
        case c = [select id,ownerid from Case where id=:cas.id];
        c.ownerId = CurrentUser.Id;
        c.Primary_Group_Name__c = CurrentUser.Primary_Group__c;
        update c;
        return null;
     }           

 
    public List<SelectOption> getclos() {
        List<SelectOption> options = new List<SelectOption>();
             Schema.DescribeFieldResult ClienetOSDecribe = Case.Client_OS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ClienetOSDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                  if(clvalues == null|| clvalues=='')   
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
                    if(browservalues == null|| browservalues=='')
                browservalues=picklistEntry.getvalue(); 
                }
              }
             return options; 
    }
 public List<SelectOption> getSeverityLevelop() {
    
         list<account> acc= new list<account>();
        acc=[select id,Severity_1_6__c from account where id=:cas.accountid];  
        List<SelectOption> options = new List<SelectOption>();
           Schema.DescribeFieldResult SeverityLevelDecribe = Case.Case_Severity__c.getDescribe();
           
              for (Schema.Picklistentry picklistEntry: SeverityLevelDecribe.getPicklistValues())
              {
                
                if(integer.valueof(pickListEntry.getValue())<=4)
                {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                SeverityLevelvalues=picklistEntry.getvalue(); 
                }
                }
                else if(acc != null && acc.size() > 0 && acc[0].Severity_1_6__c == true )
                {
                    Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
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

    public void setSelectListValue(String SelectListValue){
        this.SelectListValue=SelectListValue;
    }

    // Analytics

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

    
    // collab code by Murugappan
    
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
    
    public List<SelectOption> getcmsoptions() {
     
        List<SelectOption> options = new List<SelectOption>();
             Schema.DescribeFieldResult ClienetOSDecribe = Case.CMS_LMS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: ClienetOSDecribe.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                    if(cmsvalue==null||cmsvalue=='')
                cmsvalue=picklistEntry.getvalue();  
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


    
}