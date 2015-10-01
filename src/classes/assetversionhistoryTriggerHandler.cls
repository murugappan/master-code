public without sharing class assetversionhistoryTriggerHandler {


static Boolean firstRun = true;
    public static Boolean hasBeforeInsertRun {get {if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} set;}
    public static Boolean hasAfterInsertRun {get {if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
    public static Boolean hasBeforeUpdateRun {get {if (hasBeforeUpdateRun == null) return false; return hasBeforeUpdateRun;} set;}
    public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public assetversionhistoryTriggerHandler (){
    }
    
    
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(list<Asset_Version_History__c > newList){
    Map<Id, Asset_Version_History__c > AVHMap = new Map<id, Asset_Version_History__c >();
    set<string> idset = new set<string>();
    set<string> versionset = new set<string>();
    set<string> versionbuildset = new set<string>();
    set<Datetime> Dateset = new set<Datetime>();
    
        if (!hasBeforeInsertRun)
        {
            for(Asset_Version_History__c avh: newList)
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
            
            }
            
            
        
        }
        
        
     /*list<Asset> Asstlist = new list<Asset>();
     
     
        for(Asset c: [Select id, Version__c, Version_Build__c, Product2Id, Product2.GKEY_Product_Group__c  from Asset where id IN: AVHMap.keyset()])
        
        {
        
            for(list<Version_Build_Tree__c> vbt: [Select id, Version__c, Version_Build__c,GKEY_Product_Group__c  from Version_Build_Tree__c where GKEY_Product_Group__c =: c.Product2.GKEY_Product_Group__c AND Version__c =:c.Version__c ])
            {
                if(vbt.size() == 0 || vbt.size() == null )
                {
                    AVHMap.get(c.id).Current_Build__c.addError('Not a Valid Version/Build Pair');
                }
                
            }
            
        
         }*/
         
    
   
        
    }
    
    
    public void onafterInsert(list<Asset_Version_History__c > newList)
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