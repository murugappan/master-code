public without sharing class EditSIforCollab{


public string version {get;set;}
public string sourcebuild {get; set;}
public string asset {get; set;}
public id AssetId {get; set;}
public Case caseObj {get; set;}
public string jirasourcebuild{get;set;}
public string module {get; set;}
public string functionalarea {get; set;}
public string category {get; set;}
public list<Category__c> cate {get;set;}
public list<Functional_Area__c> func {get;set;}
public list<Module__c> modu {get;set;}
public string statusvalue {get;set;}
public string resolutionvalue {get;set;}
public string onholdreasonvalue {get;set;}




//////
public learnJIRA__c supportIncident {get; set;}
private String theId;   
    
public EditSIforCollab(ApexPages.StandardController controller) {
theId = ApexPages.currentPage().getParameters().get('id');
if (theId == null)
                {
                        theId = controller.getId();
                }
                
        loadSupportIncident();
        if(supportIncident != null){
                jirasourcebuild = supportIncident.Reported_In_Version__c;
                module = supportIncident.Issue_Topic_Id__c;
                functionalarea = supportIncident.Functional_Area_Id__c;
                category = supportIncident.Category_Id__c;
                
                
                
                
                statusvalue =  supportIncident.Status__c ;
                resolutionvalue = supportIncident.Resolution__c;
                onholdreasonvalue = supportIncident.On_Hold_Reason__c;
                
                
                
               }
        loadCase();
        if(caseObj != null ){
            //jirasourcebuild = caseObj.Source_Build_on_Case__c;
            version = caseObj.Version_on_Case__c;
            asset = caseObj.AssetId;
            if(supportIncident.Issue_Topic_Id__c == null)
            {
            module = caseObj.Module__c;
            functionalarea = caseObj.Functional_Area__c;
            category = caseObj.Category__c;
            }
        }
        
        
                 
 /*supportIncident = [Select Id, Name, Type__c, OwnerId, Duplicate_Of__c,Product_ID__c,Do_Not_Publish__c,Business_Reasons_HTML__c,Additional_Justification_HTML__c ,Patch_Request_Comments__c,Patch_Requested__c,Secutity_Issue__c,Category__c ,Access_Information_HTML__c,On_Hold_Reason__c,Priority__c,Resolution__c,Reviewed__c, Reviewer__c, Status__c, Severity__c, Affects_Version__c,
                                                                          Module__c,Reported_In_Version__c,Functional_Area__c,Steps_to_Replicate_HTML__c, JIRA_URL__c,Summary__c, External_URL__c,Module_moodlerooms__c, Source__c, Reported_By__c, Reproduced__c, Regression__c, Has_Workaround__c,
                                                                          Broken_In_Version__c,Functional_Area_Id__c ,Issue_Topic_Id__c ,Category_Id__c,  Steps_to_Replicate__c,System_Information_HTML__c,Description_HTML__c,Tier_2_Assessment__c,Client_Information_HTML__c, Workaround_HTML__c, Broken_In_Build__c, Target_Version__c, Target_Build__c, Fixed_In_Version__c, Fixed_In_Build__c,
                                                                          OriginCaseID__c
                                                           From learnJIRA__c 
                                                           Where Id =: theId];
     module = supportIncident.Issue_Topic_Id__c;
                functionalarea = supportIncident.Functional_Area_Id__c;
                category = supportIncident.Category_Id__c;        */                                               
                                                                          
  /*              loadSupportIncident();
                if(supportIncident != null){
                jirasourcebuild = supportIncident.Reported_In_Version__c;
                module = supportIncident.Module__c;
                functionalarea = supportIncident.Functional_Area__c;
                category = supportIncident.Category__c;
               }
                
                
                
        loadCase();
        if(caseObj != null){
            //jirasourcebuild = caseObj.Source_Build_on_Case__c;
            version = caseObj.Version_on_Case__c;
            asset = caseObj.AssetId;
            module = caseObj.Module__c;
            functionalarea = caseObj.Functional_Area__c;
            category = caseObj.Category__c;
        }
        
        loadSupportIncident();
                if(supportIncident != null){
                jirasourcebuild = supportIncident.Reported_In_Version__c;
                module = supportIncident.Module__c;
                functionalarea = supportIncident.Functional_Area__c;
                category = supportIncident.Category__c;
               }
                
        
        */
        

}

  private void loadSupportIncident()
        {
                try
                {
                        supportIncident = [Select Id, Name, OwnerId, Do_Not_Publish__c,Business_Reasons_HTML__c,Resolution__c,Additional_Justification_HTML__c ,Patch_Request_Comments__c,Patch_Requested__c, External_URL__c,Secutity_Issue__c,Category__c ,Access_Information_HTML__c,On_Hold_Reason__c,Priority__c,Status__c, Severity__c, 
                                                                          Module__c,Reported_In_Version__c,JIRA_Key__c,Product_ID__c ,Functional_Area__c,Steps_to_Replicate_HTML__c, Summary__c,Duplicate_Of__c,Has_Workaround__c,
                                                                          Functional_Area_Id__c ,Issue_Topic_Id__c ,Category_Id__c, End_User_Product_Suite__c,  Steps_to_Replicate__c,System_Information_HTML__c,Description_HTML__c,Tier_2_Assessment__c,Client_Information_HTML__c, Workaround_HTML__c, 
                                                                          OriginCaseID__c,Product_Suite__c
                                                           From learnJIRA__c 
                                                           Where Id =: theId];
                }
                catch (Queryexception qe)
                {
                        supportIncident = new learnJIRA__c();
                        ApexPages.addMessages(qe);
                }
        }



   private void loadcase()
    {
        try
        {
            caseObj = [Select Id, CaseNumber, Subject, A2__c, Description, Case.Asset.Name, Case.Asset.Core_License__r.Name, Case.Asset.Version_Build__c, Case.Asset.Front_Back_Access__c, 
                              Case_Severity__c, Priority, Module__r.Name , Functional_Area__r.Name,JIRA_Source_Build__c,Version_on_Case__c, Category__r.Name, Case.Contact.Name, Case.Contact.Phone, Case.Account.Name,
                              Case_Specific_Access__c, Source_Build_on_Case__c, Core_License__c, Core_License__r.Name
                       From Case 
                       Where Id =:supportincident.OriginCaseID__c];
        }
        catch (Exception e) 
        {
            caseObj = new Case();
        }
    } 

public pagereference s(){
             
        try{
            
            supportIncident.Reported_In_Version__c = jirasourcebuild;
            
            
            modu = [Select id,Name from Module__c where id =:module];
            if(modu!= null&&modu.size()>0){
          
            supportIncident.Module__c = modu[0].Name;
            supportIncident.Issue_Topic_Id__c = modu[0].Id;
            }
           else{
           supportIncident.Module__c = '';
            supportIncident.Issue_Topic_Id__c = '';
           }
            
            
            //supportIncident.Module__c = module;
            
            func = [Select id,Name from Functional_Area__c where id =:functionalarea];
            if(func != null&&func.size()>0){
         //   Functional_Area__c fa = func.get(i);
            supportIncident.Functional_Area__c = func[0].name;
            supportIncident.Functional_Area_Id__c = func[0].Id;
            }
           else{
           supportIncident.Functional_Area__c = '';
            supportIncident.Functional_Area_Id__c = '';
           } 
            
            
            //supportIncident.Functional_Area__c = functionalarea;
            
            cate = [Select id,Name from Category__c where id =:category];
            if(cate != null && cate.size()>0){
         //   for(integer i = 0; i< cate.size(); i++){
         //   Category__c ca = cate.get(i);
            supportIncident.Category__c = cate[0].Name;
            supportIncident.Category_Id__c = cate[0].Id;
            }
            else
            {
            supportIncident.Category__c = '';
            supportIncident.Category_Id__c = '';
            }
     //       }
            
            supportIncident.Status__c = statusvalue;
            supportIncident.Resolution__c = resolutionvalue;
            
            //if(statusvalue == 'On Hold' && (onholdreasonvalue == null || onholdreasonvalue == '-None-') ){
                
              //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter On Hold Reason Value');
              //ApexPages.addMessage(myMsg);
            
            //}
            //else{
            supportIncident.On_Hold_Reason__c = onholdreasonvalue;
            //}
            
            //supportIncident.Category__c = category;
            update supportIncident;
            
        }
        catch(Exception e){
            ApexPages.addmessages(e);
            return null;
        }
        PageReference pageRef = new PageReference('/' + theId);                
        pageRef.setRedirect(true);        
        return pageRef;        
        
        }












public List<selectOption> sblist{
        
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
    } 
/////-------------------------------------

/*--------------------------------- MODULE SELECT LIST ---------------------------------*/


    public List<selectOption> modules {
        get {
            //errorShow = false;
            List<selectOption> options = new List<selectOption>();

            if (asset != null) {
                options.add(new SelectOption('','-- Choose an Issue Topic --',true));
                for (Module__c m : [select id, name FROM Module__c m WHERE m.core_licence__c = : [select core_license__c from asset where id =:asset].core_license__c AND m.core_licence__c !=null order by name] )
                    options.add(new SelectOption(m.Id,m.Name));
            }

            return options;           
        }
        set;
    }   

    /*--------------------------------- FUNCTIONAL AREAS SELECT LIST ---------------------------------*/

    public List<selectOption> functionalareas {
        get {
            //errorShow = false;
            List<selectOption> options = new List<selectOption>();

            if (module != NULL) {
                options.add(new SelectOption('','-- Choose a Functional Area --'));
                for (Functional_Area__c fa : [select Id, Name,Module__c  from Functional_Area__c Where Module__c = :module AND Module__c !=null Order By Name])
                    options.add(new SelectOption(fa.Id,fa.Name));
            }
            
            return options;           
        }
        set;
    }  

    /*--------------------------------- CATEGORIES SELECT LIST ---------------------------------*/

    public List<selectOption> categories {
        get {
            //errorShow = false;
            List<selectOption> options = new List<selectOption>();

                options.add(new SelectOption('','-- Choose a Category --'));
            if (functionalarea != NULL) {
                for (Category__c cat : [select Id, Name,Functional_Area__c  from Category__c Where Functional_Area__c = :functionalarea Order By Name])
                    options.add(new SelectOption(cat.Id,cat.Name));
            }
                       
            return options;
            
          
                   
        }
        set;
    }     
//////////////////////////




}