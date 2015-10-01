trigger CPQCameleonQuoteBeforeInsertTrigger on CameleonCPQ__Quote__c (before insert) {
    
   /* for (CameleonCPQ__Quote__c quote : trigger.new) 
    {
        // Assign parent opportunity account
        Opportunity[] quoteOpportunities = [SELECT Id, AccountId FROM Opportunity WHERE Id =: quote.OpportunityId__c];
        
        if (quoteOpportunities.size() > 0) 
        {  
            Account[] accounts = [SELECT Id FROM Account WHERE Id=:quoteOpportunities[0].AccountId];
            
            if(accounts.size() > 0)
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
                                 FROM Asset a WHERE a.Status != 'Obsolete' AND AccountId =: accounts[0].Id LIMIT 200 ];
                 // Above limit has been commented BY Nikhil                
                List<CPQAsset__c> cpqAssets = new List<CPQAsset__c>();                 
                
                try{delete [SELECT id FROM CPQAsset__c WHERE Account__c =: accounts[0].Id];}catch(Exception e){System.debug('caught asset deletion exception ');}
                
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
                insert cpqAssets;
            }
        }
    }*/
}