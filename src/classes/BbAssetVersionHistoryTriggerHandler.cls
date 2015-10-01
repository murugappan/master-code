public without sharing class BbAssetVersionHistoryTriggerHandler {


    static Boolean firstRun = true;
    public static Boolean hasBeforeInsertRun {get {if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} set;}
    public static Boolean hasAfterInsertRun {get {if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
    public static Boolean hasBeforeUpdateRun {get {if (hasBeforeUpdateRun == null) return false; return hasBeforeUpdateRun;} set;}
    public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
    
   
   
    /* Constructor Method */
   
    public BbAssetVersionHistoryTriggerHandler (){
    }
    
   
        
    
    /* Triggers Methods */
    
    public void OnBeforeInsert(list<Asset_Version_History__c > newList){
        Map<Id, Asset_Version_History__c > AVHMap = new Map<id, Asset_Version_History__c >();
        set<string> idset = new set<string>();
        set<string> versionset = new set<string>();
        set<string> versionbuildset = new set<string>();
        set<Datetime> Dateset = new set<Datetime>();
        
        if (!hasBeforeInsertRun)
        {
            /*  [LaL] Start-Changes 9/3/2013 */
            /*  Stop the addition of a row into the AVH table if it is the same version and Build
                that the parent Asset is currently at.  There is an issue that was found with the CPQ
                Asset copy that would stop the AVH cloning forward beacause the Asset has a V/B that is current
            */
            Id AssetId;
            for (Asset_Version_History__c single_avh_variable :newList)
            {
                // only check for dupes on a single insert
                if (single_avh_variable.Asset__c != null ){
                    AssetId = single_avh_variable.Asset__c;
                    break;
                }                
            }
            
            if (AssetId != null) {
                for (Asset_Version_History__c each_avh_obj :[Select Asset__c, Asset__r.Version__c, Asset__r.Version_Build__c , Current_Version__c, Current_Build__c, Effective_Date__c From Asset_Version_History__c Where Asset__c =  :AssetId ] ){
                    // only check if is not from a CPQ clone forward - the date should be in the past 
                    if ( each_avh_obj.Effective_Date__c == null || each_avh_obj.Effective_Date__c >= System.Today() ){
                    
                        // check to see if the avh current V/B is the same as the Asset's V/B
                        if  ( each_avh_obj.Asset__r.Version_Build__c != null && each_avh_obj.Current_Build__c == each_avh_obj.Asset__r.Version_Build__c) { 
                            
                            each_avh_obj.Current_Build__c.addError('You are trying to add a version/build pair which is the same as the value on the asset');
                        }
                    }
                    
                 }                   
            }
            /*  [Lal] End-Changes 9/3/2013 */
            
            
            
            
            /*for(Asset_Version_History__c avh: newList)
            {
            
              if(avh.Asset__c != null)
              {
                AVHMap.put(avh.Asset__c, avh);
                idset.add(avh.id);
                versionset.add(avh.Current_Version__c);
                versionbuildset.add(avh.Current_Build__c);
                Dateset.add(avh.Effective_Date__c); 
              }
            
            }
            
            set<String> dupecheckvr = new set<String>();
            set<String> dupecheckvrbuild = new set<String>();
            set<Datetime> dupecheckeffdate = new set<Datetime>();
            for (Asset_Version_History__c  avh1 : [SELECT Asset__c,Current_Build__c,Current_Version__c,Effective_Date__c FROM Asset_Version_History__c WHERE Asset__c IN: AVHMap.keyset() ORDER BY Effective_Date__c DESC NULLS LAST LIMIT 1])
            {
                if (avh1.Asset__c!= null)
                {
                    dupecheckvr.add(avh1.Current_Version__c);
                    dupecheckvrbuild.add(avh1.Current_Build__c);
                    dupecheckeffdate.add(avh1.Effective_Date__c);
                        
                }
            }
            
            for(Asset_Version_History__c avh2: newList)
            {
               if (dupecheckvr.contains(avh2.Current_Version__c) && dupecheckvrbuild.contains(avh2.Current_Build__c)  )
               {
               avh2.Current_Version__c.addError('Duplicate Version/Build/Effective Date Found');
               avh2.Current_Build__c.addError('Duplicate Version/Build/Effective Date Found');
               }
            
            }*/
            
            
        
        }
        
        
     
         
    
   
        
    }
    
    
    public void OnafterInsert(list<Asset_Version_History__c > newList)
    {
    Map<Id, Asset_Version_History__c > AVHMap = new Map<id, Asset_Version_History__c >();

        if (!hasAfterInsertRun)
        {
        for(Asset_Version_History__c avh: newList)
        {
          if(avh.Asset__c != null)
          {
            AVHMap.put(avh.Asset__c, avh);
          }
        
        }

        }
        
        list<Asset> Asstlist = new list<Asset>();



        for(Asset c: [Select id, Version__c, Version_Build__c from Asset where id IN: AVHMap.keyset()])
        
        {
            if(AVHMap.containskey(c.id))
            {
                 c.Version__c = AVHMap.get(c.id).Current_Version__c;
                 c.Version_Build__c = AVHMap.get(c.id).Current_Build__c;
                 Asstlist.add(c);
            }
            
        }
        
        update Asstlist;
        

    }
    
    
}