public with sharing class BBW_AssetVersionUpdate {
    
    public string version {get; set;}
    public string sourcebuild {get; set;}
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; } 
    public String errorSeverity{ get; set; } 
    public Boolean closeWin {get;set;} 
    public id assetId {get;set;}    
    Asset theAsset {get;set;}
    public Id Caseid;
    public boolean isMoodle {get;set;}
    
    
    
    public BBW_AssetVersionUpdate(ApexPages.StandardController controller) {
        theAsset = (Asset)controller.getRecord(); 
        assetId = System.currentPageReference().getParameters().get('id');
        theAsset = [Select id, Version__c, Core_License__c,Core_License__r.Name, Version_Build__c from Asset where id = : assetId];
        if(theAsset.Core_License__r.Name.contains('Moodlerooms')){
            isMoodle = true;
        }
        version = theAsset.Version__c;
        sourcebuild = theAsset.Version_Build__c;
        errorShow = false;
        errorTitle = '';
        errorMessage = '';
        errorSeverity = ''; 
        if(closeWin!=true) 
            closeWin=false;
    }
    
    public PageReference SaveVersion() 
    {
        
       // try{
       if(theAsset.Version__c != version && theAsset.Version_Build__c != sourcebuild && sourcebuild != '-Please Select-'){
             Asset_Version_History__c AVH= new Asset_Version_History__c();
             AVH.Asset__c=theAsset.id;
             AVH.Current_Version__c=version;
             AVH.Current_Build__c=sourcebuild;
             AVH.Effective_Date__c=system.now();
             insert AVH;
       }
       
       else if(theAsset.Version__c == version && theAsset.Version_Build__c != sourcebuild && sourcebuild != '-Please Select-'){
             Asset_Version_History__c AVH= new Asset_Version_History__c();
             AVH.Asset__c=theAsset.id;
             AVH.Current_Version__c=version;
             AVH.Current_Build__c=sourcebuild;
             AVH.Effective_Date__c=system.now();
             insert AVH;
       }
       
       if(theAsset.Version__c != version && isMoodle == true && sourcebuild == '-Please Select-'){
             Asset_Version_History__c AVH= new Asset_Version_History__c();
             AVH.Asset__c=theAsset.id;
             AVH.Current_Version__c=version;
             AVH.Current_Build__c=version;
             AVH.Effective_Date__c=system.now();
             insert AVH;
       }
       
            /* theAsset.Version__c = version;
             theAsset.Version_Build__c = sourcebuild;                          
             update theAsset;  */
             closeWin=true;       
             return null;
     /*       }       
            catch (Exception e){
                  system.debug('Error Message-----------' + e.getMessage());
                  errorTitle = 'Updating Error!';
                  errorMessage = e.getMessage();
                  errorSeverity = 'error';
                  errorShow = true;            
                  return null;
            }*/
    } 
    
    /*----------------------------- VERSION SELECT LIST ------------------------------*/
     
    public List<selectOption> versions {
        
        
        get {
            List<selectOption> options = new List<selectOption>();
            Set<String> ver = new Set<String>();
            if (assetId != null) {
                    
                for (Asset a : [SELECT id, name, version__c,GKEY_Product_Group__c,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: assetId]){
                if(a.version__c!=null)
                    options.add(new SelectOption(a.version__c,a.version__c));
                   // version = a.version__c;
                    ver.add(a.Version__c);
                 for (Version_Build_Tree__c v : [SELECT id, Version__c FROM Version_Build_Tree__c v WHERE Version__c !=: a.version__c AND GKEY_Product_Group__c =: a.Product2.GKEY_Product_Group__c AND Active_Flag__c = true  ORDER BY Version__c ]){
                                if(v.version__c!=null && !ver.contains(v.version__c)){
                                     options.add(new SelectOption(v.version__c,v.version__c));
                                     if(version == null)
                                         version = v.version__c;
                                     ver.add(v.version__c);
                                   }
                             }     
                    }
                
           /*    for (Version__c v : [SELECT id, version__c FROM Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM Asset WHERE id =:assetId].Psft_Product_Id__c AND v.Version__c != :[SELECT version__c FROM Asset WHERE id =: assetId].version__c ORDER BY Version__c DESC])
                   {
                       if(v.version__c!=null && !ver.contains(v.version__c)){
                         options.add(new SelectOption(v.version__c,v.version__c));
                         if(version == null)
                             version = v.version__c;
                         ver.add(v.version__c);
                       }
                   }*/
                   
                 
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


/* ------------------------- CLEAR SOURCE BUILD ADD '-Please Select-' --------------- */
    
    public Pagereference clearsb(){
        System.debug('Version >>>>' +version);
        sourcebuild = '-Please Select-';
        return null;
    }


/* ------------------------- SOURCE BUILD SELECT LIST ------------------------------- */    
       public List<selectOption> sblist{
        
        get {
            
            List<selectOption> options = new List<selectOption>();
            Set<String> sb2 = new Set<String>();
            
            if(assetId != null) {
            
                    for (Asset a : [SELECT id,version__c,Version_Build__c,Product2.GKEY_Product_Group__c FROM Asset a WHERE a.id =: assetId]) { 
                if(sourcebuild == '-Please Select-')
                    options.add(new SelectOption('-Please Select-','-Please Select-'));
               if(sourcebuild != '-Please Select-' && sourcebuild != null){
                    options.add(new SelectOption(sourcebuild,sourcebuild));
                       if(a.Version_Build__c != null) {
                         if(sourcebuild == null || (sourcebuild != null && sourcebuild != a.Version_Build__c && sourcebuild != '-Please Select-'))
                           // sourcebuild  = a.Version_Build__c;
                            options.add(new SelectOption(a.Version_Build__c,a.Version_Build__c));
                          
                      }
                     
                    }
                   for (Version_Build_Tree__c v : [SELECT id, Version__c, Version_Build__c FROM Version_Build_Tree__c WHERE Version_Build__c!= :a.Version_Build__c AND GKEY_Product_Group__c =:a.Product2.GKEY_Product_Group__c AND Version__c =:version AND version_build__c !=:sourcebuild AND Active_Flag__c =true ORDER BY Version_Build__c DESC]){           
                    if(v.Version_Build__c != null)
                    options.add(new SelectOption(v.Version_Build__c,v.Version_Build__c));
                    if(sourcebuild == null && sourcebuild != '-Please Select-')
                            sourcebuild = v.Version_Build__c;
                }  
               }
               
               System.debug('----- version' + version + '----- asset' + assetId + '------ sourcebuild' + sourcebuild);
            /*   for (Bb_Prod_Version__c v : [SELECT id, source_build__c FROM Bb_Prod_Version__c v WHERE v.Psft_Product_Id__c = : [SELECT Psft_Product_Id__c FROM asset WHERE id =:assetId].Psft_Product_Id__c AND v.Version__c = :version AND v.source_build__c != :sourcebuild ORDER BY Source_Build__c DESC]){           
                    if(v.source_build__c != null){
                        options.add(new SelectOption(v.source_build__c,v.source_build__c));
                        if(sourcebuild == null && sourcebuild != '-Please Select-')
                            sourcebuild = v.source_build__c; 
                    }
                }         */
                
                  

            }
           
            System.debug('AAAAAA'+sourcebuild);
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
    
    
    static testmethod void updateVersionTest(){
    
        Account ac = new Account();
        ac.Name = 'Testing1 Account';
        ac.BillingStreet = 'Testing1 Street';
        ac.BillingCity = 'Testing1 City';
        ac.BillingState = 'Testing1 State';
        ac.BillingCountry = 'Testing1 country';        //for Angel account level queue
        ac.BillingPostalCode = 'Testing Code';
        ac.Angel_Queue__c = 'ANGEL - Midwest Engagement Team';  
        insert ac;
            
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Xythos';
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
        
        Test.StartTest();
 
        ApexPages.currentPage().getparameters().put('id',aset.ID);
        ApexPages.StandardController controller = new ApexPages.StandardController(aset);
        BBW_AssetVersionUpdate  ca = new BBW_AssetVersionUpdate(controller);
        ca.errorTitle = null;
        ca.errorMessage = null;
        ca.errorSeverity = '1';     
        ca.assetId = aset.ID;       
        ca.version = '9.1';
        
        List<SelectOption> ver = new List<SelectOption>();
        ver = ca.versions;
        
        List<SelectOption> sb = new List<SelectOption>();
        sb = ca.sblist;
        
        ca.sourcebuild  = '9.1.1';
        ca.clearsb();
        ca.SaveVersion();
        ca.theAsset.User_Limit__c = 'erereefe25sdfew5wsdf4';
        ca.SaveVersion();
        
        Test.stopTest();
  
        
    }
    
}