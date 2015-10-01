public class CreateSupportIncidentController 
{

  

    public string version {get;set;}
    public string sourcebuild {get; set;}
    public string asset {get; set;}
    public id AssetId {get; set;}
    public boolean isCollab {get;set;}
    public boolean isMoodle {get;set;}
    public boolean isAnalytics{get;set;}
    //------------------------
    public learnJIRA__c supportIncident {get; set;}
    public String originCaseId {get; set;}
    public Boolean hasError {get; set;}
    public Case caseObj {get; set;}
    
    public string jirasourcebuild{get;set;}
    private String supportIncidentPrefix = learnJIRA__c.sObjectType.getDescribe().getKeyPrefix();
    private map<String, RecordType> recordTypeNameMap;
    
    // Analytics code
    public string Issuetopic {get;set;}
    public string Functionalarea {get;set;}
    public string Hostingtype {get;set;}
    
    public CreateSupportIncidentController(ApexPages.StandardController controller) 
    {
        hasError = false;
        isMoodle=false;
        isAnalytics=false;
        supportIncident = new learnJIRA__c();
        loadCase();
        if(caseObj != null){
            jirasourcebuild = caseObj.Source_Build_on_Case__c;
            version = caseObj.Version_on_Case__c;
            asset = caseObj.AssetId;
            Issuetopic = caseObj.Module__r.Name ;
            Functionalarea = caseObj.Functional_Area__r.Name;
            Hostingtype = caseObj.Managed_Hosting__c;
        }
        
        if(caseObj.Core_License__r.Name=='Moodlerooms')
        {
            supportIncident = new learnJIRA__c(recordtypeid=learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId());
            isMoodle=true;
        }
        else if(caseObj.Core_License__r.Name=='Analytics')
        {
            supportIncident = new learnJIRA__c(recordtypeid=learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Analytics').getRecordTypeId());
            isAnalytics=true;
        }
        else if(caseObj.Core_License__r.Name == null || caseObj.Core_License__r.Name == '')
        {
            supportIncident = new learnJIRA__c(recordtypeid=learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Collaborate').getRecordTypeId());
            isCollab = true;
        }
        else if(caseObj.Core_License__r.Name.contains('Collaborate'))
        {
            supportIncident = new learnJIRA__c(recordtypeid=learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Collaborate').getRecordTypeId());
            isCollab = true;
        }

        else 
        {
            supportIncident = new learnJIRA__c(recordtypeid=learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Learn').getRecordTypeId());
        }
        system.debug('Ajithhhh' +caseObj.Core_License__r.name);
        
        loadRecordTypes();
    }
    
    private void loadcase()
    {
        try
        {
            caseObj = [Select Id, CaseNumber, Subject, A2__c, Description, Case.Asset.Name, Case.Asset.Core_License__r.Name, End_User_Product__c, Case.Asset.Version_Build__c, Case.Asset.Front_Back_Access__c, Case.Owner.Name, 
                              Case_Severity__c, Priority, Module__r.Name , Functional_Area__r.Name,JIRA_Source_Build__c,Version_on_Case__c, Category__r.Name, Case.Contact.Name, Case.Contact.Phone, Case.Account.Name,
                              Case_Specific_Access__c, Source_Build_on_Case__c, Core_License__c, Core_License__r.Name,Managed_Hosting__c,Product_Suite__c,Steps_To_Replicate__c
                       From Case 
                       Where Id =: ApexPages.currentPage().getParameters().get('cid')];
            
        }
        
        
        catch (Exception e) 
        {
            caseObj = new Case();
        }
    }
    
    private void loadRecordTypes()
    {
        recordTypeNameMap = new map<String, RecordType>();
        
        for (RecordType rt : [Select Id, Name From RecordType Where SObjectType = 'learnJIRA__c'])
        {
            recordTypeNameMap.put(rt.Name, rt);
        }
    }
    
    
    public void setBType()
    {
    system.debug('GGGGG'+ supportIncident.Business_Unit__c );
    if(supportIncident.Business_Unit__c == 'Moodlerooms')
        {
         supportIncident.recordtypeId  = learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
         
         }
   else if(supportIncident.Business_Unit__c =='Collaborate')
        {
           supportIncident.recordtypeId  = learnJIRA__c.sObjectType.getDescribe().getRecordTypeInfosByName().get('Collaborate').getRecordTypeId();
        }
      
         
           
    }
    
    public pageReference doSave()
    {
        PageReference pageRef;
        
        if (caseObj.Id != null)
        {
            supportIncident.Name = 'SI-' + caseObj.CaseNumber;
            supportIncident.Client_Information_HTML__c = 'Account Name: ' + caseObj.Account.Name + '<br />Contact Name: ' + caseObj.Contact.Name + '<br />Phone: ' + caseObj.Contact.Phone;
            supportIncident.Client_Information__c = 'Account Name: ' + caseObj.Account.Name + ' // Contact Name: ' + caseObj.Contact.Name + ' // Phone: ' + caseObj.Contact.Phone;
            supportIncident.Module__c = Issuetopic;
            supportIncident.Functional_Area__c = Functionalarea;
            supportIncident.Category__c = caseObj.Category__r.Name;
            supportIncident.OriginCaseId__c = OriginCaseId;
            supportIncident.System_Information__c = caseObj.Asset.Name;
            supportIncident.System_Information_HTML__c = caseObj.Asset.Name;
            // Removed because of line below supportIncident.Reported_In_Version__c = caseObj.Source_Build_on_Case__c;
            supportIncident.Product_Id__c = caseObj.Asset.Core_License__r.name;
            supportIncident.Access_Information__c = caseObj.Asset.Front_Back_Access__c;
            supportIncident.Access_Information_HTML__c = caseObj.Asset.Front_Back_Access__c;
            supportIncident.Core_License__c = caseObj.Core_License__r.Name;
            supportIncident.Product_Suite__c =caseObj.Product_Suite__c;
            //supportIncident.End_User_Product_Suite__c = caseObj.End_User_Product__c;
            supportIncident.Assign_To_Tier_3__c = true;
            supportIncident.Priority__c = caseObj.Priority;
            supportIncident.Severity__c = caseObj.Case_Severity__c;
            if(caseObj.Case_Severity__c == '5' || caseObj.Case_Severity__c == '6'){
            supportIncident.Severity__c = '4';
            }
            if(caseObj.Core_License__r.Name.contains('Learn'))
            {
              supportIncident.Steps_to_Replicate__c = caseObj.A2__c;
            }
            supportIncident.Reported_By__c = UserInfo.getUserId();
            supportIncident.Steps_to_Replicate_HTML__c = caseObj.Steps_To_Replicate__c;
            supportIncident.Origin_Case_Number__c = caseObj.CaseNumber;
            //supportIncident.isChanged__c = true;
            supportIncident.OriginCaseId__c = caseObj.id;
            supportIncident.Description_HTML__c = supportIncident.Private_Description__c;
            supportIncident.Case_Specific_Access__c = caseObj.Case_Specific_Access__c;
            supportIncident.Reported_In_Version__c = jirasourcebuild;
            supportIncident.Hosting_Type__c = Hostingtype;
            supportIncident.ERP_Platform__c = version;
            if (recordTypeNameMap.containsKey(caseObj.Core_License__r.Name))
            {
                supportIncident.RecordTypeId = recordTypeNameMap.get(caseObj.Core_License__r.Name).Id;
                system.debug('Alagappan' + supportIncident.RecordTypeId + '' + learnJira__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Learn').getRecordTypeId()  );
                if(supportIncident.RecordTypeId == learnJira__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Learn').getRecordTypeId()){
                    supportIncident.isChanged__c = true;
                }
            }
            
            if(caseObj.Core_License__r.Name.contains('Collaborate')){
            
                supportIncident.Status__c = 'Open';
                supportIncident.Initial_SI_Owner__c = caseObj.Owner.Name;
                
                User CurrenUser =[select id,Primary_Group__c from User where id =:Userinfo.GetUserId()];
                supportIncident.Primary_Group__c = CurrenUser.Primary_Group__c; 
                
            
            }
            
        }
        else
        {
            supportIncident.Name = supportIncident.StandAlone_SI__c;
        }
        
        try
        {
            insert supportIncident;
            
        if (caseObj.Id == null)
        {
            learnJIRA__c SISA=[select id,name,StandAlone_SI__c from learnJIRA__c where id=:supportIncident.id] ;
            if(SISA.id==SISA.name)
            {
                SISA.name=SISA.StandAlone_SI__c;
                SISA.Reported_By__c = UserInfo.getUserId();
                update SISA;
            }
         }   
            if (caseObj != null && caseObj.Id != null)
            {
                try
                {
                    Case_Support_Incident__c csi = new Case_Support_Incident__c(Case__c = caseObj.Id, Support_Incident__c = supportIncident.Id, Active__c = true);
                    insert csi;
                    pageRef = Page.ManageSIOnCase;
                    pageRef.getParameters().put('id', caseObj.Id);
                    pageRef.setRedirect(true);
                }
                catch (Exception e)
                {
                    ApexPages.addMessages(e); 
                }
            }
            else
            {
                pageRef = new PageReference('/' + supportIncident.Id).setRedirect(true);
            }
        }
        catch(Exception ex)  
        {  
            ApexPages.addMessages(ex); 
        }
        
        return pageRef;
    }
    
    public PageReference doCancel()
    {
        PageReference pageRef;
        
        if (caseObj != null)
        {
            pageRef = Page.ManageSIOnCase;
            pageRef.getParameters().put('id', caseObj.Id);
        }
        else
        {
            pageRef = new PageReference('/' + supportIncidentPrefix);
        }
        
        pageRef.setRedirect(true);
        return pageRef;
    }
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

   //------------------------- CLEAR SOURCE BUILD ADD '-Please Select-' --------------- 
    
    public Pagereference clearsb(){
        
        sourcebuild = '-Please Select-';
        return null;
    }


   //------------------------- SOURCE BUILD SELECT LIST -------------------------------     
     /*  public List<selectOption> sblist{
        
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
                    
                    if((options[i].getValue().countmatches('.')==3)&&(options[y].getValue().countmatches('.')==3))
                    {       
                    string a=options[i].getValue().split('[a-zA-Z]',0)[0].split('[.]',-1)[2]+'.'+options[i].getValue().split('[a-zA-Z]',0)[0].split('[.]',-1)[3];
                    string b=options[y].getValue().split('[a-zA-Z]',0)[0].split('[.]',-1)[2]+'.'+options[y].getValue().split('[a-zA-Z]',0)[0].split('[.]',-1)[3];
                    if(Decimal.valueof(a)<Decimal.valueof(b))
                    {
                        selectoption temp;
                        temp=options[i];
                        options[i]=options[y];
                        options[y]=temp;
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
    
    // new source build code
    /*public List<selectOption> sblist{

        get {

            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            String defaultVersion;
            String defaultVersionBuild;
        
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
             
             
             // We need Asset to get Product2 to get the GKEY Product Group
             list<Asset> listAsset = [Select id, name, Version__c, Version_Build__c, Product2.GKEY_Product_Group__c from Asset Where Id=: asset ];
                list<Version_Build_Tree__c > availversionbuilds;
                if(listAsset.size() > 0){
                Asset pickedAsset = listAsset[0];
                availversionbuilds = [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c v WHERE Version_Build__c!= :[SELECT Version_Build__c FROM Asset WHERE id =: asset].Version_Build__c AND GKEY_Product_Group__c =: pickedAsset.Product2.GKEY_Product_Group__c AND Version__c =: version AND version_build__c !=:sourcebuild  ORDER BY Version_Build__c DESC];
                
                }
                
                map<String, String> distinctVersionBuilds = new map<String, String>();
                for(Version_Build_Tree__c eachVersionBuild : availversionbuilds){
                distinctVersionBuilds.put(eachVersionBuild.Version_Build__c ,eachVersionBuild.Version_Build__c );
                
                
                }
                
                for(String eachDistinctVersionBuild: distinctVersionBuilds.keySet() ){
                options.add(new SelectOption(eachDistinctVersionBuild,eachDistinctVersionBuild));
                 sourcebuild=  eachDistinctVersionBuild;                          
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
    public List<selectOption> sblist{
        
        get {
            system.debug('Sb++');
            if(caseObj.Version_On_Case__c!=version)
            sourcebuild='-None-';
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            Set<String> tmp = new Set<String>();
            if(asset != null) {
                if(sourcebuild == '-None-')
                    options.add(new SelectOption('-None-','-None-'));
                for (Asset a : [SELECT version__c,Version_Build__c,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: asset limit 1]) {
                       if(a.Version_Build__c != null) {
                         if(sourcebuild == null || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-None-'))
                            sourcebuild  = a.Version_Build__c;
                         options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));
                         tmp.add(a.Version_Build__c); 
                      }
                       system.debug('sb--'+sourcebuild+'ver--_'+version);
               for (Version_Build_Tree__c v : [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c WHERE Version_Build__c!= :a.Version_Build__c AND GKEY_Product_Group__c =:a.Product2.GKEY_Product_Group__c AND Version__c =:version AND version_build__c !=:sourcebuild AND Active_Flag__c =true ORDER BY Version_Build__c DESC]){           
                    if(v.Version_Build__c != null)
                    options.add(new SelectOption(v.Version_Build__c,v.Version_Build__c));
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
              system.debug('OPTIONS' +options);
            return options;
        }
        set;
    }
    // end source build code 
    
    

     
}