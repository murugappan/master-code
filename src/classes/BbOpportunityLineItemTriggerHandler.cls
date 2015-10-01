/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardOpportunityItemTriggerHandler
    @abstract       handles all the logic for triggers on OpportunityLineItem
    @since          2011.0915
    @discussion     Class to execute OpportunityLineItem triggers logic
*/
public with sharing class BbOpportunityLineItemTriggerHandler {
    
    public static Boolean hasAfterInsertRun {get {if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
    public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbOpportunityLineItemTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(OpportunityLineItem[] newOpportunityLineItems){
        calculateOpportunityLineItemPrice(newOpportunityLineItems);
        calculateOpportunityLineItemFamilyAmounts(newOpportunityLineItems);
        UpdatePreviousYearNetPrice(newOpportunityLineItems);
       // UpdatePreviousYearNetPrice(newOpportunityLineItems);
        //UpdatePreviousYearNetPrice1(newOpportunityLineItems);
      //UpdatePreviousYearNetPriceupdated(newOpportunityLineItems);
      
        
        
    }
    
    public void OnAfterInsert(OpportunityLineItem[] newOpportunityLineItems, Map<ID, OpportunityLineItem> insertedOpportunityLineItemMap){

        // commented June 12, 2012 TP 2425
        // closeOpportunityWith_A_or_R_ContractLineStatus(newOpportunityLineItems);  
        
        // Added by Dominic Baker on Dec 19, 2012
        if (!hasAfterInsertRun)
        {
            hasAfterInsertRun = true;
            // commented by Nikhil for implemantation of  sales Value
            // calculateOpportunitySalesValues(newOpportunityLineItems);
            // Added by Dominic Baker on November 2, 2012
            updateAccountFields(newOpportunityLineItems);
        }    
    }
        
    public void OnBeforeUpdate(OpportunityLineItem[] oldOpportunityLineItems, OpportunityLineItem[] updatedOpportunityLineItems, Map<ID, OpportunityLineItem> oldOpportunityLineItemMap, Map<ID, OpportunityLineItem> updatedOpportunityLineItemMap){
        calculateOpportunityLineItemPrice(updatedOpportunityLineItems);
        calculateOpportunityLineItemFamilyAmounts(updatedOpportunityLineItems);
        //Commented by Nikhil:Date:-23 FEB
        //uncommented by Sneha for TP:- 12326
        // sneha's code 
         UpdatePreviousYearNetPrice(updatedOpportunityLineItems);
         //UpdatePreviousYearNetPrice1(updatedOpportunityLineItems);
        //UpdatePreviousYearNetPriceupdated(updatedOpportunityLineItems);
        //dochecklogicforadjustmentfields(updatedOpportunityLineItems);
        dochecklogicforadjustmentfields(oldOpportunityLineItems,updatedOpportunityLineItems,oldOpportunityLineItemMap,updatedOpportunityLineItemMap);
        
    }
    
    public void OnAfterUpdate(OpportunityLineItem[] oldOpportunityLineItems, OpportunityLineItem[] updatedOpportunityLineItems, Map<ID, OpportunityLineItem> oldOpportunityLineItemMap, Map<ID, OpportunityLineItem> updatedOpportunityLineItemMap){

        // commented June 12, 2012 TP 2425
        // closeOpportunityWith_A_or_R_ContractLineStatus(updatedOpportunityLineItems);
        // Added by Dominic Baker on Dec 19, 2012
        if (!hasAfterUpdateRun)
        {
            hasAfterUpdateRun = true;
            // commented by Nikhil for implemantation of  sales Value
            //calculateOpportunitySalesValues(updatedOpportunityLineItems);
            CPQAssetStatusTrigger(oldOpportunityLineItems,updatedOpportunityLineItems,oldOpportunityLineItemMap,updatedOpportunityLineItemMap);
            UpdateOppReportingValues(updatedOpportunityLineItems);
        }       
    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------
    
    
    /*///////// commented June 12, 2012 TP 2425 ///////*/
    /*/////////
    //Updates Opportunty Stage to (W) Won when all the line if one product Contract Line Status is "A" or "R" and all the othe rline item have a non null Contract Line Status
    private void closeOpportunityWith_A_or_R_ContractLineStatus(OpportunityLineItem[] opportunityLineItems) {
    
        List<Opportunity> opportunitiesToClose = new List<Opportunity>();
    
        Set<Id> opportunityIds = new Set<Id>();
    
        for(OpportunityLineItem lineItem:opportunityLineItems) 
        {
            if(lineItem.OpportunityId != null && (lineItem.CA_Line_Status__c == 'A' || lineItem.CA_Line_Status__c == 'R')) opportunityIds.add(lineItem.OpportunityId);
        }
    
    
        if(opportunityIds.size() > 0)
        {         
            for (Opportunity opportunity : [SELECT Id, StageName, Type, (SELECT Id, CA_Line_Status__c FROM OpportunityLineItems)
                                                    FROM Opportunity 
                                                    WHERE Id IN :opportunityIds 
                                                    AND (isWon = False OR (isWon = True AND Closed_in_PSFT__c = False))
                                                    AND Type = 'Renewal'
                                                    AND RecordType.Name IN ('Blackboard Opportunity Renewals','Blackboard Opportunity Renewals with Renewal Notices')])
            {
                Boolean closeWonOpportunity = true;
                
                for (OpportunityLineItem lineItem: opportunity.OpportunityLineItems)
                {
                    if(lineItem.CA_Line_Status__c == null || (lineItem.CA_Line_Status__c != 'A' && lineItem.CA_Line_Status__c != 'R' && lineItem.CA_Line_Status__c != 'C')) closeWonOpportunity = false;
                }
                
                if(closeWonOpportunity == true)
                {
                    opportunity.StageName = '(W) Won';
                    opportunity.Closed_in_PSFT__c = True;
                    opportunitiesToClose.add(opportunity);
                }
            }
            update opportunitiesToClose;
        }
    }
    /////////*/
    
    // Calculates line item price
    private void calculateOpportunityLineItemPrice (OpportunityLineItem[] opportunityLineItems)
    {
        for(OpportunityLineItem opportunityLineItem:opportunityLineItems) 
        {   
        
            if ( opportunityLineItem.Custom_Price__c == null ) opportunityLineItem.Custom_Price__c = 0;
            if ( opportunityLineItem.Discount_Value__c == null ) opportunityLineItem.Discount_Value__c = 0;
            if ( opportunityLineItem.Unused_Credit__c == null ) opportunityLineItem.Unused_Credit__c = 0;
            if ( opportunityLineItem.Backout_Value__c == null ) opportunityLineItem.Backout_Value__c = 0;
            if ( opportunityLineItem.CP_Commission__c == null ) opportunityLineItem.CP_Commission__c = 0;


            // This is to calc the Start_Price__c which is list or custom (custom wins) 
            if ( opportunityLineItem.Custom_Price__c > 0 )
            {   
                opportunityLineItem.Start_Price__c = opportunityLineItem.Quantity * opportunityLineItem.Custom_Price__c;      
            }
        
            // Use the ListPrice instead to calculate the Start_Price
            // change JLAL 5/19/2010 - for Big Machines.  They are sending UnitPrice not List
            else if (opportunityLineItem.ListPrice != null )
            { 
                opportunityLineItem.Start_Price__c = opportunityLineItem.Quantity * opportunityLineItem.ListPrice;
            }
            else if ( opportunityLineItem.UnitPrice != null )
            {           
                opportunityLineItem.Start_Price__c = opportunityLineItem.Quantity * opportunityLineItem.UnitPrice;
            }
            else
            {
                opportunityLineItem.Start_Price__c = 0;
            }
        

            // If Discount type was selected, move the value to the amount field
            if (opportunityLineItem.Discount_Type__c ==  'Amount' )
            {
                opportunityLineItem.Discount_Amount__c = opportunityLineItem.Discount_Value__c;
            }

            // Find the amount of the percentage entered
            if (opportunityLineItem.Discount_Type__c == 'Percent' )
            {
                opportunityLineItem.Discount_Amount__c = opportunityLineItem.Start_Price__c  * (opportunityLineItem.Discount_Value__c/100);       
            }
    
            // Set the Customer Price 
            opportunityLineItem.Customer_Price__c = opportunityLineItem.Start_Price__c - opportunityLineItem.Discount_Amount__c -  opportunityLineItem.Unused_Credit__c;
         
        
            // If there is a bTotalPrice it would have been sent from PSFT as total sales credit
            // Use bTotalPrice as the base after coming back from PSFT
            if (opportunityLineItem.bTotalPrice__c == null  ) 
            {       
                // Set the Unit price as startPrice - discs divide by the quantity
                opportunityLineItem.bUnitPrice__c = ( opportunityLineItem.Start_Price__c - opportunityLineItem.Discount_Amount__c - opportunityLineItem.Backout_Value__c)  / opportunityLineItem.Quantity;
            }
            else
            {
                // The unit price is going to be the PSFT total sales divide by quantity
                opportunityLineItem.bUnitPrice__c = opportunityLineItem.bTotalPrice__c / opportunityLineItem.Quantity;
            }

            // replace worklflow rule
            opportunityLineItem.UnitPrice = opportunityLineItem.bUnitPrice__c;

        }
    }
    
    //Separates Total Price into Family Values
    public static void calculateOpportunityLineItemFamilyAmounts(OpportunityLineItem[] opportunityLineItems)
    {
        Set<Id> pricebookEntryIds = new Set<Id>();
    
        for (OpportunityLineItem opportunityLineItem : opportunityLineItems )
        {
            pricebookEntryIds.add(opportunityLineItem.PricebookEntryId);
        }
        
        Map<Id, PricebookEntry> pricebookEntryMap = new Map<Id, PricebookEntry>([SELECT Id, Product2.Family FROM PricebookEntry WHERE Id IN :pricebookEntryIds]);
        
        for (OpportunityLineItem opportunityLineItem : opportunityLineItems )
        {
            if(pricebookEntryMap.get(opportunityLineItem.PricebookEntryId) != null) {
                if ( pricebookEntryMap.get(opportunityLineItem.PricebookEntryId).Product2.Family == 'Transact') opportunityLineItem.Transact_Family_Value__c = opportunityLineItem.Quantity * opportunityLineItem.bUnitPrice__c; 
                else if ( pricebookEntryMap.get(opportunityLineItem.PricebookEntryId).Product2.Family == 'Non-Recurring Other') opportunityLineItem.Non_Recurring_Other_Family_Value__c = opportunityLineItem.Quantity * opportunityLineItem.bUnitPrice__c; 
                else if ( pricebookEntryMap.get(opportunityLineItem.PricebookEntryId).Product2.Family == 'Non-Recurring Services') opportunityLineItem.Non_Recurring_Services_Family_Value__c = opportunityLineItem.Quantity * opportunityLineItem.bUnitPrice__c; 
                else if ( pricebookEntryMap.get(opportunityLineItem.PricebookEntryId).Product2.Family == 'Recurring') opportunityLineItem.Recurring_Family_Value__c = opportunityLineItem.Quantity * opportunityLineItem.bUnitPrice__c; 
            }
        }
    }
    
    private void updateAccountFields(list<OpportunityLineItem> newList)
    {
        set<Id> opportunityIdSet = new set<Id>(); //Set of Opportunity Ids on the line items to be queried
        set<Id> accountIdSet = new set<Id>(); //Set of Account Ids on the Opportunities to be queried
        map<Id, Opportunity> opportunityMap = new map<Id, Opportunity>(); //Map of Opportunity Ids with their Ids as the key
        map<Id, Account> accountMap; //Map of Accounts with their Ids as the key
         
        // Loop to collect Opportunity Ids
        for (OpportunityLineItem oli : newList)
        {
            if (oli.OpportunityId != null)
            {
                opportunityIdSet.add(oli.OpportunityId);
            }
        }
        
        // Loop to collect Account Ids and map Opportunity Ids to their Opportunity
        for (Opportunity o : [Select Id, AccountId From Opportunity Where Id IN : opportunityIdSet])
        {
            if (o.AccountId != null)
            {
                accountIdSet.add(o.AccountId);
                opportunityMap.put(o.Id, o);
            }
        }
        
        // Query to populate Account map
        accountMap = new map<Id, Account>([Select Id, CPQ_Next_Opportunity_Line_Item__c From Account Where Id IN : accountIdSet]);
        
        // Loop to either set the counter to 1 or increment the counter of line items
        for (OpportunityLineItem oli : newList)
        {
            if (oli.OpportunityId != null)
            {
                if (opportunityMap.containsKey(oli.OpportunityId) && accountMap.containsKey(opportunityMap.get(oli.OpportunityId).AccountId))
                {
                    if (accountMap.get(opportunityMap.get(oli.OpportunityId).AccountId).CPQ_Next_Opportunity_Line_Item__c == null || 
                        accountMap.get(opportunityMap.get(oli.OpportunityId).AccountId).CPQ_Next_Opportunity_Line_Item__c == 0)
                    {
                        accountMap.get(opportunityMap.get(oli.OpportunityId).AccountId).CPQ_Next_Opportunity_Line_Item__c = 2;
                    }
                    else
                    {
                        accountMap.get(opportunityMap.get(oli.OpportunityId).AccountId).CPQ_Next_Opportunity_Line_Item__c++;
                    }
                }
            }
        }
        
        if (accountMap != null && !accountMap.isEmpty())
        {
            try
            {
                update accountMap.values();
            }
            catch (DMLException e)
            {
                system.debug('Account Update Failed!');
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }
    }
    
    // Added by Dominic Baker on Dec 19, 2012
    // Updated by Dominic Baker on Mar 27, 2013
    // Commented by Nikhil Date 23 april 2014
    /*
    private void calculateOpportunitySalesValues(list<OpportunityLineItem> newList)
    {
        map<Id, Opportunity> oppMap;
        list<Opportunity> opportunityUpdateList = new list<Opportunity>();
        set<Id> opportunityIdSet = new set<Id>();
        
        for (OpportunityLineItem oli : newList)
        {
            if (oli.OpportunityId != null)
            {
                opportunityIdSet.add(oli.OpportunityId);
            }
        }
        
        for (Opportunity o : [Select Id, CPQ_New_Sales_Value__c, CPQ_Renewal_Sales_Value__c, RecordTypeId, RecordType.Name, CPQ_Expected_Renewal_Amount__c,
                                     (Select Id, CPQ_NetPrice__c From OpportunityLineItems Where CPQ_NetPrice__c != null)
                              From Opportunity 
                              Where Id IN : opportunityIdSet])
        {
            o.CPQ_Renewal_Sales_Value__c = 0;
            o.CPQ_New_Sales_Value__c = 0;
            
            for (OpportunityLineItem oli : o.OpportunityLineItems)
            {
                if (oli.CPQ_NetPrice__c != null)
                {
                    o.CPQ_Renewal_Sales_Value__c += oli.CPQ_NetPrice__c;
                }
            }
            
            if (o.RecordType.Name != null && o.RecordType.Name.contains('CPQ Renewal'))
            {
                system.debug(o.CPQ_Renewal_Sales_Value__c);
                system.debug(o.CPQ_Expected_Renewal_Amount__c);
                if (o.CPQ_Expected_Renewal_Amount__c < o.CPQ_Renewal_Sales_Value__c)
                {
                    o.CPQ_New_Sales_Value__c = o.CPQ_Renewal_Sales_Value__c - o.CPQ_Expected_Renewal_Amount__c;
                    o.CPQ_Renewal_Sales_Value__c = o.CPQ_Expected_Renewal_Amount__c;
                }
            }
            else
            {
                o.CPQ_New_Sales_Value__c = o.CPQ_Renewal_Sales_Value__c;
                o.CPQ_Renewal_Sales_Value__c = 0;
            }
            
            opportunityUpdateList.add(o);
        }
        
        if (opportunityUpdateList != null && !opportunityUpdateList.isEmpty())
        {
            try
            {
                update opportunityUpdateList;
            }
            catch (DMLException e)
            {
                system.debug('Opportunity Update Failed!');
                list<Exception_Log__c> logList = new list<Exception_Log__c>();
                Exception_Log__c el;
                for (Integer i = 0; i < e.getNumDml(); i++)
                {
                    // Process exception here
                    el = new Exception_Log__c(Exception__c = e.getDmlMessage(i), Type__c = 'Dml',
                        Class_Name__c = String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')));
                    logList.add(el);
                }
                insert logList;
            }
        }   
    }
    
  */  
    // Added by Nikhil. to update Status on Asset based on Opportunity Line Item
    
    private void CPQAssetStatusTrigger(list<OpportunityLineItem> OldList,list<OpportunityLineItem> newList,Map<id,OpportunityLineItem> OldMap,Map<id,OpportunityLineitem> NewMap)
    {
      
      
             //Set of Opps id from OppLineItem
            Set<Id> allOpps = new Set<Id>();
            
            
            //Set of lineItems ids
            Set<id>  lineid = New Set<id>();
            
            For(OpportunityLineItem Opl : newList)
            {  
                
                
                        if (Opl.CPQ_Delivery_Status__c != OldMap.get(Opl.id).CPQ_Delivery_Status__c && OldMap.get(Opl.id).CPQ_Delivery_Status__c != null && Opl.CPQ_Delivery_Status__c != null) {
                    
                            
                            if(OldMap.get(Opl.id).CPQ_Delivery_Status__c.equals('Request Pending') && Opl.CPQ_Delivery_Status__c.equals('Installed')){
                                    
                                    
                                    allOpps.add(Opl.OpportunityId);
                                    
                                    lineid.Add(Opl.id);
                    
                            }
       
                
                        }
            }   
            
            
            
            If (allOpps.size()>0){
            
                    
                    Map<Id,Map<String,Asset>> assetList = new Map<Id,Map<String,Asset>>();
                    List<Asset> asstToUpdate = new List<Asset>();
                    
                    List<OpportunityLineItem> allAccounts = new  List<OpportunityLineItem>([SELECT Id, Opportunity.AccountId from OpportunityLineItem where Id IN :lineid]);
                    
                    Map<Id,Id> olibyAccount = new Map<Id,Id>();
        
                    for(OpportunityLineItem oppLine : allAccounts){
                        
                        olibyAccount.put(oppLine.Id,oppLine.Opportunity.AccountId);     
                    }
        
       
            
                    For(Asset ast : [SELECT Id,Status,CPQ_LineIdentifier__c,AccountId,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c  FROM Asset where CPQ_Current_Opportunity_ID__c IN :allOpps and Status='Request Pending']){
                        
                         
                         if(assetList.containsKey(ast.AccountId)){
                                
                                Map<String,Asset> indAssetList = assetList.get(ast.AccountId);
                                indAssetList.put(ast.CPQ_LineIdentifier__c+ast.CPQ_Contract_Start_Date__c.Year()+'-'+ast.CPQ_Contract_End_Date__c.year(),ast);
                                
                                assetList.put(ast.AccountId, indAssetList);
                        }
                        else{
                                
                                Map<String,Asset> indAssetList = new Map<String,Asset>();
                                indAssetList.put(ast.CPQ_LineIdentifier__c+ast.CPQ_Contract_Start_Date__c.Year()+'-'+ast.CPQ_Contract_End_Date__c.year(),ast);
                                
                                assetList.put(ast.AccountId, indAssetList);
                            }
                    }    
        
        
            
                    
                    
                    For(OpportunityLineItem oli : newList)
                    {  
                
                
                        if (oli.CPQ_Delivery_Status__c != OldMap.get(oli.id).CPQ_Delivery_Status__c && OldMap.get(oli.id).CPQ_Delivery_Status__c != null && oli.CPQ_Delivery_Status__c != null) {
                        
                                
                                    if(OldMap.get(oli.id).CPQ_Delivery_Status__c.equals('Request Pending') && oli.CPQ_Delivery_Status__c.equals('Installed')){
                                    
                                    
                                                Map<String,Asset> indAssetList = assetList.get(olibyAccount.get(oli.Id));
                                    
                                                
                                                if(indAssetList != null){
                                                    
                                                    
                                                    
                                                        If(oli.Renewal_Unique_Line_ID__c != Null)
                                                        {
                                                        
                                                                if(indAssetList.get(oli.Renewal_Unique_Line_ID__c+oli.CPQ_Product_Start_Date__c.year()+'-'+oli.CPQ_Product_End_Date__c.year()) != null){
                                                                   
                                                                    indAssetList.get(oli.Renewal_Unique_Line_ID__c+oli.CPQ_Product_Start_Date__c.year()+'-'+oli.CPQ_Product_End_Date__c.year()).Status='Installed';
                                                                    asstToUpdate.add(indAssetList.get(oli.Renewal_Unique_Line_ID__c+oli.CPQ_Product_Start_Date__c.year()+'-'+oli.CPQ_Product_End_Date__c.year()));
                                                                }
                                                    
                                                        }
                                                
                                                }
                                            
                                    }
                        
                        
                        }
        
                    }
                    
                    If(!asstToUpdate.isEmpty()){
                        
                        update asstToUpdate;
                    
                    }
    
    
            }
           
    
    
    }
    
    ////
    private void UpdatePreviousYearNetPrice(OpportunityLineItem[] opportunityLineItems)
    {
      
      if(runrenewaltrigger.NotrunOppl ==False)
      {   
            runrenewaltrigger.NotrunOppl=True;
           // Store previous opportunity Ids
           Set<id> PreOppid = New Set<id>();
           
           //Set of Opportunityid
           Set<id> Oppid = New Set<id>();
           System.debug('Test2NikNik');
           For(OpportunitylineItem Oppline : opportunityLineItems)
           {
            /*   if(Oppline.PFIN_Intgr_Record_Type__c.contains('CPQ Renewal Opportunity Record Type') && Oppline.Previous_Opportunity__c!=Null && Oppline.Previous_Opportunity__c.length()==18)
               {
                   PreOppid.Add(Oppline.Previous_Opportunity__c);
                   Oppid.Add(Oppline.Opportunityid);
               }
               else if(Oppline.PFIN_Intgr_Record_Type__c.contains('CPQ Renewal Opportunity Record Type') && Oppline.CPQ_Previous_Opportunity__c!=null)
               {
                    PreOppid.Add(Oppline.CPQ_Previous_Opportunity__c);
                   Oppid.Add(Oppline.Opportunityid);
               }*/
                Oppid.Add(Oppline.Opportunityid);
           }

          map<id,opportunity>preopmap=new map<id,opportunity>(); //([Select id,CPQ_Previous_Opportunity__c from Opportunity where id IN :OPPid]);
          for(Opportunity opp:[Select id,Opportunity_ID_18__c,CPQ_Previous_Opportunity__c from Opportunity where id IN :OPPid])
          {
            preopmap.put(opp.Opportunity_ID_18__c,opp);
            PreOppid.add(opp.CPQ_Previous_Opportunity__c);
            system.debug('PreOppid1'+PreOppid);
          }
        
           if(PreOppid.Size()>0)
           {       
           
                   // Map of Currency
                    Map<String,DatedConversionRate> currencyTable = new Map<String,DatedConversionRate>();
                    
                    Map<id,Opportunity> MOppp= New Map<Id,Opportunity>([Select id,CurrencyIsocode,Multi_Year_Deal__c from Opportunity Where ID IN :Oppid]);
                
                      For(DatedConversionRate cur: [Select ConversionRate, IsoCode from DatedConversionRate WHERE StartDate <= :Date.today() AND NextStartDate > :Date.today()])
                      {
                          currencyTable.put(cur.IsoCode,cur);
                      }
                   
                   
                   // Map of Key and Assets
                   Map<String,Asset>  MKeyAset= New Map<String,Asset>();
                   List<OpportunityLineItem> OppLinetoUpdate = New List<OpportunityLineItem>();
                   
                   System.debug('PreOppId'+PreOppid);

                   // Map has been filled with Key and  proper Asset
                   For(Asset Ast : [Select id,CurrencyIsocode,CPQ_isMultiyear__c,CPQ_Net_Price__c,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c,CPQ_Current_Opportunity_ID__c,CPQ_Previous_Opportunity_ID__c,Opportunity__c,CPQ_LineIdentifier__c,Psft_Product_Id__c,CPQ_currentYear__c,Local_Price_Calculation__c from Asset Where (Opportunity__c!=null AND Opportunity__c IN : PreOppid)  OR (CPQ_Current_Opportunity_ID__c!=null AND CPQ_Current_Opportunity_ID__c IN : PreOppid) ])
                   {
                       if(Ast.CPQ_Current_Opportunity_ID__c != null)
                       {
                           // test if(Ast.CPQ_isMultiyear__c == True && Ast.CPQ_Contract_Start_Date__c != null && Ast.CPQ_Contract_End_Date__c !=null)
                           if(Ast.CPQ_Contract_Start_Date__c != null && Ast.CPQ_Contract_End_Date__c !=null)
                           {
                            MKeyAset.Put(Ast.CPQ_Current_Opportunity_ID__c+Ast.Psft_Product_Id__c+Ast.CPQ_LineIdentifier__c+Ast.CPQ_Contract_Start_Date__c.year()+Ast.CPQ_Contract_End_Date__c.year(),Ast);
                            System.debug('Map of Asset'+MKeyAset);
                           }
                           else
                           MKeyAset.Put(Ast.CPQ_Current_Opportunity_ID__c+Ast.Psft_Product_Id__c+Ast.CPQ_LineIdentifier__c,Ast);
                       }
                       
                       else
                       {
                        //if(Ast.CPQ_isMultiyear__c == True && Ast.CPQ_Contract_Start_Date__c != null && Ast.CPQ_Contract_End_Date__c !=null)
                        if(Ast.CPQ_Contract_Start_Date__c != null && Ast.CPQ_Contract_End_Date__c !=null)
                        {
                        MKeyAset.Put(Ast.Opportunity__c+Ast.Psft_Product_Id__c+Ast.CPQ_LineIdentifier__c+Ast.CPQ_Contract_Start_Date__c.year()+Ast.CPQ_Contract_End_Date__c.year(),Ast);
                        System.debug('Map of Asset2'+MKeyAset);
                        }
                        else
                          MKeyAset.Put(Ast.Opportunity__c+Ast.Psft_Product_Id__c+Ast.CPQ_LineIdentifier__c,Ast);
                        }
                   }

    
                   // Map for previous opportunity id and Previous Oppline item
    
                  Map<String,OpportunityLineitem> MOppline = New Map<String,OpportunityLineitem>();

         /*         For(OpportunityLineItem Opppl : [Select id,Opportunityid,PriorYearPrice__c,PS_Product_ID__c,Opportunity.CPQ_Previous_Start_Date__c,Opportunity.CPQ_Previous_End_Date__c,Renewal_Unique_Line_ID__c,Previous_Opportunity__c from OpportunityLineItem Where Previous_Opportunity__c IN :PreOppid and Opportunity.StageName='(W) Won'])
                  {
                    if(Opppl.PriorYearPrice__c!=null && Opppl.Opportunity.CPQ_Previous_Start_Date__c != null && Opppl.Opportunity.CPQ_Previous_End_Date__c!=null && Opppl.CPQ_Year_2_Amount__c!=null && Opppl.CPQ_Year_3_Amount__c != null && Opppl.CPQ_Year_4_Amount__c!=null && Opppl.CPQ_Year_5_Amount__c!=null && Opppl.Opportunityid!=null)    
                    {
                      MOppline.put(Opppl.Opportunityid+Opppl.PS_Product_ID__c+Opppl.Renewal_Unique_Line_ID__c+Opppl.Opportunity.CPQ_Previous_Start_Date__c.year()+Opppl.Opportunity.CPQ_previous_End_Date__c.year(),Opppl);
                      if (MKeyAset.containsKey(Opppl.Opportunityid+Opppl.PS_Product_ID__c+Opppl.Renewal_Unique_Line_ID__c+Opppl.Opportunity.CPQ_Previous_Start_Date__c.year()+Opppl.Opportunity.CPQ_Previous_End_Date__c.year()))
                      {
                         Opppl.PriorYearPrice__c = MKeyAset.get(Opppl.Opportunityid+opppL.PS_Product_ID__c+Opppl.Renewal_Unique_Line_ID__c+Opppl.Opportunity.CPQ_Previous_Start_Date__c.year()+Opppl.Opportunity.CPQ_Previous_End_Date__c.year()).Local_Price_Calculation__c;
                         // OppLinetoUpdate.add(Oppline);  
                      }
                    }
                    else
                    {
                    MOppline.put(Opppl.Opportunityid+Opppl.PS_Product_ID__c+Opppl.Renewal_Unique_Line_ID__c,Opppl);
                    if (MKeyAset.containsKey(Opppl.Opportunityid+Opppl.PS_Product_ID__c+Opppl.Renewal_Unique_Line_ID__c))
                    {
                        Opppl.PriorYearPrice__c = MKeyAset.get(Opppl.Opportunityid+opppL.PS_Product_ID__c+Opppl.Renewal_Unique_Line_ID__c).Local_Price_Calculation__c;
                               
                    }
                   }
                  }*/

                   map<id,Opportunity> Datemap= new map<id,Opportunity>([Select id,CPQ_Previous_Start_Date__c,CPQ_Previous_End_Date__c from Opportunity where id in:Oppid]);
                    

                  For(OpportunitylineItem Oppline : opportunityLineItems)
                   {
                       
                       if(Oppline.PFIN_Intgr_Record_Type__c.contains('CPQ Renewal Opportunity Record Type') && Preopmap.get(Oppline.OpportunityId)!=Null && Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c.length()==18)
                       {

                        string Key;
                        if(DateMap.get(Oppline.OpportunityId)!=null&&Datemap.get(Oppline.OpportunityId).CPQ_Previous_Start_Date__c!=null && Datemap.get(Oppline.OpportunityId).CPQ_Previous_End_Date__c!=null)
                        {
                            key=Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c+Datemap.get(Oppline.OpportunityId).CPQ_Previous_Start_Date__c.year()+Datemap.get(Oppline.OpportunityId).CPQ_previous_End_Date__c.year();
                        }
                        else
                        {
                            key=Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c;
                        }
                        if(MKeyAset.containsKey(Key))
                        {
                         // System.debug('Same Converion Rate' +MOppp.get(Oppline.Opportunityid).currencyIsoCode+MKeyAset.get(Oppline.Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c+Datemap.get(Oppline.ID).Opportunity.CPQ_Previous_Start_Date__c.year()+Datemap.get(Oppline.ID).Opportunity.CPQ_Previous_End_Date__c.year()).CurrencyIsocode );
                          if(MOppp.get(Oppline.Opportunityid).currencyIsoCode == MKeyAset.get(Key).CurrencyIsocode)
                          {
                            Oppline.PriorYearPrice__c=MKeyAset.get(Key).CPQ_Net_Price__c;
                                  
                          }
                          else
                          {
                            System.debug('Different Converion Rate');  
                             // Oppline.PriorYearPrice__c=((MKeyAset.get(Oppline.Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CPQ_Net_Price__c)/(currencyTable.get(MKeyAset.get(Oppline.Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CurrencyIsocode).ConversionRate))*(currencyTable.get(MOppp.get(Oppline.Opportunityid).currencyIsoCode).ConversionRate);
                            Oppline.PriorYearPrice__c=MKeyAset.get(Key).Local_Price_Calculation__c;
                          }
                               
                        }
                        }
                        else
                        {
                         if(MKeyAset.containsKey(Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c))
                        {
                           //System.debug('Same Converion Rate' +MOppp.get(Oppline.Opportunityid).currencyIsoCode+MKeyAset.get(Oppline.Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CurrencyIsocode );
                            if(MOppp.get(Oppline.Opportunityid).currencyIsoCode == MKeyAset.get(Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CurrencyIsocode)
                            {
                              Oppline.PriorYearPrice__c=MKeyAset.get(Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CPQ_Net_Price__c;
                            }
                            else
                            {
                                System.debug('Different Converion Rate');  
                               // Oppline.PriorYearPrice__c=((MKeyAset.get(Oppline.Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CPQ_Net_Price__c)/(currencyTable.get(MKeyAset.get(Oppline.Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).CurrencyIsocode).ConversionRate))*(currencyTable.get(MOppp.get(Oppline.Opportunityid).currencyIsoCode).ConversionRate);
                                Oppline.PriorYearPrice__c=MKeyAset.get(Preopmap.get(Oppline.OpportunityId).CPQ_Previous_Opportunity__c+Oppline.PS_Product_ID__c+Oppline.Renewal_Unique_Line_ID__c).Local_Price_Calculation__c;
                            }
                               
                        }

                       }
                                                 
                    }
                   
               }//Close of for loop

        
           }
        
      }
   
    ////////////////////////////////////
    
    private void UpdatePreviousYearNetPrice1(OpportunityLineItem[] opportunityLineItems)
    {
           
           // Store previous opportunity Ids
           Set<id> PreOppIdset = New Set<id>();
           
           //Set of Opportunityid
           Set<id> OppIdset = New Set<id>();
           
           
           for(OpportunitylineItem Oppline : opportunityLineItems)
           {
               if(Oppline.OpportunityId != null)
               {
                   OppIdset.add(Oppline.Opportunityid);
                   //PreOppIdset.add(Oppline.Previous_Opportunity__c);
               } 
           }
           
           list<Opportunity> oppList = [Select id, Opportunity_ID_18__c from Opportunity Where Id IN: OppIdset ];
           list<Asset> assetList = [Select id, CPQ_Net_Price__c, CPQ_LineIdentifier__c, Local_Price_Calculation__c, CPQ_Current_Opportunity_ID__c from Asset
                                   Where CPQ_Current_Opportunity_ID__c IN: OppIdset ];
           system.debug('MG***'+assetList.size());
           system.debug('MG1***'+assetList);
           Map<String, Asset> assetMap = new Map<String, Asset>();
           
                                   
           if(assetList.size() > 0){
                
                for(asset ast: assetList ){
                    assetMap.put(ast.CPQ_LineIdentifier__c, ast);
                }
           }
           
           ////////////////////
           
           for(OpportunitylineItem preOppline : opportunityLineItems)
           {
               if(preOppline.Previous_Opportunity__c != null)
               {
                   PreOppIdset.add(preOppline.Previous_Opportunity__c);
               } 
           }
           
           list<Asset> prevassetList = [Select id, CPQ_Net_Price__c, CPQ_LineIdentifier__c, Local_Price_Calculation__c, CPQ_Current_Opportunity_ID__c from Asset
                                       Where CPQ_Current_Opportunity_ID__c IN: PreOppIdset ];
                                   
           system.debug('MG2***'+prevassetList.size());
           system.debug('MG3***'+prevassetList); 
           Map<String, Asset> prevassetMap = new Map<String, Asset>();  
           
           if(prevassetList.size() > 0){
                
                for(asset ast: prevassetList ){
                    prevassetMap.put(ast.CPQ_LineIdentifier__c, ast);
                }
           }                    
                                   
           /////////////////////                        
           
           list<OpportunityLineItem> OppLinetoUpdate = new list<OpportunityLineItem> ();
           list<OpportunityLineItem> RenewalOppLinetoUpdate = new list<OpportunityLineItem> ();
           
           for(OpportunitylineItem Oppline : opportunityLineItems){
               if (assetMap.containsKey(Oppline.Renewal_Unique_Line_ID__c)){
                   Oppline.PriorYearPrice__c = assetMap.get(Oppline.Renewal_Unique_Line_ID__c).Local_Price_Calculation__c;
                   OppLinetoUpdate.add(Oppline);  
               }
               
               if (prevassetMap.containsKey(Oppline.Renewal_Unique_Line_ID__c)){
                   Oppline.PriorYearPrice__c = prevassetMap.get(Oppline.Renewal_Unique_Line_ID__c).Local_Price_Calculation__c;
                   RenewalOppLinetoUpdate.add(Oppline);  
               }
           
           
           
           }
           
           if(OppLinetoUpdate.size() > 0){
               system.debug('MG4***'+OppLinetoUpdate.size());
               system.debug('MG5***'+OppLinetoUpdate);
           }
           
           if(RenewalOppLinetoUpdate.size() > 0){
               system.debug('MG6***'+RenewalOppLinetoUpdate.size());
               system.debug('MG7***'+RenewalOppLinetoUpdate);
           }
           
           
           
           
    }  
    
    
/////////

//updated code

private void UpdatePreviousYearNetPriceupdated(OpportunityLineItem[] opportunityLineItems)
    {
           
           
      if(runrenewaltrigger.NotrunOppl == False)
      {   

           runrenewaltrigger.NotrunOppl = true;
           // Store previous opportunity Ids
           Set<id> PreOppIdset = New Set<id>();
           
           //Set of Opportunityid
           Set<id> OppIdset = New Set<id>();
           
           set<id> Idset = new set<id>();
           
           
           for(OpportunitylineItem Oppline : opportunityLineItems)
           {
               
               Idset.add(Oppline.Id);
               
               if(Oppline.OpportunityId != null && Oppline.Previous_Opportunity__c != null)
               {
                   
                   OppIdset.add(Oppline.Opportunityid);
                   PreOppIdset.add(Oppline.Previous_Opportunity__c);
                   system.debug('MG1***'+OppIdset);
                   system.debug('MG1.1***'+PreOppIdset); 
                } 
           }

           
           
           list<Asset> prevassetList = [Select id, CPQ_Net_Price__c, CPQ_LineIdentifier__c, CPQ_Contract_Start_Date__c, CPQ_Contract_End_Date__c, Local_Price_Calculation__c, CPQ_Current_Opportunity_ID__c from Asset
                                       Where CPQ_Current_Opportunity_ID__c IN: PreOppIdset  AND CPQ_isMultiyear__c = true];

           system.debug('MG1.2***'+prevassetList.size());
           system.debug('MG1.3***'+prevassetList); 

           Map<String, Asset> prevassetMap = new Map<String, Asset>();  
           
           if(prevassetList.size() > 0){
                
                for(asset ast: prevassetList ){
                       if(Ast.CPQ_Current_Opportunity_ID__c != null)
                       {
                          prevassetMap.put(ast.CPQ_LineIdentifier__c+ast.CPQ_Contract_Start_Date__c+ast.CPQ_Contract_End_Date__c,ast);
                          system.debug('MG1.4***'+prevassetMap); 
                       }
                       
                       system.debug('AGGGG'+prevassetMap.keyset());

                }
           }                    
                                   
           list<OpportunityLineItem> renewalOppLinetoUpdate = new list<OpportunityLineItem> ();
           map<id,OpportunitylineItem> Datemap= new map<id,OpportunitylineItem>([Select id,Opportunity.CPQ_Previous_Start_Date__c,Opportunity.CPQ_Previous_End_Date__c from OpportunitylineItem where id IN : Idset]);
                           
           
           
           
           for(OpportunitylineItem Oppline : opportunityLineItems){
               system.debug('MGGGGG'+Oppline.Renewal_Unique_Line_ID__c+Oppline.Opportunity.CPQ_Previous_Start_Date__c+Oppline.Opportunity.CPQ_Previous_End_Date__c);
               
               
               //string Key = Oppline.Renewal_Unique_Line_ID__c+Datemap.get(Oppline.Id).Opportunity.CPQ_Previous_Start_Date__c+Datemap.get(Oppline.Id).Opportunity.CPQ_previous_End_Date__c;
               string Key = Oppline.Renewal_Unique_Line_ID__c+Oppline.Renewal_Opp_Prev_Start_Date__c+Oppline.Renewal_Opp_Prev_End_Date__c;
               
               
               system.debug('GGGG'+key);
               
               if (prevassetMap.containsKey(Key)){
                   Oppline.PriorYearPrice__c = prevassetMap.get(Key).Local_Price_Calculation__c;
                   renewalOppLinetoUpdate.add(Oppline);  
                   system.debug('MG1.5***'+renewalOppLinetoUpdate);
               }
           
           }
           
           if(renewalOppLinetoUpdate.size() > 0){
               system.debug('MG1.6***'+renewalOppLinetoUpdate.size());
               system.debug('MG1.7***'+renewalOppLinetoUpdate);
           }
           
           
     }      
           
    } 


////////


private void UpdateOppReportingValues(OpportunityLineItem[] opportunityLineItems){
list<Opportunity> oppUpdate = new list<Opportunity>();
set<Id> Idset = new set<Id>();

for(OpportunityLineItem oppline: opportunityLineItems){
    if(oppline.Quota_New_Sales_Adjustment__c != null){
        Idset.add(oppline.OpportunityId);
    }
}

list<Opportunity> oppList = [Select id from Opportunity Where id IN: Idset];

for(Opportunity Opp: oppList ){
        oppUpdate.add(opp);
    
}

Update oppUpdate;


}



/*private void dochecklogicforadjustmentfields(OpportunityLineItem[] opportunityLineItems)
    {
      

      for(OpportunitylineItem Oppline : opportunityLineItems){
            if(Oppline.Quota_New_Sales_Adjustment__c == null && Oppline.Quota_Renewal_Sales_Adjustment__c != null){
                    Oppline.Quota_New_Sales_Adjustment__c.addError('Value cannot be null!');
            }

            if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c == null){
                    Oppline.Quota_Renewal_Sales_Adjustment__c.addError('Value cannot be null!');
            }

            if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_New_Sales_Adjustment__c > 0){
                    Oppline.Quota_Renewal_Sales_Adjustment__c = -(Oppline.Quota_New_Sales_Adjustment__c);

            }

            if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_New_Sales_Adjustment__c < 0){
                    Oppline.Quota_Renewal_Sales_Adjustment__c = -(Oppline.Quota_New_Sales_Adjustment__c);

            }

            /*if(Oppline.Quota_Renewal_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c > 0){
                    Oppline.Quota_New_Sales_Adjustment__c = -(Oppline.Quota_Renewal_Sales_Adjustment__c);

            }

            if(Oppline.Quota_Renewal_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c < 0){
                    Oppline.Quota_New_Sales_Adjustment__c = -(Oppline.Quota_Renewal_Sales_Adjustment__c);

            }*/

      //}





    //}

 private void dochecklogicforadjustmentfields(list<OpportunityLineItem> OldList,list<OpportunityLineItem> newList,Map<id,OpportunityLineItem> OldMap,Map<id,OpportunityLineitem> NewMap)
    {



        for(OpportunityLineItem Oppline : newList)
                    {  
                        
                                //if ((Oppline.Quota_New_Sales_Adjustment__c != OldMap.get(Oppline.id).Quota_New_Sales_Adjustment__c) && (Oppline.Quota_Renewal_Sales_Adjustment__c != OldMap.get(Oppline.id).Quota_Renewal_Sales_Adjustment__c)) {
                                 //   Oppline.addError('Cannot change both new sales and renewal sales adjustment values at the same time!!');
                                //}

                                /*if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_New_Sales_Adjustment__c > 0){
                                   Oppline.Quota_Renewal_Sales_Adjustment__c = -(Oppline.Quota_New_Sales_Adjustment__c);
                                   system.debug('MgOne');

                                }
                                
                                if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_New_Sales_Adjustment__c < 0){
                                    Oppline.Quota_Renewal_Sales_Adjustment__c = -(Oppline.Quota_New_Sales_Adjustment__c);
                                    system.debug('MgTwo');

                                }


                                if(Oppline.Quota_Renewal_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c > 0){
                                    Oppline.Quota_New_Sales_Adjustment__c = -(Oppline.Quota_Renewal_Sales_Adjustment__c);
                                    system.debug('MgThree');

                                }

                                if(Oppline.Quota_Renewal_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c < 0){
                                    Oppline.Quota_New_Sales_Adjustment__c = -(Oppline.Quota_Renewal_Sales_Adjustment__c);
                                    system.debug('MgFour');

                                }*/

                                /*if ((Oppline.Quota_New_Sales_Adjustment__c != OldMap.get(Oppline.id).Quota_New_Sales_Adjustment__c) && (Oppline.Quota_Renewal_Sales_Adjustment__c != OldMap.get(Oppline.id).Quota_Renewal_Sales_Adjustment__c)) {
                                    Oppline.addError('Cannot change both new sales and renewal sales adjustment values at the same time!!');
                                }*/

                                if(Oppline.Quota_New_Sales_Adjustment__c == null && Oppline.Quota_Renewal_Sales_Adjustment__c != null){
                                        Oppline.Quota_New_Sales_Adjustment__c.addError('Value cannot be null!');
                                }

                                if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c == null){
                                        Oppline.Quota_Renewal_Sales_Adjustment__c.addError('Value cannot be null!');
                                }

                                if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_New_Sales_Adjustment__c > 0){
                                        
                                        if(Oppline.Quota_Renewal_Sales_Adjustment__c != -(Oppline.Quota_New_Sales_Adjustment__c)){
                                                Oppline.Quota_Renewal_Sales_Adjustment__c.addError('Value should be the exact reverse of the new sales adjustment!');
                                        }
                                        
                                }

                                if(Oppline.Quota_New_Sales_Adjustment__c != null && Oppline.Quota_New_Sales_Adjustment__c < 0){
                                        
                                        if(Oppline.Quota_Renewal_Sales_Adjustment__c != -(Oppline.Quota_New_Sales_Adjustment__c)){
                                                Oppline.Quota_Renewal_Sales_Adjustment__c.addError('Value should be the exact reverse of the new sales adjustment!');
                                        }
                                        
                                }

                                if(Oppline.Quota_Renewal_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c > 0){
                                        
                                        if(Oppline.Quota_New_Sales_Adjustment__c != -(Oppline.Quota_Renewal_Sales_Adjustment__c)){
                                                Oppline.Quota_New_Sales_Adjustment__c.addError('Value should be the exact reverse of the renewal sales adjustment!');
                                        }
                                        
                                }

                                if(Oppline.Quota_Renewal_Sales_Adjustment__c != null && Oppline.Quota_Renewal_Sales_Adjustment__c < 0){
                                        
                                        if(Oppline.Quota_New_Sales_Adjustment__c != -(Oppline.Quota_Renewal_Sales_Adjustment__c)){
                                                Oppline.Quota_New_Sales_Adjustment__c.addError('Value should be the exact reverse of the renewal sales adjustment!');
                                        }
                                        
                                }





                    }   
            







    }








    
}