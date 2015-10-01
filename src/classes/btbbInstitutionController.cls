public Without Sharing class  btbbInstitutionController {
     GlobalComponent gc = new GlobalComponent();
    public Account Acct { get; set; }
    public id AcctId { get; set; }
    public Id contactId { get; set; }
    List<Asset> assetList { get; set; }
    public id assetId { get; set; }
    public Boolean isEditMode { get; set; }
    List<AssetWrapper> Assets = new List<AssetWrapper>();
    public String nickName { get; set; }
    public String softURL { get; set; }
    public String version { get; set; }
    public String build { get; set; }

    public String assetName { get; set; }
    public String AccountName { get; set; }
    public String AccountRep {get; set;} 
    public String ComplexHostingRep {get; set;}
    public String AccPSCompID { get; set; }
    public List<SelectOption> Accounts { get; set; } 
    List<User> u;
    public asset asst {get;set;}
    
     public string corelicenses {get;set;}
    public String appServerOS { get; set; }
    public String database { get; set; }
    public String dbServerOS { get; set; }
    public String jdkVersion { get; set; }
    public boolean isCLB {get;set;}
    public boolean collabonlycontactrole {get;set;}
    public map<id,string> accountadminmap=new map<id,string>(); //Stores id of Account and Core License if Admin
    public string adminaccess {get; set;}
    public String getUserId() {
        return userInfo.getUserId();
    }
    
    public List<Bb_Account_Team_Role__c> getBbAccountReps() {
        return [SELECT Name, Member__c, Id, Role_Code__c FROM Bb_Account_Team_Role__c WHERE Account__r.Id =:AcctId /*AND Role_Code__c = '3'*/ limit 999];
    }
    
    public boolean isAdmin{get;set;}
    
    
     public List<SelectOption> getDatabaseList() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult BrowserDecribe1 = Asset.Database__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe1.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                database=picklistEntry.getvalue(); 
                }
              }
             return options; 
    }
    public List<SelectOption> getDbServerOS1() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult BrowserDecribe2 = Asset.Database_Server_OS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe2.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                dbServerOS=picklistEntry.getvalue(); 
                }
              }
             return options;
        
        
    }
    
    public List<SelectOption> getJDKVersionList() {
        List<SelectOption> options = new List<SelectOption>();

         Schema.DescribeFieldResult BrowserDecribe3 = Asset.JDK_Version__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe3.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                jdkVersion=picklistEntry.getvalue(); 
                }
              }
             return options;
        
    }
   
    public List<SelectOption> getApplServerOS() {
       List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult BrowserDecribe4 = Asset.Application_Server_OS__c.getDescribe();
              for (Schema.Picklistentry picklistEntry: BrowserDecribe4.getPicklistValues())
              {
                Options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
                if(PicklistEntry.defaultvalue){
                appServerOS=picklistEntry.getvalue(); 
                }
              }
             return options;
        
    }   
    public class ContactWrapper{
        public string a { get; set; }
        public List<String> listContact{ get; set; }
        public ContactWrapper(){            
        }
        public ContactWrapper(String sub,List<String> ContactList) {
        a= sub;        
        listContact =ContactList;
        }
    }
    public class AssetWrapper{
        public Id asstId { get; set; }
        public string JDK_Version { get; set; }
        public string Database { get; set; }
        public string Database_Server_OS { get; set; }
        public string Application_Server_OS { get; set; }
        public string Version { get; set; }
        public string Version_Build { get; set; }
        public string Product { get; set; }
        public string Software_URL { get; set; }
        public string Nickname { get; set; }
        public string Name { get; set; }
        public string ManageHosting { get; set; }
        public string CoreLicense {get;set;}
        public string externaldesciption {get;set;}
        public string coreliscenseproduct {get;set;}
        public boolean isadmin{get;set;}
        public string adminaccess {get; set;}
        public string productname {get; set;}
        
     
        public AssetWrapper(Id assetId1, String JDK_Version1,String Database1,String Database_Server_OS1,String Application_Server_OS1,String Version1, String Build1, String Product1,String Software_URL1,String Nickname1,String Name1, String MH, String CRL,boolean isadmin, string coreliscenseproduct1,string adminaccess1,string productname1) {
            asstId = assetId1;
            JDK_Version=JDK_Version1;
            Database =Database1;
            Database_Server_OS=Database_Server_OS1;
            Application_Server_OS=Application_Server_OS1;
            Version =Version1;
            Version_Build = Build1;
            Product=Product1;
            Software_URL=Software_URL1;
            Nickname =Nickname1;
            Name =Name1;
            ManageHosting = MH;
            CoreLicense = CRL;
            coreliscenseproduct = coreliscenseproduct1; 
            productname=productname1;
            // this.isadmin=isadmin;
            adminaccess = adminaccess1;
            if(adminaccess.containsignorecase(CRL)){
            
                this.isadmin = true;            
            }
            
        }
        
        public AssetWrapper(Id assetId1, string externaldesciption1, string coreliscenseproduct1, String Name1, string CRL ,boolean isadmin, string adminaccess1,string productname1 ){
         asstId = assetId1;
         externaldesciption = externaldesciption1;
         coreliscenseproduct = coreliscenseproduct1;
         Name = Name1;
         CoreLicense = CRL;
         adminaccess = adminaccess1;
         productname=productname1;
       //  this.isadmin=isadmin;
       if(adminaccess.containsignorecase(CRL)){
            
                this.isadmin = true;            
            }
        }
    }
    public List<AssetWrapper> AssetData {
        
        get {
            Assets = new List<AssetWrapper>();
            //for(Asset ast : [Select Id, Managed_Hosting__c, JDK_Version__c,Database__c,Database_Server_OS__c,Application_Server_OS__c,Version__c,Version_Build__c,Product_ID__c,Core_License__r.Name, Software_URL__c,Nickname__c,Name from Asset where AccountId=:AcctId AND Status != 'Uninstalled' AND Core_License__c != Null ORDER BY Name ]) { // commented for CPQ - go live
                for(Asset ast : [Select Id, Managed_Hosting__c, JDK_Version__c,Database__c,Database_Server_OS__c, External_Description__c, Application_Server_OS__c,Version__c,Version_Build__c,Product_ID__c,Core_License__r.Name, Core_License__r.Product__c, Software_URL__c,Nickname__c,Name,External_Asset_Name__c from Asset where (AccountId=:AcctId AND Core_License__c != Null AND isBtbbEligible__c = True) OR (AccountId=:AcctId AND Force_Btbb_Visibility__c = true AND Core_License__c != null) ORDER BY Name ]) {
                boolean isadmin =false;
                
                
                if(accountadminmap.get(acctId)!= null && accountadminmap.get(acctId).containsignorecase(ast.Core_License__r.Name))
                {
                  isadmin=false;
                }

                if(ast.Core_License__r.Name.Contains('Collaborate')){
                Assets.add(new AssetWrapper(ast.Id, ast.External_Description__c, ast.Core_License__r.Product__c, ast.Name, ast.Core_License__r.Name,isadmin,adminaccess,ast.External_Asset_Name__c ) );
                }
                else{
                Assets.add(new AssetWrapper(ast.Id, ast.JDK_Version__c,ast.Database__c,ast.Database_Server_OS__c,ast.Application_Server_OS__c,ast.Version__c,ast.Version_Build__c,ast.Core_License__r.Name,ast.Software_URL__c,ast.Nickname__c,ast.Name, ast.Managed_Hosting__c, ast.Core_License__r.Name,isadmin, ast.Core_License__r.Product__c,adminaccess,ast.External_Asset_Name__c));
            }
            }
            return Assets;

        }
        set;
    }
    public ContactWrapper[] getContactData() {
         ContactWrapper[] Contacts= new ContactWrapper[]{};
         Map<String,List<String>> map1=new Map<String,List<String>>();
         string TempRole='';
         ContactWrapper Contact1= new ContactWrapper();

         List<String> roleNameList = new List<String>();
         roleNameList.add('ANALYTICS - Admin');
         roleNameList.add('XPLOR - Admin');
         roleNameList.add('ANGEL - Admin');
         roleNameList.add('Collaborate - Admin');
         roleNameList.add('LEARN - Academic Developer');
         roleNameList.add('LEARN - MLA Admin'); 
         roleNameList.add('LEARN (Bb) - Admin'); 
         roleNameList.add('LEARN (CE/Vista) - Admin');
         roleNameList.add('Moodlerooms - Admin');
         roleNameList.add('MOODLEROOMS - System Admin');
         roleNameList.add('TRANSACT - Admin'); 
         roleNameList.add('XYTHOS - Admin');


         system.debug('listrole-->'+roleNameList);
         List<String> strContact=New List<String>();         
         for(Contact_Role__c cr : [Select Role__c,Contact__r.FirstName, Contact__r.LastName from Contact_Role__c where Account__c=:AcctId AND Expire_Role__c = false AND Role__c IN :roleNameList AND Contact__c!= NULL and  Contact__r.Contact_Status__c='Active' order by Role__c ASC]) {
             

             List<String> Conname=map1.get(cr.Role__c);
             if(Conname==null){
             Conname=new List<String>();
             if(cr.Contact__r.FirstName!=null)                 
             Conname.add(cr.Contact__r.FirstName + ' ' + cr.Contact__r.LastName);
             else
                 Conname.add(cr.Contact__r.LastName);
             map1.put(cr.Role__c,Conname);
             }else{
                if(!(conname.size()>=998) )
                {
                   if(cr.Contact__r.FirstName!=null)
                   {                    
                         Conname.add(cr.Contact__r.FirstName + ' ' + cr.Contact__r.LastName);
                   }
                  else
                         Conname.add(cr.Contact__r.LastName);

                   map1.put(cr.Role__c,Conname);
                  System.debug('Role-->'+cr.Role__c);

                }  
              }
           }
           for(String Rolename:map1.keyset()){
               Contacts.add(new ContactWrapper(Rolename,map1.get(Rolename)));
           }    
           system.debug('----conatct size ---'+contacts.size());      
         return Contacts;
    }
    public btbbInstitutionController() {
        isAdmin=false;

        //asst = (Asset)controller.getRecord(); 
        u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]); 
        if(System.currentPageReference().getParameters().get('id') != null)
           AcctId= System.currentPageReference().getParameters().get('id');
        if(System.currentPageReference().getParameters().get('cid') != null && System.currentPageReference().getParameters().get('cid') != '')   
            contactId = System.currentPageReference().getParameters().get('cid');           
        Accounts = new List<SelectOption>();
        Set<Id> accSet = new Set<Id>();
        if(contactId != null) {
            
            //Added by Shirish for default preferred Institution
            AcctId = [Select Preferred_Institution__c from Contact Where id = :contactId ].Preferred_Institution__c;

            // End of added by Shirish
            
            list<Contact_Role__c> contRoleList1 = [Select Id, Contact__c, Role__c, Account__c,BusinessUnit__c,AccessCode__c From Contact_Role__c where Contact__c = :contactId AND Expire_Role__c = false and AccessCode__c !='0' AND Contact__c!= NULL order by Role__c Asc];
            
            if(contRoleList1.size() == 1){
            
                if(contRoleList1[0].Role__c.contains('COLLABORATE')){
                    collabonlycontactrole = true;
                
                }
                else
                {
                collabonlycontactrole = false;
                }
            }
            adminaccess='';
            for(contact_role__c c:contRoleList1)
            {
                if(c.BusinessUnit__c!= null && c.BusinessUnit__c!= 'Moodlerooms' && c.BusinessUnit__c!='ANALYTICS' && c.BusinessUnit__c!='xpLor')
                {
                    if(integer.valueof(c.accesscode__c)==7)
                    isAdmin=true;
                }
                if(integer.valueof(c.accesscode__c)==7){
                     
                    adminaccess = adminaccess + ',' + c.BusinessUnit__c;  
                }
                
            }
            
            
            
            
            
            for(Contact_Role__c contRoleList : [Select Id, Contact__c, Account__c,role__c From Contact_Role__c where Contact__c = :contactId AND Expire_Role__c = false and role__c != null AND Contact__c!= NULL AND  AccessCode__c !='0' order by Role__c Asc]) {
                
                accSet.add(contRoleList.Account__c);

                if(contRoleList.role__c.containsignorecase('Admin'))
                {
                  if(accountadminmap.get(contRoleList.Account__c) != null)
                  {
                    string temp = accountadminmap.get(contRoleList.Account__c);
                    accountadminmap.put(contRoleList.Account__c,temp+','+contRoleList.role__c);
                  }
                  else
                  {
                    accountadminmap.put(contRoleList.Account__c,contRoleList.role__c);
                  }
                }
            }
            
            
            if(accSet.size() > 0) {                
                for(Account accObj : [Select Name, PS_Company_Id__c, Id From Account Where id IN :accSet Order BY Name ASC]) {
          
                    if(acctId == null) {
                        acctId = accObj.Id;
                        AccountName = accObj.Name;
                        AccPSCompId = accObj.PS_Company_Id__c;
                    
                    //Added by Shirish for default preferred Institution
                    } else if(accObj.Id == acctId) {
                        
                        AccountName = accObj.Name;
                        AccPSCompId = accObj.PS_Company_Id__c;
                    }//end Added by Shirish
                    else{
                           acctId = accObj.Id;
                           AccountName = accObj.Name;
                           AccPSCompId = accObj.PS_Company_Id__c;
                        }
                    Accounts.add(new SelectOption(accObj.Id, accObj.Name));
                }   
            }
        }   
             
    }
     public boolean getaccstat()
  {
  if(accounts.size()>1)
  return true;
  else
  return false;
  }

    public Boolean isAccontSel {
        get {
                if(null != AcctId)       
                    return false;
                else
                    return true;
        }
        set;
    }   
    
           
    public PageReference selectAccount() {
        
        if(AcctId != null) {
            
            Account acct = [Select Id, PS_Company_Id__c, Name From Account a where id=:AcctId];
            AccountName = acct.Name;
            AccPSCompId = acct.PS_Company_Id__c;
            
            //Added by shirish on 21 NOV for Preferred Institution
            Contact cont = new Contact(Id = contactId);
            cont.Preferred_Institution__c = AcctId;
            update cont;
            //End of added by Shirish
        } else {
            
            AccountName = null;
            AccPSCompId = null;
        }
        isEditMode = false;
        return null;
    }
    
    public PageReference EditAsset() {
        
        System.debug('In Bind EditAsset 1>>>>>>>>>> ' + assetId);
        if(System.currentPageReference().getParameters().get('AssetUpdate') != null)
           assetId= System.currentPageReference().getParameters().get('AssetUpdate');
        System.debug('In Bind EditAsset 2>>>>>>>>>> ' + assetId); 
        System.debug('Selected Assets' +assets);
        for(AssetWrapper ast : assets) {
            
            if(ast.asstid == assetId) {
                build = ast.Version_Build;
                nickName = ast.Nickname;
                version = ast.Version;
                softURL = ast.Software_URL;
                assetName = ast.Name;
                appServerOS = ast.Application_Server_OS;
                database = ast.Database;
                dbServerOS = ast.Database_Server_OS;
                jdkVersion = ast.JDK_Version;
                corelicenses =ast.CoreLicense;
                
                
            }
        }
         
        isEditMode = true;
        return null;
    }
    
    public PageReference SaveAsset() {
        System.debug('In Bind SaveAsset >>>>>>>>>>' + assetId);
        
        Asset ast1 = new Asset(Id=assetId);
        ast1.Nickname__c = nickName;
        ast1.Software_URL__c = softURL;
        //ast1.Version__c = version;
        //ast1.Version_Build__c = build;
        ast1.Application_Server_OS__c = appServerOS;
        ast1.Database__c = database;
        ast1.Database_Server_OS__c = dbServerOS;
        ast1.JDK_Version__c = jdkVersion;
        
        
        update ast1;
        
        Asset ast2 = [Select id, Version__c, Version_Build__c from Asset where id =: assetid LIMIT 1];
        if(ast2.Version__c != version && ast2.Version_Build__c != build){
        Asset_Version_History__c AVH= new Asset_Version_History__c();
        AVH.Asset__c=assetId;
        AVH.Current_Version__c=version;
        AVH.Current_Build__c=build;
        AVH.Effective_Date__c=system.now();
        insert AVH;
        }
        
        else if(ast2.Version__c == version && ast2.Version_Build__c != build){
        Asset_Version_History__c AVH= new Asset_Version_History__c();
        AVH.Asset__c=assetId;
        AVH.Current_Version__c=version;
        AVH.Current_Build__c=build;
        AVH.Effective_Date__c=system.now();
        insert AVH;
        }
       

        
        Assets = new List<AssetWrapper>();
        for(Asset ast : [Select Id, Managed_Hosting__c, JDK_Version__c,Database__c,Database_Server_OS__c,Application_Server_OS__c,Version__c,Version_Build__c,Core_License__r.Name,Core_License__r.Product__c,Software_URL__c,Nickname__c,Name,Product2.Name from Asset where AccountId=:AcctId AND Status != 'Uninstalled' AND Core_License__c != NULL order by Name]) {
             boolean isadmin =true;
                System.debug('Ajith1 >>>>>>>>>>' + adminaccess+'--'+ast.id);  
                Assets.add(new AssetWrapper(ast.Id, ast.JDK_Version__c,ast.Database__c,ast.Database_Server_OS__c,ast.Application_Server_OS__c,ast.Version__c,ast.Version_Build__c,ast.Core_License__r.Name, ast.Software_URL__c,ast.Nickname__c,ast.Name, ast.Managed_Hosting__c, ast.Core_License__r.Name,isadmin,ast.Core_License__r.Product__c,adminaccess,ast.External_Asset_Name__c));
                     
        }
        
         
        System.debug('Ajith2 >>>>>>>>>>' + adminaccess);
        System.debug('In Bind EditAsset 2>>>>>>>>>> ' + ast1); 
        isEditMode = false;
        return null;
    }
    public PageReference CancelAsset() {
        assetId = null;
        //System.debug('In Bind CancelAsset >>>>>>>>>>' + asst);
        isEditMode = false;
        return null;
    }
    
   /* public List<selectOption> versions{
        get{
                List<selectOption> options = new List<selectOption>();
                System.debug(assetId);
                if (assetId != null) {
                    
                for (Asset a : [SELECT id, name, version__c FROM Asset a WHERE a.id =: assetId]){
                if(a.version__c!=null)
                    options.add(new SelectOption(a.version__c,a.version__c));
                    }
                  for (Version__c v : [SELECT Version__c FROM Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:assetId].Psft_Product_Id__c AND v.version__c != :[SELECT version__c FROM Asset WHERE id =: assetId].version__c ORDER BY Version__c DESC]){
                      if(v.version__c != null) 
                         options.add(new SelectOption(v.version__c,v.version__c));
                  }    
            }
            return options;
        }set;    
    }*/
    
    
    // new versions code
     public List<selectOption> versions {


        get {
            List<selectOption> options = new List<selectOption>();
            Set<String> ver = new Set<String>();
            if (assetId!= null) {

                for (Asset a : [SELECT id, name, version__c, Product2Id, Product2.GKEY_Product_Group__c FROM Asset a  Where a.id =: assetId]){
                   options.add(new selectoption('-Please Select-','-Please Select-'));

                    if(a.version__c!=null)
                        options.add(new SelectOption(a.version__c,a.version__c));
                        //ver.add(a.Version__c);
                }
                
                list<Asset> listAsset = [Select id, name, Product2.GKEY_Product_Group__c from Asset Where Id=:assetId];
                list<Version_Build_Tree__c > availversions;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversions = [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE Version__c != :[SELECT version__c FROM Asset WHERE id =: assetId].version__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Active_Flag__c = true ORDER BY Version__c DESC ];
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
                                if(((a[k]).isNumeric() && (b[k]).isNumeric() &&Integer.valueof(a[k])<integer.valueof(b [k]))||((a[k]).isAlpha() && (b[k]).isAlpha()&&a[k]<b[k]))
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
    
    
    
    // end versions code
    
    /*public List<selectOption> sblist{
        get{
            List<selectOption> options = new List<selectOption>();
            System.debug(version);
            if(version != null && assetID != null){
               for (Bb_Prod_Version__c v : [SELECT id, source_build__c FROM Bb_Prod_Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:assetId].Psft_Product_Id__c AND v.Version__c = :version ORDER BY Source_Build__c DESC]){           
                        if(v.source_build__c != null)
                           options.add(new SelectOption(v.source_build__c,v.source_build__c));
                }           
            }
            return options;
        }
        set;
    }*/
    public Pagereference clearsb(){
        build = '-Please Select-';
        return null;
    }
    // new source build code
     public List<selectOption> sblist{
        get{
            List<selectOption> options = new List<selectOption>();
            System.debug(version);
            if(assetID != null)
            {
              if(build=='-Please Select-')
              options.add(new SelectOption('-Please Select-','-Please Select-'));
              if(build != '-Please Select-' && build != null){
                    
                    options.add(new selectoption('-Please Select-','-Please Select-'));
                    for (Asset a : [SELECT version__c,Version_Build__c,Product2Id,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: assetID]) {
                        if(a.Version_Build__c != null) {
                            if(build == null || (build != null && build != a.Version_Build__c && build != '-Please Select-'))
                                build  = a.Version_Build__c;
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

                   list<Asset> listAsset = [Select id, name, Version__c, Version_Build__c, Product2.GKEY_Product_Group__c from Asset Where Id=: assetID];
                list<Version_Build_Tree__c > availversionbuilds;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversionbuilds = [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c v WHERE Version_Build__c!= :[SELECT Version_Build__c FROM Asset WHERE id =: assetID].Version_Build__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Version__c =: version AND version_build__c !=:build AND v.Active_Flag__c = true  ORDER BY Version_Build__c DESC];
                
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
            return options;
        }
        set;
    }
    
    // end source build code

    public boolean isDeveloper {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;                
                System.debug('Before .....' + u[0].ContactId );
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :gc.ContactId AND Contact__c!= NULL order by Role__c ASC]) {
                    System.debug('Inside .....' + contRole.Role__c);
                    if(null != contRole.Role__c && (contRole.Role__c.Contains('Developer'))) {
                        
                        isDeveloper = true;
                        break;
                    } else {
                        isDeveloper = false;  
                        //break; 
                    }
                }
               
            }         
            System.debug('isDeveloper >>>>>>>>>' +isDeveloper);
            return isDeveloper;
        }
        set { 
            if(value != null) isDeveloper = value;
        }
    }   
    
    public boolean isMLAAdmin {
                
        get {                   
                
            if(u != null && u.size() > 0) {
                Integer flag = 0;                
                for(Contact_Role__c contRole : [Select Account__c, Role__c, Id, Contact__c From Contact_Role__c where contact__c = :gc.ContactId AND Contact__c!= NULL order by Role__c Asc]) {
                    if(null != contRole.Role__c && (contRole.Role__c.Contains('MLA') && contRole.Role__c.Contains('Admin'))) {
                        
                        isMLAAdmin = true;                      
                    } else {
                        isMLAAdmin = false;  
                        break; 
                    }
                }
            }         
            System.debug('isMLAAdmin >>>>>>>>>' +isMLAAdmin);
            return isMLAAdmin;
        }
        set { 
            if(value != null) isMLAAdmin = value;
        }
    } 
    
   
    public PageReference Redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else if(System.currentPageReference().getParameters().get('cid') == null || System.currentPageReference().getParameters().get('cid') == '' || System.currentPageReference().getParameters().get('cid') != gc.ContactId) {
           PageReference pageRedirect = new PageReference('/btbb_myinstitution?cid='+gc.ContactId);
            pageRedirect.setRedirect(true);
            return pageRedirect ;
        }
        else 
            return null;
    }  
}