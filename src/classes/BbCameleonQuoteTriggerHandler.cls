public without sharing class BbCameleonQuoteTriggerHandler {

             
             
             
            public static Boolean hasBeforeInsertRun {get {if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} set;}
            public static Boolean hasAfterInsertRun {get {if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
            public static Boolean hasBeforeUpdateRun {get {if (hasBeforeUpdateRun == null) return false; return hasBeforeUpdateRun;} set;}
            public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
                     
             
             
             
             
             // ------------------------------------------------
            // Constructor Method
            // ------------------------------------------------
            public BbCameleonQuoteTriggerHandler(){
            }

            
            
            public void OnBeforeInsert(CameleonCPQ__Quote__c[] newCameleonQuotes){
            
                if (!hasBeforeInsertRun)
                    {
                   
                   
                   
                    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                    String MyProflieName = PROFILE[0].Name;  
                    
                    hasBeforeInsertRun= True;
                    
                    if(MyProflieName == 'Bb - Contract Review User - CPQ'){
                        CreateQuoteException(newCameleonQuotes);
                    }
                    
                    if(MyProflieName != 'Bb - Contract Review User - CPQ'){
                        CPQCameleonQuoteBeforeInsertOrUpdate(newCameleonQuotes);
                    }
                    //CPQCameleonQuoteBeforeInsertOrUpdate(newCameleonQuotes);
                    //CreateQuoteException(newCameleonQuotes);
                    
                    }
                    
            
            
            }
            
            public void OnAfterInsert(CameleonCPQ__Quote__c[] newCameleonQuotes, Map<ID, CameleonCPQ__Quote__c> insertedCameleonQuoteMap){
             
             
              if (!hasAfterInsertRun)
                    {
                         hasAfterInsertRun=True;
                         //Commented by Nikhil. to Make code perfect moved to before insert
                         //CPQCameleonQuoteAfterInsert(insertedCameleonQuoteMap);
                         
                         createCPQAsset(newCameleonQuotes);
                     }    
             
              }
             
             
            public void OnBeforeUpdate(CameleonCPQ__Quote__c[] oldCameleonQuote, CameleonCPQ__Quote__c[] updatedCameleonQuote, Map<ID, CameleonCPQ__Quote__c> oldCameleonQuoteMap, Map<ID, CameleonCPQ__Quote__c> updatedCameleonQuoteMap){
             
             if (!hasBeforeUpdateRun)
                {    
                
                hasBeforeUpdateRun=True;
             
               }
             
             
             }
             
            public void OnAfterUpdate(CameleonCPQ__Quote__c[] oldCameleonQuote, CameleonCPQ__Quote__c[] updatedCameleonQuote, Map<ID, CameleonCPQ__Quote__c> oldCameleonQuoteMap, Map<ID, CameleonCPQ__Quote__c> updatedCameleonQuoteMap){
              
                 if (!hasAfterUpdateRun)
                   { 
                   
                   
                   hasAfterUpdateRun=True;
                   
                   }
                   
            
            
            
            }
            
            Public void OnBeforeDelete(CameleonCPQ__Quote__c[] oldCameleonQuote,Map<ID, CameleonCPQ__Quote__c> oldCameleonQuoteMap)
            {
            
             CPQCameleonQuoteBeforeDelete(oldCameleonQuoteMap);
            
            }
            
            // Move from Afterinsert to Before insert
            /*
            Private void CPQCameleonQuoteAfterInsert(Map<id,CameleonCPQ__Quote__c> NewMap)
            {
                       
                       
                       List<CameleonCPQ__Quote__c> allQuotes = [SELECT OpportunityId__c,OpportunityId__r.RecordType.Name,OpportunityId__r.Account.BillingCountry, OpportunityId__r.Account.Id,OpportunityId__r.CurrencyIsoCode,OpportunityRecordTypeName__c, CameleonCPQ__AccountId__c, CurrencyIsoCode FROM CameleonCPQ__Quote__c WHERE Id IN: NewMap.keySet()];
   
                       Map<String,CurrencyType> currencyTable = new Map<String,CurrencyType>();
                       
                       List<CameleonCPQ__Quote__c> LisforUpdate = new List<CameleonCPQ__Quote__c>();
                       
                       Date now = Date.today();
                       For(CurrencyType cur: [Select ConversionRate,IsoCode,DecimalPlaces from CurrencyType WHERE IsActive=True])
                       {
                         currencyTable.put(cur.IsoCode,cur);
                       }  
                        
                       
                       
                       for (CameleonCPQ__Quote__c quote : allQuotes) 
                       {
                           if(quote.OpportunityId__c != null)
                             {
                                  //quote.CurrencyIsoCode = quote.OpportunityId__r.CurrencyIsoCode;
                                  if(quote.OpportunityId__r.RecordType.Name != Null)
                                    {
                                       quote.OpportunityRecordTypeName__c = quote.OpportunityId__r.RecordType.Name;  
                                    }
                                    
                                    
                                    if(quote.OpportunityId__r.Account.id != null)
                                    { 
                                       quote.CameleonCPQ__AccountId__c = quote.OpportunityId__r.Account.id;
                                       quote.CustomerTier__c = CPQCustomerTierMgr.getCustomerTier(quote.OpportunityId__r.Account.BillingCountry);
                                    }   
                              } 
                              quote.CurrencyIsoCode = 'USD';  
                              quote.ExchangeRate__c = currencyTable.get(quote.OpportunityId__r.CurrencyIsoCode).ConversionRate; 
                              LisforUpdate.add(quote);   
                       }
                       Update LisforUpdate;
                                

            }
            */

            // Changed by Nikhil to make the code perfect.
            Private void CPQCameleonQuoteBeforeInsertOrUpdate(List<CameleonCPQ__Quote__c> NewMap)
            {
            
            
                 // Map of Currency
                 Map<String,DatedConversionRate> currencyTable = new Map<String,DatedConversionRate>();
                // Commented for 14935
                /*
                 For(CurrencyType cur: [Select ConversionRate,IsoCode,DecimalPlaces from CurrencyType WHERE IsActive=True])
                  {
                      currencyTable.put(cur.IsoCode,cur);
                  }
                 */ 
                 Date now = Date.today();
                 For(DatedConversionRate cur: [Select ConversionRate, IsoCode from DatedConversionRate WHERE StartDate <= :now AND NextStartDate > :now])
                 {
                 currencyTable.put(cur.IsoCode,cur);
                 }    
            
                  //Opps id
                  Set<id> Oppid = New Set<id>();
                  //Collect the OpportunityIds

                  for (CameleonCPQ__Quote__c quote : NewMap) 
                    { 
                        if(quote.OpportunityId__c != null)
                        {
                          Oppid.Add(quote.OpportunityId__c);
                        } 
                    }
            
                    // Map of Opportunities
                    Map<Id,Opportunity> Mopp = New Map<id,Opportunity>([Select id,RecordType.Name,Account.BillingCountry,Account.Id,CurrencyIsoCode from Opportunity Where Id IN :Oppid]);
                    system.debug('MG123'+Mopp);
                    
                    // Logic here
                    for (CameleonCPQ__Quote__c quote : NewMap) 
                      { 
                            // Record type
                            if(Mopp.containsKey(quote.OpportunityId__c) && Mopp.get(quote.OpportunityId__c).RecordType.Name != Null)
                            {
                               quote.OpportunityRecordTypeName__c = Mopp.get(quote.OpportunityId__c).RecordType.Name;  
                            }
                            
                            if(Mopp.containsKey(quote.OpportunityId__c) && Mopp.get(quote.OpportunityId__c).Account.id != null)
                            { 
                               quote.CameleonCPQ__AccountId__c = Mopp.get(quote.OpportunityId__c).Account.id;
                               quote.CustomerTier__c = CPQCustomerTierMgr.getCustomerTier(Mopp.get(quote.OpportunityId__c).Account.BillingCountry);
                            }   
                    
                              quote.CurrencyIsoCode = 'USD'; 
                              system.debug('Test123'+currencyTable.get(Mopp.get(quote.OpportunityId__c).CurrencyIsoCode).ConversionRate); 
                              
                                quote.ExchangeRate__c = currencyTable.get(Mopp.get(quote.OpportunityId__c).CurrencyIsoCode).ConversionRate; 
                              
                              
                      }
            }
            Private void CPQCameleonQuoteBeforeDelete(Map<id,CameleonCPQ__Quote__c> OldMap)
            {
            
            List<CameleonQuoteLineItem__c> LCamLineItemToDelete = [Select id from CameleonQuoteLineItem__c Where Cameleon_Quote__c IN :OldMap.keySet()];
            Delete LCamLineItemToDelete;
            
            
            
            }
            
            
            // testing code
            
             
            Private void CreateQuoteException(List<CameleonCPQ__Quote__c> NewMap)
            {
            
            
                  List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                  String MyProflieName = PROFILE[0].Name;
                  system.debug('MGGGG'+MyProflieName);
                  
                  
                  //List<Profile> profileName = [Select Name from Profile where Name = 'Bb - Contract Review User - CPQ'];
                  
                  
                  //Opps id
                  Set<id> Oppid = New Set<id>();
                  //Collect the OpportunityIds

                  for (CameleonCPQ__Quote__c quote : NewMap) 
                    { 
                        if(MyProflieName == 'Bb - Contract Review User - CPQ')
                        {
                          quote.addError('This profile does not have access to create quotes. Please contact your administrator!');
                          //Oppid.Add(quote.OpportunityId__c);
                        } 
                    }
            
                 
            }
            
            
            
            //

            public void createCPQAsset(List<CameleonCPQ__Quote__c> NewMap)
            {
              set<id> OpportunityIds = new set<id>();
              for (CameleonCPQ__Quote__c quote : NewMap) 
              {
                  OpportunityIds.add(quote.OpportunityId__c);
              }

              Map<id,Opportunity> OpportunityMap= new Map<id,Opportunity>([SELECT Id, AccountId FROM Opportunity WHERE Id IN:OpportunityIds]);
              set<id> Accountids = new set<id>();
              for(Opportunity opportunityRecord :OpportunityMap.values())
              {
                Accountids.add(opportunityRecord.AccountId);
              }

              if(Accountids != null && Accountids.size()>0)
              {
                List<Asset> assets = 
                                          [SELECT Id,
                                                  AccountId,
                                                  a.CPQ_Active__c, 
                                                  a.CPQ_NumQty__c,
                                                  a.CPQ_Contract_End_Date__c,
                                                  a.CPQ_contractLength__c,
                                                  a.CPQ_Contract_Start_Date__c,
                                                  a.CPQ_Current_Opportunity_ID__c,
                                                  a.CPQ_currentYear__c,
                                                  a.CPQ_forCPQ__c,
                                                  a.FTE__c,
                                                  a.CPQ_Intergrated_System__c,
                                                  a.CPQ_isCoreItem__c,
                                                  a.CPQ_isMultiyear__c,
                                                  a.CPQ_ISO_Currency_Code__c,
                                                  a.CPQ_isRenewable__c,
                                                  a.CPQ_LineIdentifier__c,
                                                  a.Maintenance_Level__c,
                                                  a.Name,
                                                  a.CPQ_Net_Price__c,
                                                  a.Number_of_Seats__c,
                                                  a.Number_of_Users__c,
                                                  a.Opportunity__c,
                                                  a.CPQ_Package__c,
                                                  a.CPQ_Package_Id__c,
                                                  a.CPQ_Parent_Item__c,
                                                  a.CPQ_Previous_Opportunity_ID__c,
                                                  a.CPQ_Product_Platform__c,
                                                  a.Psft_Product_Id__c,
                                                  a.QPQ_Reseller__c,
                                                  a.CPQ_Selling_Exchange_Rate__c,
                                                  a.CPQ_User_Band__c,
                                                  a.Quantity,
                                                  a.Software_URL__c,
                                                  a.Status
                                           FROM Asset a WHERE a.Status != 'Obsolete' AND AccountId IN :Accountids];
                List<CPQAsset__c> cpqAssets = new List<CPQAsset__c>();
                delete [SELECT id FROM CPQAsset__c WHERE Account__c IN:Accountids];
                 for (Asset asset : assets)
                          {
                              CPQAsset__c cpq = new CPQAsset__c();
                              
                              cpq.Account__c = asset.AccountId;
                              cpq.CPQ_Active__c = asset.CPQ_Active__c;
                              cpq.Asset__c = asset.Id;
                              cpq.CPQ_NumQty__c = asset.CPQ_NumQty__c;
                              cpq.CPQ_Contract_End_Date__c = asset.CPQ_Contract_End_Date__c;
                              cpq.CPQ_contractLength__c = asset.CPQ_contractLength__c;
                              cpq.CPQ_Contract_Start_Date__c = asset.CPQ_Contract_Start_Date__c;
                              cpq.CPQ_Current_Opportunity_ID__c = asset.CPQ_Current_Opportunity_ID__c;
                              cpq.CPQ_currentYear__c = asset.CPQ_currentYear__c;
                              cpq.CPQ_forCPQ__c = asset.CPQ_forCPQ__c;
                              cpq.FTE__c = asset.FTE__c;
                              cpq.CPQ_Intergrated_System__c = asset.CPQ_Intergrated_System__c;
                              cpq.CPQ_isCoreItem__c = asset.CPQ_isCoreItem__c;
                              cpq.CPQ_isMultiyear__c = asset.CPQ_isMultiyear__c;
                              cpq.CPQ_ISO_Currency_Code__c = asset.CPQ_ISO_Currency_Code__c;
                              cpq.CPQ_isRenewable__c = asset.CPQ_isRenewable__c;
                              cpq.CPQ_LineIdentifier__c = asset.CPQ_LineIdentifier__c;
                              cpq.Maintenance_Level__c = asset.Maintenance_Level__c;
                              cpq.Name = asset.Name.left(79);
                              cpq.CPQ_Net_Price__c = asset.CPQ_Net_Price__c;
                              cpq.Number_of_Seats__c = asset.Number_of_Seats__c;
                              cpq.Number_of_Users__c = asset.Number_of_Users__c;
                              cpq.Opportunity__c = asset.Opportunity__c;
                              cpq.CPQ_Package__c = asset.CPQ_Package__c;
                              cpq.CPQ_Package_Id__c = asset.CPQ_Package_Id__c;
                              cpq.CPQ_Parent_Item__c = asset.CPQ_Parent_Item__c;
                              cpq.CPQ_Previous_Opportunity_ID__c = asset.CPQ_Previous_Opportunity_ID__c;
                              cpq.CPQ_Product_Platform__c = asset.CPQ_Product_Platform__c;
                              cpq.Psft_Product_Id__c = asset.Psft_Product_Id__c;
                              cpq.QPQ_Reseller__c = asset.QPQ_Reseller__c;
                              cpq.CPQ_Selling_Exchange_Rate__c = asset.CPQ_Selling_Exchange_Rate__c;
                              cpq.CPQ_User_Band__c = asset.CPQ_User_Band__c;
                              cpq.Quantity__c = asset.Quantity;
                              cpq.Status__c = asset.Status;
                              
                              //Added by Nikhil
                              cpq.Software_URL__c=asset.Software_URL__c;
                              
                              cpqAssets.add(cpq);
                          } 
                          if(cpqAssets!=null && cpqAssets.size()>0 )
                          {
                            upsert(cpqAssets);
                          }                            
              }
           
            }

}