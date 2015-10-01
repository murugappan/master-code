public with sharing class SupportIncidentChangeDetailsController 
{
        public learnJIRA__c supportIncident {get; set;}
        public String selectedBrokenVersion {get; set;}
        public String selectedTargetVersion {get; set;}
        public String selectedFixedVersion {get; set;}
        public String selectedBrokenBuild {get; set;}
        public String selectedTargetBuild {get; set;}
        public String statusvalue{get;set;}
        public String resolutionvalue{get;set;}
        public String onholdreasonvalue{get;set;}
        public String selectedFixedBuild {get; set;}
        public list<SelectOption> versionList {get; set;}
        public list<SelectOption> buildList {get; set;}
        public Boolean hasErrors {get; set;}
        private Case caseObj;
        private String theId;
        public Boolean isMoodle{get;set;}
        public Boolean isAnalytics{get;set;}
        public string version {get;set;}
        public string sourcebuild {get; set;}
        public string asset {get;set;}
        public id AssetId {get; set;}

        public string module {get;set;}
        public string functionalarea {get;set;}

        public list<Module__c> Mod {get;set;}
        public list<Functional_Area__c> Func {get;set;}

        map <id,string> issuetopicmap= new map<id,string>();
        map <id,string> functionalareamap= new map<id,string>();
        
        map<id,Schema.RecordTypeInfo> SIrecodtypemap{
        get{
            return Schema.SObjectType.learnJIRA__c.getRecordTypeInfosById();        
           }
        }
        
        public SupportIncidentChangeDetailsController(ApexPages.StandardController stdController)
        {
                hasErrors = false;
                isMoodle = false;
                isAnalytics = false;
                theId = ApexPages.currentPage().getParameters().get('id');
                if (theId == null)
                {
                        theId = stdController.getId();
                }
                loadSupportIncident();
                if(supportIncident != null)
                {
                  module = supportIncident.Issue_Topic_Id__c;
                  functionalarea = supportIncident.Functional_Area_Id__c;
                }

                loadCase();
                if(CaseObj != null)
                {
                  asset = caseObj.AssetId;   
                }
               
                /* if(CaseObj != null && caseObj.Core_License__r.Name=='Moodlerooms')
                {
                   isMoodle=true;
                } 
                else if(CaseObj != null && caseObj.Core_License__r.Name=='Analytics')
                {
                   isAnalytics=true; 
                }*/
                
                if(SIrecodtypemap.get(supportIncident.recordtypeid).getname().containsIgnoreCase('Moodlerooms'))
                {
                   isMoodle=true;
                }
                if(SIrecodtypemap.get(supportIncident.recordtypeid).getname().containsIgnoreCase('Analytics'))
                {
                   isAnalytics=true;
                }
                
                
                if(CaseObj != null)
                {
                 if(supportIncident.Issue_Topic_Id__c == null)
                 {
                   module = caseObj.Module__c;
                   functionalarea = caseObj.Functional_Area__c;
                  }
                } 
      
                loadVersions();
                loadPicklists();
                statusvalue = supportIncident.Status__c;
                resolutionvalue = supportIncident.Resolution__c;
                onholdreasonvalue = supportIncident.On_Hold_Reason__c;
                selectedBrokenBuild = supportIncident.Broken_In_Build__c;
                selectedTargetBuild = supportIncident.Target_Build__c;
                selectedFixedBuild = supportIncident.Fixed_In_Build__c;
                version = supportIncident.ERP_Platform__c;
                sourcebuild = supportIncident.Reported_In_Version__c;
                //Added for Analytics
               
           }
        
        
        
      private void loadSupportIncident()
        {
                try
                {
                        supportIncident = [Select Id, Name, Type__c, OwnerId, Duplicate_Of__c,On_Hold_Reason__c,Resolution__c,Reviewed__c, Reviewer__c, Status__c, Severity__c, Affects_Version__c,
                                                                          Module__c,Reported_In_Version__c,Functional_Area__c, JIRA_URL__c,Summary__c, External_URL__c,Module_moodlerooms__c, Source__c, Reported_By__c, Reproduced__c, Regression__c, Has_Workaround__c,
                                                                          Broken_In_Version__c,Steps_to_Replicate__c,System_Information_HTML__c,Description_HTML__c,Tier_2_Assessment__c,Client_Information_HTML__c, Workaround_HTML__c, Broken_In_Build__c, Target_Version__c, Target_Build__c, Fixed_In_Version__c, Fixed_In_Build__c,
                                                                          OriginCaseID__c,Original_Reported_Core_Version__c,Release_Type__c,Product_ID__c,Hosting_Type__c,ERP_Platform__c,Issue_Topic_Id__c,Functional_Area_Id__c,recordtypeid
                                                           From learnJIRA__c 
                                                           Where Id =: theId];
                }
                catch (Queryexception qe)
                {
                        supportIncident = new learnJIRA__c();
                        ApexPages.addMessages(qe);
                }
        }
        
        public pagereference s(){

        if(statusvalue == 'Closed' && string.isBlank(resolutionvalue)){
            
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Resolution is required for Closed status!.');

                ApexPages.addmessage(myMsg);

                return null;
                //ApexPages.addMessages(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Resolution is required for Closed status!.'));
         }
         if(statusvalue == 'On Hold' && onholdreasonvalue == '-None-')
         {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Select a valid On Hold Reason');

                ApexPages.addmessage(myMsg);

                return null;

         }
        
        
        supportIncident.Status__c = statusvalue;
        supportIncident.On_Hold_Reason__c = onholdreasonvalue;
        supportIncident.Resolution__c = resolutionvalue;
        
        supportIncident.Broken_In_Version__c = selectedBrokenVersion; 
        supportIncident.Target_Version__c = selectedTargetVersion;
        supportIncident.Fixed_In_Version__c = selectedFixedVersion;
        supportIncident.Broken_In_Build__c = selectedBrokenBuild;
        supportIncident.Target_Build__c = selectedTargetBuild;
        supportIncident.Fixed_In_Build__c =selectedFixedBuild;

        supportIncident.ERP_Platform__c = version;
        supportIncident.Reported_In_Version__c = sourcebuild;

       /*supportIncident.Module__c = issuetopicmap.get(module);
        supportIncident.Functional_Area__c = functionalareamap.get(functionalarea); */

        Mod = [Select id,Name from Module__c where id =:module];
            if(Mod!= null && Mod.size()>0)
            {
              supportIncident.Module__c = Mod[0].Name;
              supportIncident.Issue_Topic_Id__c = Mod[0].Id;
            }
            else
            {
              supportIncident.Module__c = '';
              supportIncident.Issue_Topic_Id__c = '';
            }

        Func = [Select id,Name from Functional_Area__c where id =:functionalarea];
            if(Func != null && func.size()>0)
            {
              supportIncident.Functional_Area__c = Func[0].name;
              supportIncident.Functional_Area_Id__c = Func[0].Id;
            }
           else
            {
              supportIncident.Functional_Area__c = '';
              supportIncident.Functional_Area_Id__c = '';
            } 


        update supportIncident;
        PageReference pageRef = new PageReference('/' + supportIncident.id);                
        pageRef.setRedirect(true);        
        return pageRef;        
       // return null;
       
        }
        
        private void loadCase()
        {
                try
                {
                        caseObj = [Select Id, CaseNumber, AssetId, Asset.Version__c, Asset.Version_Build__c, Asset.Psft_Product_Id__c, Core_License__c,Asset.Core_License__c,Core_License__r.Name,Source_Build_on_Case__c,Version_on_Case__c,Module__c,Functional_Area__c
                                           From Case 
                                           Where Id =: supportIncident.OriginCaseID__c];
                }
                catch (Queryexception qe) {}
        }
        
  /*      public list<SelectOption> issueTopicList
        {
                get
                {
                        list<SelectOption> optionList = new list<SelectOption>();
                        
                        return optionList;
                } set;
        }   */
/*--------------------------------- MODULE SELECT LIST ---------------------------------*/

    public list<selectOption> moduleList 
    {
        get 
        {  
            list<SelectOption> options = new list<SelectOption>();
 
            if (caseObj != null && caseObj.AssetId != null)
            {
                options.add(new SelectOption('','-- Choose an Issue Topic --',true));
                
                for (Module__c m : [Select Id, Name 
                                                        FROM Module__c 
                                                        WHERE Core_Licence__c =: caseObj.Asset.Core_License__c 
                                                        order by Name])
                {
                    options.add(new SelectOption(m.Id, m.Name));
                    issuetopicmap.put(m.Id, m.Name); 
                }
            }
            return options;           
        }
        set;
    }
     /*--------------------------------- FUNCTIONAL AREAS SELECT LIST ---------------------------------*/

    public List<selectOption> functionalareas {
        get {

            List<selectOption> options = new List<selectOption>();

            if (module != NULL) {
                options.add(new SelectOption('','-- Choose a Functional Area --'));
                for (Functional_Area__c fa : [select Id, Name,Module__c  from Functional_Area__c Where Module__c = :module AND Module__c !=null Order By Name])
                {
                    options.add(new SelectOption(fa.Id,fa.Name));
                    functionalareamap.put(fa.Id,fa.Name);
                }
            }
            
            return options;           
        }
        set;
    }  
        
        private void loadVersions()
        {
                versionList = new list<SelectOption>();
                versionList.add(new SelectOption('-None-','-None-'));
                
        if (caseObj != null)
        {          
            for (Version__c v : [SELECT Id, Version__c 
                                                 FROM Version__c 
                                                 WHERE Psft_Product_Id__c =: caseObj.Asset.Psft_Product_Id__c 
                                                 order by Version__c desc])
            {
                if (v.Version__c != null)
                {
                        versionList.add(new SelectOption(v.Version__c, v.Version__c));
                }
                }
        }
        else
        {
                for (Version__c v : [Select Id, Version__c 
                                                 From Version__c 
                                                 order by Version__c desc])
            {
                if (v.Version__c != null)
                {
                        versionList.add(new SelectOption(v.Version__c, v.Version__c));
                }
                }
        }   
        }   
    
  
    public list<SelectOption> brokenBuildList
        {   
        get 
        {
            list<SelectOption> options = new list<selectOption>();
            
                options.add(new SelectOption('-None-','-None-'));
                for (MoodleroomsBuild__c v : [SELECT id, Name, Sort_Order__c
                                                                         FROM MoodleroomsBuild__c v ORDER By Sort_Order__c DESC])
                {           
                if (v.Name != null)
                options.add(new SelectOption(v.Name, v.Name));
            }           

            return options;
        }
        set;
    } 
    
    
    
    public list<SelectOption> targetBuildList
        {   
        get 
        {
            list<SelectOption> options = new list<selectOption>();
            
                options.add(new SelectOption('-None-','-None-'));
                for (MoodleroomsBuild__c v : [SELECT id, Name,Sort_Order__c 
                                                                         FROM MoodleroomsBuild__c v ORDER By Sort_Order__c DESC])
                {           
                if (v.Name != null)
                options.add(new SelectOption(v.Name, v.Name));
            }           

            return options;
        }
        set;
    }
    
    public list<SelectOption> fixedBuildList
        {   
        get 
        {
            list<SelectOption> options = new list<selectOption>();
            
                options.add(new SelectOption('-None-','-None-'));
                for (MoodleroomsBuild__c v : [SELECT id, Name, Sort_Order__c 
                                                                         FROM MoodleroomsBuild__c v ORDER By Sort_Order__c DESC])
                {           
                if (v.Name != null)
                options.add(new SelectOption(v.Name, v.Name));
            }           

            return options;
        }
        set;
    }
    
    private void loadPicklists()
    {
        
        if (supportIncident.Broken_In_Version__c != null || supportIncident.Broken_In_Version__c != '')
                {
                        selectedBrokenVersion = supportIncident.Broken_In_Version__c;
                }
                else if (caseObj != null)
                {
                        selectedBrokenVersion = caseObj.Asset.Version__c;
                }
                if (supportIncident.Target_Version__c != null || supportIncident.Target_Version__c != '')
                {
                        selectedTargetVersion = supportIncident.Target_Version__c;
                }
                else if (caseObj != null)
                {
                        selectedTargetVersion = caseObj.Asset.Version__c;
                }
                if (supportIncident.Fixed_In_Version__c != null || supportIncident.Fixed_In_Version__c != '')
                {
                        selectedFixedVersion = supportIncident.Fixed_In_Version__c;
                }
                else if (caseObj != null)
                {
                        selectedFixedVersion = caseObj.Asset.Version__c;
                }
    }
      // versions code
      public List<selectOption> versions {
        get{
                
                List<selectOption> options = new List<selectOption>();
                String v1;
                if (asset != null) {
                
                 
                    for (Asset a : [SELECT version__c,Product2.GKEY_Product_Group__c  FROM Asset a WHERE a.id =: asset limit 1] ) {
                        
                           set<string> versionset= new set<string>(); 
                           for (Version_Build_Tree__c v : [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE  GKEY_Product_Group__c =: a.Product2.GKEY_Product_Group__c AND Active_Flag__c = true  ORDER BY Version__c ]){
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
    // end of versions code

   //------------------------- CLEAR SOURCE BUILD ADD '-Please Select-' --------------- 
    
    public Pagereference clearsb(){
       
        sourcebuild = '-Please Select-';
        return null;
    }

   // source build code
    public List<selectOption> sblist{
        
        get {
            
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            Set<String> tmp = new Set<String>();
            if(asset != null) {
                    
        for (Asset a : [SELECT version__c,Version_Build__c,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: asset limit 1]) {
                      
               for (Version_Build_Tree__c v : [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c WHERE GKEY_Product_Group__c =:a.Product2.GKEY_Product_Group__c AND Version__c =:version AND Active_Flag__c =true ORDER BY Version_Build__c DESC]){           
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
              
            return options;
        }
        set;
    }
    // end source build code  

}