/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardOpportunityTriggerHandler
    @abstract       handles all the logic for triggers on Opportunity
    @since          2011.0915
    @discussion     Class to execute Opportunity triggers logic
*/
public without sharing class BbOpportunityTriggerHandler {

    static Boolean firstRun = true;
    public static Boolean hasBeforeInsertRun {get {if (hasBeforeInsertRun == null) return false; return hasBeforeInsertRun;} set;}
    public static Boolean hasAfterInsertRun {get {if (hasAfterInsertRun == null) return false; return hasAfterInsertRun;} set;}
    public static Boolean hasBeforeUpdateRun {get {if (hasBeforeUpdateRun == null) return false; return hasBeforeUpdateRun;} set;}
    public static Boolean hasAfterUpdateRun {get {if (hasAfterUpdateRun == null) return false; return hasAfterUpdateRun;} set;}
    public static Boolean CPQhasBeforeUpdateRun {get {if (CPQhasBeforeUpdateRun == null) return false; return CPQhasBeforeUpdateRun;} set;}
    public static Boolean hasBeforeUpdateRun1{get {if (hasBeforeUpdateRun1 == null) return false; return hasBeforeUpdateRun1;} set;}
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbOpportunityTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Opportunity[] newOpportunities){
        if (!hasBeforeInsertRun)
        {
           hasBeforeInsertRun = true;
            updateOpportunityInteractionFlag(newOpportunities);
            updateOpportunityOwnerRelationship(newOpportunities);
            updateOpportunityPageLayout(newOpportunities);
            updateOpportunityIntegrationStage(newOpportunities);
            updateOpportunityChannelPartner(newOpportunities);
            updateTransactForecastCategoryName(newOpportunities);
            stampApprovalBlock(newOpportunities);
            updateBbContractIntegrationStatus(newOpportunities);
    
            /* Jon Lal - February 28, 2012 - commented out/ redenudant */
            //updateOpportunityQuotaValue(newOpportunities);
    
            
            updateContactRoleCount(newOpportunities);
        
            /* Jon Lal - January 12, 2012 */
            /* need to run this before crossSellOpportunites */
           // calculateQuotaValue(newOpportunities);
        
            
            /* Jon Lal - February 27, 2012 */
            /* Jon Lal - April 5, 2012 - added beforeInsert method instead */
            //crossSellOpportunity(newOpportunities);
    
            /* April 5, 2012 - onInsert duplicate */
            // this method will solely update fields on the parent before it is inserted.
            // this will not spawn the child because the parent has no Opp.Id yet
           crossSellOpportunity(newOpportunities); 
            //Code to Validate Opportunity Type "New Sale" or "Expansion Business" is being used incorrectly
            TypeOpportunity(newOpportunities);
           //update sales Reporting Group for Opportunity
          
           //Date:22nd May 2012
           // Lead converstion part is in Lead Trigger.
             updateSalesReportingGroup(newOpportunities); 
           
            /* November 1, 2012 - Copy Account field by Dominic Baker */
        
          //  hasBeforeInsertRun = true;
            copyAccountFields(newOpportunities);
        }
        // Moved outside because of DEX
        renewalCheckAndFlip(newOpportunities);
    }
    
    public void OnAfterInsert(Opportunity[] newOpportunities, Map<ID, Opportunity> insertedOpportunityMap){
        if (!hasAfterInsertRun)
        {
            hasAfterInsertRun = true;
            
            
            
             // Added to the before insert to lessen queries Dominic Baker
            //Commented by before insert .Because it has been written for lead converstion.
             // updateSalesReportingGroup(newOpportunities); 

            /* April 5, 2012 - this method should spawn the child opportunity */
            // this should just run and not touch the inOpp fields.
             crossSellOpportunity(newOpportunities);   
           
        }
    }
        
    public void OnBeforeUpdate(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap){
        if (!hasBeforeUpdateRun)
        {
        
            hasBeforeUpdateRun = true;
            Kimblerulesevaluation(oldOpportunityMap, updatedOpportunityMap); 
            updateOpportunityInteractionFlag(updatedOpportunities);
            updateOpportunityOwnerRelationship(updatedOpportunities);
            updateOpportunityPageLayout(updatedOpportunities);
            updateOpportunityIntegrationStage(updatedOpportunities);
            updateOpportunityChannelPartner(updatedOpportunities);
            updateTransactForecastCategoryName(updatedOpportunities);
            stampApprovalBlock(updatedOpportunities); 
            CPQcontractstatuscheck(updatedOpportunities);
            /* Jon Lal - February 28, 2012 - commented out/ redenudant */ 
            // updateOpportunityQuotaValue(updatedOpportunities);
     
            
            // Added by Nikhil.Date 10 Sept 2013
            // Commented out to push CPQ code to production.  LaL
              PartnerRelatedValidation(updatedOpportunities);
            
            
            updateContactRoleCount(updatedOpportunities);
            updateOpportunityNextStep(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            updateTransacOpportunityQuotaValue(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            
            updateTerritoryWhenOwnerIsChanged(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);        
            
            /* Jon Lal - January 12, 2012 */
            /* need to run this before crossSellOpportunites */
          //  calculateQuotaValue(updatedOpportunities);
            
            //Added by Nikhil TP:3068
            // Commented out by Dominic 4/4/13
            // For CPQ deployment, it has been commented
            // UpdateSourceCheckBox(updatedOpportunities);
            
             //Added by nikhil to work on Before update also date:5/10/2013
           //  updateSalesReportingGroup(updatedOpportunities);
            
            /* Jon Lal - February 28, 2012 */        
            crossSellOpportunity(updatedOpportunities);
            // added by Nikhil
            TypeOpportunity(updatedOpportunities);
            // Added by Nikhil to update discount value in opp
            UpdateDiscountvalueOnOpp(updatedOpportunities);
          
            /* November 29, 2012 - Cameleon Opportunity Validations by Dominic Baker */
            
           // hasBeforeUpdateRun = true;
           // Added by Nikhil(commented till Joshua's comfirmation)
         // validateContractStatus(updatedOpportunities);
        }
        // Commented by Nikhil Date 10/27/2014
          //ExceptionalPerpetual(updatedOpportunities);
        // Added By Nikhil to update sales value
         //  CreateReportingValues(updatedOpportunities);
         //  calculateOpportunitySalesValues(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
        // Moved outside because of DEX
        renewalCheckAndFlip(updatedOpportunities);
        // Had to move outside of the recurssive trigger because of Cameleon trigger
        setOpportunityPlatform(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
        setCollaborateOpportunityProducts(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
        validateCameleonOpportunities(updatedOpportunities, oldOpportunities);
    }
      
    public void OnAfterUpdate(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap){
        if (!hasAfterUpdateRun)
        {
           hasAfterUpdateRun = true;
           
           // Added by Nikhil
             updateProductStatusOnLineitem(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            collaborateSalesTeamAssignmentNotification(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            createTaskMoodleRoomTeam(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            createTaskConnectTeam(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            /* Etienne Coutant - July 20, 2012 */
            //updateCollaborateCohortStatusOnAccount(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
            
            //Added by Nikhil on Date : 30/01.2013
              // Commented out by Dominic 4/4/13 UpdateShippingInQuaterInOppProduct(updatedOpportunities,updatedOpportunityMap,oldOpportunityMap);
            
            /* November 8, 2012 - Fire Approval Process from Trigger */
        
         //   hasAfterUpdateRun = true;
         UpdateAdjustmentAsset(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
        }
        sumbitOpportunityForApproval(updatedOpportunities, oldOpportunities);
         // Added by Nikhil to excute this method at last And to prevent recursive call
        CPQRenewalCreation(updatedOpportunities,oldOpportunityMap);
    }
    // For reporting Trigger only to fire on Renewal creation
     public void OnBeforeUpdate1(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap){
        //if (!hasBeforeUpdateRun1)
        {
            
            //hasBeforeUpdateRun1=True;
            ExceptionalPerpetual(updatedOpportunities);
           //Added By Nikhil to update sales value
           CreateReportingValues(updatedOpportunities);
           calculateOpportunitySalesValues(oldOpportunities,updatedOpportunities,oldOpportunityMap,updatedOpportunityMap);
        }
      }  

    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------    
    
    //updates the Opportunity with the products and the type of those products    
    private void setCollaborateOpportunityProducts(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {
        System.debug('*** setCollaborateOpportunityProducts -- Context Starts -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    
        Set<Id> opportunityIds = new Set<Id>();
    
        //Store opportunityIds for each open Collaborate Opportunity
        for(Opportunity opp : updatedOpportunities)
        {
           if(opp.Platform__c != null && opp.Platform__c.contains('Collaborate') && opp.isClosed == False) opportunityIds.add(opp.Id);
        }
    
        if(opportunityIds.size() > 0)
        {
            for (Opportunity opp : [SELECT Id, Name, Opportunity_Product_Types__c, Opportunity_Product_Changes__c, RecordTypeId, RecordType.Name,
                                        (SELECT Id, PriceBookEntry.Product2.External_Long_Description__c, PriceBookEntry.Product2.Product_Category__c, PriceBookEntry.Product2.Product_Sub_Category__c, Drop_Product__c, Product_Upgrade__c, CPQ_Product_Status__c FROM OpportunityLineItems) 
                                    FROM Opportunity
                                    WHERE Id IN :opportunityIds])
            {
                //Lists the products listed under the Opportunity (e.g. Wimba Classroom)
                Set<String> products = new Set<String>();
                //Lists the product types for products listed under the Opportunity (e.g. License)
                Set<String> productTypes = new Set<String>();
                //Lists the product change for products listed under the Opportunity (e.g. Partial Drop)
                Set<String> productChanges = new Set<String>();
    
                Boolean upgradeOnly = true;
                for (OpportunityLineItem lineItem: opp.OpportunityLineItems)
                {
                    //Step 1, lists the products
                    if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Wimba Classroom') products.add('Classroom');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Voice Authoring') products.add('Voice');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Web Conferencing') 
                        {
                            if(lineItem.PriceBookEntry.Product2.External_Long_Description__c != null && lineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Evaluation License')) products.add('Cohort');
                            else products.add('Web Conferencing');
                        }
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Wimba Create') products.add('Create');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Enterprise IM') products.add('Enterprise IM');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Enterprise IM Basic') products.add('Enterprise IM Basic');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'LearnCentral') products.add('LearnCentral');
                   
                    // No longer needed changed to "Web Conferencing" ( August 2012 - TP 2263)
                    //else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'vSpaces') products.add('vSpaces');
                    //else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Plan & Publish') products.add('Plan & Publish');
                    
                    //Step 2, lists the product types
                    if(lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'SAAS' || lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'ASP' || lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Integration' || lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'API Documentation' || lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'POC' || lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'vClass'|| lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'vOffice'|| lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Moderator Access') productTypes.add('Hosting');
                    else if(lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Standalone') productTypes.add('Standalone');
                    else if(lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Dedicated ASP') productTypes.add('Dedicated Hosting');
                    else if(lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'License') productTypes.add('License');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Services' && lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Telephone') productTypes.add('Telephony');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Services' && lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Materials') productTypes.add('Materials');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Services' && lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Technical Service') productTypes.add('Technical Services');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Services') productTypes.add('Services');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Other' && lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Storage') productTypes.add('Storage');
                    else if(lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'ELM') productTypes.add('Above');
                    else if(lineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Annual Maintenance') productTypes.add('Annual Maintenance');
                    else if(lineItem.PriceBookEntry.Product2.Product_Category__c == 'Wimba Create') productTypes.add('Create');
                    
                    //Step 3, lists the product changes
                    if(lineItem.Drop_Product__c == 'Yes') productChanges.add('Partial Drop');
                    if(lineItem.Product_Upgrade__c == True) productChanges.add('Partial Upgrade');
                    else upgradeOnly = false;
                    
                    // New Code
                    system.debug(opp.RecordType.Name);
                    if (lineItem.CPQ_Product_Status__c == 'Dropped' /* || lineItem.CPQ_Product_Status__c == 'Replace' */)
                    {
                        productChanges.add('Partial Drop');
                    }
                    else if (lineItem.CPQ_Product_Status__c == 'Upgrade' || lineItem.CPQ_Product_Status__c=='Replace' || lineItem.CPQ_Product_Status__c=='Replace-Package')
                    {
                        productChanges.add('Partial Upgrade');
                    }
                    else if (opp.RecordType.Name == 'CPQ Renewal Opportunity Record Type' && (lineItem.CPQ_Product_Status__c == 'New' || lineItem.CPQ_Product_Status__c == 'Renew - Qty Change'))
                    {
                        system.debug('Here');
                        productChanges.add('Upgrade');
                    }
                }
                String result = '';
                for(String product:products)
                {
                    result += product;
                    result += ';';
                }
                if(result.endsWith(';')) result = result.substring(0,result.lastIndexOf(';'));
                updatedOpportunityMap.get(opp.Id).Opportunity_Products__c = result;
                
                
                result = '';
                for(String productType:productTypes)
                {
                    result += productType;
                    result += ';';
                }
                if(result.endsWith(';')) result = result.substring(0,result.lastIndexOf(';'));
                updatedOpportunityMap.get(opp.Id).Opportunity_Product_Types__c = result;   
    
                result = '';
                for(String productChange:productChanges)
                {
                    result += productChange;
                    result += ';';
                }
                if(result.endsWith(';')) result = result.substring(0,result.lastIndexOf(';'));
                // commented out by Dominic if(result.contains('Partial Upgrade') && upgradeOnly == true) result = result.replace('Partial Upgrade','Upgrade Only');
                updatedOpportunityMap.get(opp.Id).Opportunity_Product_Changes__c = result;   
            }
        }
        System.debug('*** setCollaborateOpportunityProducts -- Context Ends -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    }

    //Updates the Opportunity with the platform of the products
    private void setOpportunityPlatform(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {
        System.debug('*** setOpportunityPlatform -- Context Starts -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    
        Set<Id> opportunityIds = new Set<Id>();
        
        //Replicated Renewal Opportunity
        Id repid='01270000000Hn7X';
    
        //Store opportunityIds for each open Collaborate Opportunity
        for(Opportunity opp : updatedOpportunities)
        {
           if(opp.isClosed == False && opp.HasOpportunityLineItem == True&& opp.recordtypeid!=repid) opportunityIds.add(opp.Id); // Changed by Dominic because taking out recurrsive loop broke this
        // else if(opp.is_Collaborate_Opportunity__c== 'True')opp.Platform__c='Collaborate';  
        }
    
        if(opportunityIds.size() > 0)
        {
            for (Opportunity opp : [SELECT Id, Platform__c, (SELECT Id, PriceBookEntry.Product2.Platform__c FROM OpportunityLineItems WHERE PriceBookEntry.Product2.Platform__c != null) 
                                    FROM Opportunity
                                    WHERE Id IN :opportunityIds])
            {
                //Lists the platforms for attached products (e.g. Learn, Collaborate)
                Set<String> productsPlatforms = new Set<String>();
    
                for (OpportunityLineItem lineItem: opp.OpportunityLineItems)
                {
                    productsPlatforms.add(lineItem.PriceBookEntry.Product2.Platform__c);
                }
                String result = '';
                for(String productsPlatform:productsPlatforms)
                {
                    result += productsPlatform;
                    result += ';';
                }
                if(result.endsWith(';')) result = result.substring(0,result.lastIndexOf(';'));
                updatedOpportunityMap.get(opp.Id).Platform__c = result;
            }
        }
        System.debug('*** setOpportunityPlatform -- Context Ends -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    }


    //Updates Opportunity Territory when the owner is changed
    private void updateTerritoryWhenOwnerIsChanged(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {
        System.debug('*** updateTerritoryWhenOwnerIsChanged -- Context Starts -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    
        Set<Id> accountIds = new Set<Id>();
        List<Opportunity> validOpps = new List<Opportunity>();
    
        //Store opportunityIds for each Opportunity
        for(Opportunity opp : updatedOpportunities)
        {
           // if it is not closed and the Owner ID field is changing    
           if(opp.IsClosed == False && updatedOpportunityMap.get(opp.Id).OwnerId != oldOpportunityMap.get(opp.Id).OwnerId)
           {
               accountIds.add(opp.AccountId);
               validOpps.add(opp);
           } 
        }
        if(accountIds.size() > 0)
        {
            List<AccountShare> accountShareList = [SELECT UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = 'Territory' AND AccountId IN :accountIds];
            Set<Id> accountShareGroupIds = new Set<Id>();
            for(AccountShare accountShare:accountShareList) accountShareGroupIds.add(accountShare.UserOrGroupId);
            if(accountShareGroupIds.size() > 0)
            {
                Map<Id,Group> groupMap = new Map<Id,Group>([SELECT RelatedId, Name, OwnerId FROM Group WHERE Id IN :accountShareGroupIds]);
                Set<Id> territoryIds = new Set<Id>();
                for(Group g:groupMap.values()) territoryIds.add(g.RelatedId);
                
                Map<Id,Territory> territoryMap = new Map<Id,Territory>([SELECT Id, ForecastUserId FROM Territory WHERE Id IN :territoryIds]);
                System.debug('ValidOpps'  + territoryIds.size());
                if(accountShareGroupIds.size() > 0)
                {
                    // Jon Lal: changed to only work on validOpps (not updatedOpportunities)
                    for (Opportunity opp : validOpps) {
                        opp.TerritoryId = null;
                        for(AccountShare accountShare:[SELECT UserOrGroupId, AccountId FROM AccountShare WHERE RowCause = 'Territory' AND AccountId = :opp.AccountId]) 
                        {
                            if(opp.AccountId == accountShare.AccountId && groupMap.get(accountShare.UserOrGroupId) != null && groupMap.get(accountShare.UserOrGroupId).RelatedId != null &&  territoryMap.get(groupMap.get(accountShare.UserOrGroupId).RelatedId).ForecastUserId == opp.OwnerId)
                            opp.TerritoryId = groupMap.get(accountShare.UserOrGroupId).RelatedId;
                        }
                    }
                
                }
                 
            }
        }
        System.debug('*** updateTerritoryWhenOwnerIsChanged -- Context Ends -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    }
    
    //creates notification to the Sales Team Members when Sales Team assigned is checked
    private void collaborateSalesTeamAssignmentNotification(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {
        System.debug('*** collaborateSalesTeamAssignmentNotification -- Context Starts -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());

        Set<Id> oppIds = new Set<Id>();
        List<Task> tasks = new List<Task>();
        
        // interate through Opportunities
        for(Opportunity opp : updatedOpportunities){
        //if(opp.is_Collaborate_Opportunity__c == 'True' && opp.isClosed == False && opp.Sales_Team_assigned__c == True && updatedOpportunityMap.get(opp.Id).Sales_Team_assigned__c != oldOpportunityMap.get(opp.Id).Sales_Team_assigned__c) oppIds.add(opp.Id);
        if(opp.Platform__c != null && opp.Platform__c.contains('Collaborate') && opp.isClosed == False && opp.Sales_Team_assigned__c == True && updatedOpportunityMap.get(opp.Id).Sales_Team_assigned__c != oldOpportunityMap.get(opp.Id).Sales_Team_assigned__c) oppIds.add(opp.Id);
        
        
        }
        
        if(oppIds.size() > 0)
        {
            
            List<OpportunityTeamMember> salesTeamMap = [SELECT Id, UserId, User.Email, OpportunityId FROM OpportunityTeamMember WHERE TeamMemberRole IN ('Collaborate ICS','Collaborate TSM') AND OpportunityId IN : oppIds];
            
            for(OpportunityTeamMember otm:salesTeamMap)
            {
                tasks.add(new Task(WhatId =  otm.OpportunityId, Subject = 'You have been assigned to the Sales Team', ActivityDate = Date.today(), OwnerId = otm.UserId, Type = 'Other'));
            }
            
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = true;
            if(tasks.size() > 0) database.insert(tasks, dlo);
        }
        System.debug('*** collaborateSalesTeamAssignmentNotification -- Context Ends -- SOQL Queries : '  + Limits.getQueries()  + '/' + + Limits.getLimitQueries());
    }    
    
     //creates task for MoodleRoom Team
   private void createTaskMoodleRoomTeam(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {

        Set<Id> wonOppIds = new Set<Id>();
        Set<Id> lostOppIds = new Set<Id>();
        List<Task> tasks = new List<Task>();
        
        for(Opportunity opp : updatedOpportunities){
        if(opp.Platform__c != null && opp.Platform__c.contains('Moodlerooms') && opp.isClosed == true && updatedOpportunityMap.get(opp.Id).isClosed != oldOpportunityMap.get(opp.Id).isClosed && updatedOpportunityMap.get(opp.Id).StageName != oldOpportunityMap.get(opp.Id).StageName && updatedOpportunityMap.get(opp.Id).StageName == '(W) Won' && (opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ New Sales Opportunity Record Type').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ New Sales Opportunity Record Type (Locked)').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type (Locked)').getRecordTypeId()))  
        wonOppIds.add(opp.Id);
        if(opp.Platform__c != null && opp.Platform__c.contains('Moodlerooms') && opp.isClosed == true && updatedOpportunityMap.get(opp.Id).isClosed != oldOpportunityMap.get(opp.Id).isClosed && updatedOpportunityMap.get(opp.Id).StageName != oldOpportunityMap.get(opp.Id).StageName && updatedOpportunityMap.get(opp.Id).StageName == '(L) Lost' && (opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type (Locked)').getRecordTypeId()))  
        lostOppIds.add(opp.Id);
        }
        
        if(wonOppIds.size() > 0)
        {
            
          list<GroupMember> gmList =  [Select g.UserOrGroupId, g.Id, g.Group.DeveloperName, g.GroupId From GroupMember g where g.Group.DeveloperName='MoodleRoom_Team'];
          list<Opportunity> oppList = [Select Id,Name from Opportunity where id in:wonOppIds];
          
          for(Opportunity o: oppList)
           {
            for(GroupMember gm:gmList)
            {
                tasks.add(new Task(WhatId =  o.Id, 
                                  Subject = 'Opportunity Moved to Closed Won', OwnerId = gm.UserOrGroupId,Priority ='Normal',Status='Not Started',ActivityDate = Date.today() + 5 ));
            }
            
           }
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            if(tasks.size() > 0) database.insert(tasks, dlo);
        }
        
        if(lostOppIds.size() > 0)
        {
            
          list<GroupMember> gmList =  [Select g.UserOrGroupId, g.Id, g.Group.DeveloperName, g.GroupId From GroupMember g where g.Group.DeveloperName='MoodleRoom_Team'];
          list<Opportunity> oppList = [Select Id,Name from Opportunity where id in:lostOppIds];
          
          for(Opportunity o: oppList)
           {
            for(GroupMember gm:gmList)
            {
                tasks.add(new Task(WhatId =  o.Id, 
                                  Subject = 'Opportunity Moved to Closed Lost', OwnerId = gm.UserOrGroupId,Priority ='Normal',Status='Not Started',ActivityDate = Date.today() + 5 ));
            }
            
           }
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            if(tasks.size() > 0) database.insert(tasks, dlo);
        }
    }  
    
    
     //creates task for Connect Team
    private void createTaskConnectTeam(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {

        Set<Id> wonOppIds = new Set<Id>();
        Set<Id> lostOppIds = new Set<Id>();
        List<Task> tasks = new List<Task>();
        
        for(Opportunity opp : updatedOpportunities){
        if(opp.Platform__c != null && opp.Platform__c.contains('Connect') && opp.isClosed == true && updatedOpportunityMap.get(opp.Id).isClosed != oldOpportunityMap.get(opp.Id).isClosed && updatedOpportunityMap.get(opp.Id).StageName != oldOpportunityMap.get(opp.Id).StageName && updatedOpportunityMap.get(opp.Id).StageName == '(W) Won' && (opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ New Sales Opportunity Record Type').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ New Sales Opportunity Record Type (Locked)').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type (Locked)').getRecordTypeId()))  
        wonOppIds.add(opp.Id);
        if(opp.Platform__c != null && opp.Platform__c.contains('Connect') && opp.isClosed == true && updatedOpportunityMap.get(opp.Id).isClosed != oldOpportunityMap.get(opp.Id).isClosed && updatedOpportunityMap.get(opp.Id).StageName != oldOpportunityMap.get(opp.Id).StageName && updatedOpportunityMap.get(opp.Id).StageName == '(L) Lost' && (opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type').getRecordTypeId() || opp.recordtypeId == Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName().get('CPQ Renewal Opportunity Record Type (Locked)').getRecordTypeId()))  
        lostOppIds.add(opp.Id);
        }
        
        if(wonOppIds.size() > 0)
        {
            
          list<GroupMember> gmList =  [Select g.UserOrGroupId, g.Id, g.Group.DeveloperName, g.GroupId From GroupMember g where g.Group.DeveloperName='MoodleRoom_Team'];
          list<Opportunity> oppList = [Select Id,Name from Opportunity where id in:wonOppIds];
          
          for(Opportunity o: oppList)
           {
            for(GroupMember gm:gmList)
            {
                tasks.add(new Task(WhatId =  o.Id, 
                                  Subject = 'Opportunity Moved to Closed Won', OwnerId = gm.UserOrGroupId,Priority ='Normal',Status='Not Started',ActivityDate = Date.today() + 5 ));
            }
            
           }
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            if(tasks.size() > 0) database.insert(tasks, dlo);
        }
        
        if(lostOppIds.size() > 0)
        {
            
          list<GroupMember> gmList =  [Select g.UserOrGroupId, g.Id, g.Group.DeveloperName, g.GroupId From GroupMember g where g.Group.DeveloperName='Connect_Team'];
          list<Opportunity> oppList = [Select Id,Name from Opportunity where id in:lostOppIds];
          
          for(Opportunity o: oppList)
           {
            for(GroupMember gm:gmList)
            {
                tasks.add(new Task(WhatId =  o.Id, 
                                  Subject = 'Opportunity Moved to Closed Lost', OwnerId = gm.UserOrGroupId,Priority ='Normal',Status='Not Started',ActivityDate = Date.today() + 5 ));
            }
            
           }
            Database.DMLOptions dlo = new Database.DMLOptions();
            dlo.EmailHeader.triggerUserEmail = false;
            if(tasks.size() > 0) database.insert(tasks, dlo);
        }
    }     
    
    // set the last interaction flag
    private void updateOpportunityInteractionFlag(Opportunity[] opportunities)
    {
        for(Opportunity opp : opportunities)
        {
            //Current user
            Id userProfile = UserInfo.getProfileId();
            // Bb API User Profile
            Id apiProfile = '00e70000000zlf8AAA';
            
            if (userProfile != apiProfile )
            {    
                if (opp.last_interaction_flag__c == false)
                {
                    opp.last_interaction_dttm__c = System.now();
                    opp.last_interaction_flag__c = True;  
                    opp.last_interaction_user__c = UserInfo.getUserId();
                }
            }
        }    
    }
    
    // copy OwnerId field to Owner__c for Owner__r binding
    private void updateOpportunityOwnerRelationship(Opportunity[] opportunities)
    {
        for(Opportunity opp : opportunities) opp.Owner__c = opp.OwnerId;
    }

    // set the page layout for different buttons
    private void updateOpportunityPageLayout(Opportunity[] opportunities)
    {
        String requestQuoteBtn = '01270000000DpOtAAK';
        String modifyQuoteBtn  = '01270000000DtTJAA0';  
        String transact_rec    = '01270000000DxPMAA0';        
        String phaseOne        = '01270000000DeXiAAK';
        
        for(Opportunity opp : opportunities)
        {
        
            // only alter record types where the RecordTypeId field is not checked
            if ( opp.Record_Type_Locked__c == false )
            {
            
                // only alter recotd types that are the orig phase 2 ones
                // No longer look at Owner__r.P2_Opportunity_Enabled__c flag
                
                if  ( opp.RecordTypeId == requestQuoteBtn || opp.RecordTypeId == modifyQuoteBtn )
                {
                    // on the switch to create quote the modify button will appear
                    if  ( opp.Psft_Integration_Stage__c  == 'Create Quote' || opp.Psft_Integration_Stage__c == 'Pending Quote'  || opp.Closed_in_Psft__c ) opp.RecordTypeId = modifyQuoteBtn;
                    // show the req quote button
                    else opp.RecordTypeId = requestQuoteBtn;
                }
                
            }
        }  
    }  


    // set the integration and fin ops stages
    private void updateOpportunityIntegrationStage(Opportunity[] opportunities)
    {
        Id xsell_slave_recType = '01270000000HhWtAAK'; // PRD
    
        for(Opportunity opp : opportunities)
        {
            // only do this if the oppr is flagged for it.
            // need a change to skip Cross-sell Slave Opportunities
            if ( opp.PeoplesoftIntegration__c == 'true'  && opp.RecordTypeId != xsell_slave_recType) 
            {

                // if the integration stage is null or lost
                if ( opp.Psft_Integration_Stage__c == null || opp.Psft_Integration_Stage__c == 'Lost Opportunity')
                {
                    if (opp.StageName == '(D) Power Sponsor Qualification' || opp.StageName == '(C) Decision Due' || opp.StageName == '(B) Pending Contract' || opp.StageName == '(A) Signature Due' || opp.StageName == '(W) Won')
                    {
                        opp.Psft_Integration_Stage__c = 'Active Opportunity';  
                        opp.Finance_Ops_Stage__c = 'Active Opportunity';  
                    }
                }
                
                // if the Sales user sets StageName to (L) LOST
                if (opp.StageName == '(L) Lost' )  
                {
                    // always set fin ops to lost
                    opp.Finance_Ops_Stage__c = 'Lost Opportunity';
                
                    // The oppr is set to (L) Lost while in Act Opp, Create Quote with Quote Id, or Modify Quote
                    if (opp.Psft_Integration_Stage__c == 'Active Opportunity' || opp.Psft_Integration_Stage__c == 'Pending Quote' )
                    {
                        opp.Psft_Integration_Stage__c = 'Lost Opportunity';        
                    }
                
                    // The Sales person is requesting a quote while in (L) Lost stage.
                    if (opp.Psft_Integration_Stage__c == 'Create Quote')
                    {
                        opp.Finance_Ops_Stage__c = 'Quote';
                        opp.StageName = '(C) Decision Due';
                    }
                
                    // The Sales user is setting a Won Oppr to (L)OST
                    if (opp.Psft_Integration_Stage__c == 'Won Opportunity')
                    {
                        opp.Psft_Integration_Stage__c = 'Lost Opportunity';
                    }      
                }
            }
            // When the oppr is closed in PSFT, the finops stage and the 
            // psft_integration_stage are set by CastIron to Won and (W)on
            // Closed_in_Psft is also flagged as true.    
            // The Sales user should never set the Sfdc Opp to (W)on.           
        }   
    }

    // update the oppr channel partner from the account
    private void updateOpportunityChannelPartner(Opportunity[] opportunities)
    {
        // Create an empty array of Account Ids
        Set<Id> accountIds = new Set<Id>();
       
        // for every oppr 
        for(Opportunity opp : opportunities)
        {
            if(opp.AccountId != null) accountIds.add(opp.AccountId);
        }
    
        if(accountIds.size() > 0)
        { 
            Map<Id,Account> accounts = new Map<Id,Account>([SELECT Id, Reseller__c FROM Account WHERE Id in :accountIds]);
       
            for(Opportunity opp : opportunities)
            {
 //below two lines are added by nikhil           
              if(opp.AccountId != null)
               {
              if(accounts.get(opp.AccountId).Reseller__c!= Null )
              {
              system.debug('GGGGG' + accounts.get(opp.AccountId).Reseller__c);
              opp.Channel_Partner__c = accounts.get(opp.AccountId).Reseller__c;
             }
            }
           }   
        }
    }
   
    
    private void Kimblerulesevaluation(Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap) {
        list<Bb_ContractIntegrationStatus__c> bcontlist = [Select Id, Name, enum__c from Bb_ContractIntegrationStatus__c where enum__c = 'Send' LIMIT 1 ];
       
        Map<string, KimbleOne__Product__c > ProductMap = new Map<string, KimbleOne__Product__c >();
        Map<string, KimbleOne__DeliveryElement__c> OLIelementMap = new Map<string, KimbleOne__DeliveryElement__c>();
        Map<String,Boolean> ProductUsageGeneratedMap = new Map<String,Boolean>();
    
        list<KimbleOne__Product__c> Klist = [Select id, KimbleOne__ProductDomain__r.KimbleOne__RevenueGenerationModel__r.KimbleOne__IsUsageGenerated__c,SF_Product2__c, SF_ProductCode__c from KimbleOne__Product__c where KimbleOne__ProductDomain__r.KimbleOne__RevenueGenerationModel__r.KimbleOne__IsUsageGenerated__c =false];
        for(KimbleOne__Product__c kp: Klist){
            ProductMap.put(kp.SF_ProductCode__c,kp);
            //ProductUsageGeneratedMap.put(kp.SF_ProductCode__c,kp.KimbleOne__ProductDomain__r.KimbleOne__RevenueGenerationModel__r.KimbleOne__IsUsageGenerated__c);
        }   
    
        list<KimbleOne__DeliveryElement__c> OLIlist = [Select id, OpportunityLineItem__c, KimbleOne__Product__c, KimbleOne__Product__r.KimbleOne__ProductDomain__r.KimbleOne__RevenueGenerationModel__r.KimbleOne__IsUsageGenerated__c, KimbleOne__InvoicingCurrencyContractRevenue__c, KimbleOne__ContractRevenue__c from KimbleOne__DeliveryElement__c];
        for(KimbleOne__DeliveryElement__c oli: OLIlist){
            OLIelementMap.put(oli.OpportunityLineItem__c,oli);
            ProductUsageGeneratedMap.put(oli.OpportunityLineItem__c,oli.KimbleOne__Product__r.KimbleOne__ProductDomain__r.KimbleOne__RevenueGenerationModel__r.KimbleOne__IsUsageGenerated__c);
        
            
        }
 
        set<Id> OppIdset = new set<Id>();
        for(Id oppId : updatedOpportunityMap.keySet()){
            System.debug('====== stage'+updatedOpportunityMap.get(oppId).StageName);
            if(updatedOpportunityMap.get(oppId).StageName != oldOpportunityMap.get(oppId).StageName && updatedOpportunityMap.get(oppId).StageName == '(W) Won')
              OppIdset.add(oppId);
        }
       
        System.debug('====== OppIdset'+OppIdset);
       
        Map<Id, List<OpportunityLineItem>> oppIdOLIListMap = new Map<Id, List<OpportunityLineItem>>();
       
        list<OpportunityLineItem> oppLineitemslist = [Select id, Name,Opportunity.StageName, OpportunityId, Product2Id, Product2.ProductCode, totalprice
                                                      from OpportunityLineItem
                                                      Where OpportunityId IN :OppIdset];
       
        System.debug('======== oppLineitemslist'+oppLineitemslist);
       
        if(oppLineitemslist != null && oppLineitemslist.size() > 0) {
            for(OpportunityLineItem oli : oppLineitemslist) {
                List<OpportunityLineItem> tempList = oppIdOLIListMap.get(oli.OpportunityId);
                if(tempList == null) {
                    tempList = new List<OpportunityLineItem>();
                    oppIdOLIListMap.put(oli.OpportunityId, tempList);
                }
                tempList.add(oli);
            }
        }
       
        /*for(OpportunityLineItem oliitem: oppLineitemslist){
            if(ProductMap.keyset().contains(oliitem.Product2Id)){
                if(OLIelementMap.keyset().contains(oliitem.Id)){
                    //valid scenario
                    opportunity opp = new opportunity(id=oliitem.opportunity.Id);
                   
                }
                else{
                    oliitem.addError('Kimble mapping is wrong, please check!');
                }
            }
        }*/
      
        for(Id oppId : OppIdset) {
            List<OpportunityLineItem> oliListS = oppIdOLIListMap.get(oppId);
            if(oliListS != null && oliListS.size() > 0) {
                Boolean validated = null;
              
                
                for(OpportunityLineItem oliitem: oliListS) {
                    System.debug('====== ProductMap.keyset() ======='+ProductMap.keyset());
                    System.debug('====== oliitem.Product2.ProductCode ======='+oliitem.Product2.ProductCode);
                  if(ProductMap.keyset().contains(oliitem.Product2.ProductCode)){
                       
                        System.debug('====== entering ======='+OLIelementMap.keySet());
                        System.debug('------IsUsageGeneratedFlag---'+ProductUsageGeneratedMap.get(oliitem.Id));
                        if(OLIelementMap != null && OLIelementMap.keyset().contains(oliitem.Id) ){
                            system.debug('entering into this if condition');
                            //valid scenario 
                            system.debug('oliItem Price ....'+ oliitem.totalprice);
                            system.debug('oliItem Price ....'+ oliitem.totalprice.setScale(2, RoundingMode.HALF_UP));                           
                            system.debug('entering into this if condition'+OLIelementMap.get(oliitem.Id));
                            system.debug('entering into this if condition'+OLIelementMap.get(oliitem.Id).KimbleOne__InvoicingCurrencyContractRevenue__c);
                            system.debug('ProductUsageGeneratedMap.get(oliitem.Id).. ....'+ ProductUsageGeneratedMap.get(oliitem.Id));
                        
                               if((oliitem.totalprice.setScale(2, RoundingMode.HALF_UP) == OLIelementMap.get(oliitem.Id).KimbleOne__InvoicingCurrencyContractRevenue__c) && (ProductUsageGeneratedMap.get(oliitem.Id) == false)){
                                    validated = true;
                                    system.debug('entering into this if condition 1'+validated);
                                }
                                else if((oliitem.totalprice == 0.00 && OLIelementMap.get(oliitem.Id).KimbleOne__InvoicingCurrencyContractRevenue__c <=1.00 ) && (ProductUsageGeneratedMap.get(oliitem.Id) == false)){
                                    validated = true;
                                    system.debug('entering into this if condition 1'+validated);
                                }
                                else if(ProductUsageGeneratedMap.get(oliitem.Id) == false)
                                {
                                    System.debug('====== validated ======='+validated);
                              validated = false;
                              updatedOpportunityMap.get(oppId).addError('Kimble mapping is wrong.Please check the Total Price! Here is the link to Opportunity Product: <a href="/' + oliitem.Id + '";>'+oliitem.Name+'</a>',false);
                            //updatedOpportunityMap.get(oppId).addError('ERROR:<a href=\'oliitem.Id\'>oliitem.Name</a>', false);
                           
                                }
                       
                        }
                        else {
                            System.debug('====== validated ======='+validated);
                            validated = false;
                            updatedOpportunityMap.get(oppId).addError('Kimble mapping is wrong.Please check! Here is the link to Opportunity Product: <a href="/' + oliitem.Id + '";>'+oliitem.Name+'</a>',false);
                            //updatedOpportunityMap.get(oppId).addError('ERROR:<a href=\'oliitem.Id\'>oliitem.Name</a>', false);
                           
                            
                            
                        }
                    }
                }
                System.debug('======Finally validated ======='+validated);
               
                if(validated != null && validated) {
                    opportunity opp = updatedOpportunityMap.get(oppId);
                    opp.Bb_contractIntegrationStatus__c = bcontlist[0].Id;
                    System.debug('======opp.Bb_contractIntegrationStatus__c ======='+opp.Bb_contractIntegrationStatus__c);                  
                }
               
                if(validated == null ){
                opportunity opp = updatedOpportunityMap.get(oppId);
                   opp.Bb_contractIntegrationStatus__c = bcontlist[0].Id;
                   System.debug('======opp.Bb_contractIntegrationStatus__c ======='+opp.Bb_contractIntegrationStatus__c);
                }
                System.debug('======Finally validated ======='+validated);
            }
           
    
    
        }
       
    }
    

    // update_transact_forecast_category_name
    private void updateTransactForecastCategoryName(Opportunity[] opportunities)
    {
        Map<String,String> stages = new Map<String,String>();
        stages.put('(S) Suspect Qualification', 'Omitted');  
        stages.put('(E) Sponsor Qualification', 'Pipeline');  
        stages.put('(D) Power Sponsor Qualification', 'Best Case');      
        stages.put('(C) Decision Due', 'Best Case');  
        stages.put('(B) Pending Contract', 'Commit');  
        stages.put('(A) Signature Due', 'Commit');  
        stages.put('(W) Won', 'Closed');  
        stages.put('(L) Lost', 'Omitted');  
      
        // Only for Transact
        for(Opportunity opp : opportunities )
        {
            if(opp.Line_of_Business__c == 'Transact') opp.ForecastCategoryName = stages.get(opp.StageName);
        }
    }

    // replace WF_FIELD_UPDATE for set picklist value
    private void stampApprovalBlock(Opportunity[] opportunities)
    {
        for(Opportunity opp : opportunities)
        {
          if(opp.Approval_Count__c >= 1 && opp.Approval_Block__c != 'Do Not Allow Product Edits') opp.Approval_Block__c = 'Do Not Allow Product Edits';
          if(opp.Approval_Count__c == 0 && opp.Approval_Block__c != 'Allow Product Edits') opp.Approval_Block__c = 'Allow Product Edits';
        }
    }
    
    private void CPQcontractstatuscheck(Opportunity[] opportunities)
    {
        
        set<Id> Idset = new set<Id>();
        for(Opportunity opp: opportunities){
                Idset.add(opp.Id);

        }

        list<Partner> partnerList = [Select id, OpportunityId from Partner Where OpportunityId IN: Idset];

        for(Opportunity opp : opportunities)
        {
         
              if((opp.CPQ_Contract_Status__c == 'Request Contract Generation') && (!Contract_Status_Countries__c.getAll().ContainsKey(opp.Account_Country__c))){
                    if((opp.CPQ_Partner_Billing_Instructions__c == null) || (opp.CPQ_Partner_Billing_Instructions__c == '--None--') || (partnerList.size() == 0)){
                        opp.addError('Partner Billing Instructions & Partner Related List cannot be null');
                    }

              }
           
        }
    }

    
    private void updateBbContractIntegrationStatus(Opportunity[] opportunities)
    {
        list<Bb_ContractIntegrationStatus__c> blist = [Select id, Name, enum__c from Bb_ContractIntegrationStatus__c where enum__c = 'Pending' LIMIT 1 ];
        
        system.debug('Murugappan'+blist);
        for(Opportunity opp : opportunities)
        {
            if(blist!=Null)
            {
                 opp.Bb_contractIntegrationStatus__c = blist[0].Id;
            }     
           system.debug('Alagappan'+opp.Bb_contractIntegrationStatus__c );
         
        }
    }
    
    
    
    // For renewal record type flip
    private void renewalCheckAndFlip(Opportunity[] opportunities)
    {
        Id renewalRecType = '01270000000Hi47';              //PRD
        Id renewalRecTypeWithNotice = '01270000000Hi48';    //PRD
        Id cpqNewRecordTypeId = '01270000000Hlam'; //PRD
        Id cpqRenewRecordTypeId = '01270000000Hlar'; //PRD
        Id cpqRenewRecordtypelockedId='01270000000HldX';//PRD
        Id cpqSalesRecordtypelockedId='01270000000HldW';//PRD        
        for(Opportunity opp : opportunities)
        { 
            if (opp.HoldReasonCheck__c == 0) {
                opp.FinanceReviewed__c = False;
            } 
            else {
                opp.FinanceReviewed__c = True; 
                if (opp.RecordTypeId != cpqNewRecordTypeId && opp.RecordTypeId != cpqRenewRecordTypeId  && opp.RecordTypeId != cpqRenewRecordtypelockedId  && opp.RecordTypeId != cpqSalesRecordtypelockedId)
                {       
                    opp.RecordTypeId = renewalRecTypeWithNotice;
                }
            }
        }
    }

    /* April 5, 2012 - need to break crossSellOpp for insert to before and after insert */
    


    
    /* cross sell create and update */
    /* Jon Lal - Changes - Jan 13, 2012 */
 
    private void crossSellOpportunity( Opportunity[] updatedOpportunities )
    {
        Id renewalRecType1    = '01270000000Hi47AAC';
        Id renewalRecType2    = '01270000000Hi48AAC';
        Id phaseOneRecType    = '01270000000DeXiAAK';
        Id collaborateRecType = '01270000000HiZnAAK';
        Id transactRecType    = '01270000000DxPMAA0';  
        Id crossSellRecType   = '01270000000HhWtAAK';
        String crossSellType  = 'Cross-sell Out';
    
        
        Decimal crossSellOut_pct = 0.50;
  
        // TP 2419: This is reduced to 0.85 if the closedDate > 2012-07-05              
        Decimal crossSellIn_pct = 0.90;
  
        Decimal keyAccount_pct = 1.00;
        Decimal keyAccountParent_pct = 1.00;

        List<Opportunity> validOpportunities = new List<Opportunity>();
        Set<Id> opportunityIds = new Set<Id>();
        Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
        
        List<Opportunity> newCrossSellIn = new List<Opportunity>();
        List<Opportunity> existingCrossSellIn = new List<Opportunity>();
        Set<Id> existingCrossSellOutIds = new Set<Id>();
        Set<Id> existingCrossSellInIds = new Set<Id>(); 
        
        Date StartDt =  date.valueOf('2011-01-01');
                        
        for (Opportunity opp : updatedOpportunities)
        {
            if (   opp.RecordTypeId != renewalRecType1 
                && opp.RecordTypeId != renewalRecType2 
                && opp.RecordTypeId != crossSellRecType
                && opp.CloseDate >= StartDt
                
                // Skip BD-type opportunites
                && opp.Platform_Referral_To__c != 'BD - Barnes & Noble'
                
                // START> TP 2419:  allow cross-sell for this group
                // && opp.Platform_Referral_To__c != 'BD - Developmental Education'
                
                // Skip cross-sell for these groups
                && opp.Platform_Referral_To__c != 'BD - Wiley'
                && opp.Platform_Referral_To__c != 'BD - Pearson'
                && opp.Platform_Referral_To__c != 'BD - McGraw'
                && opp.Platform_Referral_To__c != 'BD - Cengage'
                // END> TP 2419
                                
                && opp.Platform_Referral_To__c != 'BD - Follett'
                && opp.Platform_Referral_To__c != 'BD - McGraw-Hill'
                && opp.Platform_Referral_To__c != 'BD - NBC Learn'
                && opp.Platform_Referral_To__c != 'BD - Kaltura'
                && opp.Platform_Referral_To__c != 'BD - Internships.com'    
                && opp.Platform_Referral_To__c != 'BD - Other Partners (NON-SPIFF)'
                && opp.Platform_Referral_To__c != 'BD - Highpoint Technology Solutions (Mobile)'
                
                
                // Valid for proccessing
                && ( 
                    (opp.Cross_sell_Type__c == 'Cross-sell In' && opp.Originating_User__c != null )  
                      || opp.Transfer_To_Rep__c != null  // first time a Trans to Rep is found
                      || opp.Cross_sell_Type__c == 'Key Account Parent' // subsequent KAP is found
                    )                        
                                
                )
                
            {   
                // Fill the List, the Set, the Map for Opportunities that are to be processed            
                validOpportunities.add(opp);
                system.debug('JLAL>>> This is being flaged as a Valid Opp: ' + opp.RecordTypeId);
                system.debug('JLAL>>> This is being flaged as a Valid Opp: ' + opp.Cross_sell_Type__c);
                system.debug('JLAL>>> This is being flaged as a Valid Opp: ' + opp.Originating_User__c);
                system.debug('JLAL>>> This is being flaged as a Valid Opp: ' + opp.CloseDate);
                system.debug('JLAL>>> This is being flaged as a Valid Opp: ' + validOpportunities);
                                
                // Skip those opps that don't have an Id yet and avoid filling in NULL
                if ( opp.Id != null )
                {
                    OpportunityIds.add(opp.Id);
                    OpportunityMap.put(opp.Id, opp);
                   system.debug('+++++iiii+++' + OpportunityIds); 
                }
            }
        }
        
        // Get a list of Cross Sell Out Opps that belong to the Set being processed
        List<Opportunity> existingCrossSellOutOpportunities = new List<Opportunity>();
        
        // June 5, 2012 - need to ensure sharing rules are correct to locate an exising cross-sell out.
        if ( OpportunityIds.size() > 0 )
        {
         system.debug('+++++mmmmm+++' + OpportunityIds);
         existingCrossSellOutOpportunities = [select Id, xsell_master_opportunity__c, Cross_Sell_Type__c, Quota_Value__c From Opportunity Where xsell_master_opportunity__c IN :OpportunityIds];
         system.debug('existingCrossSellOutOpportunities ' + existingCrossSellOutOpportunities);
        }
        

        // list of new Cross Sell Out Opps to be inserted later
        List<Opportunity> newCrossSellOutOpportunities = new List<Opportunity>();  

        // map CrossSellIn <ID> ---> CrossSellOut <ID>
        Map<Id,Id> existingCrossSellInToOutMap = new Map<Id, Id>();

        // mapp CrossSellOutID ---> <Opportunity>
        Map<Id, Opportunity> existingCrossSellOutMap = new Map <Id, Opportunity>();


        // process all the pre-existing Cross Sell Out Opportunies
        for (Opportunity outOpp : existingCrossSellOutOpportunities)
        {
            existingCrossSellInToOutMap.put(outOpp.xsell_master_opportunity__c, outOpp.Id);
            existingCrossSellOutMap.put(outOpp.Id, outOpp);
        }
        
        // June 5, 2012 - create a map of parent Opps and their owners for new cross sell outs
        
        

        // Create  lists; One that need Cross Sells to be created, others to be updated
        for (Opportunity inOpp : validOpportunities)
        {
            // reduce the Cross Sell In Quota to 90%
            // also do not run cross sell math if the override button is checked ( TP 2673)
            if(inOpp.Quota_Value_Override__c == false && inOpp.Cross_sell_Type__c == 'Cross-sell In' && inOpp.Amount != null)
            {
              // TP :2429,Commented by Nikhil. it has been replace by TP :4560
              
                //Second condition on if,Added by Nikhil on 21st July 2013
                // START> TP 2419: reduce amount to 85% if after July 5, 2012
                if (inOpp.CloseDate > date.valueOf('2012-07-05') && inOpp.CloseDate < date.valueOf('2013-05-01') )
                {
                    crossSellIn_pct = 0.85;  
                }
                // END> TP 2419
               
               
               // Added by Nikhil on 21st July 2013
               // START> TP 4560: reduce amount to 100% if after May 1, 2013
                if (inOpp.CloseDate > date.valueOf('2013-05-01') )
                {
                    crossSellIn_pct = 1.0;  
                }
                // END> TP 2419
                // If statement put in to fix null pointer
                //Commmented as no need
                /*
                if (inOpp.Quota_Value__c == null)
                {
                    inOpp.Quota_Value__c = 0;
                }
                inOpp.Quota_Value__c = inOpp.Quota_Value__c * crossSellIn_pct;
               */ 
            }
            
            
            // list of CrossSellIn that already have a crossSellOut
            if ( existingCrossSellInToOutMap.containsKey (inOpp.Id) )
            {
               System.debug('valid opp' +inOpp.Id);
                Opportunity outOpp = existingCrossSellOutMap.get( existingCrossSellInToOutMap.get(inOpp.Id) );

                // Key account & key Account Parent 
                if (outOpp.Cross_sell_Type__c == 'Key Account' )
                {
                    // 100%
                    crossSellIn_pct = keyAccountParent_pct;
                    crossSellOut_pct = keyAccount_pct;
                    
                }
                else
                {
                    // Only change 
                    outOpp.OwnerId = inOpp.Originating_User__c;              
                }
                
                outOpp.AccountId = inOpp.AccountId;
                outOpp.Name = 'Cross-sell - ' + inOpp.Name;
                outOpp.CloseDate = inOpp.CloseDate;
                outOpp.StageName = inOpp.StageName;
                
                outOpp.Closed_in_PSFT__c = inOpp.Closed_in_PSFT__c;
                outOpp.Probability = inOpp.Probability;
                outOpp.Closed_Loss_Won_Reason_Detail__c = inOpp.Closed_Loss_Won_Reason_Detail__c;
                outOpp.Won_from__c = inOpp.Won_from__c;
                outOpp.Lost_to__c = inOpp.Lost_to__c;
                outOpp.PSFT_Integration_stage__c = null;
                outOpp.CurrencyIsoCode = inOpp.CurrencyIsoCode;
                outOpp.Competitor__c = inOpp.Competitor__c;
                outOpp.Primary_Contact__c = inOpp.Primary_Contact__c;
                outOpp.Primary_Contact_Assigned__c = true;
                
                // The Cross Sell Out needs to be 5/9ths of the Cross Sell In Opp QV

                // added TP 2673
                // only update the Cross-sell Out opp's quota value if the override on the Cross-sell in Opp is false
                //Commmented as no need
               
               // if (inOpp.Quota_Value_Override__c == false && inOpp.Quota_Value__c != null ) outOpp.Quota_Value__c = inOpp.Quota_Value__c * ( crossSellOut_pct / crossSellIn_pct );


            }



            
            // New Cross Sell Ins that need a new Cross Sell Out generated;
            else
            {  
                // need to set the percentages outside the if stmt for KAP / KA
                if (inOpp.Transfer_To_Rep__c != null || inOpp.Cross_sell_Type__c == 'Key Account Parent' )
                {
                    crossSellIn_pct = keyAccountParent_pct;
                    crossSellOut_pct = keyAccount_pct;
                    crossSellType = 'Key Account';
                    
                    // run when the parent is writable
                    if  (trigger.isBefore)
                    {
                        /* START -->  Here is where the inOpp fields are written to */
                        system.debug('JLAL > Start of parent changes');
                                           
                        inOpp.Cross_sell_Type__c = 'Key Account Parent';
                    
                    
                        // The first time that parent generates a cross sell out
                        if ( inOpp.Transfer_To_Rep__c != null )
                        {
                        
                            // change the rec type so that the transfer to rep looks at a familiar screen
                            // UI manipulation, only work on human entry

                            List<User> userInfo = new List<User> ([Select Id,  Line_of_Business__c From User Where Id = :inOpp.Transfer_to_Rep__c Limit 1]);
                            String lineOfBusiness = userInfo[0].Line_of_Business__c;
                            
                            if (lineOfBusiness == 'Transact')
                            {
                                inOpp.Record_Type_Locked__c = true;
                                inOpp.RecordTypeId = transactRecType;
                            }
                            else if (lineOfBusiness == 'Collaborate')
                            {
                                inOpp.RecordTypeId = collaborateRecType;                                
                            }
                            else if (lineOfBusiness == 'Student Services' || lineOfBusiness == 'Connect')
                            {
                                inOpp.Record_Type_Locked__c = true;
                                inOpp.RecordTypeId = phaseOneRecType;
                            }                 

                        
                            inOpp.Originating_User__c = inOpp.OwnerId;
                            inOpp.OwnerId = inOpp.Transfer_To_Rep__c;
                            inOpp.Transfer_To_Rep__c = null;
                            inOpp.Sales_Team_Id__c = null;
                        
                        }
                        system.debug('JLAL > end of parent changes');
                        /* END -->  Here is where the inOpp fields are written to */         
            
                    }
                
               } 
                   
               // don't run this before Insert - it will fail
               // it needs to run after insert with inOpp.Id is present
               if(inOpp.Id != null)
               {
                   system.debug('JLAL > Creating a new cross sell out opp if inOpp.Id is present');
                   Opportunity outOpp = new Opportunity();
                   outOpp.AccountId = inOpp.AccountId;                
                   outOpp.Name = 'Cross-sell - ' + inOpp.Name;
                   outOpp.Cross_sell_Type__c = crossSellType;
                   outOpp.CloseDate = inOpp.CloseDate;
                   outOpp.StageName = inOpp.StageName;
                   outOpp.OwnerId = inOpp.Originating_User__c;
                   outOpp.Closed_in_PSFT__c = inOpp.Closed_in_PSFT__c;
                   outOpp.Record_Type_Locked__c = true;
               
                   // this fails before insert
                   outOpp.xsell_master_opportunity__c = inOpp.Id;
               
               
                   outOpp.RecordTypeId = crossSellRecType;
                   outOpp.Probability = inOpp.Probability;
                   outOpp.Closed_Loss_Won_Reason_Detail__c = inOpp.Closed_Loss_Won_Reason_Detail__c;
                   outOpp.Won_from__c = inOpp.Won_from__c;
                   outOpp.Lost_to__c = inOpp.Lost_to__c;
                   outOpp.CurrencyIsoCode = inOpp.CurrencyIsoCode;
                   outOpp.Competitor__c = inOpp.Competitor__c;
                   outOpp.Primary_Contact__c = inOpp.Primary_Contact__c;
                   outOpp.Primary_Contact_Assigned__c = true;
 
                   // The Cross Sell Out needs to be 5/9ths of the Cross Sell In Opp QV
                   //Commneted as no need
                   
                  // if (inOpp.Amount != null ) outOpp.Quota_Value__c = inOpp.Quota_Value__c * ( crossSellOut_pct / crossSellIn_pct );
               
                            
                   // add the current slave to a list to be inserted later.
                   newCrossSellOutOpportunities.add(outOpp);                
               }   
            }
                  
        }        
        update existingCrossSellOutOpportunities;
        insert newCrossSellOutOpportunities;            
        system.debug('times'  +newCrossSellOutOpportunities);

        // June 5,2012 - for every new cross-sell out oppr that is created, we need to add and entry to Opportunity_Share
        List<OpportunityShare> SharesToInsert = new List<OpportunityShare>();
        for (Opportunity eachNewOpp : newCrossSellOutOpportunities)
        {
            OpportunityShare OppShare = new OpportunityShare();
            OppShare.OpportunityId = eachNewOpp.Id;
            OppShare.OpportunityAccessLevel = 'Edit';
            //OppShare.RowCause = 'Cross-Sell Out';
            OppShare.UserOrGroupId = opportunityMap.get(eachNewOpp.xsell_master_opportunity__c).OwnerId;
            SharesToInsert.add(OppShare);           
 
        }
        insert SharesToInsert;
    }
    
    /* Jon Lal - February 28, 2012 - comment out */
    /* this is now obsolete as calculateQuotaValue runs for every Opp */    
    // Quota Value Fix
    /*
    private void updateOpportunityQuotaValue(Opportunity[] opportunities)
    {
        for (Opportunity opp : opportunities)
        {
           if ( opp.Cross_sell_Type__c == null ) opp.Cross_sell_Type__c = 'Home';
         
           // if there are products with prices.
           else if ( opp.Amount != null &&  opp.Cross_sell_Type__c == 'Home') opp.Quota_Value__c = opp.Amount;
        }
    }

    */


    // Update Transact dates
    private void updateTransacOpportunityQuotaValue(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap)
    {

        Set<Id> set_all_opps = new Set<Id>();
        List<Opportunity> list_all_opps = new List<Opportunity>();
        Map<Id, Opportunity> map_dld_opps = new Map<Id, Opportunity>();
        Map<Id, Opportunity> map_pdd_opps = new Map<Id, Opportunity>();
        Map<Id, Opportunity> map_psd_opps = new Map<Id, Opportunity>();
        
        for (Opportunity opp : updatedOpportunities)
        {
            if ( opp.ts_project_start_date__c != oldOpportunityMap.get(opp.Id).ts_project_start_date__c)
            {
                set_all_opps.add(opp.Id);
                list_all_opps.add(opp);
                map_psd_opps.put(opp.Id, opp);
            }
            if ( opp.ts_product_delivery_date__c != oldOpportunityMap.get(opp.Id).ts_product_delivery_date__c)
            {
                set_all_opps.add(opp.Id);
                list_all_opps.add(opp);
                map_pdd_opps.put(opp.Id, opp);
            }
            if ( opp.ts_desired_live_date__c != oldOpportunityMap.get(opp.Id).ts_desired_live_date__c)
            {
                System.Debug('In dld 1');
                set_all_opps.add(opp.Id);
                list_all_opps.add(opp);
                map_dld_opps.put(opp.Id, opp);
            }
                
        }
        List<OpportunityLineItem> list_of_lines = new List<OpportunityLineItem>(); 
        Map<Id, OpportunityLineItem> lines = new Map<Id, OpportunityLineItem>([SELECT Id, OpportunityId, ts_line_desired_live_date__c, ts_line_product_delivery_date__c, ts_line_project_start_date__c From OpportunityLineItem Where OpportunityId IN :set_all_opps]);
    
        // for every line belonging to a changed opp either because of one or more changed date fields.
        for(Id lineId :lines.keySet())
        {  
            
            Id parentOppId = lines.get(lineId).OpportunityId;
            System.debug(parentOppId);
            
            // psd changed
            if (map_psd_opps.containsKey(parentOppId) )
            {
                lines.get(lineId).ts_line_project_start_date__c = map_psd_opps.get(parentOppId).ts_project_start_date__c;
            }
            // pdd changed
            if (map_pdd_opps.containsKey(parentOppId) )
            {
                lines.get(lineId).ts_line_product_delivery_date__c = map_pdd_opps.get(parentOppId).ts_product_delivery_date__c;
            }        
            // dld changed
            if (map_dld_opps.containsKey(parentOppId) )
            {
                system.Debug('In dld 2');
                system.Debug(map_dld_opps.get(parentOppId).ts_desired_live_date__c);
                lines.get(lineId).ts_line_desired_live_date__c = map_dld_opps.get(parentOppId).ts_desired_live_date__c;
                
            }
            list_of_lines.add(lines.get(lineId));        
        }    
        update list_of_lines;
    }
    
    // Updates Last Next Step Update field
    private void updateOpportunityNextStep(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap)
    {
        for (Opportunity opp : updatedOpportunities)
        {
           if ( opp.NextStep !=  oldOpportunityMap.get(opp.Id).NextStep) opp.Last_Next_Step_Update__c = System.now();
         
        }
    }  
    
    /* Jon Lal - January 25, 2012 rewrite */
    /* Change in production Feb 14, 2012 */
    private void updateContactRoleCount(Opportunity[] opportunities)
    {

        // Get the Opps that we are updating        
        Set<Id> OpportunityIds = New Set<Id>();
        Map<Id, Integer> OppRoleCount = new Map<Id, Integer>();
        Map<Id, Boolean> OppHasPrimary = new Map<Id, Boolean>();
        
        
        for (Opportunity o : Opportunities)
        {
            OpportunityIds.add(o.Id);
            OppRoleCount.put(o.Id, 0);
            OppHasPrimary.put(o.Id, false);
        }
        
        // Get the Roles related to the opps
        List<OpportunityContactRole> ContactRoles = New List<OpportunityContactRole>([Select Id, OpportunityId, IsPrimary From OpportunityContactRole Where OpportunityId In : OpportunityIds]);


        // Itterate through list and fill Maps
        for (OpportunityContactRole ocr : ContactRoles)
        {       
            // if no primary found yet
            if (OppHasPrimary.get(ocr.OpportunityId) != true)
            {
                OppHasPrimary.put(ocr.OpportunityId , ocr.IsPrimary);
            }
            
            // increment count mapper
            OppRoleCount.put(ocr.OpportunityId , OppRoleCount.get(ocr.OpportunityId) + 1 );
            
        }

        
        
        
        // Stamp the fields
        for (Opportunity o : Opportunities)
        {
            o.Number_of_Contacts_Roles_Assigned__c = OppRoleCount.get(o.Id);
            o.Primary_Contact_Assigned__c = OppHasPrimary.get(o.Id);        
        }

    }
    /*** --- end re_write */
    
    
    /*  --- Commented out due to re-write
    private void updateContactRoleCount(Opportunity[] opportunities)
    {
        Boolean isPrimary;
        Integer iCount;
        for(Opportunity opp : Opportunities){
        isPrimary = False; 
        for (List<OpportunityContactRole> oppcntctrle :[select OpportunityId from OpportunityContactRole where (OpportunityContactRole.IsPrimary = True and OpportunityContactRole.OpportunityId = :opp.id)]){
            if (oppcntctrle.Size() >0){
                isPrimary = True;
            }   
        }
        iCount = 0;
        for (List<OpportunityContactRole> oppcntctrle2 : [select OpportunityId from OpportunityContactRole where (OpportunityContactRole.OpportunityId = :opp.id)]){    
            if (oppcntctrle2 .Size()>0){
                iCount= oppcntctrle2 .Size();     
            }
        }
        opp.Number_of_Contacts_Roles_Assigned__c = iCount;
        opp.Primary_Contact_Assigned__c =isPrimary; 
        }
        
    }
    --- */ 
   
    /* Jon Lal - January 12, 2012 */
    // Commented by Nikhil As No need after N/R Calculation.
    /*
    private void calculateQuotaValue(Opportunity[] updatedOpportunities)
    {
        
        // Do not process Cross Sell Opps - they have no lines.
        List<Opportunity> validOpportunities = new List<Opportunity>();
        for (Opportunity opp : updatedOpportunities)
        {
            // Add an override button to account for bundles
            // TP 2576 Quota_Value_Override__c (LAL - 8/8/2012)
            if (opp.Quota_Value_Override__c == false && opp.Cross_sell_Type__c != 'Cross-sell Out' && opp.Cross_sell_Type__c != 'Key Account' )
            {       
                validOpportunities.add(opp);
            }
        }
        
        
        Set<Id> Opportunities = new Set<Id>();
        Map<Id, Decimal> Running_Quota_Value = new Map<Id, Decimal>();
        for (Opportunity opp : validOpportunities)
        {
            if (opp.Id != null)
            {
                Opportunities.add(opp.Id);
                Running_Quota_Value.put(opp.Id, 0.00);
            }        
        }       

        List<OpportunityLineItem> OpportunityLineItems = new List<OpportunityLineItem>( );
       
        if ( Opportunities.size() > 0)
        {
            OpportunityLineItems = [Select Id, OpportunityId, PricebookEntry.Product2.Perpetual__c, PricebookEntry.Product2.Family, TotalPrice From OpportunityLineItem Where OpportunityId IN : Opportunities] ;
        }
        
        // Itterate through every line item and keep a running total in the Map for the opp
        for(OpportunityLineItem oli : OpportunityLineItems)
        {
            Decimal rt = 0.00;
            
            // Get the running total
            rt = Running_Quota_Value.get(oli.OpportunityId);
            
            if ( oli.PricebookEntry.Product2.Perpetual__c == 'true' && oli.PricebookEntry.Product2.Family == 'Non-Recurring Other')
            {
                rt = rt + oli.TotalPrice * 0.3333333333;
            }
            else
            {
                rt = rt + oli.TotalPrice;
            }
            Running_Quota_Value.put(oli.OpportunityId, rt);
        }   
        
        // Set the running total back to the opp
        for (Opportunity opp : validOpportunities)
        {
            opp.Quota_Value__c = Running_Quota_Value.get(opp.Id);              
        }   
        
        
    }
 */  
  private void TypeOpportunity(Opportunity[] updatedOpportunities)
   {     
   // user u1 =[select id,SalesReportingGroup__c from user where id = :UserInfo.getUserId()]; 
     set<id> opid = new set<id>();
     set<id> ownid= new set<id>();
    for(Opportunity op :updatedOpportunities)
      {
        opid.add(op.AccountId);
        ownid.add(op.OwnerId);
      }
   Map<ID, User> u1 = new Map<ID, User>([select id,SalesReportingGroup__c from User where id IN  : ownid]);    
   Map<ID, Account> Acc = new Map<ID, Account>([select id,Name,CustomerofLearn__c,CustomerofTransact__c,CustomerofMobile__c,CustomerofConnect__c,CustomerofStudentServices__c,CustomerofAnalytics__c,CustomerofCollaborate__c from Account where id IN  : opid]);    
   Id recid='01270000000HhWt';  
   Id Renrecid1='01270000000Hi47';
   Id Renrecid2='01270000000HjGZ';
   Id Renrecid3='01270000000Hi48';
   Id Renrecid4='01270000000DsgW';
   Id Renrecid5='01270000000Hlar'; // CPQ Renewal
   Id Renrecid6='01270000000HldW'; // CPQ New Locked 
   Id Renrecid7='01270000000HldX'; // CPQ Renewal Locked
   Id Renrecid8='01270000000Hn7X';
   Id Renrecid9='01270000000DpOtAAK';
   
   
   
    for(Opportunity opp :updatedOpportunities)
      {
       if(opp.RecordTypeId !=Renrecid9 && opp.RecordTypeId!=Renrecid8 && opp.RecordTypeId !=Renrecid7 &&opp.RecordTypeId !=Renrecid6 && opp.RecordTypeId !=Renrecid5 && opp.RecordTypeId !=recid && opp.RecordTypeId !=Renrecid1 && opp.RecordTypeId !=Renrecid2 &&  opp.RecordTypeId !=Renrecid3 && opp.RecordTypeId !=Renrecid4 && u1.get(opp.OwnerId).SalesReportingGroup__c!=Null)
        {
       if(opp.Accountid != Null)
          {
        if(acc.get(opp.AccountId).CustomerofLearn__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c.contains('Learn'))
          opp.Type='Expansion Business';
        if(acc.get(opp.AccountId).CustomerofLearn__c==FALSE && u1.get(opp.OwnerId).SalesReportingGroup__c.contains('Learn'))
          opp.Type='New Business';
        if(acc.get(opp.AccountId).CustomerofConnect__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Connect')
          opp.Type='Expansion Business';
        if(acc.get(opp.AccountId).CustomerofConnect__c==FALSE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Connect')
            opp.Type='New Business';
        if(acc.get(opp.AccountId).CustomerofTransact__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Transact')
           opp.Type='Expansion Business';
        if(acc.get(opp.AccountId).CustomerofTransact__c==FALSE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Transact' )
           opp.Type='New Business';
          if(acc.get(opp.AccountId).CustomerofMobile__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Mobile')
          opp.Type='Expansion Business';
        if(acc.get(opp.AccountId).CustomerofMobile__c==FALSE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Mobile' )
          opp.Type='New Business';
          if(acc.get(opp.AccountId).CustomerofAnalytics__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Analytics')
         opp.Type='Expansion Business';
        if(acc.get(opp.AccountId).CustomerofAnalytics__c==FALSE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Analytics' )
          opp.Type='New Business';
        if(acc.get(opp.AccountId).CustomerofStudentServices__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Student Services')
           opp.Type='Expansion Business';
        if(acc.get(opp.AccountId).CustomerofStudentServices__c==FALSE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Student Services' )
          opp.Type='New Business'; 
        if(acc.get(opp.AccountId).CustomerofCollaborate__c==TRUE && u1.get(opp.OwnerId).SalesReportingGroup__c=='Collaborate')
           {
             opp.Type='Expansion Business'; 
             //opp.Revenue_Type__c='Upsell';
           }   
          }
        }  
      }
   }   
     
        
    private void  updateSalesReportingGroup(Opportunity[] updatedOpportunities)
    {
      
      
       Set<id> usrid = new set<id>();
    
       for(Opportunity Oppp : updatedOpportunities)
       {
       usrid.add(Oppp.OwnerId);  
       }
       
        List<Opportunity> opp =[select id,OwnerId,Sales_Reporting_Group__c,Owner.SalesReportingGroup__c  from Opportunity where id IN : updatedOpportunities]; 
        for(Opportunity op : opp)
        {
            If(op.Owner.SalesReportingGroup__c  != Null)
             {
                    op.Sales_Reporting_Group__c =op.Owner.SalesReportingGroup__c ;
             }       
        } 
           
   } 
    
    // Writted by Dominic Baker on November 1, 2012    
    private void copyAccountFields(list<Opportunity> newList)
    {
        set<Id> accountIdSet = new set<Id>(); // This set will collect Account ids for the query
        map<Id, Account> accountMap; // This may will have the accounts and their ids as the key
        
        // This query will retrieve the account ids to be queried
        for (Opportunity o : newList)
        {
            if (o.AccountId != null)
            {
                accountIdSet.add(o.AccountId);
            }
        }
        
        // this query will fill the accountMap
        accountMap = new map<Id, Account>([Select Id, CPQ_PO_Required__c From Account Where Id IN : accountIdSet]);
        
        // This will set the Opportunity fields with the Account fields
        for (Opportunity o : newList)
        {
            if (o.AccountId != null && accountMap.containsKey(o.AccountId))
            {
                o.CPQ_PO_Required__c = accountMap.get(o.AccountId).CPQ_PO_Required__c;
                o.CPQ_Bill_To_Account_Name__c = o.AccountId;
                o.CPQ_Ship_To_Account_Name__c = o.AccountId;
            }
        }
    }
    
    // Written by Dominic Baker on November 8, 2012
    private void sumbitOpportunityForApproval(list<Opportunity> newList, list<Opportunity> oldList)
    {   
        for (Opportunity o : newList)
        {
            if (o.CPQ_Quote_Status__c == 'Pending Price Quote Approval')
            {
                try
                {
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    req1.setComments('Submitting request for approval.');
                    req1.setObjectId(o.id);
                    //req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                    Approval.ProcessResult result = Approval.process(req1);
                    system.assert(result.isSuccess());
                }
                catch (Exception e) {
                System.debug('++Approval++' + e);
                
                }
            }
        }
    }
    
    // Written by Dominic Baker on November 29, 2012
    private void validateCameleonOpportunities(list<Opportunity> newList, list<Opportunity> oldList)
    {
        map<Id, Opportunity> newMap = new map<Id, Opportunity>(newList);
        map<Id, Opportunity> oldMap = new map<Id, Opportunity>(oldList);
        map<Id, Account> accountMap;
        set<Id> accountIdSet = new set<Id>();
        set<Id> opportunityIdSet = new set<Id>();
        map<Id, list<Contact_Role_Selector__c>> connectorMap = new map<Id, list<Contact_Role_Selector__c>>(); // Opp Id is the key
        map<Id, list<OpportunityTeamMember>> teamMemberMap = new map<Id, list<OpportunityTeamMember>>(); // Opp Id is the key
        map<Id, OpportunityPartner> partnerMap = new map<Id, OpportunityPartner>(); // Only need one to validate
        Opportunity opp;
        Boolean hasPrimaryContact, hasSystemAdmin, hasNewRep, hasRenewRep;
        set<Id> cpqRecordTypeIdSetNew = new set<Id>();
        set<Id> cpqRecordTypeIdSetRen = new set<Id>();
        
        for (RecordType r : [Select Id, SObjectType, Name From RecordType Where SObjectType = 'Opportunity'])
        {
            if (r.Name.startsWith('CPQ New Sales'))
            {
                cpqRecordTypeIdSetNew.add(r.Id);
            }
            if(r.Name.startsWith('CPQ Renewal'))
            {
             
             cpqRecordTypeIdSetRen.add(r.Id);
            
            }
        }
        
        for (Opportunity o : newList)
        {
            if (o.AccountId != null && o.Id != null )
            {
              if(cpqRecordTypeIdSetNew.contains(o.RecordTypeId))
              {
                
                if (o.StageName.contains('(D) Power Sponsor Qualification') || o.StageName.contains('Won') || o.StageName.contains('Signature Due')|| o.StageName.contains('(B) Pending Contract') )
                {
                    if (oldMap != null && oldMap.containsKey(o.Id))
                    {
                        if (o.StageName != oldMap.get(o.Id).StageName)
                        {
                            opportunityIdSet.add(o.Id);
                        }
                    }
                    else
                    {
                        opportunityIdSet.add(o.Id);
                    }
                    accountIdSet.add(o.AccountId);
                }
              }  
            if(cpqRecordTypeIdSetRen.contains(o.RecordTypeId))
              {
                
                if (o.StageName.contains('Paperwork / Pricing Pending') || o.StageName.contains('Won') || o.StageName.contains('Customer Agreement')|| o.StageName.contains('(B) Pending Contract') )
                {
                    if (oldMap != null && oldMap.containsKey(o.Id))
                    {
                        if (o.StageName != oldMap.get(o.Id).StageName)
                        {
                            opportunityIdSet.add(o.Id);
                        }
                    }
                    else
                    {
                        opportunityIdSet.add(o.Id);
                    }
                    accountIdSet.add(o.AccountId);
                }
              }
              //  Commented By Nikhil(incident INC0052613)
              /*
                if (o.CPQ_Sales_Closed__c)
                {
                    opportunityIdSet.add(o.Id);
                    accountIdSet.add(o.AccountId);
                }
              */  
            }
        }
        
        system.debug(opportunityIdSet);
        
        //Added By sales developer
        
                                              
        // Map of Oppid and contact role
        Map<id,set<String>> MoppRole = New  Map<id,set<String>>();                                     
        
        accountMap = new map<Id, Account>([Select Id, Type From Account Where Id IN : accountIdSet]);
        
        for (Contact_Role_Selector__c crc : [Select Id, Contact_Role__c, Contact_Role__r.Role__c, Opportunity__c
                                              From Contact_Role_Selector__c 
                                              Where Opportunity__c IN : opportunityIdSet])
        {
            if (connectorMap.containsKey(crc.Opportunity__c))
            {
                connectorMap.get(crc.Opportunity__c).add(crc);
                MoppRole.get(crc.Opportunity__c).add(crc.Contact_Role__r.Role__c);
            }
            else
            {
                connectorMap.put(crc.Opportunity__c, new Contact_Role_Selector__c[]{crc});
                MoppRole.put(crc.Opportunity__c,new Set<String> {crc.Contact_Role__r.Role__c});
            }
        }
       System.debug('++NikMap++' + MoppRole);
        for (OpportunityPartner op : [Select Id, OpportunityId, IsPrimary, AccountToId From OpportunityPartner Where OpportunityId IN : opportunityIdSet])
        {
            if (op.OpportunityId != null && newMap.containsKey(op.OpportunityId) && op.AccountToId != newMap.get(op.OpportunityId).AccountId)
            {
                partnerMap.put(op.OpportunityId, op);
            }
        }
        
        /*for (OpportunityTeamMember otm : [Select Id, TeamMemberRole, OpportunityId From OpportunityTeamMember Where OpportunityId IN : opportunityIdSet])
        {
            if (teamMemberMap.containsKey(otm.OpportunityId))
            {
                teamMemberMap.get(otm.OpportunityId).add(otm);
            }
            else
            {
                teamMemberMap.put(otm.OpportunityId, new OpportunityTeamMember[]{otm});
            }
        }*/
        
        
        for (Opportunity o : newList)
        {
            if (opportunityIdSet.contains(o.Id))
            {
                hasPrimaryContact = True;
                hasSystemAdmin = True;
                
               
                String[] picklistlines =new String[]{};
                if(o.Platform__c !=Null)
                {
                picklistlines = o.Platform__c.split(';');  
                }
                else 
                {
                      hasPrimaryContact = False;
                      hasSystemAdmin = false;
                }
                if (connectorMap.containsKey(o.Id))
                {
                  if(o.Platform__c !=Null)
                    {  
                        if(MoppRole.get(o.id).contains('Multi-Platform - Primary Sales Contact') && MoppRole.get(o.id).contains('Multi-Platform - Primary Sales Technical Contact'))
                        { 
                            // Nothing to do since   hasPrimaryContact and hasSystemAdmin has already set to True
                        }
                        else if(MoppRole.get(o.id).contains('Multi-Platform - Primary Sales Contact') && !MoppRole.get(o.id).contains('Multi-Platform - Primary Sales Technical Contact'))
                        {
                            hasSystemAdmin= False;
                        }
                        else if(!MoppRole.get(o.id).contains('Multi-Platform - Primary Sales Contact') && MoppRole.get(o.id).contains('Multi-Platform - Primary Sales Technical Contact'))
                        {
                            hasPrimaryContact = False;
                        }
                        else
                        {
                            For(String str :picklistlines )
                                { 
                                   System.debug('++++' +MoppRole.get(o.id)); 
                                  
                                    if(!MoppRole.get(o.id).contains(str.toUpperCase()+' '+'-'+' '+'Primary Sales Contact'))
                                     {
                                      
                                     
                                      hasPrimaryContact = False;
                                      Break;
                                     
                                     }
                                     if(!MoppRole.get(o.id).contains(str.toUpperCase()+' '+'-'+' '+'Primary Sales Technical Contact'))
                                     {
                                      
                                     
                                      hasSystemAdmin= False;
                                      Break;
                                     
                                     }
                    
                                }
                    
                        }   
                    }
                     else{
                            
                  for (Contact_Role_Selector__c crc : connectorMap.get(o.Id))
                    {
                        if (crc.Contact_Role__r.Role__c != null && crc.Contact_Role__r.Role__c.contains('Primary Sales Contact'))
                        {
                            hasPrimaryContact = true;
                        }
                        if (crc.Contact_Role__r.Role__c != null && crc.Contact_Role__r.Role__c.contains('Primary Sales Technical Contact'))
                        {
                            hasSystemAdmin = true;
                        }
                        if (hasPrimaryContact && hasSystemAdmin)
                        {
                            break;
                        }
                    } 
                     
                     
                     
                     }
                     
                }
                // Added by Nikhil .Date:-04/03/2014
                else
                {
                 hasPrimaryContact = False;
                 hasSystemAdmin = false;
                
                }
                    
                if (o.StageName.contains('Power Sponsor Qualification'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Power Sponsor Qualification\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Power Sponsor Qualification\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    
                }
               else if (o.StageName.contains('Decision Due'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Decision Due\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Decision Due\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    
                } 
                
               else if (o.StageName.contains('Pending Contract'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Pending Contract\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Pending Contract\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (accountMap != null && accountMap.containsKey(o.AccountId) && accountMap.get(o.AccountId).Type == 'Partner' && !partnerMap.containsKey(o.Id))
                    {
                        o.StageName.addError('You cannot set the Stage to \'Pending Contract\' without a Reseller because the Account on the Opportunity is a \'Partner Account.\'');
                    }
                }
                else if (o.StageName.contains('Signature Due'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Signature Due\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Signature Due\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                }
              else if (o.StageName.contains('Paperwork / Pricing Pending'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Paperwork / Pricing Pending\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Paperwork / Pricing Pending\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                }
               else if (o.StageName.contains('Customer Agreement'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Customer Agreement\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Customer Agreement\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                }    
                else if (o.StageName.contains('Won'))
                {
                    if (!hasPrimaryContact)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Won\' without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    if (!hasSystemAdmin)
                    {
                        o.StageName.addError('You cannot set the Stage to \'Won\' without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                }
                else if (o.CPQ_Sales_Closed__c)
                {     
                    
                    if (!hasPrimaryContact) 
                    {   
                       
                        o.CPQ_Sales_Closed__c.addError('You cannot check this without a Primary Sales Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                    
                    if (!hasSystemAdmin  )
                    {
                        o.CPQ_Sales_Closed__c.addError('You cannot check this without a Primary Sales Technical Contact. Please add this Contact Role from the Contact Role Selector related list.');
                        continue;
                    }
                                       
                }
                
                /*hasNewRep = false;
                hasRenewRep = false;
                
                if (teamMemberMap.containsKey(o.Id))
                {
                    for (OpportunityTeamMember otm : teamMemberMap.get(o.Id))
                    {
                        if (otm.TeamMemberRole == 'New Sale Representative')
                        {
                            hasNewRep = true;
                        }
                        if (otm.TeamMemberRole == 'Renewal Sale Representative')
                        {
                            hasRenewRep = true;
                        }
                        if (hasNewRep && hasRenewRep)
                        {
                            break;
                        }
                    }
                }
                if (!(hasNewRep && hasRenewRep))
                {
                    o.CPQ_Sales_Closed__c.addError('All sales closed opportunities must have a New Sale Representative & Renewal Sale Representative in the Opportunity Team section.');
                    continue;
                }*/
            }
        }
    }
   /*
   private void UpdateShippingInQuaterInOppProduct(list<Opportunity> newList,Map<ID, Opportunity> updatedOpportunityMap,Map<ID, Opportunity> OldOpportunityMap)
    {  
     Set<id> Oppid = New Set<id>();
     List<OpportunityLineItem> LoppLine =   New List<OpportunityLineItem>();
     For(Opportunity op : newList)
      {
      if(Op.ts_shipping_in_quarter__c != OldOpportunityMap.get(op.id).ts_shipping_in_quarter__c)
       Oppid.add(op.id);
      }
      For(OpportunityLineItem Oppline : [select id,transact_shipping_in_quarter__c,Opportunityid from OpportunityLineItem where Opportunityid IN : Oppid])
       {
        Oppline.transact_shipping_in_quarter__c=updatedOpportunityMap.get(Oppline.Opportunityid).ts_shipping_in_quarter__c;
        LoppLine.add(Oppline); 
       }
     Update LoppLine;   
    
    
    }*/
 //Added by Nikhil for TP:3292 
   /*private void UpdateShippingInQuaterInOppProduct(list<Opportunity> newList,Map<ID, Opportunity> updatedOpportunityMap,Map<ID, Opportunity> OldOpportunityMap)
    {  
       
          Set<id> Oppid = New Set<id>();
          List<OpportunityLineItem> LoppLine =   New List<OpportunityLineItem>();
       
          For(Opportunity op : newList)
          {    
               if(Op.Shipping_In_Quarter__c != OldOpportunityMap.get(op.id).Shipping_In_Quarter__c)
               {
                  
                  Oppid.add(op.id);
                  
               }
         }
       
         LoppLine= [select id,transact_shipping_in_quarter__c,Opportunityid from OpportunityLineItem where Opportunityid IN : Oppid];
      
      
         if(LoppLine.Size()>0)
         {
               For(OpportunityLineItem Oppline : LoppLine )
               {
                     Oppline.transact_shipping_in_quarter__c=updatedOpportunityMap.get(Oppline.Opportunityid).Shipping_In_Quarter__c;
                
               }
              Update LoppLine;   
    
         }
  }*/
    // Added By Nikhil TP:3068 and TP:3486 , it works on lead converstion
  /*
    private void UpdateSourceCheckBox(list<Opportunity> newList)
    { 
        
    // it will work when we add Campaign influence has been added to Opp 
     
           For(Opportunity Op : newList)
           {
            
            
               if(Op.CampaignId != Null)
                    Op.Influenced__c=True;
               else
                    Op.Influenced__c=False;

               if(Op.LeadSource == 'Marketing' || Op.LeadSource == 'Web' || Op.LeadSource == 'Phone')
                   op.Sourced__c = True;  
                else
                   op.Sourced__c = False;      
           }
         
     
  }
  */  
  
   Private void updateProductStatusOnLineitem(List<Opportunity> OldList, List<Opportunity> NewList,Map<id,Opportunity> OldMap,Map<id,Opportunity> NewMap)
   {     
       
        //Newly created Opportunity id
        Set<id>  opid = new Set<id>();
        
        For(Opportunity Op : NewList)
        {
             if(Op.StageName=='(L) Lost' && Op.PFIN_Intgr_Record_Type__c.contains('CPQ Renewal Opportunity Record Type'))
              {
                opid.add(Op.id);
                
              }
            
        }
        
        
        If(opid.Size()> 0)
        {
                List<OpportunityLineItem> Litem = New List<OpportunityLineItem>();
                
                For(OpportunityLineItem Opl :[select id,CPQ_Product_Status__c,OpportunityId from OpportunityLineItem where OpportunityId IN : opid])
                 {
                    Opl.CPQ_Product_Status__c='Dropped';
                    Litem.add(Opl);
                    
                 }
                 
                 Update Litem;
                 
         }        
                  
          
    
    
    
    
    
    
    
   }  
   
  
   //  Commented out 9/20/2013 to migrate CPQ change to PRD 
  
   Private Void PartnerRelatedValidation(list<Opportunity> newList)
   { 
     
      //CPQ  Opportunity Record Type
      
      Schema.DescribeSObjectResult d1 = Schema.SObjectType.Opportunity; 
      Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName();
      Id CpqRec1 = rtMapByName.get('CPQ New Sales Opportunity Record Type').getRecordTypeId();
      Id CpqRec2 = rtMapByName.get('CPQ Renewal Opportunity Record Type').getRecordTypeId();
      Id CpqRec3 = rtMapByName.get('CPQ New Sales Opportunity Record Type (Locked)').getRecordTypeId();
      Id CpqRec4 = rtMapByName.get('CPQ Renewal Opportunity Record Type (Locked)').getRecordTypeId();
      
      // set of newly updated record id
      Set<id> opid = new Set<id>();
      
      //Set of Related account id
      Set<id> accid = new Set<id>();
    
    
      for(Opportunity Op : newList)
       {
        opid.add(Op.id);
        accid.add(Op.Accountid);
       } 
      
     // Map for Related Account  
     Map<id,Account> AccMap = New Map<id,Account>([Select id,billingCountry from Account where id IN : accid]);
     
     //Map for Related partner
     Map<id,OpportunityPartner> PartnerMap = new Map<id,OpportunityPartner>();
     
    for(OpportunityPartner Opart : [Select id,Opportunityid from  OpportunityPartner where  Opportunityid IN : opid] )
      {
      PartnerMap.Put(Opart.Opportunityid,Opart);
      }
     
     
     Set<string> Countryset = CountryName__c.getAll().keySet();
     
     
     for(Opportunity Op : newList)
     {  
        if(Op.RecordTypeid == CpqRec1 || Op.RecordTypeid == CpqRec2 || Op.RecordTypeid == CpqRec3 || Op.RecordTypeid == CpqRec4 )
           {
               if(Op.CPQ_Sales_Closed__c==True)
                   {
                     if(Countryset.Contains(AccMap.get(Op.Accountid).billingCountry))
                         {
                             if(!PartnerMap.containsKey(OP.id))
                               {
                                // testing Op.Adderror('Please indicate the partner you are working with in the Partners Related List located below');
                               
                               }
                           
                           
                          }
                    }
             }
          else 
           { 
              if(Op.StageName=='(A) Signature Due' || Op.StageName=='Customer Agreement')
                {
                   if(Countryset.Contains(AccMap.get(Op.Accountid).billingCountry))
                         {
                             if(!PartnerMap.containsKey(OP.id))
                               {
                                Op.Adderror('Please indicate the partner you are working with in the Partners Related List located below');
                               
                               }
                           
                           
                          }
           
           
               
               }
           }   
     }
   } 
   
  
  
   Private  void  CPQRenewalCreation(List<Opportunity> NewList, Map<id,Opportunity> OldOppsMap)
    {
  
        Boolean allowRun = false;
         //This trigger Should not fire again for same record in same Transaction.   
        for(Opportunity test : NewList){
            if(!CPQTriggerHelper.renwalOppCreated(test.Id)){
                allowRun=true;
            }
        }
    
        //Below two string has been used to determine record type for CPQ
        String renewStr ='CPQ Renewal Opportunity Record Type';
        String newId='CPQ New Sales Opportunity Record Type';
        
        
        //Set of Oppid 
        Set<Id> allOpps = new Set<Id>();
        
        
        //Set of Account id related to Opps
        Set<id> Acid = new set<id>();
        
        
        //ids of CPQ Previous Opportuity
        Set<id> CPreOpid = New Set<id>();
        
        //ids of Cameleon Quote
        Set<id> Camquteid = New Set<id>();
    
        
        For(Opportunity Opp : NewList)   
        {
            if (Opp.Parent_Adjustment_Opportunity__c== Null && Opp.StageName != OldOppsMap.get(Opp.id).StageName && Opp.StageName == '(W) Won' && Opp.AccountId!=null && (Opp.PFIN_Intgr_Record_Type__c.contains(renewStr) || Opp.PFIN_Intgr_Record_Type__c.contains(newId))) 
            {
                     allOpps.add(Opp.Id);
                     Acid.Add(Opp.AccountId);
                     if(Opp.CPQ_Previous_Opportunity__c!=Null)
                     CPreOpid.Add(Opp.CPQ_Previous_Opportunity__c);
                     Camquteid.Add(Opp.CPQActiveRelease__c);
            }
        
        }
   
        if(allowRun && allOpps.size()>0)
        {
        
         runrenewaltrigger.renewaltrigger=True;
       
          //This has been used for second time for trigger  itiration.
           Integer currentYear = 1;
   
            // Query for all lineItems(this Only Query will work for bulk)

            List<OpportunityLineItem>  Llitem = [SELECT OpportunityId,PS_Product_ID__c,Quote_Margin__c,Quote_Margin_Differential__c,PriorYearPrice__c,User_Quantity__c,Price_Type__c,User_Band__c,Product_Instance__c,Data_Storage_Quantity__c,CPQ_Delivery_Status__c,Opportunity.Name,Renewal_Unique_Line_ID__c, CPQ_isRenewable__c,Custom_Price__c,CPQ_Contract_Extended__c,CPQ_isCoreItem__c,CPQ_User_Band__c,CPQ_Package_Id__c,CPQ_Integrated_System__c,CPQ_NetPrice__c,CPQ_Previous_Year_Net_Price__c,CPQ_Year_5_Amount__c,CPQ_Year_4_Amount__c,CPQ_Annualized_Product_Amount__c,PricebookEntry.Name,CPQ_Product_Status__c,CPQ_Year_3_Amount__c,CPQ_Product_Start_Date__c,CPQ_Previous_Opportunity__c,CPQ_Product_End_Date__c,CPQ_isService_Product__c,CPQ_Current_Opportunity_ID__c,CPQ_Platform__c, PricebookEntry.Product2Id,PricebookEntry.Product2.Platform__c, PricebookEntry.ProductCode, Description, UnitPrice,Quantity,CPQ_Year_2_Amount__c from OpportunityLineItem WHERE OpportunityId=:allOpps];
            
            //Only for Total Price
            Map<id,OpportunityLineitem> Mopp1= New Map<id,OpportunityLineitem>([Select id,TotalPrice from OpportunityLineItem  WHERE OpportunityId=:allOpps]); 
               
            
            //Query for Cameleon Quote
            Map<id,CameleonCPQ__Quote__c> McamQuote = New Map<id,CameleonCPQ__Quote__c>([Select id,ExchangeRate__c from CameleonCPQ__Quote__c where id IN :Camquteid]);
            
            /*---- to excute code only when if there is any aligned Product --*/
            Set<String> ProStatus = New Set<String>();
            /*---END---*/
           
           /*---- Map of Opportunity with list of associated lineItems-------*/
                //Map OpportunityId and list of it's related OpportunityLineItem 
                Map<id,List<OpportunityLineItem>> Mline =  New Map<id,List<OpportunityLineItem>>();
                
                For(OpportunityLineItem Opl : Llitem)
                 {  
                 
                    ProStatus.Add(Opl.CPQ_Product_Status__c);
                    
                    If(Mline.containsKey(Opl.OpportunityId))
                    {
                    List<OpportunityLineItem> lit =Mline.get(Opl.OpportunityId);
                    lit.Add(Opl);
                    Mline.Put(Opl.OpportunityId,lit);
                    }
                     Else{
                     List<OpportunityLineItem> litm = New List<OpportunityLineItem>();
                     litm.Add(Opl);
                     Mline.Put(Opl.OpportunityId,litm);
                     
                    }
                 
                }
                System.debug('LineItem' +Mline);
            /*--------END of Map----------*/
            
            
            
            /*---- map of Opportunity with Associated Assets----*/
            
             List<Asset> Lassets =[SELECT AccountId,API_Login__c,API_Password__c,Application_Server_OS__c,ASP_Location__c,Asset_Type__c,BbIM_SAS_Integrated__c,Bugzilla_Bug_Number__c,Clustering_of_Servers__c,CL_Test_API_Login__c,CL_Test_API_Password__c,CMS_Type__c,CMS_Version__c,Comments__c,ContactId,Core_License__c,CPQ_Active__c,CPQ_contractLength__c,CPQ_Contract_End_Date__c,CPQ_Contract_Start_Date__c,CPQ_currentYear__c,CPQ_Current_Opportunity_ID__c,CPQ_forCPQ__c,CPQ_Intergrated_System__c,CPQ_isCoreItem__c,CPQ_isMultiyear__c,CPQ_ISO_Currency_Code__c,CPQ_isRenewable__c,CPQ_LineIdentifier__c,CPQ_Net_Price__c,CPQ_NumQty__c,CPQ_Package_Id__c,CPQ_Package__c,CPQ_Parent_Item__c,CPQ_Previous_Opportunity_ID__c,CPQ_Product_Platform__c,CPQ_Selling_Exchange_Rate__c,CPQ_User_Band__c,CreatedById,CreatedDate,CurrencyIsoCode,Customer_Value__c,Database_Server_OS__c,Database__c,Date_Ordered__c,Date_Registered__c,Date_Shipped__c,Days_to_Expiration__c,Description,Development_Server_URL__c,DNS_Servers__c,Domain_Name__c,Eportfolio_Enabled__c,Eportfolio_of_Seats__c,External_Asset_Name__c,External_Description__c,External_Order_Id__c,Force_SSL__c,Front_Back_Access__c,FTE__c,Gateway_IP_Address__c,Grace_Period__c,Hardware_Key__c,Hardware_Option__c,Hosting_Contact__c,Hosting_Option__c,Hosting_Server__c,Hostname__c,IC_Custom__c,Id,Implementation_Consultant_Email__c,Implementation_Consultant__c,InstallDate,Installed_Product_ID__c,Installed_Product_Note__c,Instance_URL__c,Integration_Component__c,IsCompetitorProduct,IsDeleted,I_and_C_Support__c,JDK_Version__c,LastModifiedById,LastModifiedDate,Last_Upgrade_Date__c,License_Expiration_Date__c,License_Key__c,Login_Styles__c,Maintenance_Level__c,Managed_Hosting__c,Manager_Login__c,Manager_Password__c,Moderator_Link__c,Name,Network__c,New_Users_this_month__c,New_Users_this_week__c,Nickname__c,Number_of_Institutions_Hosted__c,Number_of_Seats__c,Number_of_Users__c,Old_Product_Id__c,Opportunity_Owner_Email__c,Opportunity_Owner_Phone__c,Opportunity_Owner_Title__c,Opportunity_Owner__c,Opportunity__c,Order_Id__c,Participant_Link__c,Phone_End_Date__c,Phone_Service_Type__c,Phone_Simulcast_Number__c,Phone_Start_Date__c,Platform__c,Price,Primary_IP__c,Product2Id,Production_Server_URL__c,Product_Category__c,Product_ID__c,Product_Type__c,Psft_Product_Id__c,PurchaseDate,Purchase_Order__c,QPQ_Reseller__c,Quantity,Recording_Link__c,Secondary_Contact_Email__c,Secondary_Contact__c,SerialNumber,Server_Customization__c,Server_Network_Mask__c,Server_OS__c,Software_URL__c,Status,Support_Email__c,Support_Level__c,Support_Phone__c,SystemModstamp,Time_Zone__c,Total_Users__c,Type__c,Upgraded_from_Product_ID__c,Upgraded__c,Upgrade_Flag__c,UsageEndDate,User_Limit__c,Version_Build__c,Version_Effective_Date__c,Version__c,Virtual_IP__c,Voice_Direct_Enabled__c,Warm_Standby_IP__c,Warranty_End_Date__c,Warranty_Name__c,Warranty_Start_Date__c,Warranty_Status__c,WebCT_Instance__c,WebCT_IP_Address__c from Asset WHERE (Status='Installed' OR Status='Request Pending') AND CPQ_forCPQ__c=true AND CPQ_isRenewable__c=true AND CPQ_Current_Opportunity_ID__c IN :CPreOpid ORDER BY CPQ_Contract_Start_Date__c DESC];
             
             
             Map<id,List<Asset>> MAsset =  New Map<id,List<Asset>>();
             
             For(Asset Aset : Lassets)
            {  
                    
                        If(MAsset.containsKey(Aset.CPQ_Current_Opportunity_ID__c))
                        {
                            
                            List<Asset> lit =MAsset.get(Aset.CPQ_Current_Opportunity_ID__c);
                            lit.Add(Aset);
                            MAsset.Put(Aset.CPQ_Current_Opportunity_ID__c,lit);
                        }
                         
                         Else{
                             
                             List<Asset> Aseet = New List<Asset>();
                             Aseet.Add(Aset);
                             MAsset.Put(Aset.CPQ_Current_Opportunity_ID__c,Aseet);
                         
                        }
                 
            }
             
             
             /*----END-----*/
        List<Asset> MngAsset = New List<Asset>();
        if(CPreOpid.Size()>0)
        MngAsset =[Select id,Managed_Hosting__c,Opportunity__c,Psft_Product_Id__c from Asset Where Opportunity__c IN : CPreOpid ];

        Map<string,Asset>  MangAsset = New Map<String,Asset>();
        
        For(Asset Aset : MngAsset)
        {  
            MangAsset.put(Aset.Opportunity__c+Aset.Psft_Product_Id__c,Aset);
        }     
             
        /*----  List Of Asset for Alignment Asset(Start) --- */
        Map<String,List<Asset>> AlginAstlist = New Map<String,List<Asset>>();
        if(ProStatus.Contains('Aligned'))
        {
            
            List<Asset> LassetsForAlign =[SELECT AccountId,API_Login__c,API_Password__c,Application_Server_OS__c,ASP_Location__c,Asset_Type__c,BbIM_SAS_Integrated__c,Bugzilla_Bug_Number__c,Clustering_of_Servers__c,CL_Test_API_Login__c,CL_Test_API_Password__c,CMS_Type__c,CMS_Version__c,Comments__c,ContactId,Core_License__c,CPQ_Active__c,CPQ_contractLength__c,CPQ_Contract_End_Date__c,CPQ_Contract_Start_Date__c,CPQ_currentYear__c,CPQ_Current_Opportunity_ID__c,CPQ_forCPQ__c,CPQ_Intergrated_System__c,CPQ_isCoreItem__c,CPQ_isMultiyear__c,CPQ_ISO_Currency_Code__c,CPQ_isRenewable__c,CPQ_LineIdentifier__c,CPQ_Net_Price__c,CPQ_NumQty__c,CPQ_Package_Id__c,CPQ_Package__c,CPQ_Parent_Item__c,CPQ_Previous_Opportunity_ID__c,CPQ_Product_Platform__c,CPQ_Selling_Exchange_Rate__c,CPQ_User_Band__c,CreatedById,CreatedDate,CurrencyIsoCode,Customer_Value__c,Database_Server_OS__c,Database__c,Date_Ordered__c,Date_Registered__c,Date_Shipped__c,Days_to_Expiration__c,Description,Development_Server_URL__c,DNS_Servers__c,Domain_Name__c,Eportfolio_Enabled__c,Eportfolio_of_Seats__c,External_Asset_Name__c,External_Description__c,External_Order_Id__c,Force_SSL__c,Front_Back_Access__c,FTE__c,Gateway_IP_Address__c,Grace_Period__c,Hardware_Key__c,Hardware_Option__c,Hosting_Contact__c,Hosting_Option__c,Hosting_Server__c,Hostname__c,IC_Custom__c,Id,Implementation_Consultant_Email__c,Implementation_Consultant__c,InstallDate,Installed_Product_ID__c,Installed_Product_Note__c,Instance_URL__c,Integration_Component__c,IsCompetitorProduct,IsDeleted,I_and_C_Support__c,JDK_Version__c,LastModifiedById,LastModifiedDate,Last_Upgrade_Date__c,License_Expiration_Date__c,License_Key__c,Login_Styles__c,Maintenance_Level__c,Managed_Hosting__c,Manager_Login__c,Manager_Password__c,Moderator_Link__c,Name,Network__c,New_Users_this_month__c,New_Users_this_week__c,Nickname__c,Number_of_Institutions_Hosted__c,Number_of_Seats__c,Number_of_Users__c,Old_Product_Id__c,Opportunity_Owner_Email__c,Opportunity_Owner_Phone__c,Opportunity_Owner_Title__c,Opportunity_Owner__c,Opportunity__c,Order_Id__c,Participant_Link__c,Phone_End_Date__c,Phone_Service_Type__c,Phone_Simulcast_Number__c,Phone_Start_Date__c,Platform__c,Price,Primary_IP__c,Product2Id,Production_Server_URL__c,Product_Category__c,Product_ID__c,Product_Type__c,Psft_Product_Id__c,PurchaseDate,Purchase_Order__c,QPQ_Reseller__c,Quantity,Recording_Link__c,Secondary_Contact_Email__c,Secondary_Contact__c,SerialNumber,Server_Customization__c,Server_Network_Mask__c,Server_OS__c,Software_URL__c,Status,Support_Email__c,Support_Level__c,Support_Phone__c,SystemModstamp,Time_Zone__c,Total_Users__c,Type__c,Upgraded_from_Product_ID__c,Upgraded__c,Upgrade_Flag__c,UsageEndDate,User_Limit__c,Version_Build__c,Version_Effective_Date__c,Version__c,Virtual_IP__c,Voice_Direct_Enabled__c,Warm_Standby_IP__c,Warranty_End_Date__c,Warranty_Name__c,Warranty_Start_Date__c,Warranty_Status__c,WebCT_Instance__c,WebCT_IP_Address__c from Asset WHERE (Status='Installed' OR Status='Request Pending') AND CPQ_forCPQ__c=true AND CPQ_isRenewable__c=true AND Accountid IN :Acid ORDER BY CPQ_Contract_Start_Date__c DESC];
             
            
              if(LassetsForAlign.Size()>0)
                 {
                        For(Asset curAsset : LassetsForAlign)
                        {
                     
                                  if(AlginAstlist.containsKey(curAsset.Psft_Product_Id__c + '~' + curAsset.CPQ_LineIdentifier__c)){
                                    
                                        
                                        List<Asset> indAssetLst = AlginAstlist.get(curAsset.Psft_Product_Id__c + '~' + curAsset.CPQ_LineIdentifier__c);
                                        indAssetLst.Add(curAsset);
                                        AlginAstlist.put(curAsset.Psft_Product_Id__c+'~' + curAsset.CPQ_LineIdentifier__c, indAssetLst);
                                    
                                    }
                                    else{
                                            
                                            List<Asset> indAssetLst = new List<Asset>();
                                            indAssetLst.Add(curAsset);
                                            AlginAstlist.put(curAsset.Psft_Product_Id__c+'~' + curAsset.CPQ_LineIdentifier__c, indAssetLst);
                                    
                                    }
                        
                        
                        }         
        
               }
        
        
        }
        
        /*----END-----*/
             
           
        
        // To Get Id for CPQ Renewal Opportunity Record Type Start
        
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Opportunity; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d1.getRecordTypeInfosByName();
        Id renewId = rtMapByName.get('CPQ Renewal Opportunity Record Type').getRecordTypeId();
        
        //END
        
        // List of contact role selector related to all updated Opps
         List<Contact_Role_Selector__c> contacts = new List<Contact_Role_Selector__c>();
         
         // Query for all Contact role selector related to all updated opps
         
         contacts = [SELECT Opportunity__c, Contact_Role__r.Contact__c, ROLE__c FROM Contact_Role_Selector__c WHERE Opportunity__c IN :allOpps and (ROLE__c like '%Primary Sales Contact%' OR ROLE__c like '%Primary Sales Technical Contact%')];
         
         //Map of Oppid with list of Contact Roles and Contactid
         Map<Id,Map<String,Id>> allContactsList = new Map<Id,Map<String,Id>>();
         
        
        // This contains Contactid for related Contact role
            Set<Id> contIds = new Set<Id>();
        
        
        For(Contact_Role_Selector__c indvContact : contacts){
                
                
                if(allContactsList.containsKey(indvContact.Opportunity__c)){
                        
                        Map<String,Id> contList = allContactsList.get(indvContact.Opportunity__c);
                        contList.put(indvContact.ROLE__c ,indvContact.Contact_Role__r.Contact__c);
                        allContactsList.put(indvContact.Opportunity__c, contList);
                        contIds.add(indvContact.Contact_Role__r.Contact__c);
                       
                }
                
                else{
                        
                        Map<String,Id> contList = new Map<String,Id>();
                        contList.put(indvContact.ROLE__c ,indvContact.Contact_Role__r.Contact__c);
                        allContactsList.put(indvContact.Opportunity__c, contList);
                        contIds.add(indvContact.Contact_Role__r.Contact__c);
                    
                    }
        }
        
      // Map of all Accounts realted to updated Opps
      Map<Id, Account> curAcct = new Map<Id,Account>([SELECT CPQ_Next_Opportunity_Line_Item__c from Account where Id IN :Acid]);
        
        //List to Update OR to Delete records
        
        List<Asset> AccAssets = new List<Asset>();
        List<Asset> toDelete = new List<Asset>();
        Map<String,Opportunitylineitem> alignedOpps = new Map<String,Opportunitylineitem>();
        List<OpportunityLineItem> oppLines = new List<OpportunityLineItem>();
        List<OpportunityLineItem> oppLinesCopy = new List<OpportunityLineItem>();
        
        //List of renewal opps
        List<Opportunity> RenOpps = New List<Opportunity>();
        
        //List of Associated Account
        List<Account> Lacc = New List<Account>();
        
        
      
     //It will store Converaion rate for Opp.
      Double rate=1;
      
        For(Opportunity Op: NewList){
          
            if(Op.StageName != OldOppsMap.get(Op.id).StageName && Op.StageName == '(W) Won' && Op.AccountId!=null && (Op.PFIN_Intgr_Record_Type__c.contains(renewStr) || Op.PFIN_Intgr_Record_Type__c.contains(newId)))
            {
               //Below Current, I Have decalre it above so that i can use it Next Trigger 
              // Integer currentYear = 1;
               
               
               // Check Whether Renewal is required OR Not.
                Boolean needRenewal=false;
                
                // MultiYear Info for an Opportunity.
                String multiYear = (Op.Multi_Year_Deal__c == null ? 'No' : Op.Multi_Year_Deal__c);
        
            /*------ Calculate Rate. Based on Coversion rate of CurrencyIsocode-----*/
                     if(Op.CurrencyIsoCode== 'AUD')
                      {
                      
                        rate = Double.valueOf(1);
                      
                      }
                      else{
                      
                    //  rate = Op.CPQActiveRelease__r.ExchangeRate__c;  
                    //Added by Nikhil 
                       try{
                       
                         rate = McamQuote.get(Op.CPQActiveRelease__c).ExchangeRate__c;  
                         
                          }
                          /*Catch(Exception e)
                          {
                            Op.Adderror('LineNo:2484'+e);
                          }*/
                        Catch(NullPointerException e)
                        {
                         Op.Adderror('Please enter "CPQActiveRelease" field value in Approval Information Section');
                         // throw new applicationException ('Please enter "CPQActiveRelease" field value in Approval Information Section',e);
                          
                        }     
                      
                      }
            /*--------------------Calculate rate end-------------------------------------   */        
                    
                    
                    //Since Multiyear field is like 2 Years,3 Years.so numYears will contain numrical value of year
                    Integer numYears = 1;
                    
                    
                    
                    
                    //Split the multiyear, take only integer value
                        if(!(multiYear==null) && !(multiYear=='No') && !(multiYear=='Yes') && !(multiYear=='Already on a Multi-Year') && !(multiYear.trim() =='')){
                                   
                                   
                                    
                                    numYears = integer.valueOf((multiYear.split(' '))[0]);  //Split Value from Space and take numerical values Like( 2 , 3 , 4 , 5) Year. 
                                
                                }
                    
                    System.debug('NumberOfYear' + numYears );
                    
               
                    
                /*---- To calculate Primary Contact and Scondary Contact----*/              
                        Map<String,Id> contList = allContactsList.get(Op.Id);
                        
                        Set<String> conRoles = (  contList != null? contList.keySet() : new Set<String>());
                        
                        Id stdContact = null;
                        Id secondContact = null;
                        
                        for(String key : conRoles){
                            
                            if(key.contains('Primary Sales Contact')){                      
                                
                                stdContact=contList.get(key);
                                
                            }else if(key.contains('Primary Sales Technical Contact')){
                                
                                secondContact=contList.get(key);
                                
                            }
                        }
                    
                /*-------------END of Contact Calculation --------*/
      
      
                 // Will check  trigger is first time wroking for this Opps
                if (!CPQTriggerHelper.renwalOppCreated(Op.Id)) {
                
                
                    
                   // This is for  CPQ New Sales Opportunity Record Type  And CPQ New Sales Opportunity Record Type(Locked) Record Type
                    if(Op.PFIN_Intgr_Record_Type__c.contains(newId)){
                    
                        
                        
                        Double uniqueOppNum = curAcct.get(Op.AccountId).CPQ_Next_Opportunity_Line_Item__c;
                        
                        uniqueOppNum=(uniqueOppNum == null || uniqueOppNum==0 ? 1 : uniqueOppNum);
                                
                                
                        Date prodStartDate=Op.Start_Date__c;
                        Date prodEndDate = Op.End_Date__c;
                        
                        // Iterate through all the line items        
                        
                       // If(Mline.get(Op.id) != null)
                       try {                        
                        For (OpportunityLineItem quoLine : Mline.get(Op.id)){  
                            
                            prodStartDate=Op.Start_Date__c;
                            prodEndDate = Op.End_Date__c; 
                        
                        
                            quoLine.Renewal_Unique_Line_ID__c = String.valueOf(Integer.valueOf(uniqueOppNum));
                            quoLine.CPQ_Product_Start_Date__c=prodStartDate;
                            quoLine.CPQ_Product_End_Date__c=prodEndDate;
                            quoLine.CPQ_Delivery_Status__c='Request Pending';
                            
                            
                            For(Integer j=0;j<numYears;j++){
                               
                                if((quoLine.CPQ_isRenewable__c == true && j > 0) || (j == 0)){
                                    
                                    prodStartDate = (j==0 ? prodStartDate : prodEndDate+1); 
                                    
                                    prodEndDate = (j==0 ? prodEndDate : prodStartDate+364);
                                                                   
                                    Asset asstTest = new Asset();
                                    needRenewal=(needRenewal ? needRenewal : quoLine.CPQ_isRenewable__c);                                                  
                                    Asset asst = createAsset(quoLine, asstTest,prodStartDate, prodEndDate,false,(Opportunity)Op,j,rate,String.valueOf(Integer.valueOf(uniqueOppNum)),1,numYears);
                                    System.debug(LoggingLevel.DEBUG,'Asset creation'+j);
                                    // Added BY Nikhl to associate with opportunity with crosspondent asset
                                    if(j==0 && asst.Opportunity__c== Null)
                                    asst.Opportunity__c=op.id;
                                   
                                    asst.ContactId=stdContact;
                                    
                                    asst.Secondary_Contact__c=secondContact;
                                    AccAssets.add(asst);
                                   
                                }
                            }

                            oppLines.add(quoLine);
                            uniqueOppNum++;                         
                            
                        }
                    }
                    /*Catch(Exception e)
                          {
                            Op.Adderror('LineNo:2605'+e);
                          }*/
                    Catch(NullPointerException e)
                    {
                        Op.Adderror('Please add products before closing the deal.');
                    }
                   /* Else
                    {
                        Op.Platform__c.addError('There are no products. Please add products before closing the deal');
                    }
                     */   
                        curAcct.get(Op.AccountId).CPQ_Next_Opportunity_Line_Item__c=uniqueOppNum;
                        Lacc.Add(curAcct.get(Op.AccountId));
                }
                
                // This is for  CPQ Renewal Sales Opportunity Record Type  And CPQ Renewal Sales Opportunity Record Type(Locked) Record Type
                Else{
                  
                     // To Increment CPQ NExt Opportunity Line Item in CPQ.
                     Double uniqueOppNum = curAcct.get(Op.AccountId).CPQ_Next_Opportunity_Line_Item__c; 
                     
                     
                     // IF Account field CPQ_Next_Opportunity_Line_Item__c is Null. Then Set UniqueOppNum as 1.
                     uniqueOppNum=(uniqueOppNum == null || uniqueOppNum==0 ? 1 : uniqueOppNum);
                     
                     
                   //  Map<String,Map<String,Asset>> curAssetList = new Map<String,Map<String,Asset>>();
                       // Added By Nikhil
                       Map<String,List<Asset>>  curAssetList = New Map<String,List<Asset>>();
    
                     Integer lastYear = 1;
                     
                        For(Asset curAsset : MAsset.get(Op.CPQ_Previous_Opportunity__c)){
                                System.debug('++Nik+' + curAsset.CPQ_Contract_Start_Date__c);
                                //store product  by product key and line id
                                lastYear= Integer.valueOf(curAsset.CPQ_currentYear__c);
                               //String astkey =curAsset.Psft_Product_Id__c + '~' + curAsset.CPQ_LineIdentifier__c + '~' + curAsset.CPQ_Contract_Start_Date__c;
                         
                                if(curAssetList.containsKey(curAsset.Psft_Product_Id__c + '~' + curAsset.CPQ_LineIdentifier__c)){
                                
                                    
                                    //Map<String,Asset> indAssetList = curAssetList.get(curAsset.Psft_Product_Id__c + '~' + curAsset.CPQ_LineIdentifier__c);
                                    List<Asset> indAssetList = curAssetList.get(curAsset.Psft_Product_Id__c + '~' + curAsset.CPQ_LineIdentifier__c); 
                                    indAssetList.Add(curAsset);
                                    curAssetList.put(curAsset.Psft_Product_Id__c+'~' + curAsset.CPQ_LineIdentifier__c, indAssetList);
                                
                                }
                                else{
                                        
                                       // Map<String,Asset> indAssetList = new Map<String,Asset>();
                                         List<Asset> indAssetList = New List<Asset>();
                                         indAssetList.Add(curAsset);
                                        curAssetList.put(curAsset.Psft_Product_Id__c+'~' + curAsset.CPQ_LineIdentifier__c, indAssetList);
                                
                                }
                        }
                        // Need to See again because it has been repeated again
                        if(!(multiYear=='No') && !(multiYear=='Yes') && !(multiYear=='Already on a Multi-Year') && !(multiYear.trim() =='')){
                            
                            numYears = integer.valueOf((multiYear.split(' '))[0]);  //possible values should be 2 years, 3 years, 4 years, 5 years, numYears will be the integer value
                        
                        }
                     
                        currentYear=(numYears-(lastYear+1)==0 || numYears-(lastYear+1) < 0 ? 1 : lastYear+1);
                        
                       //from first line get if this opportunity is a contract extension and update currentYear accordingly
                       Boolean extension=false;
                       
                       try{extension = ((OpportunityLineItem)Mline.get(Op.id)[0]).CPQ_Contract_Extended__c;}
                       catch(Exception e)
                       { 
                        extension=false;
                        //Op.Adderror('LineNo:2677'+e);
                       } 
                       if(numYears-(lastYear+1)==0 && !extension){
                            
                            numYears=1;
                        
                        }
                        
                       currentYear = (extension ==true ? 1 : currentYear);
                       
                      // Date prodStartDate=Op.Start_Date__c;
                      // Date prodEndDate=Op.End_Date__c;
                       
                       
                       //itrate through all the line items
                       For (OpportunityLineItem quoLine : Mline.get(Op.id)){
                       
                       
                            quoLine.CPQ_Product_Start_Date__c=Op.Start_Date__c;
                            quoLine.CPQ_Product_End_Date__c=Op.End_Date__c;
                            quoLine.CPQ_Delivery_Status__c='Request Pending';
                            
                            
                             if((quoLine.CPQ_Product_Status__c=='New')){
                             
                                    Date prodStartDate=Op.Start_Date__c;
                                    Date prodEndDate=Op.End_Date__c;
                                 
                                quoLine.Renewal_Unique_Line_ID__c=String.valueOf(Integer.valueOf(uniqueOppNum));
                                
                                For(Integer j=currentYear;j<=numYears;j++){
                                   
                                    if((quoLine.CPQ_isRenewable__c == true && j > currentYear) || (j == currentYear)){
                                        
                                    prodStartDate = (j==currentYear ? prodStartDate : prodEndDate+1); 
                                    
                                    prodEndDate = (j==currentYear ? prodEndDate : prodStartDate+364);
                                                                                    
                                        needRenewal=(needRenewal ? needRenewal : quoLine.CPQ_isRenewable__c);
                                        Asset asstTest = new Asset();   
                                   
                                        Asset asst = createAsset(quoLine, asstTest,prodStartDate, prodEndDate,false,(Opportunity)Op,j-1,rate,String.valueOf(Integer.valueOf(uniqueOppNum)),1,numYears);
                                        asst.ContactId=stdContact;
                                        asst.Secondary_Contact__c=secondContact;
                                         System.debug(LoggingLevel.DEBUG,'Asset creation'+asst+j);
                                        // Added BY Nikhl to associate with opportunity with crosspondent asset
                                        if(j==currentYear && asst.Opportunity__c== Null)
                                        asst.Opportunity__c=op.id;
                                        
                                        AccAssets.add(asst);
                                               
    
                                    }
                                }
                                uniqueOppNum++;
                            }
                            // if Opportunity Line itme Combination is there in Asset and Product Status on Lineitem is not Dropped and Realigned.
                             
                             else if(curAssetList.containsKey(quoLine.PricebookEntry.ProductCode + '~' + quoLine.Renewal_Unique_Line_ID__c) && !(quoLine.CPQ_Product_Status__c=='Dropped') && !(quoLine.CPQ_Product_Status__c=='Realigned') && !(quoLine.CPQ_Product_Status__c=='Replace') && !(quoLine.CPQ_Product_Status__c=='Replace-Package')){
                            
                                   Date prodStartDate=Op.Start_Date__c;
                                   Date prodEndDate=Op.End_Date__c;
                                   
                                   needRenewal=(needRenewal ? needRenewal : quoLine.CPQ_isRenewable__c);
                                  
                                  //Map<String,Asset> indAssetList = curAssetList.get(quoLine.PricebookEntry.ProductCode+'~' + quoLine.Renewal_Unique_Line_ID__c);
                                   List<Asset> indAssetList = curAssetList.get(quoLine.PricebookEntry.ProductCode+'~' + quoLine.Renewal_Unique_Line_ID__c);
                                  Integer ind =(currentYear-1);
                                  
                                  //Added By Nikhil 
                                  boolean curAsstpres= False;
                                  
                                  For(Asset oldAst : indAssetList){
                                    System.debug('ContractDate' +oldAst.CPQ_Contract_Start_Date__c+prodStartDate);
                                    if(oldAst.CPQ_Contract_Start_Date__c > prodStartDate){
                                        
                                        toDelete.add(oldAst);
                                       
                                        
                                    }
                                    else if(oldAst.CPQ_Contract_Start_Date__c==prodStartDate){
                                       
                                         curAsstpres=True;
                                       
                                        
                                        if(oldAst.CPQ_currentYear__c +1 == oldAst.CPQ_contractLength__c)
                                        {
                                        oldAst.CPQ_currentYear__c=currentYear; 
                                        oldAst.CPQ_contractLength__c=currentYear;
                                        oldAst.CPQ_isMultiyear__c=False;
                                        }
                                        else
                                        {
                                        oldAst.CPQ_currentYear__c=currentYear;
                                        
                                        }
                                        
                                        oldAst.CPQ_Current_Opportunity_ID__c=Op.id;
                                        oldAst.CPQ_Previous_Opportunity_ID__c=Op.CPQ_Previous_Opportunity__c;
                                        If(MangAsset.containsKey(Op.CPQ_Previous_Opportunity__c+oldAst.Psft_Product_Id__c))  
                                        oldAst.Managed_Hosting__c=MangAsset.get(Op.CPQ_Previous_Opportunity__c+oldAst.Psft_Product_Id__c).Managed_Hosting__c;  
                                        
                                        oldAst.Status='Installed';
                                        
                                        //Only for renewal opps
                                        if(oldAst.Opportunity__c== Null)
                                        oldAst.Opportunity__c=Op.id;
                                        
                                       
                                        if(currentYear -1==0){                               
                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c/rate);               
                                            }else if(currentYear -1==1){
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_2_Amount__c==null ? 0 : quoLine.CPQ_Year_2_Amount__c/rate);             
                                            }else if(currentYear -1==2){                                                                
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_3_Amount__c==null ? 0 : quoLine.CPQ_Year_3_Amount__c/rate);             
                                            }else if(currentYear -1==3){
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_4_Amount__c==null ? 0 : quoLine.CPQ_Year_4_Amount__c/rate);             
                                            }else if(currentYear -1==4){
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_5_Amount__c==null ? 0 : quoLine.CPQ_Year_5_Amount__c/rate);             
                                            }
                                        
                                                                            
                                        Date futStartDate = prodStartDate; 
                                        
                                        Date futprodEndDate = prodEndDate;  
                                        
                                        
                                        ind++;
                                       
                                        for(Integer j=currentYear +1;j<=numYears;j++)
                                        {
                                            
                                            futStartDate = (j==currentYear ? futStartDate : futprodEndDate+1); 
                                          
                                            futprodEndDate = (j==currentYear ? futprodEndDate : futStartDate+364);
                                                    
                                            Asset asstFutr = createAsset(quoLine, oldAst,futStartDate, futprodEndDate,true,Op,j-1,rate,oldAst.CPQ_LineIdentifier__c,currentYear,numYears);                                                                              
                                            asstFutr.ContactId=stdContact;
                                            asstFutr.Secondary_Contact__c=secondContact;
                                            System.debug(LoggingLevel.DEBUG,'Asset creation'+asstFutr+j);
                                            AccAssets.add(asstFutr);
                                                      
                                        }
                                    AccAssets.add(oldAst);    
                                    }
                                    else
                                    {
                                    oldAst.Status='Obsolete';
                                    oldAst.CPQ_Active__c=false;            
        
                                     AccAssets.add(oldAst);
                                     
                                    //Commented By Nikhil Since need to create Asset if it has been extended
                                     
                                     /*
                                           if(curAsstpres== False && Op.Multi_Year_Deal__c=='No')
                                           {
                                                   
                                                    
                                                    Asset asstFutr = createAsset(quoLine, oldAst,prodStartDate, prodEndDate,true,Op,0,rate,oldAst.CPQ_LineIdentifier__c,1,1);                                                                              
                                                    asstFutr.ContactId=stdContact;
                                                    asstFutr.Secondary_Contact__c=secondContact;
                                                    AccAssets.add(asstFutr);
                                                      
                                           
                                           }
                                     
                                    */
                                    
                                        Date futStartDate = prodStartDate; 
                                        
                                        Date futprodEndDate = prodEndDate;  
                                        
                                        
                                        ind++;
                                        
                                       System.debug('++++' +  curAsstpres);
                                        if(curAsstpres== False)
                                           {
                                       
                                                    for(Integer j=currentYear;j<=numYears;j++){
                                                        
                                                         futStartDate = (j==currentYear ? futStartDate : futprodEndDate+1); 
                                                      
                                                        futprodEndDate = (j==currentYear ? futprodEndDate : futStartDate+364);
                                                                
                                                        Asset asstFutr = createAsset(quoLine, oldAst,futStartDate, futprodEndDate,true,Op,j-1,rate,oldAst.CPQ_LineIdentifier__c,currentYear,numYears);                                                                              
                                                        asstFutr.ContactId=stdContact;
                                                        asstFutr.Secondary_Contact__c=secondContact;
                                                        System.debug(LoggingLevel.DEBUG,'Asset creation'+asstFutr+j); 
                                                        if(j==currentYear)
                                                        {
                                                        asstFutr.Status='Installed';
                                                        if(asstFutr.Opportunity__c== Null)
                                                         asstFutr.Opportunity__c=Op.id;
                                                        }
                                                        else{
                                                        asstFutr.Status='Request Pending';
                                                        }
                                                        
                                                        
                                                        AccAssets.add(asstFutr);
                                                                  
                                                    }
                                           }         
                                    
                                    
                                    }
                                   
                                }
                              
                        }
                            // if Opportunity Line itme Combination is there in Asset and Product Status on Lineitem is  Dropped .
                            else if((curAssetList.containsKey(quoLine.PricebookEntry.ProductCode+ '~' + quoLine.Renewal_Unique_Line_ID__c)) && (quoLine.CPQ_Product_Status__c=='Dropped' || quoLine.CPQ_Product_Status__c=='Replace' || quoLine.CPQ_Product_Status__c=='Replace-Package'))
                            {           
                                
                               // Map<String,Asset> indAssetList = curAssetList.get(quoLine.PricebookEntry.ProductCode + '~' + quoLine.Renewal_Unique_Line_ID__c);
                                 List<Asset> indAssetList = curAssetList.get(quoLine.PricebookEntry.ProductCode+'~' + quoLine.Renewal_Unique_Line_ID__c);
                                for(Asset oldAst : indAssetList)
                                {                               
                                    
                                    oldAst.Status='Obsolete';
                                    oldAst.CPQ_Active__c=false;         
        
                                    AccAssets.add(oldAst);
                                    
                                }
                            }
                            // When product status on Lineitem is Aligned.
                            else if(quoLine.CPQ_Product_Status__c=='Aligned'){
                               
                               
                               Date prodStartDate=Op.Start_Date__c;
                               Date prodEndDate=Op.End_Date__c;
                               
                               needRenewal=(needRenewal ? needRenewal : quoLine.CPQ_isRenewable__c);
                                
                                //alignedOpps.Put(quoLine.CPQ_Previous_Opportunity__c,quoLine);
                                //Bewlow part is added to create assets for Aligned product
                                
                                /* ---- Start ----- */
                                 
                                  
                                  List<Asset> Asstlst= AlginAstlist.get(quoLine.PricebookEntry.ProductCode+'~' + quoLine.Renewal_Unique_Line_ID__c);
                                  
                                  Boolean curAsstpress= False;
                                  
                                    For(Asset oldAst : Asstlst){
                                    
                                    if(oldAst.CPQ_Contract_Start_Date__c > prodStartDate){
                                        
                                        toDelete.add(oldAst);
                                       
                                        
                                    }
                                    else if(oldAst.CPQ_Contract_Start_Date__c==prodStartDate){
                                       
                                         curAsstpress=True;
                                       
                                        
                                        if(oldAst.CPQ_currentYear__c +1 == oldAst.CPQ_contractLength__c)
                                        {
                                        oldAst.CPQ_currentYear__c=currentYear; 
                                        oldAst.CPQ_contractLength__c=currentYear;
                                        oldAst.CPQ_isMultiyear__c=False;
                                        }
                                        else
                                        {
                                        oldAst.CPQ_currentYear__c=currentYear;
                                        
                                        }
                                        
                                        oldAst.CPQ_Current_Opportunity_ID__c=Op.id;
                                        oldAst.CPQ_Previous_Opportunity_ID__c=Op.CPQ_Previous_Opportunity__c;
                                        oldAst.Status='Installed';
                                        //Only for renewal opps
                                        if(oldAst.Opportunity__c== Null)
                                        oldAst.Opportunity__c=Op.id;
                                       
                                        if(currentYear -1==0){                               
                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c/rate);               
                                            }else if(currentYear -1==1){
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_2_Amount__c==null ? 0 : quoLine.CPQ_Year_2_Amount__c/rate);             
                                            }else if(currentYear -1==2){                                                                
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_3_Amount__c==null ? 0 : quoLine.CPQ_Year_3_Amount__c/rate);             
                                            }else if(currentYear -1==3){
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_4_Amount__c==null ? 0 : quoLine.CPQ_Year_4_Amount__c/rate);             
                                            }else if(currentYear -1==4){
                                                
                                                oldAst.CPQ_Net_Price__c=(quoLine.CPQ_Year_5_Amount__c==null ? 0 : quoLine.CPQ_Year_5_Amount__c/rate);             
                                            }
                                        
                                                                            
                                        Date futStartDate = prodStartDate; 
                                        
                                        Date futprodEndDate = prodEndDate;  
                                        
                                        
                                       
                                       
                                        for(Integer j=currentYear +1;j<=numYears;j++){
                                            
                                             futStartDate = (j==currentYear ? futStartDate : futprodEndDate+1); 
                                          
                                            futprodEndDate = (j==currentYear ? futprodEndDate : futStartDate+364);
                                                    
                                            Asset asstFutr = createAsset(quoLine, oldAst,futStartDate, futprodEndDate,true,Op,j-1,rate,oldAst.CPQ_LineIdentifier__c,currentYear,numYears);                                                                              
                                            asstFutr.ContactId=stdContact;
                                            asstFutr.Secondary_Contact__c=secondContact;
                                            System.debug(LoggingLevel.DEBUG,'Asset creation'+asstFutr+j);                                         
                                            AccAssets.add(asstFutr);
                                                      
                                        }
                                    AccAssets.add(oldAst);    
                                    }
                                    else
                                    {
                                    oldAst.Status='Obsolete';
                                    oldAst.CPQ_Active__c=false;            
        
                                     AccAssets.add(oldAst);
                                     
                                     Date futStartDate = prodStartDate; 
                                        
                                     Date futprodEndDate = prodEndDate;  
                                     
                                       
                                          if(curAsstpress== False)
                                           {
                                       
                                                    for(Integer j=currentYear;j<=numYears;j++){
                                                        
                                                         futStartDate = (j==currentYear ? futStartDate : futprodEndDate+1); 
                                                      
                                                        futprodEndDate = (j==currentYear ? futprodEndDate : futStartDate+364);
                                                                
                                                        Asset asstFutr = createAsset(quoLine, oldAst,futStartDate, futprodEndDate,true,Op,j-1,rate,oldAst.CPQ_LineIdentifier__c,currentYear,numYears);                                                                              
                                                        asstFutr.ContactId=stdContact;
                                                        asstFutr.Secondary_Contact__c=secondContact;
                                                        System.debug(LoggingLevel.DEBUG,'Asset creation'+asstFutr+j);
                                                        if(j==currentYear)
                                                        {
                                                        asstFutr.Status='Installed';
                                                        //Only for renewal opps
                                                        if(asstFutr.Opportunity__c== Null)
                                                        asstFutr.Opportunity__c=Op.id;
                                                        }
                                                        else{
                                                        asstFutr.Status='Request Pending';
                                                        }
                                                        AccAssets.add(asstFutr);
                                                                  
                                                    }
                                           }         
                                     
                                    
                                    
                                    
                                    }
                                   
                                }  
                                
                                
                                
    
                                
                            }
                       
                         curAcct.get(Op.Accountid).CPQ_Next_Opportunity_Line_Item__c=uniqueOppNum;
                         oppLines.add(quoLine);
                         
                       }
                    
                Lacc.Add(curAcct.get(Op.Accountid));
               }
            
            }  
            else{
                    System.debug(LoggingLevel.DEBUG,'CPQRenewalCreationDebug opp already added');
                } 
             
            // if Renewal is required then create an Renewal Opps            
            
            if(needRenewal){
                Opportunity renewalOpp=Op.clone(false,true,false,false);
                //Opportunity renewalOpp=Op;
                renewalOpp.RecordTypeId = renewId;
                renewalOpp.Type='Renewal';
        
                
                Date renewalStartDate = Op.End_Date__c + 1;
                Date renewalEndDate = renewalStartDate + 364;
                
                
                if((Date.isLeapYear(renewalStartDate.Year()) && renewalStartDate.month()<=2) || (Date.isLeapYear((renewalEndDate+1).Year()) &&((renewalEndDate+1).month() >2))|| (Date.isLeapYear((renewalEndDate+1).Year()) && (renewalEndDate+1).month() ==2 && (renewalEndDate+1).day() ==29))
                renewalEndDate=renewalEndDate+1;
        
           
               if(numYears ==1 && !(multiYear=='No')){
                    multiYear='No';
                }
        
                String origName = '';
                try{origName=renewalOpp.Name.remove('[RENEWAL]');}catch(Exception e){origName = ''; 
                          
                            //Op.Adderror('LineNo:3099'+e);
                          }
                String platform = '';
                try{platform=(Op.Platform__c.contains('Collaborate') ? 'CL' : '') + ' ' + (Op.Platform__c.contains('Analytics') ? 'AN' : '');}catch(Exception e){platform = '';
                          
                            //Op.Adderror('LineNo:3104'+e);
                          }
                origName=origName.remove((renewalStartDate.year()-1) + '-' + (renewalEndDate.year()-1));    
                
                String renewalName='[RENEWAL] ' +  platform.trim() + ' ' + renewalStartDate.year() + '-' + renewalEndDate.year() + ' ' + origName;
                renewalOpp.Name=renewalName;
                
                renewalOpp.CPQ_Previous_Opportunity__c = Op.Id;
                renewalOpp.CloseDate=renewalStartDate;
                renewalOpp.StageName=(multiYear=='No' ? 'Paperwork / Pricing Pending' : 'Customer Agreement');
                renewalOpp.Probability=(multiYear=='No' ? 50 : 90);
                renewalOpp.CPQ_Contract_Status__c='';
                renewalOpp.CPQ_Quote_Status__c ='';
                renewalOpp.CPQ_Sales_Closed__c=false;
              //  renewalOpp.Finance_Verified__c=false;
                renewalOpp.CPQ_PO_Amount__c=0;
                renewalOpp.CPQ_PO_Number__c='';
                renewalOpp.CPQ_Year_1_Amount__c=0;
                renewalOpp.Year_2_Amount__c=0;
                renewalOpp.Year_3_Amount__c=0;
                renewalOpp.Year_4_Amount__c=0;
                renewalOpp.Year_5_Amount__c=0;
                renewalOpp.CPQ_Year_1_Discount_Value__c=0;
                renewalOpp.CPQ_Year_2_Discount_Value__c=0;
                renewalOpp.CPQ_Year_3_Discount_Value__c=0;
                renewalOpp.CPQ_Year_4_Discount_Value__c=0;
                renewalOpp.CPQ_Year_5_Discount_Value__c=0;
                renewalOpp.CPQ_PO_Received__c=false;
                renewalOpp.CPQ_PO_Validated__c=false;
                renewalOpp.CPQ_PO_Required__c='Unknown';
                renewalOpp.CPQ_Approval_to_Invoice_wo_PO_Attached__c=false;
                renewalOpp.Invoice_Number__c='';
                renewalOpp.Multi_Year_Deal__c=multiYear;
                renewalOpp.Renewal_ID__c='';
                renewalOpp.CPQ_Payment_Terms__c='Net 30';
        
                renewalOpp.Start_Date__c=renewalStartDate;
                renewalOpp.End_Date__c=renewalEndDate;   
                renewalOpp.CPQ_New_Sales_Value__c=0;
        
                renewalOpp.CPQ_Previous_Start_Date__c=Op.Start_Date__c;
                renewalOpp.CPQ_Previous_End_Date__c=Op.End_Date__c;           
        
                renewalOpp.CPQ_Is_Discount_Approval__c = false;
                renewalOpp.CPQ_Is_Hosted_Approval__c = false;
                renewalOpp.CPQ_Is_Perpetual_Approval__c = false;
                renewalOpp.CPQ_Is_Service_Approval__c = false;
                renewalOpp.CPQ_Is_Specific_Product_Approval__c = false;
                renewalOpp.CPQ_Is_T_M_Approval__c = false;
                renewalOpp.CPQ_Is_Treasury_Approval__c = false;
                renewalOpp.ForecastCategoryName=(multiYear=='No' ? 'Best Case' : 'Commit');
                renewalOpp.Forecast_Value__c=null;
                renewalOpp.Comments_for_Contracts__c='';
                renewalOpp.Comments_for_Finance__c='';
                renewalOpp.Comments_for_Fulfillment__c='';
                renewalOpp.Forecast_Comments__c='';
                renewalOpp.Cross_sell_Type__c=null;
                renewalOpp.CPQ_NonBinding_MultiYear__c=false;
                renewalOpp.CPQ_Partner_Billing_Instructions__c='';
                renewalOpp.CPQ_Requires_Special_PFIN_Setup__c=false;
                renewalOpp.CPQ_Contract_Verified__c=false;
                renewalOpp.CPQ_Reseller_Renewal_Commission__c=null;
                renewalOpp.CPQ_Reseller_New_Software_Commission__c=null;
                renewalOpp.CPQ_Reseller_New_Services_MH_Commission__c=null;
                renewalOpp.PS_Opp_ID__c=null;
                renewalOpp.PS_Quote_Id__c=null;
                renewalOpp.Invoice_Number__c='';
                
                renewalOpp.moodlerooms_Netsuite_ID__c=null;
                renewalOpp.Edline_SLX_Cross_Sell_Lead_ID__c='';
                
                renewalOpp.CPQActiveRelease__c=null;
                
                //Added By Nikhil
                renewalOpp.NextStep='';
                renewalOpp.PFIN_Intgr_Status_Msg__c='';
                renewalOpp.Closed_Loss_Won_Reason__c='';
            
                
                Double renewalTotal =0;
                Double renewalAnnual=0;
                
                 //copy all opportunity line items that are renewable and set the previous year price
                for (OpportunityLineItem quoLine : Mline.get(Op.id)){
                    String first = '<a style="color:#B20000" href="';
                    String fullFileURL = URL.getSalesforceBaseUrl().toExternalForm();  // You can easily use in any instance, no need hard code
                    String last = '">Go to Associated Product.</a>'; 
                    String roleID = quoLine.ID;
                    if(quoLine.CPQ_isRenewable__c==true && !(quoLine.CPQ_Product_Status__c=='Dropped') ){
                        if(multiYear.equals('No'))
                            renewalTotal += quoLine.CPQ_Annualized_Product_Amount__c;
                        else{
                             /* Updating the renewal total at the opportunity based on renewal year*/ 
                             try{
                             if(currentYear==0){                               
                               
                                renewalTotal += quoLine.CPQ_NetPrice__c;                                     
                            }else if(currentYear==1){
                                
                                renewalTotal += quoLine.CPQ_Year_2_Amount__c; 
                            }else if(currentYear==2){                                                                
                               
                                renewalTotal += quoLine.CPQ_Year_3_Amount__c;            
                            }else if(currentYear==3){
                                   
                                renewalTotal += quoLine.CPQ_Year_4_Amount__c; 
                            }else if(currentYear==4){
                                
                                renewalTotal += quoLine.CPQ_Year_5_Amount__c; 
                            }
                           } 
                          /* Catch(Exception e)
                          {
                            Op.Adderror('LineNo:3217'+e);
                          }*/
                           Catch(NullPointerException e)
                           {
                            op.AddError('<span style="color:#B20000">Associated Product\'s Year Amount cannot be Null:<span><br/>' + first + fullFileURL + '/' +roleID+ last,false);
                           
                                                    
                           }
                        }        
                    }       
                }
                renewalOpp.CPQ_Expected_Renewal_Amount__c=renewalTotal;
                RenOpps.Add(renewalOpp);
                
               
                
                
            }
         }
         CPQTriggerHelper.setAlreadyCreatedRenewals(Op.Id);
      }
     // Commented aligned part for time being
     /*
      // added by Nikhil for aligned opps
      if(!alignedOpps.isEmpty())
       {
       
          
           Set<String> realignOppIds = alignedOpps.keySet();
           
            //get all opps that have products aligning.
                Set<String> openOpps = new Set<String>();
                AggregateResult[] groupedResults = [select OpportunityId, count(CPQ_Product_Status__c) from OpportunityLineItem where CPQ_Product_Status__c <> 'Realigned' and OpportunityId IN :realignOppIds GROUP BY OpportunityId];
                for(AggregateResult ar : groupedResults){
                    openOpps.add((String)ar.get('OpportunityId'));
                }
                
                
                realignOppIds.removeAll(openOpps); 
                
                
                List<Opportunity> opps = [SELECT Id, StageName from Opportunity where Id IN :realignOppIds];
                List<Opportunity> oppsUpdate = new List<Opportunity>();
    
                for(Opportunity opp : opps){
                    opp.StageName='Closed – Realign';
                    oppsUpdate.add(opp);
                }
                 
                update oppsUpdate;
       
       
       
       
       
       }
      
     */ 
      
    
         
     
      
      If(toDelete.Size()>0)
      Delete toDelete;

      //END 
     If(oppLines.Size()>0)
      Upsert oppLines;
      
      If(lacc.Size()>0)
      Upsert Lacc; 
      
      
      
      
      
      //Renewal Opps id
     // Set<id> Renewopid = new Set<id>();
      Map<id,Opportunity> Mrenw = New Map<id,Opportunity>();
      // List of CameleonCPQ__Quote__c Objects
      List<CameleonCPQ__Quote__c> LcamQuote = New List<CameleonCPQ__Quote__c>();
      
      // This is to create renewal opps related line Item.
      If(RenOpps.Size()>0)
      {
      Set<id> Renewopid = new Set<id>();
      Insert RenOpps; 
      
      For(Opportunity Opp : RenOpps)
      {
      Renewopid.Add(Opp.id);
      }
      For(Opportunity Op: [Select id,Multi_Year_Deal__c,CPQ_Previous_Opportunity__c,StageName,Start_Date__c,End_Date__c from Opportunity Where id IN : Renewopid])
       {
         Mrenw.put(Op.CPQ_Previous_Opportunity__c,Op);
         
       }
      
      
      
      For(Opportunity Op : NewList)
       {
            if(Op.StageName != OldOppsMap.get(Op.id).StageName && Op.StageName == '(W) Won' && Op.AccountId!=null && (Op.PFIN_Intgr_Record_Type__c.contains(renewStr) ||  Op.PFIN_Intgr_Record_Type__c.contains(newId)))
            {       
                    

                     Integer lastYear = 1;
                      
                     if(Op.PFIN_Intgr_Record_Type__c.contains(newId))
                       currentYear = 1;
                      else
                      {
                      
                      lastYear=Integer.Valueof(MAsset.get(Op.CPQ_Previous_Opportunity__c)[0].CPQ_currentYear__c);
                      
                      Boolean extension=false;
                      try{extension = ((OpportunityLineItem)Mline.get(Op.id)[0]).CPQ_Contract_Extended__c;}catch(Exception e){extension=false;Op.Adderror('LineNo3340'+e);}
                      currentYear = (extension ==true ? 1 : currentYear);

                      
                      }
                   
                    
                     For (OpportunityLineItem quoLine : Mline.get(Op.id))
                     {
                            
                           if(quoLine.CPQ_isRenewable__c==true && !(quoLine.CPQ_Product_Status__c=='Dropped') && !(quoLine.CPQ_Product_Status__c=='Replace') && !(quoLine.CPQ_Product_Status__c=='Replace-Package'))
                           {
                            
                                OpportunityLineItem oliCopy=quoLine.clone(false,true,false,false);
                                oliCopy.OpportunityId=Mrenw.get(Op.id).id;
                                // Added By Nikhil(Current Year  issue)(start)
                                oliCopy.CPQ_Current_Opportunity_ID__c=Mrenw.get(Op.id).id;
                                // END
                                oliCopy.CPQ_Product_Status__c='Renewal';
                                
                                
                                oliCopy.CPQ_Product_Start_Date__c=Mrenw.get(Op.id).Start_Date__c;
                                oliCopy.CPQ_Product_End_Date__c=Mrenw.get(Op.id).End_Date__c; 
                                
                                //OpportunityLineItem oliCopy=quoline;
                                if(Mrenw.get(Op.id).Multi_Year_Deal__c=='No'){
                                    
                                    // Divide by Quantity add by Nikhil Since customer 
                                    oliCopy.Custom_Price__c=(quoLine.CPQ_Annualized_Product_Amount__c/quoLine.Quantity);
                                    
                                    oliCopy.CPQ_NetPrice__c=quoLine.CPQ_Annualized_Product_Amount__c;
                                    oliCopy.CPQ_Previous_Year_Net_Price__c=quoLine.CPQ_Annualized_Product_Amount__c;
                                    oliCopy.Expected_Renewal_Value__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                }
                                else{
                                    oliCopy.Custom_Price__c=quoLine.CPQ_NetPrice__c;
                                    oliCopy.CPQ_NetPrice__c=quoLine.CPQ_NetPrice__c;
                                    
                                    if(currentYear==0){                               
                                        
                                        oliCopy.CPQ_NetPrice__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);    
                                        oliCopy.Custom_Price__c=((quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c)/quoLine.Quantity);
                                        
                                       oliCopy.CPQ_Previous_Year_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c); 
                                                
                                    }else if(currentYear==1){
                                      
                                        oliCopy.CPQ_NetPrice__c=(quoLine.CPQ_Year_2_Amount__c==null ? 0 : quoLine.CPQ_Year_2_Amount__c);             
                                        oliCopy.Custom_Price__c=((quoLine.CPQ_Year_2_Amount__c==null ? 0 : quoLine.CPQ_Year_2_Amount__c)/quoLine.Quantity);
                                        
                                        oliCopy.CPQ_Previous_Year_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                        oliCopy.Expected_Renewal_Value__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                    }else if(currentYear==2){                                                                
                                       
                                        oliCopy.CPQ_NetPrice__c=(quoLine.CPQ_Year_3_Amount__c==null ? 0 : quoLine.CPQ_Year_3_Amount__c);
                                        oliCopy.Custom_Price__c=((quoLine.CPQ_Year_3_Amount__c==null ? 0 : quoLine.CPQ_Year_3_Amount__c)/quoLine.Quantity);   
                                        
                                        oliCopy.CPQ_Previous_Year_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);           
                                        oliCopy.Expected_Renewal_Value__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                    }else if(currentYear==3){
                                         
                                        oliCopy.CPQ_NetPrice__c=(quoLine.CPQ_Year_4_Amount__c==null ? 0 : quoLine.CPQ_Year_4_Amount__c); 
                                        oliCopy.Custom_Price__c=((quoLine.CPQ_Year_4_Amount__c==null ? 0 : quoLine.CPQ_Year_4_Amount__c)/quoLine.Quantity); 
                                        
                                        oliCopy.CPQ_Previous_Year_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);           
                                        oliCopy.Expected_Renewal_Value__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                    }else if(currentYear==4){
                                        
                                        oliCopy.CPQ_NetPrice__c=(quoLine.CPQ_Year_5_Amount__c==null ? 0 : quoLine.CPQ_Year_5_Amount__c);             
                                        oliCopy.Custom_Price__c=((quoLine.CPQ_Year_5_Amount__c==null ? 0 : quoLine.CPQ_Year_5_Amount__c)/quoLine.Quantity);
                                        
                                        oliCopy.CPQ_Previous_Year_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                        oliCopy.Expected_Renewal_Value__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c);
                                    }
                                } 
                                // Anuualize the value
                                /*
                                if( Op.Start_Date__c!= Null && Op.End_Date__c!=Null && Op.Start_Date__c.daysBetween(Op.End_Date__c)>365)
                                {
                                      if((Date.isLeapYear(Op.Start_Date__c.Year())&& Op.Start_Date__c.month()<=2) ||(Date.isLeapYear(Op.End_Date__c.Year())&& Op.End_Date__c.month() >2) )
                                       {
                                        
                                         
                                          oliCopy.PriorYearPrice__c=(Mopp1.get(quoLine.id).TotalPrice/(Op.Start_Date__c.daysBetween(Op.End_Date__c)+1))*366;
                                       }
                                       else
                                       {
                                        
                                         
                                          oliCopy.PriorYearPrice__c=(Mopp1.get(quoLine.id).TotalPrice/(Op.Start_Date__c.daysBetween(Op.End_Date__c)+1))*365;
                                       
                                       }
                                } 
                                else
                                { */
                
                                       oliCopy.PriorYearPrice__c=Mopp1.get(quoLine.id).TotalPrice;
                                       System.debug('++==++'+ Mopp1.get(quoLine.id).TotalPrice);
                                       System.debug('++=1=++'+quoLine.UnitPrice+ oliCopy.Quantity);
                             //   }      
                                
                                
                                oliCopy.CPQ_Annualized_Product_Amount__c= oliCopy.CPQ_NetPrice__c;                   
                                oliCopy.CPQ_Previous_Opportunity__c=Op.Id;
                                oliCopy.CPQ_isService_Product__c=false;
                              //oliCopy.CPQ_Previous_Year_Net_Price__c=quoLine.CPQ_NetPrice__c;
                                
                                oppLinesCopy.add(oliCopy);          
                                
                            }
                            
                            
                        }   
                            

                            CameleonCPQ__Quote__c renewalQuo=new CameleonCPQ__Quote__c();
                            
                            String quoName='[RENEWAL Quote] '+Op.Name;
                            renewalQuo.Name=((quoName.length() > 80) ? quoName.substring(0,79) : quoName);
                            
                            renewalQuo.CameleonCPQ__AccountId__c=Op.AccountId;
                            renewalQuo.OpportunityId__c=Mrenw.get(Op.id).Id;   

                            
                            CPQTriggerHelper.setAlreadyCreatedRenewals(Op.Id);
                            //upsert(renewalQuo); 
                            LcamQuote.Add(renewalQuo);                          
                        
       
       
                    
            }
       
            
            
                }
                
               
            
            }
 // Upsert assets has been move down to associate with renewal opportunities Start
      If(AccAssets.Size()> 0)
      { 
            for(Asset ast : AccAssets)
             {  
                if(ast.Opportunity__c== Null && Mrenw.containsKey(ast.CPQ_Current_Opportunity_ID__c)&& ast.CPQ_Contract_Start_Date__c!=Null && Mrenw.get(ast.CPQ_Current_Opportunity_ID__c).Start_Date__c!=Null && ast.CPQ_Contract_Start_Date__c==Mrenw.get(ast.CPQ_Current_Opportunity_ID__c).Start_Date__c)
                  {
                   
                   ast.Opportunity__c=Mrenw.get(ast.CPQ_Current_Opportunity_ID__c).id;
                  }
                  
             }
            upsert(AccAssets);
      
      } 
      
      if(oppLinesCopy != null && oppLinesCopy.size()>0 )
          Upsert oppLinesCopy;
      if(LcamQuote!=null && LcamQuote.size()>0)
          Upsert LcamQuote;     
        
 }  
 }
  // Creation of the Opportunity Line Item
      private Asset createAsset(OpportunityLineItem quoLine, Asset oldAst, Date startDate, Date endDate,Boolean copy, Opportunity opp, Integer year, Double rate, String uniqNum, Integer currentYear,Integer numYears) {
          Asset asstFutr;
          System.debug(LoggingLevel.DEBUG,'In createAssetMethod');
            if(copy){
                asstFutr = oldAst.clone(false,true,false,false);
                System.debug('Cloning the asset');
                asstFutr.CPQ_LineIdentifier__c=oldAst.CPQ_LineIdentifier__c;
                asstFutr.Version__c = oldAst.Version__c;
                System.debug('Version__c'+asstFutr.Version__c);
                asstFutr.Version_Build__c = oldAst.Version_Build__c;
                System.debug('Version Build__c'+asstFutr.Version_Build__c);
                asstFutr.Software_URL__c=oldAst.Software_URL__c;
                System.debug('Software_URL__c'+asstFutr.Software_URL__c);
                                            
                               
            }else{
                asstFutr = new Asset();
            }
          asstFutr.Opportunity__c=Null;
          //Commented By Nikhil  
           
           /*
            //update for NetSpot go live. Need to make sure the asset knows the currency is AUD
            if(opp.CurrencyIsoCode == 'AUD'){
                asstFutr.CurrencyIsoCode='AUD';
            }else{
                asstFutr.CurrencyIsoCode='USD'; 
            }
          */  
          // Added BY Nikhil (Created assets will be AUD if Platform in NetSpot)
          if(quoLine.PricebookEntry.Product2.Platform__c== 'NetSpot'){
                asstFutr.CurrencyIsoCode='AUD';
            }else{
                asstFutr.CurrencyIsoCode='USD'; 
            }
          
            // Added for LeapYear
            if(startDate != Null && endDate !=Null && startDate.daysBetween(endDate)!=365)
            {
                if((Date.isLeapYear(startDate.Year()) && startDate.month()<=2) || (Date.isLeapYear((endDate+1).Year()) &&((endDate+1).month() >2))|| (Date.isLeapYear((endDate+1).Year()) && (endDate+1).month() ==2 && (endDate+1).day() ==29))
                endDate=endDate+1;
            }
            //If Start date and End Date is Null.
            if(startDate != Null && endDate !=Null)            
            asstFutr.Name=quoLine.PricebookEntry.Name + ' (' + startDate.year() + '-' + endDate.year() + ')';
            else
            asstFutr.Name=quoLine.PricebookEntry.Name + ' ('+')';
            
            asstFutr.AccountId = opp.AccountId;
            asstFutr.Psft_Product_Id__c = quoLine.PricebookEntry.ProductCode;
            asstFutr.Description = quoLine.Description;
            asstFutr.Product2Id = quoLine.PricebookEntry.Product2Id;
            asstFutr.CPQ_Contract_Start_Date__c=startDate;
            asstFutr.CPQ_Contract_End_Date__c=endDate;
            
            asstFutr.CPQ_NumQty__c =quoLine.Quantity;
            asstFutr.CPQ_LineIdentifier__c = uniqNum;
            // Product Instance
          //asstFutr.Product_Instance__c=quoLine.Product_Instance__c;
            asstFutr.CPQ_Active__c=true;
            asstFutr.CPQ_Selling_Exchange_Rate__c = rate;
            asstFutr.CPQ_Intergrated_System__c= quoLine.CPQ_Integrated_System__c;
            asstFutr.CPQ_isCoreItem__c =quoLine.CPQ_isCoreItem__c;
            asstFutr.CPQ_User_Band__c=quoLine.CPQ_User_Band__c;
            asstFutr.CPQ_Package_Id__c = quoLine.CPQ_Package_Id__c;
            
            System.debug(Logginglevel.INFO,'j: ' + year);
            
            String multiYear = (opp.Multi_Year_Deal__c == null ? 'No' : opp.Multi_Year_Deal__c);
            
            Boolean mY=(multiYear=='No' ? false : true);
            
            if(numYears ==1 && !(multiYear=='No')){
                mY=false;
            }
            
            //asset stored price should be the yearly price if it is not a multi-year quote.
            if(year==0){                               
                
                asstFutr.CPQ_Net_Price__c=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c/rate);               
            }else if(year==1){
                
                asstFutr.CPQ_Net_Price__c=(quoLine.CPQ_Year_2_Amount__c==null ? 0 : quoLine.CPQ_Year_2_Amount__c/rate);             
            }else if(year==2){                                                                
                
                asstFutr.CPQ_Net_Price__c=(quoLine.CPQ_Year_3_Amount__c==null ? 0 : quoLine.CPQ_Year_3_Amount__c/rate);             
            }else if(year==3){
                
                asstFutr.CPQ_Net_Price__c=(quoLine.CPQ_Year_4_Amount__c==null ? 0 : quoLine.CPQ_Year_4_Amount__c/rate);             
            }else if(year==4){
                
                asstFutr.CPQ_Net_Price__c=(quoLine.CPQ_Year_5_Amount__c==null ? 0 : quoLine.CPQ_Year_5_Amount__c/rate);             
            }
            
            //if not a multi-year set the net price to the yearly price so next years renewal will be correct.
            
            if(!mY){
                Double totPrice=(quoLine.CPQ_NetPrice__c==null ? 0 : quoLine.CPQ_NetPrice__c/rate);
                Double yearPrice;
                if(startDate.daysBetween(endDate)!=365)
                yearPrice=((totPrice) / (startDate.daysBetween(endDate) + 1)) * 365;
                else
                yearPrice=((totPrice) / (startDate.daysBetween(endDate) + 1)) * 366;
                asstFutr.CPQ_Net_Price__c=yearPrice; 
                    
            }
            
           
            if(quoLine.Opportunityid!=Null)
           
            
                     
            
                        
            asstFutr.CPQ_isMultiyear__c=mY;
            asstFutr.CPQ_isRenewable__c=quoLine.CPQ_isRenewable__c;
            
            //#719 , all newly created asset should be request pending Status
            
            if(quoLine.Opportunity.Name.Contains('[RENEWAL]'))
            {
                
                if(year==(currentYear-1) /* && quoLine.CPQ_Product_Status__c.equals('New') */){
                    
                    asstFutr.Status='Installed';
                    
                    }else{
                        
                        asstFutr.Status='Request Pending';
                    
                    } 
            
            
            } 
            else
            {
            // for original Opps Asset status should be 'Request Pending'.
            asstFutr.Status='Request Pending';
            }
            
            
            
            asstFutr.CPQ_currentYear__c=currentYear;      //for new sales, current Year is always one
            asstFutr.CPQ_contractLength__c = numYears;      
            asstFutr.CPQ_forCPQ__c=true;
            asstFutr.CPQ_Product_Platform__c=quoLine.CPQ_Platform__c;
          //asstFutr.CPQ_Current_Opportunity_ID__c=quoLine.CPQ_Current_Opportunity_ID__c;
            asstFutr.CPQ_Current_Opportunity_ID__c=Opp.id;
            asstFutr.CPQ_Previous_Opportunity_ID__c=opp.CPQ_Previous_Opportunity__c;
            //Added By Nikhil for Testing purpose. 
            asstFutr.Installed_Product_ID__c='';
            asstFutr.Price = quoLine.UnitPrice;
            asstFutr.Data_Storage_Quantity__c=quoLine.Data_Storage_Quantity__c;
            //Requested by Anjan
            asstFutr.User_Quantity__c=quoLine.User_Quantity__c;
            asstFutr.Price_Type__c=quoLine.Price_Type__c;
            asstFutr.User_Band__c=quoLine.User_Band__c;
            // END 
            asstFutr.Quote_Margin_Differential__c=quoLine.Quote_Margin_Differential__c;
            asstFutr.Quote_Margin__c=quoLine.Quote_Margin__c;
            if(AssetQuantityPurchased__c.getinstance(quoLine.PS_Product_ID__c)!=Null)
            {
            asstFutr.Quantity_Purchased__c=quoLine.quantity*AssetQuantityPurchased__c.getinstance(quoLine.PS_Product_ID__c).multiplier__c;
            System.debug('Test==Test'+quoLine.quantity+ AssetQuantityPurchased__c.getinstance(quoLine.PS_Product_ID__c).multiplier__c);
            }
            return asstFutr;
        }
        Private void UpdateDiscountvalueOnOpp( list<Opportunity> newlist)
        {   
            
              //Id of Moodleroom pricebook
              Pricebook2 Mpriid= [Select id from Pricebook2 Where Name='Moodlerooms'];
              
              
              //Set of all lineitem ids
              Set<id> Oppid = new Set<id>();
              
              
              // Retrieve Opp id for Moodle rooms pricebook
              For(Opportunity Opp : newlist)
              {
                 if(Opp.Pricebook2id==Mpriid.id && Opp.Pricebook2id != Null)
                 {
                    Opp.MR_Services_Discount__c=0.0;
                    Opp.MR_Software_Discount__c=0.0;
                    Opp.MR_Training_Discount__c=0.0;
                    Oppid.Add(Opp.id);
                 }
                
              }
              
              if(Oppid.Size()>0)
              {
                
                   // List of all the lineitems of Opps
                   list<OpportunityLineItem> LoppLine = [Select id,OpportunityId,TotalPrice,listprice,Quantity,Custom_Price__c,pricebookentry.Product2.ProductCode,pricebookentry.Product2.Product_Group__c from OpportunityLineItem Where Opportunityid IN :Oppid];
                   System.debug('Line689'+LoppLine.size());
                   
                    // Calculate total price(Excluding discount) and sales vlaue for all the line items 
               Map<id,double> SoftTotalvalue = new Map<id,Double>();
               Map<id,double> SoftSalesvalue = new Map<id,Double>();
               Map<id,double> SrvcTotalvalue = new Map<id,Double>();
               Map<id,double> SrvcSalesvalue = new Map<id,Double>();
               Map<id,double> TrnTotalvalue = new Map<id,Double>();
               Map<id,double> TrnSalesvalue = new Map<id,Double>();
               
               For(OpportunityLineItem Oppl : LoppLine)
               {
                 // Below is for MR Software Discount
                  if(Oppl.pricebookentry.Product2.Product_Group__c != Null)
                  {
                     if(MRSoftwareDiscount__c.getInstance(Oppl.pricebookentry.Product2.Product_Group__c) !=Null)
                     { 
                        if((Oppl.listprice !=Null && Oppl.listprice !=0.0 ) && Oppl.Custom_Price__c <=Oppl.listprice) 
                        {
                             System.debug('Line' +Oppl.id );
                              // Use to calculate total price 
                              if(SoftTotalvalue.containskey(Oppl.Opportunityid))
                              {
                                //SoftTotalvalue.get(Oppl.Opportunityid)=SoftTotalvalue.get(Oppl.Opportunityid)+(Oppl.listprice*Oppl.Quantity);
                                SoftTotalvalue.put(Oppl.Opportunityid,SoftTotalvalue.get(Oppl.Opportunityid)+(Oppl.listprice*Oppl.Quantity));
                                System.debug('TotalValue' + SoftTotalvalue);
                              }
                              else
                              {
                                SoftTotalvalue.put(Oppl.Opportunityid,(Oppl.listprice*Oppl.Quantity));
                                System.debug('TotalValue' + SoftTotalvalue);
                              }
                              // Use to calculate total sales value
                              if(SoftSalesvalue.containskey(Oppl.Opportunityid))
                              {
                               //SoftSalesvalue.get(Oppl.Opportunityid)=SoftSalesvalue.get(Oppl.Opportunityid)+(Oppl.totalprice);
                               SoftSalesvalue.put(Oppl.Opportunityid,SoftSalesvalue.get(Oppl.Opportunityid)+(Oppl.totalprice));
                               System.debug('SalesValue' + SoftSalesvalue);
                              }
                              else
                              {
                                SoftSalesvalue.put(Oppl.Opportunityid,(Oppl.totalprice));
                                 System.debug('SalesValue' + SoftSalesvalue);
                              }
                             
                             Continue;
                        }
                     }
                     
                     // Below is for MR Services Discount
                  
                      if(Oppl.pricebookentry.Product2.Product_Group__c=='MDLSVCSR' ||Oppl.pricebookentry.Product2.Product_Group__c=='MDLSVCS' )
                      {
                          if(MRServicesDiscount__c.getInstance(Oppl.pricebookentry.Product2.ProductCode) !=Null)
                          {
                            if((Oppl.listprice !=Null && Oppl.listprice !=0.0) && Oppl.Custom_Price__c <=Oppl.listprice ) 
                            {
                              // Use to calculate total price 
                              if(SrvcTotalvalue.containskey(Oppl.Opportunityid))
                              {
                                //SrvcTotalvalue.get(Oppl.Opportunityid)=SrvcTotalvalue.get(Oppl.Opportunityid)+(Oppl.listprice*Oppl.Quantity);
                                SrvcTotalvalue.Put(Oppl.Opportunityid,SrvcTotalvalue.get(Oppl.Opportunityid)+(Oppl.listprice*Oppl.Quantity));
                              }
                              else
                              {
                                SrvcTotalvalue.put(Oppl.Opportunityid,(Oppl.listprice*Oppl.Quantity));
                                
                              }
                              // Use to calculate total sales value
                              if(SrvcSalesvalue.containskey(Oppl.Opportunityid))
                              {
                              //SrvcSalesvalue.get(Oppl.Opportunityid)=SrvcSalesvalue.get(Oppl.Opportunityid)+(Oppl.totalprice);
                              SrvcSalesvalue.put(Oppl.Opportunityid,SrvcSalesvalue.get(Oppl.Opportunityid)+(Oppl.totalprice));
                              }
                              else
                              {
                                SrvcSalesvalue.put(Oppl.Opportunityid,(Oppl.totalprice));
                                
                              }
                                
                                Continue;
                            }
                          }
                      }
                      //Below is for Training discount
                      if(Oppl.pricebookentry.Product2.Product_Group__c=='MDLSVCSR'  || Oppl.pricebookentry.Product2.Product_Group__c=='MDLSVCS'  || Oppl.pricebookentry.Product2.Product_Group__c=='MDLSVCSREC' )
                      {
                          
                          if(MRServicesDiscount__c.getInstance(Oppl.pricebookentry.Product2.ProductCode) == Null )
                          { 
                            if((Oppl.listprice !=Null && Oppl.listprice !=0.0) && Oppl.Custom_Price__c <=Oppl.listprice ) 
                             {
                                 // Use to calculate total price 
                              if(TrnTotalvalue.containskey(Oppl.Opportunityid))
                              {
                                //TrnTotalvalue.get(Oppl.Opportunityid)=TrnTotalvalue.get(Oppl.Opportunityid)+(Oppl.listprice*Oppl.Quantity);
                                TrnTotalvalue.put(Oppl.Opportunityid,TrnTotalvalue.get(Oppl.Opportunityid)+(Oppl.listprice*Oppl.Quantity));
                              }
                              else
                              {
                                TrnTotalvalue.put(Oppl.Opportunityid,(Oppl.listprice*Oppl.Quantity));
                                
                              }
                              // Use to calculate total sales value
                              if(TrnSalesvalue.containskey(Oppl.Opportunityid))
                              {
                                //TrnSalesvalue.get(Oppl.Opportunityid)=TrnSalesvalue.get(Oppl.Opportunityid)+(Oppl.totalprice);
                                TrnSalesvalue.put(Oppl.Opportunityid,TrnSalesvalue.get(Oppl.Opportunityid)+(Oppl.totalprice));
                              }
                              else
                              {
                                TrnSalesvalue.put(Oppl.Opportunityid,(Oppl.totalprice));
                                
                              }
                                  Continue;
                             }
                          }
                         
                        
                      }
                    
                  }
                  
                  
                  
                  
                  
                  
                
               }
               
               
              
              
              For(Opportunity Op : newlist)
              {  
                  
                   if(Op.Pricebook2id==Mpriid.id && Op.Pricebook2id != Null)
                   {
                    
                         if(SoftTotalvalue.ContainsKey(Op.id))        
                          {
                             System.debug('+++'+ SoftTotalvalue.get(Op.id) +'++++' +String.Valueof(SoftSalesvalue.get(Op.id) ));
                            Op.MR_Software_Discount__c=((SoftTotalvalue.get(Op.id)-SoftSalesvalue.get(Op.id))/SoftTotalvalue.get(Op.id))*100;
                          }
                          if(SrvcTotalvalue.Containskey(Op.id))
                          {
                            Op.MR_Services_Discount__c=((SrvcTotalvalue.get(Op.id)-SrvcSalesvalue.get(Op.id))/SrvcTotalvalue.get(Op.id))*100;
                          }
                          if(TrnTotalvalue.Containskey(Op.id))
                          {
                            Op.MR_Training_Discount__c=((TrnTotalvalue.get(Op.id)-TrnSalesvalue.get(Op.id))/TrnTotalvalue.get(Op.id))*100;
                          }
                
                   }
                
              }
              
            } 
            
        }
   // Written By Nikhil Start Date:- 05/07/2014
   // Need to divide the work in CPQ and Non CPQ process  

  // Written By Nikhil Start Date:- 05/07/2014
     // To Identify exceptional perpetual products
Private void ExceptionalPerpetual(Opportunity[] updatedOpportunities)
  {
  
        //Ids of updated Opps for CPQ
         Set<id> Oppids = new set<id>();
        // Map of opp and Product Group
        Map<id,String> SumofGrp = New Map<id,String>();
        
        //Add to set only for opporunity with lineitem
         For(Opportunity opp: updatedOpportunities)
         {
         
         Oppids.add(opp.id);
         
         }
             
        If(Oppids.Size()>0)
        {
        
            For(OpportunityLineitem oppl :[Select id,Currencyisocode,Product2.Platform__c,Product2.Name,CPQ_Previous_Year_Net_Price__c,Product2.Product_Group__c,TotalPrice,CPQ_Product_Status__c,Type__c,ACCT_Product_Type__c,Product2.Perpetual__c,Opportunityid,PS_Product_ID__c,CPQ_Platform__c,opportunity.Currencyisocode from OpportunityLineitem Where Opportunityid IN : Oppids  ORDER BY CPQ_Product_Status__c DESC])
            {
            
                //TO find the exceptional perpetual combination.
                If(Oppl.Product2.Platform__c=='Analytics' || Oppl.Product2.Platform__c=='Learn' )
                {
                    If(SumofGrp.Containskey(Oppl.Opportunityid))
                      {  
                         // Donot add the same product groups
                         if(!SumofGrp.get(Oppl.Opportunityid).contains(Oppl.Product2.Product_Group__c)) 
                         { 
                           SumofGrp.put(Oppl.Opportunityid,SumofGrp.get(Oppl.Opportunityid)+ Oppl.Product2.Product_Group__c);
                         }
                         else
                         Continue;    
                      }
                      Else
                      {
                       SumofGrp.put(Oppl.Opportunityid,Oppl.Product2.Product_Group__c);
                      
                      }
                }
            }
         
        }
       System.debug('++++' + SumofGrp);     
        For(Opportunity opp: updatedOpportunities)
         { 
           
           if(SumofGrp.Containskey(opp.id))
           {
             if(PerpetualException__c.getAll().ContainsKey(SumofGrp.get(opp.id)))
             { 
               System.debug('++NN++' + SumofGrp.get(opp.id));
                opp.Exceptional_Perpetual__c=true;
             
             }
             else
             {
                 opp.Exceptional_Perpetual__c=false;
             
             }         
           }
         }
  }

   // Written By Nikhil Start Date:- 05/07/2014
Private void CreateReportingValues(Opportunity[] updatedOpportunities)
   {
      
           // Ids of updated Opps for CPQ
            Set<id> Oppids = new set<id>();
            
            // Id of Non CPQ opps
            Set<id> NonCPQid = New Set<id>();
            
            // Ids for all CPQ and Non CPQ
            set<id> AllOpps = New set<id>();
            
            //Replicated Renewal Opportunity
            Id repid='01270000000Hn7XAAS';
            
            //Add to set only for opporunity with lineitem
            For(Opportunity opp: updatedOpportunities)
            {
                 
                 if(opp.Recordtypeid !=repid)
                 {
                    // For CPQ and Non CPQ
                    if(opp.PFIN_Intgr_Record_Type__c.contains('CPQ') )
                        Oppids.add(opp.id);
                    else
                        NonCPQid.add(opp.id);
                    
                    // For all
                    AllOpps.add(opp.id);
                 }   
                      
            }
            // Delete all Opportunity value objects 
            if(AllOpps.size()>0)
            {
              Delete [Select id from Opportunity_Value__c Where Opportunity_c__c IN : AllOpps];
            }
            
            //List of reproting value objects
            List<Opportunity_Value__c> LReportingValue = New List<Opportunity_Value__c>();          
            
            // For CPQ process
            if(Oppids.size()>0)
            {
            
            // Map of total  New contract value
            Map<id,Double> NewCon= New Map<id,Double>();
            // Map for totoal  expiring contract value
            Map<id,Double> RenCon = New Map<id,Double>();
            
            List<OpportunityLineitem> Lopp=[Select id,Product2.Productcode,Opportunity.Account_Country__c,Quota_New_Sales_Adjustment__c,Quota_Renewal_Sales_Adjustment__c,Opportunity.Start_Date__c,Opportunity.End_Date__c,Opportunity.Exceptional_Perpetual__c,Currencyisocode,Product2.Platform__c,Product2.Name,CPQ_Previous_Year_Net_Price__c,Product2.Product_Group__c,TotalPrice,CPQ_Product_Status__c,Type__c,ACCT_Product_Type__c,Product2.Perpetual__c,Opportunityid,PS_Product_ID__c,CPQ_Platform__c,opportunity.Currencyisocode from OpportunityLineitem Where Opportunityid IN : Oppids  ORDER BY CPQ_Product_Status__c DESC];
            
                
            
            For(OpportunityLineItem Oppl : Lopp)
            {
                
                 // Store total New contract value
                if(Oppl.TotalPrice != Null)
                {
                      
                     If(NewCon.Containskey(Oppl.Opportunityid))
                      {
                          
                        NewCon.put(Oppl.Opportunityid,NewCon.get(Oppl.Opportunityid)+ Oppl.TotalPrice); 
                      }
                      Else
                      {
                       NewCon.put(Oppl.Opportunityid,Oppl.TotalPrice);
                      
                      }
                }  
                  
                  // Store total Expiring contract value
               //if(Oppl.CPQ_Previous_Year_Net_Price__c!= Null)
                 {
                      
                      If(RenCon.Containskey(Oppl.Opportunityid))
                      {
                        if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)  
                        RenCon.put(Oppl.Opportunityid,RenCon.get(Oppl.Opportunityid)+ Oppl.CPQ_Previous_Year_Net_Price__c);
                        else
                        RenCon.put(Oppl.Opportunityid,RenCon.get(Oppl.Opportunityid)+ 0.0); 
                      }
                      Else
                      {
                       if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null) 
                       RenCon.put(Oppl.Opportunityid,Oppl.CPQ_Previous_Year_Net_Price__c);
                       else
                       RenCon.put(Oppl.Opportunityid,0.0);
                      
                      }
                  }     
            }
              
              // To calculate these values on the basis of product group
              Map<id,Map<string,Map<string,Double>>> MExpCon = New Map<id,Map<string,Map<string,Double>>>();
              Map<id,Map<string,Map<string,Double>>> MNewCon = New Map<id,Map<string,Map<string,Double>>>();
              Map<id,Map<string,Map<string,Double>>> MNewSale = New Map<id,Map<string,Map<string,Double>>>();
              Map<id,Map<string,Map<string,Double>>> MRenSale = New Map<id,Map<string,Map<string,Double>>>();
              Map<id,Map<string,Map<String,Double>>> MDrop = New Map<id,Map<string,Map<string,Double>>>();
              
              // TP 12783
              Map<id,Map<string,Map<string,Double>>> MNewConCus = New Map<id,Map<string,Map<string,Double>>>();
              
              //Map of opportunityid, Productcode and Acct gorup(TP12783)
              Map<id,Map<string,String>> MapPrdCOdeGrp = New  Map<id,Map<string,String>>();
              
              
              
              For(OpportunityLineItem Oppl : Lopp)
              {  
                 // Expiring contracts Start
                 if(MExpCon.ContainsKey(Oppl.Opportunityid))
                 {
                    
                    if(MExpCon.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                    {   
                            
                        if(MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.Product_Group__c))
                        {
                         
                         Map<string,Double> temp= New Map<String,Double>();
                         temp=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                         if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                         temp.put(Oppl.Product2.Product_Group__c,MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+Oppl.CPQ_Previous_Year_Net_Price__c);
                         else
                         temp.put(Oppl.Product2.Product_Group__c,MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+0.0);
                         Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                         temp1=MExpCon.get(Oppl.Opportunityid);
                         temp1.put(Oppl.Product2.Platform__c,temp);
                         MExpCon.put(Oppl.Opportunityid,temp1);
                           
                        }
                        else
                        {
                           Map<string,Double> temp= New Map<String,Double>();
                           temp=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                           if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                           temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                           else
                           temp.put(Oppl.Product2.Product_Group__c,0.0);
                           
                            Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                            temp1=MExpCon.get(Oppl.Opportunityid);
                            temp1.put(Oppl.Product2.Platform__c,temp);
                            MExpCon.put(Oppl.Opportunityid,temp1);
                        
                        }
                    
                    }
                    else
                    {
                    
                       Map<string,Double> temp= New Map<String,Double>();
                       if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                       temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                       else
                       temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                       Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                       temp1=MExpCon.get(Oppl.Opportunityid);
                       temp1.put(Oppl.Product2.Platform__c,temp);
                       
                       MExpCon.put(Oppl.opportunityid,temp1);        
                    
                    }
                 }
                 else
                 {
                    Map<string,Double> temp= New Map<String,Double>();
                    if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                    temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                    else
                    temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                    Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                    temp1.put(Oppl.Product2.Platform__c,temp);
                    
                    MExpCon.put(Oppl.opportunityid,temp1);
                  
                 }
                 
              // Expiring contracts END
              // New Contracts start
                 if(MNewCon.ContainsKey(Oppl.Opportunityid))
                 {
                    
                    if(MNewCon.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                    {   
                            
                        if(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.Product_Group__c))
                        {
                         
                         Map<string,Double> temp= New Map<String,Double>();
                         temp=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                         if(Oppl.TotalPrice!=Null)
                         temp.put(Oppl.Product2.Product_Group__c,MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+Oppl.TotalPrice);
                         else
                         temp.put(Oppl.Product2.Product_Group__c,MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+0.0);
                         Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                         temp1=MNewCon.get(Oppl.Opportunityid);
                         temp1.put(Oppl.Product2.Platform__c,temp);
                         MNewCon.put(Oppl.Opportunityid,temp1);
                           
                        }
                        else
                        {
                           Map<string,Double> temp= New Map<String,Double>();
                           temp=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                           if(Oppl.TotalPrice!=Null)
                           temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                           else
                           temp.put(Oppl.Product2.Product_Group__c,0.0);
                           
                            Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                            temp1=MNewCon.get(Oppl.Opportunityid);
                            temp1.put(Oppl.Product2.Platform__c,temp);
                            MNewCon.put(Oppl.Opportunityid,temp1);
                        
                        }
                    
                    }
                    else
                    {
                    
                       Map<string,Double> temp= New Map<String,Double>();
                       if(Oppl.TotalPrice!=Null)
                       temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                       else
                       temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                       Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                       temp1=MNewCon.get(Oppl.Opportunityid);
                       temp1.put(Oppl.Product2.Platform__c,temp);
                       
                       MNewCon.put(Oppl.opportunityid,temp1);        
                    
                    }
                 }
                 else
                 {
                    Map<string,Double> temp= New Map<String,Double>();
                    if(Oppl.TotalPrice!=Null)
                    temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                    else
                    temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                    Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                    temp1.put(Oppl.Product2.Platform__c,temp);
                    
                    MNewCon.put(Oppl.opportunityid,temp1);
                  
                 }
               //END 
               
              // For Renwal sales Calculation
              If(Oppl.CPQ_Product_Status__c=='Renew' || Oppl.CPQ_Product_Status__c=='Renewal')
              {
                if(MRenSale.ContainsKey(Oppl.Opportunityid))
                 {
                    
                    if(MRenSale.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                    {   
                            
                        if(MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.Product_Group__c))
                        {
                         
                         Map<string,Double> temp= New Map<String,Double>();
                         temp=MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                         if(Oppl.TotalPrice!=Null)
                         temp.put(Oppl.Product2.Product_Group__c,MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+Oppl.TotalPrice);
                         else
                         temp.put(Oppl.Product2.Product_Group__c,MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+0.0);
                         Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                         temp1=MRenSale.get(Oppl.Opportunityid);
                         temp1.put(Oppl.Product2.Platform__c,temp);
                         MRenSale.put(Oppl.Opportunityid,temp1);
                           
                        }
                        else
                        {
                           Map<string,Double> temp= New Map<String,Double>();
                           temp=MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                           if(Oppl.TotalPrice!=Null)
                           temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                           else
                           temp.put(Oppl.Product2.Product_Group__c,0.0);
                           
                            Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                            temp1=MRenSale.get(Oppl.Opportunityid);
                            temp1.put(Oppl.Product2.Platform__c,temp);
                            MRenSale.put(Oppl.Opportunityid,temp1);
                        
                        }
                    
                    }
                    else
                    {
                    
                       Map<string,Double> temp= New Map<String,Double>();
                       if(Oppl.TotalPrice!=Null)
                       temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                       else
                       temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                       Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                       temp1=MRenSale.get(Oppl.Opportunityid);
                       temp1.put(Oppl.Product2.Platform__c,temp);
                       
                       MRenSale.put(Oppl.opportunityid,temp1);        
                    
                    }
                 }
                 else
                 {
                    Map<string,Double> temp= New Map<String,Double>();
                    if(Oppl.TotalPrice!=Null)
                    temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                    else
                    temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                    Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                    temp1.put(Oppl.Product2.Platform__c,temp);
                    
                    MRenSale.put(Oppl.opportunityid,temp1);
                  
                 } 
              }
              // END
              // New sales calcualtion
              If(Oppl.CPQ_Product_Status__c=='Renew' || Oppl.CPQ_Product_Status__c=='Renewal')
              {
                if(MNewSale.ContainsKey(Oppl.Opportunityid))
                 {
                    
                    if(MNewSale.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                    {   
                            
                        if(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.Product_Group__c))
                        {
                         
                         Map<string,Double> temp= New Map<String,Double>();
                         temp=MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                         if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                         temp.put(Oppl.Product2.Product_Group__c,MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+Oppl.CPQ_Previous_Year_Net_Price__c);
                         else
                         temp.put(Oppl.Product2.Product_Group__c,MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+0.0);
                         Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                         temp1=MNewSale.get(Oppl.Opportunityid);
                         temp1.put(Oppl.Product2.Platform__c,temp);
                         MNewSale.put(Oppl.Opportunityid,temp1);
                           
                        }
                        else
                        {
                           Map<string,Double> temp= New Map<String,Double>();
                           temp=MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                           if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                           temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                           else
                           temp.put(Oppl.Product2.Product_Group__c,0.0);
                           
                            Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                            temp1=MNewSale.get(Oppl.Opportunityid);
                            temp1.put(Oppl.Product2.Platform__c,temp);
                            MNewSale.put(Oppl.Opportunityid,temp1);
                        
                        }
                    
                    }
                    else
                    {
                    
                       Map<string,Double> temp= New Map<String,Double>();
                       if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                       temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                       else
                       temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                       Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                       temp1=MNewSale.get(Oppl.Opportunityid);
                       temp1.put(Oppl.Product2.Platform__c,temp);
                       
                       MNewSale.put(Oppl.opportunityid,temp1);        
                    
                    }
                 }
                 else
                 {
                    Map<string,Double> temp= New Map<String,Double>();
                    if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                    temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                    else
                    temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                    Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                    temp1.put(Oppl.Product2.Platform__c,temp);
                    
                    MNewSale.put(Oppl.opportunityid,temp1);
                  }
                 } 
              //END 
              // Grouped by Dropped Start
        if(Oppl.CPQ_Product_Status__c=='Dropped')
         {
                if(MDrop.ContainsKey(Oppl.Opportunityid))
                 {
                    
                    if(MDrop.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                    {   
                            
                        if(MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.Product_Group__c))
                        {
                         
                         Map<string,Double> temp= New Map<String,Double>();
                         temp=MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                         if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                         temp.put(Oppl.Product2.Product_Group__c,MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+Oppl.CPQ_Previous_Year_Net_Price__c);
                         else
                         temp.put(Oppl.Product2.Product_Group__c,MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+0.0);
                         Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                         temp1=MDrop.get(Oppl.Opportunityid);
                         temp1.put(Oppl.Product2.Platform__c,temp);
                         MDrop.put(Oppl.Opportunityid,temp1);
                           
                        }
                        else
                        {
                           Map<string,Double> temp= New Map<String,Double>();
                           temp=MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                           if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                           temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                           else
                           temp.put(Oppl.Product2.Product_Group__c,0.0);
                           
                            Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                            temp1=MDrop.get(Oppl.Opportunityid);
                            temp1.put(Oppl.Product2.Platform__c,temp);
                            MDrop.put(Oppl.Opportunityid,temp1);
                        
                        }
                    
                    }
                    else
                    {
                    
                       Map<string,Double> temp= New Map<String,Double>();
                       if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                       temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                       else
                       temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                       Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                       temp1=MDrop.get(Oppl.Opportunityid);
                       temp1.put(Oppl.Product2.Platform__c,temp);
                       
                       MDrop.put(Oppl.opportunityid,temp1);        
                    
                    }
                 }
                 else
                 {
                    Map<string,Double> temp= New Map<String,Double>();
                    if(Oppl.CPQ_Previous_Year_Net_Price__c!=Null)
                    temp.put(Oppl.Product2.Product_Group__c,Oppl.CPQ_Previous_Year_Net_Price__c);
                    else
                    temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                    Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                    temp1.put(Oppl.Product2.Platform__c,temp);
                    
                    MDrop.put(Oppl.opportunityid,temp1);
                  
                 }
         }   
         // Start(12783)  
            // Map of contarct value for 12783
            If(Oppl.CPQ_Product_Status__c=='New' )
                {
                    if(MNewConCus.ContainsKey(Oppl.Opportunityid))
                     {
                        
                        if(MNewConCus.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                        {   
                                
                            if(MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.ProductCode))
                            {
                             
                             Map<string,Double> temp= New Map<String,Double>();
                             temp=MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                             if(Oppl.TotalPrice!=Null)
                             temp.put(Oppl.Product2.ProductCode,MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.ProductCode)+Oppl.TotalPrice);
                             else
                             temp.put(Oppl.Product2.ProductCode,MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.ProductCode)+0.0);
                             Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                             temp1=MNewConCus.get(Oppl.Opportunityid);
                             temp1.put(Oppl.Product2.Platform__c,temp);
                             MNewConCus.put(Oppl.Opportunityid,temp1);
                               
                            }
                            else
                            {
                               Map<string,Double> temp= New Map<String,Double>();
                               temp=MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                               if(Oppl.TotalPrice!=Null)
                               temp.put(Oppl.Product2.ProductCode,Oppl.TotalPrice);
                               else
                               temp.put(Oppl.Product2.ProductCode,0.0);
                               
                                Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                                temp1=MNewConCus.get(Oppl.Opportunityid);
                                temp1.put(Oppl.Product2.Platform__c,temp);
                                MNewConCus.put(Oppl.Opportunityid,temp1);
                            
                            }
                        
                        }
                        else
                        {
                        
                           Map<string,Double> temp= New Map<String,Double>();
                           if(Oppl.TotalPrice!=Null)
                           temp.put(Oppl.Product2.ProductCode,Oppl.TotalPrice);
                           else
                           temp.put(Oppl.Product2.ProductCode,0.0);
                        
                           Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                           temp1=MNewConCus.get(Oppl.Opportunityid);
                           temp1.put(Oppl.Product2.Platform__c,temp);
                           
                           MNewConCus.put(Oppl.opportunityid,temp1);        
                        
                        }
                     }
                     else
                     {
                        Map<string,Double> temp= New Map<String,Double>();
                        if(Oppl.TotalPrice!=Null)
                        temp.put(Oppl.Product2.ProductCode,Oppl.TotalPrice);
                        else
                        temp.put(Oppl.Product2.ProductCode,0.0);
                        
                        Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                        temp1.put(Oppl.Product2.Platform__c,temp);
                        
                        MNewConCus.put(Oppl.opportunityid,temp1);
                      
                     }
                }

                //END (12783) 
                 // TP:12783(Mapping of Product code to acct group(Start))  
                If(Oppl.CPQ_Product_Status__c=='New' )
                 {
                      if(MapPrdCOdeGrp.ContainsKey(Oppl.Opportunityid))
                      {
                        Map<String,String> temp1 = New Map<String,String>();
                        temp1=MapPrdCOdeGrp.get(Oppl.Opportunityid);
                        temp1.put(Oppl.Product2.ProductCode,Oppl.Product2.Product_Group__c);
                        MapPrdCOdeGrp.put(Oppl.Opportunityid,temp1);
                        
                      
                      }
                      else
                      {
                        Map<string,String> temp= New Map<String,String>();
                        temp.put(Oppl.Product2.ProductCode,Oppl.Product2.Product_Group__c);
                        MapPrdCOdeGrp.put(Oppl.Opportunityid,temp);
                      }
                    
                        
                 }
                // END     
        // END      
            }
            //End of Line item Looop
            
            // set of string to run once for a product group
            Set<String> PreRun = new Set<String>();
            
            //TP12783
             Set<string> PRDCode = New Set<String>();
             
             //TP12783 Addition Add
             // to Avoid Additional Add,If same Product with replace and New
             Map<String,Double> LegacyNew = New Map<String,Double>();
            
            // Run once
            Boolean firstRun1= false;
            
            
            For(Opportunitylineitem oppl :Lopp)
            {
            
              If(PreRun.contains(Oppl.OpportunityId+Oppl.Product2.Platform__c+oppl.Product2.Product_Group__c) || PRDCode.Contains(Oppl.Opportunityid+oppl.Product2.Productcode))
              {
                Continue;
              }
              Else
              {
             PreRun.add(Oppl.OpportunityId+Oppl.Product2.Platform__c+oppl.Product2.Product_Group__c);
             Opportunity_Value__c opprep = New Opportunity_Value__c();
             //TP:12783
             IF(LegacyProductCodeMap__c.getInstance(oppl.Product2.Productcode)!=Null && MNewConCus.ContainsKey(Oppl.Opportunityid) && MNewConCus.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(LegacyProductCodeMap__c.getinstance(oppl.Product2.Productcode).Current_Product_Code__c))
             {
              opprep.Name=MapPrdCOdeGrp.get(Oppl.Opportunityid).get(LegacyProductCodeMap__c.getInstance(oppl.Product2.Productcode).Current_Product_Code__c);
             }
             else
             {
             opprep.Name=Oppl.Product2.Product_Group__c;
             }
             opprep.CurrencyIsoCode= Oppl.Currencyisocode;
             opprep.Opportunity_c__c=oppl.Opportunityid;
             opprep.Platform__c=oppl.CPQ_Platform__c; 
             opprep.CurrencyIsoCode__c=oppl.opportunity.Currencyisocode;
             if(oppl.ACCT_Product_Type__c=='Services')
             opprep.IsServices__c=True;
             if(oppl.ACCT_Product_Type__c=='Software')
             opprep.IsSoftware__c=True;
             if(oppl.ACCT_Product_Type__c=='Managed Hosting')
             opprep.IsManagedHosting__c=True;
             if(oppl.Type__c=='Recurring')
             opprep.IsRecurring__c=True;
             if(oppl.Product2.Perpetual__c=='true')
             opprep.IsPerpetual__c=true;
             else
             opprep.IsPerpetual__c=false;
             
             If(oppl.Product2.Product_Group__c!=Null)
             opprep.ACCT_Product_Group__c=oppl.Product2.Product_Group__c;
             // New contract
             opprep.Amount__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
             // Expiring contract
             opprep.Expiring_Contract_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
             //Renewal Sales Value
           
           
           //Renewal sales Caculation Start
              If(Oppl.CPQ_Product_Status__c!='Dropped')
              {
                  
                  if(Oppl.CPQ_Product_Status__c=='Replace-Package' || Oppl.CPQ_Product_Status__c=='Replace' || Oppl.CPQ_Product_Status__c=='Renew' || Oppl.CPQ_Product_Status__c=='Renewal')
                   {
                      
                      // Product Group has Renewal products
                      if(MRenSale.ContainsKey(Oppl.Opportunityid) && MRenSale.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                      {
                         
                               if(NewCon.get(oppl.Opportunityid)> RenCon.get(oppl.Opportunityid))
                                 {
                                      if(MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) > MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c))
                                        { 
                                         
                                          if(MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                                           {
                                            
                                            opprep.Renewal_sales_value__c=(MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) +(MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)- MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)))-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                            opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c +MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                           }
                                           Else
                                           {
                                            opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) +(MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                            opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c;
                                           }
                                        }
                                        else
                                        {
                                          if(MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                                           { 
                                              if(MRenSale.ContainsKey(Oppl.Opportunityid) && MRenSale.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                                              {
                                              opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                              opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c + MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) + (MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                              }
                                              else
                                              {
                                              opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                              opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c + MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                              }
                                           } 
                                           Else
                                           { 
                                              if(MRenSale.ContainsKey(Oppl.Opportunityid) && MRenSale.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                                              {
                                              opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                              opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c + (MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                              }
                                              else
                                              {
                                              opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                              opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                                              }
                                           }
                                                                                    
                                        }
                                }
                                else
                                {    // No Need check for Drop. I add might be work in future
                                    if(MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                                    {
                                       opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                       opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                                    }
                                    Else
                                    {
                                    opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                    opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                                    }
                        
                                }
                          
                         
                      }
                      Else
                      {
                        if(MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                        {
                        
                            If(NewCon.get(oppl.Opportunityid)-RenCon.get(oppl.Opportunityid)>0)
                            {
                               opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                               opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c -MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) ;
                            }
                            else
                            {
                               opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                               opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                            }
                        }
                        Else
                        {
                        
                        If(NewCon.get(oppl.Opportunityid)-RenCon.get(oppl.Opportunityid)>0)
                        {
                         System.debug('Testtest' + oppl.Product2.Productcode);
                           //TP12783
                           // System.debug('TestNIkhil'+ LegacyProductCodeMap__c.getInstance(oppl.Product2.productcode) + MNewConCus.ContainsKey(Oppl.Opportunityid) +MNewConCus.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c)+ MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(LegacyProductCodeMap__c.getinstance(oppl.Product2.Productcode).Current_Product_Code__c));
                            IF(LegacyProductCodeMap__c.getInstance(oppl.Product2.Productcode)!=Null && MNewConCus.ContainsKey(Oppl.Opportunityid) && MNewConCus.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(LegacyProductCodeMap__c.getinstance(oppl.Product2.Productcode).Current_Product_Code__c))
                            {   
                                system.debug('Legacy Product');
                                PRDCode.add(Oppl.Opportunityid + LegacyProductCodeMap__c.getInstance(oppl.Product2.Productcode).Current_Product_Code__c); 
                                opprep.Renewal_sales_value__c=MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(LegacyProductCodeMap__c.getinstance(oppl.Product2.Productcode).Current_Product_Code__c);
                                opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                                //Added New 12783
                                LegacyNew.put(Oppl.Opportunityid+MapPrdCOdeGrp.get(Oppl.Opportunityid).get(LegacyProductCodeMap__c.getInstance(oppl.Product2.Productcode).Current_Product_Code__c),opprep.Quota_Renewal_Sales__c);
                            }
                            else
                            {
                             opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                             opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                            } 
                        }
                        else
                        {
                         opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                         opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c ;
                        }  
                        
                        }
                      
                      }
                      
                   }
                   Else if(Oppl.CPQ_Product_Status__c=='New' && !PRDCode.contains(Oppl.product2.Productcode))
                    { 
                        
                        firstRun1=True;
                        opprep.Renewal_sales_value__c=0.0;
                        
                        
                           if(MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                            { 
                               if(NewCon.get(oppl.Opportunityid)>= RenCon.get(oppl.Opportunityid))
                                {
                                    opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                    opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c + MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                }
                                else
                                {
                                  opprep.New_Sales__c=0.0;
                                  opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c); 
                                  opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c;
                                }
                            }
                            else
                            { 
                               if(NewCon.get(oppl.Opportunityid)> RenCon.get(oppl.Opportunityid))
                               {
                                 //TP12783 New
                                  if(LegacyNew.ContainsKey(oppl.Opportunityid+oppl.Product2.Product_Group__c))
                                  {
                                    opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-LegacyNew.get(oppl.Opportunityid+oppl.Product2.Product_Group__c);
                                    opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c;
                                    
                                  }
                                  else
                                  {
                                     opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                     opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c;
                                  }     
                               }
                               else
                               {
                                opprep.New_Sales__c=0.0;
                                opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c); 
                                opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c;
                               
                               }
                            } 
                if(NewCon.get(oppl.Opportunityid)>= RenCon.get(oppl.Opportunityid))
                   {   
                         
                         if(Oppl.opportunity.Exceptional_Perpetual__c==True && (Oppl.CPQ_Platform__c=='Analytics'||Oppl.CPQ_Platform__c=='Learn'))
                            {
                                if(PerpetualProducts__c.getAll().ContainsKey(Oppl.Product2.Product_Group__c))
                                {   
                                     opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                }
                                else if(Oppl.opportunity.End_Date__c!= Null && Oppl.opportunity.Start_Date__c!=Null && Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)> 365)
                                {
                                   // Added for Leap Year
                                   if((Date.isLeapYear(Oppl.opportunity.Start_Date__c.Year())&& Oppl.opportunity.Start_Date__c.month()<=2) ||(Date.isLeapYear(Oppl.opportunity.End_Date__c.Year())&& Oppl.opportunity.End_Date__c.month()>2) )
                                   {  
                                         opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*366;
                                   }
                                   else
                                   {
                                       opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*365;
                                   }
                                
                                }
                                else
                                {
                                    opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                }
                            } 
                            else
                            {
                               if(PerpetualProducts__c.getAll().ContainsKey(Oppl.Product2.Product_Group__c))
                               {
                                
                                //testing code
                                //if((opprep.Name == 'CDPERPSUP')){
                                  //  opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                //}
                                if((Oppl.Opportunity.Account_Country__c == 'China')){
                                    opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                    system.debug('MGMG'+opprep.Quota_New_Sales__c);
                                }

                                else {
                                    opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/3);
                                    system.debug('MGMGMG'+opprep.Quota_New_Sales__c);
                                
                                }
                                
                               }
                               else if(Oppl.opportunity.End_Date__c!= Null && Oppl.opportunity.Start_Date__c!=Null && Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)>365)
                                {
                                  if((Date.isLeapYear(Oppl.opportunity.Start_Date__c.Year())&& Oppl.opportunity.Start_Date__c.month()<=2) ||(Date.isLeapYear(Oppl.opportunity.End_Date__c.Year())&& Oppl.opportunity.End_Date__c.month() >2) )
                                   {  
                                         opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*366;
                                   }
                                   else
                                   {  
                                    opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*365;
                                   }
                                }
                                else
                                {
                                    opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                    opprep.Quota_New_Sales__c=opprep.New_Sales__c;
                                }
                                
                            } 
                    }
                    else
                    {
                     opprep.Quota_New_Sales__c=opprep.New_Sales__c;
                    }       
                        
                    // To make  run on New status
                      /*
                       if(MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                        {
                        
                            If(NewCon.get(oppl.Opportunityid)-RenCon.get(oppl.Opportunityid)>=0)
                               opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                            else
                               opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                          
                        }
                        Else
                        {
                        
                        If(NewCon.get(oppl.Opportunityid)-RenCon.get(oppl.Opportunityid)>=0)
                         opprep.Renewal_sales_value__c=MExpCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                        else
                         opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                          
                        
                        }
                       */
                    }
                  
              }
              else
              {
                
                  
                  if(NewCon.get(oppl.Opportunityid)> RenCon.get(oppl.Opportunityid))
                    {
                     opprep.Quota_Renewal_Sales__c=MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                     opprep.Renewal_sales_value__c=0.0;
                    }
                    else
                    {
                      opprep.Renewal_sales_value__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                      opprep.Quota_Renewal_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                    }
          
              } 
           // END   
              // New Sales Value
              If(Oppl.CPQ_Product_Status__c!='Dropped')
              {   
                  if(firstRun1== False)
                  {  
                    
                     if(NewCon.get(oppl.Opportunityid)> RenCon.get(oppl.Opportunityid))
                     {
                    
                        if(MRenSale.ContainsKey(Oppl.Opportunityid) && MRenSale.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c)&& (MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) < MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)))
                          {
                              if( MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                              {
                                  opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c-(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c))-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                  opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c-(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c))-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                              }
                              else
                              {
                               opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c-(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                               opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c-(MNewSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-MRenSale.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                              
                              }
                          }
                          else
                          {  
                             if( MDrop.ContainsKey(Oppl.Opportunityid) && MDrop.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(oppl.Product2.Product_Group__c))
                              {
                               
                                     if(opprep.Renewal_sales_value__c!= Null)
                                     {
                                      opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c -MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                      opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c -MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                     }
                               }
                               else
                               {
                                  if(opprep.Renewal_sales_value__c!= Null)
                                     {
                                       //TP12783
                                       IF(LegacyProductCodeMap__c.getInstance(oppl.Product2.Productcode)!=Null && MNewConCus.ContainsKey(Oppl.Opportunityid) && MNewConCus.get(Oppl.Opportunityid).ContainsKey(Oppl.Product2.Platform__c) && MNewConCus.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(LegacyProductCodeMap__c.getinstance(oppl.Product2.Productcode).Current_Product_Code__c))
                                       {
                                        opprep.New_Sales__c=0.0;
                                        opprep.Quota_New_Sales__c=0.0;
                                       }
                                       else
                                       { 
                                        
                                         opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c;
                                         opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)-opprep.Renewal_sales_value__c;
                                       } 
                                     }
                               }      
                           }
                     }
                     else
                     {
                       opprep.New_Sales__c=0.0;
                       opprep.Quota_New_Sales__c=0.0;
                     } 
                  }
                      
              } 
              else
              {  
                 if(NewCon.get(oppl.Opportunityid)> RenCon.get(oppl.Opportunityid))
                 {
                    opprep.New_Sales__c=-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) + MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                    opprep.Quota_New_Sales__c=-MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)+ MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                    opprep.Renewal_Sales_Adjustment__c=MDrop.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                  }
                  else
                  {
                   // Commented as no need.
                     /*
                      if(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c) >0)
                      {
                       opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                       opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                      }
                    */  
                      // If overall drop in contract then New sales and Renewal sales value will be 0.
                      {
                        opprep.New_Sales__c=0.0;
                        opprep.Quota_New_Sales__c=0.0;
                      
                      } 
                       opprep.Renewal_Sales_Adjustment__c=0.0;
                  }  
              }
              // testing code
              
if(oppl.Quota_New_Sales_Adjustment__c != null && oppl.Quota_New_Sales_Adjustment__c > 0 ){
                 
                 Decimal masternewsalesval = opprep.New_Sales__c;
                 Decimal masternewewalsalesval = opprep.Renewal_sales_value__c;
    opprep.Quota_New_Sales__c = masternewsalesval + oppl.Quota_New_Sales_Adjustment__c;
    opprep.Quota_Renewal_Sales__c = masternewewalsalesval - oppl.Quota_New_Sales_Adjustment__c;            
    system.debug('GOOGLE'+oppl.Quota_New_Sales_Adjustment__c );
    system.debug('GOOGLE'+opprep.Quota_New_Sales__c );

}

else if(oppl.Quota_New_Sales_Adjustment__c != null && oppl.Quota_New_Sales_Adjustment__c < 0 ){
                 
                 Decimal masternewsalesval = opprep.New_Sales__c;
                 Decimal masternewewalsalesval = opprep.Renewal_sales_value__c;
    opprep.Quota_New_Sales__c = masternewsalesval + oppl.Quota_New_Sales_Adjustment__c;            
    opprep.Quota_Renewal_Sales__c = masternewewalsalesval + oppl.Quota_New_Sales_Adjustment__c;            
    
    system.debug('GOOGLE'+oppl.Quota_New_Sales_Adjustment__c );
    system.debug('GOOGLE'+opprep.Quota_New_Sales__c );

}

else if(oppl.Quota_Renewal_Sales_Adjustment__c != null && oppl.Quota_Renewal_Sales_Adjustment__c > 0 ){
                 
                 Decimal masternewsalesval = opprep.New_Sales__c;
                 Decimal masternewewalsalesval = opprep.Renewal_sales_value__c;
    opprep.Quota_New_Sales__c = masternewsalesval - oppl.Quota_Renewal_Sales_Adjustment__c;            
    opprep.Quota_Renewal_Sales__c = masternewewalsalesval + oppl.Quota_Renewal_Sales_Adjustment__c;            
    
    system.debug('GOOGLE'+oppl.Quota_Renewal_Sales_Adjustment__c );
    system.debug('GOOGLE'+opprep.Quota_Renewal_Sales__c );

}

else if(oppl.Quota_Renewal_Sales_Adjustment__c != null && oppl.Quota_Renewal_Sales_Adjustment__c < 0 ){
                 
                 Decimal masternewsalesval = opprep.New_Sales__c;
                 Decimal masternewewalsalesval = opprep.Renewal_sales_value__c;
    opprep.Quota_New_Sales__c = masternewsalesval - oppl.Quota_Renewal_Sales_Adjustment__c;            
    opprep.Quota_Renewal_Sales__c = masternewewalsalesval + oppl.Quota_Renewal_Sales_Adjustment__c;            
    
    system.debug('GOOGLE'+oppl.Quota_Renewal_Sales_Adjustment__c );
    system.debug('GOOGLE'+opprep.Quota_Renewal_Sales__c );

}
if(opprep.Name == 'ASTRNTRAV'){
    opprep.Quota_New_Sales__c = 0.0; // TP 18113
}

// end testing code
              LReportingValue.Add(opprep);
            
            }
}




}
    // For non cpq process
    if(NonCPQid.Size()>0)
    {
        List<OpportunityLineitem> Lopp1=[Select id,opportunity.End_Date__c,Opportunity.Account_Country__c,opportunity.Start_Date__c,opportunity.Exceptional_Perpetual__c,Opportunity.Type,Currencyisocode,Product2.Platform__c,Product2.Name,CPQ_Previous_Year_Net_Price__c,Product2.Product_Group__c,TotalPrice,CPQ_Product_Status__c,Type__c,ACCT_Product_Type__c,Product2.Perpetual__c,Opportunityid,PS_Product_ID__c,CPQ_Platform__c,opportunity.Currencyisocode from OpportunityLineitem Where Opportunityid IN : NonCPQid  ORDER BY CPQ_Product_Status__c DESC];
              
        //New Contract Map for Non CPQ process
        Map<id,Map<string,Map<string,Double>>> MNewCon = New Map<id,Map<string,Map<string,Double>>>();      
            For(OpportunityLineItem Oppl : Lopp1)
            {
                 
                // New Contracts start
                 if(MNewCon.ContainsKey(Oppl.Opportunityid))
                 {
                    
                    if(MNewCon.get(Oppl.Opportunityid).Containskey(Oppl.Product2.Platform__c))
                    {   
                            
                        if(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).Containskey(Oppl.Product2.Product_Group__c))
                        {
                         
                         Map<string,Double> temp= New Map<String,Double>();
                         temp=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                         if(Oppl.TotalPrice!=Null)
                         temp.put(Oppl.Product2.Product_Group__c,MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+Oppl.TotalPrice);
                         else
                         temp.put(Oppl.Product2.Product_Group__c,MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(Oppl.Product2.Product_Group__c)+0.0);
                         Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                         temp1=MNewCon.get(Oppl.Opportunityid);
                         temp1.put(Oppl.Product2.Platform__c,temp);
                         MNewCon.put(Oppl.Opportunityid,temp1);
                           
                        }
                        else
                        {
                           Map<string,Double> temp= New Map<String,Double>();
                           temp=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c);
                           if(Oppl.TotalPrice!=Null)
                           temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                           else
                           temp.put(Oppl.Product2.Product_Group__c,0.0);
                           
                            Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                            temp1=MNewCon.get(Oppl.Opportunityid);
                            temp1.put(Oppl.Product2.Platform__c,temp);
                            MNewCon.put(Oppl.Opportunityid,temp1);
                        
                        }
                    
                    }
                    else
                    {
                    
                       Map<string,Double> temp= New Map<String,Double>();
                       if(Oppl.TotalPrice!=Null)
                       temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                       else
                       temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                       Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                       temp1=MNewCon.get(Oppl.Opportunityid);
                       temp1.put(Oppl.Product2.Platform__c,temp);
                       
                       MNewCon.put(Oppl.opportunityid,temp1);        
                    
                    }
                 }
                 else
                 {
                    Map<string,Double> temp= New Map<String,Double>();
                    if(Oppl.TotalPrice!=Null)
                    temp.put(Oppl.Product2.Product_Group__c,Oppl.TotalPrice);
                    else
                    temp.put(Oppl.Product2.Product_Group__c,0.0);
                    
                    Map<String,Map<String,Double>> temp1 = New Map<String,Map<String,Double>>();
                    temp1.put(Oppl.Product2.Platform__c,temp);
                    
                    MNewCon.put(Oppl.opportunityid,temp1);
                  
                 }
               //END 
            }
            // To create reporting object records
            
            // set of string to run once for a product group
            Set<String> PreRun = new Set<String>();
            
            For(Opportunitylineitem oppl :Lopp1)
            {
            
                  If(PreRun.contains(Oppl.OpportunityId+Oppl.Product2.Platform__c+oppl.Product2.Product_Group__c))
                  {
                    Continue;
                  }
                  Else
                  {
                 PreRun.add(Oppl.OpportunityId+Oppl.Product2.Platform__c+oppl.Product2.Product_Group__c);
                 Opportunity_Value__c opprep = New Opportunity_Value__c();
                 opprep.Name=Oppl.Product2.Product_Group__c;
                 opprep.CurrencyIsoCode= Oppl.Currencyisocode;
                 opprep.Opportunity_c__c=oppl.Opportunityid;
                 opprep.Platform__c=oppl.CPQ_Platform__c; 
                 opprep.CurrencyIsoCode__c=oppl.opportunity.Currencyisocode;
                 if(oppl.ACCT_Product_Type__c=='Services')
                 opprep.IsServices__c=True;
                 if(oppl.ACCT_Product_Type__c=='Software')
                 opprep.IsSoftware__c=True;
                 if(oppl.ACCT_Product_Type__c=='Managed Hosting')
                 opprep.IsManagedHosting__c=True;
                 if(oppl.Type__c=='Recurring')
                 opprep.IsRecurring__c=True;
                 if(oppl.Product2.Perpetual__c=='true')
                 opprep.IsPerpetual__c=true;
                 else
                 opprep.IsPerpetual__c=false;
                 
                 If(oppl.Product2.Product_Group__c!=Null)
                 opprep.ACCT_Product_Group__c=oppl.Product2.Product_Group__c;
                 // New contract
                 opprep.Amount__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                 //Expiring contract
                 opprep.Expiring_Contract_value__c=0.0;
                 
                 if(oppl.Opportunity.Type=='New Business' || oppl.Opportunity.Type=='Expansion Business')
                 {
                    opprep.Renewal_sales_value__c=0.0;
                    opprep.Quota_Renewal_Sales__c=0.0;
                    opprep.New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                    if(Oppl.opportunity.Exceptional_Perpetual__c==True)
                            {
                                if(PerpetualProducts__c.getAll().ContainsKey(Oppl.Product2.Product_Group__c))
                                {
                                     opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                }
                                else if(Oppl.opportunity.End_Date__c!= Null && Oppl.opportunity.Start_Date__c!=Null &&Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)>365)
                                {
                                    if((Date.isLeapYear(Oppl.opportunity.Start_Date__c.Year())&& Oppl.opportunity.Start_Date__c.month()<=2) ||(Date.isLeapYear(Oppl.opportunity.End_Date__c.Year())&& Oppl.opportunity.End_Date__c.month() >2) )
                                   {  
                                         opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*366;
                                   }
                                   else
                                   { 
                                    opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*365;
                                   }
                                }
                                else
                                {
                                    opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                }

                            }
                            else
                            {
                               

                               if(PerpetualProducts__c.getAll().ContainsKey(Oppl.Product2.Product_Group__c))
                               {
                               


                                if((Oppl.Opportunity.Account_Country__c == 'China')){
                                    opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c));
                                    system.debug('MGMG'+opprep.Quota_New_Sales__c);
                                }

                                else {
                                    opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/3);
                                    system.debug('MGMGMG'+opprep.Quota_New_Sales__c);
                                
                                }

                                // making the above change for non CPQ process
                                //System.debug('+++3++');
                                //opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/3);
                                
                               }
                               else if(Oppl.opportunity.End_Date__c!= Null && Oppl.opportunity.Start_Date__c!=Null && Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)>365)
                                {
                                   if((Date.isLeapYear(Oppl.opportunity.Start_Date__c.Year())&& Oppl.opportunity.Start_Date__c.month()<=2) ||(Date.isLeapYear(Oppl.opportunity.End_Date__c.Year())&& Oppl.opportunity.End_Date__c.month() >2) )
                                   {  
                                         opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*366;
                                   }
                                   else
                                   { 
                                         opprep.Quota_New_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*365;
                                   }
                                }
                                else
                                {
                                    opprep.Quota_New_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                                }
                            }  
                     
                 }
                 else if(oppl.Opportunity.Type=='Renewal')
                 {
                    opprep.New_Sales__c=0.0; 
                    opprep.Renewal_sales_value__c= MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                   //opprep.Quota_Renewal_Sales__c=opprep.Renewal_sales_value__c;
                    opprep.Quota_New_Sales__c=0.0;
                    
                    if(Oppl.opportunity.Exceptional_Perpetual__c==True)
                        {
                            if(PerpetualProducts__c.getAll().ContainsKey(Oppl.Product2.Product_Group__c))
                            {
                                 opprep.Quota_Renewal_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                            }
                            else if(Oppl.opportunity.End_Date__c!= Null && Oppl.opportunity.Start_Date__c!=Null &&Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)>365)
                            {
                               if((Date.isLeapYear(Oppl.opportunity.Start_Date__c.Year())&& Oppl.opportunity.Start_Date__c.month()<=2) ||(Date.isLeapYear(Oppl.opportunity.End_Date__c.Year())&& Oppl.opportunity.End_Date__c.month() >2) )
                                   {  
                                         opprep.Quota_Renewal_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*366;
                                   }
                                   else
                                   { 
                                        opprep.Quota_Renewal_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*365;
                                   }
                            }
                            else
                            {
                                opprep.Quota_Renewal_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                            }

                        }
                        else
                        {
                           if(PerpetualProducts__c.getAll().ContainsKey(Oppl.Product2.Product_Group__c))
                           {
                             System.debug('++Nik4++');
                            opprep.Quota_Renewal_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/3);
                            
                           }
                           else if( Oppl.opportunity.End_Date__c!= Null && Oppl.opportunity.Start_Date__c!=Null && Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)>365)
                            {
                              if((Date.isLeapYear(Oppl.opportunity.Start_Date__c.Year())&& Oppl.opportunity.Start_Date__c.month()<=2) ||(Date.isLeapYear(Oppl.opportunity.End_Date__c.Year())&& Oppl.opportunity.End_Date__c.month() >2) )
                               {  
                                         opprep.Quota_Renewal_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*366;
                               }
                              else
                                 {   
                                        opprep.Quota_Renewal_Sales__c=(MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c)/(Oppl.opportunity.Start_Date__c.daysBetween(Oppl.opportunity.End_Date__c)+1))*365;
                                }
                            }
                            else
                            {
                                opprep.Quota_Renewal_Sales__c=MNewCon.get(Oppl.Opportunityid).get(Oppl.Product2.Platform__c).get(oppl.Product2.Product_Group__c);
                            }
                         } 
                 }
                 /*
                 else
                 {
                 opprep.New_Sales__c=0.0;
                 opprep.Quota_New_Sales__c=0.0;
                 opprep.Renewal_sales_value__c=0.0;
                 opprep.Quota_Renewal_Sales__c=0.0;
                 }
                 */
                 LReportingValue.Add(opprep);      
                 }
             
                      
            } 

    } 
If(LReportingValue.Size()>0)
Insert LReportingValue;  

   }
   



   //END date :- 05/07/2014     
   // Writtern by Nikhil .date:-23 April 2004
      // Writtern by Nikhil .date:-23 April 2004
        Private void  calculateOpportunitySalesValues(Opportunity[] oldOpportunities, Opportunity[] updatedOpportunities, Map<ID, Opportunity> oldOpportunityMap, Map<ID, Opportunity> updatedOpportunityMap)
     {
       
       // Set of CPQ record Type
       Set<id> Oppid = New Set<id>();
       
       //Replicated Renewal Opportunity
        Id repid='01270000000Hn7XAAS';
        
       For(Opportunity opp: updatedOpportunities)
       {
       if(opp.recordtypeid !=repid)
          {
            
            opp.CPQ_New_Sales_Value__c=0.0;
            opp.CPQ_Renewal_Sales_Value__c=0.0;
            // Update this field only for CPQ
            if(opp.PFIN_Intgr_Record_Type__c.contains('CPQ') )
            opp.CPQ_Expected_Renewal_Amount__c=0.0;
            opp.Renewal_Sales_Adjustment__c=0.0;
            opp.Learn_Renewal_Value__c=0.0;
            opp.Learn_New_Sales_Value__c=0.0;
            opp.Collaborate_Renewal_Value__c=0.0;
            opp.Collaborate_New_Sales_Value__c=0.0;
            opp.Mobile_Renewal_Value__c=0.0;
            opp.Mobile_New_Sales_Value__c=0.0;
            opp.Analytics_Renewal_Value__c=0.0;
            opp.Analytics_New_Sales_Value__c=0.0;
            opp.NetSpot_Renewal_Value__c=0.0;
            opp.NetSpot_New_Sales_Value__c=0.0;
            opp.Educational_Services_New_Sales_Value__c=0.0;
            opp.Educational_Services_Renewal_Value__c=0.0;
            opp.Transact_New_Sales__c=0.0;
            opp.Transact_Renewal_Sales_Value__c=0.0;
            opp.Student_Services_New_Sales_Value__c=0.0;
            opp.Student_Services_Renewal_Value__c=0.0;
            opp.Engage_Services_New_Sales_Value__c=0.0;
            opp.Engage_Services_Renewal_Value__c=0.0;
            opp.Moodlerooms_New_Sales_Value__c=0.0;
            opp.Moodlerooms_Renewal_Value__c=0.0;
            opp.Connect_New_Sales_Value__c=0.0;
            opp.Connect_Renewal_Value__c=0.0;
            opp.MyEDU_Quota_New_Sales_Credit__c=0.0;
            opp.MyEDU_Quota_Renewal_Sales_Credit__c=0.0;


            //Quote new sales and Renewal sales value
            opp.Quota_Value__c=0.0;
            opp.Quota_Renewal_Sales_Value__c=0.0;
            Opp.Prior_Year_Price__c=0.0;
            Oppid.add(opp.id);

          }
       }
       
       
       If(Oppid.Size()>0)
       {
               Map<id,OpportunityLineitem> Lopline = New Map<id,OpportunityLineitem>([Select id,Opportunity.PFIN_Intgr_Record_Type__c,Opportunity.Amount,Totalprice,CPQ_Product_Status__c,CPQ_Previous_Year_Net_Price__c,OpportunityId,PriorYearPrice__c from OpportunityLineitem Where Opportunityid IN : Oppid]);
               system.debug('LopLine size'+Lopline.size()+ '****'+Lopline);
               // Calculate Expiring contract value
               For(OpportunityLineitem oppl : Lopline.Values())
               {
                  if(oppl.Opportunity.PFIN_Intgr_Record_Type__c.contains('CPQ'))
                  {
                      // Calculate Expiring cpntract value
                      if(oppl.CPQ_Previous_Year_Net_Price__c != Null)
                      { 
                      
                      updatedOpportunityMap.get(oppl.Opportunityid).CPQ_Expected_Renewal_Amount__c=updatedOpportunityMap.get(oppl.Opportunityid).CPQ_Expected_Renewal_Amount__c+Oppl.CPQ_Previous_Year_Net_Price__c;
                         
                      }
                      if(oppl.PriorYearPrice__c!=Null)
                      {
                        updatedOpportunityMap.get(oppl.Opportunityid).Prior_Year_Price__c=updatedOpportunityMap.get(oppl.Opportunityid).Prior_Year_Price__c+Oppl.PriorYearPrice__c;
                      }
                   }
               }
               // Renewal Sales Adjustment Calculation
               For(OpportunityLineItem Opl: Lopline.Values())
               {
                  if(Opl.Opportunity.PFIN_Intgr_Record_Type__c.contains('CPQ'))
                  {
                    
                     if(opl.CPQ_Product_Status__c=='Renew' || opl.CPQ_Product_Status__c=='Renewal' || opl.CPQ_Product_Status__c=='Dropped')
                     {
                        system.debug('enter if');
                        if((opl.CPQ_Previous_Year_Net_Price__c> opl.totalPrice)&&(updatedOpportunityMap.get(Opl.Opportunityid).Amount>updatedOpportunityMap.get(Opl.Opportunityid).CPQ_Expected_Renewal_Amount__c)) 
                        {
                          updatedOpportunityMap.get(Opl.Opportunityid).Renewal_Sales_Adjustment__c = updatedOpportunityMap.get(Opl.Opportunityid).Renewal_Sales_Adjustment__c + (opl.CPQ_Previous_Year_Net_Price__c-opl.totalPrice);
                        }
                     }
                  }
               }
              
               
               // New sales value and renewal sales value calculation start
               For(Opportunity_Value__c temp : [Select id,Quota_New_Sales__c,Quota_Renewal_Sales__c,Platform__c,Opportunity_c__c,Expiring_Contract_value__c,New_Sales__c,Amount__c,Renewal_sales_value__c from Opportunity_Value__c Where Opportunity_c__c IN :Oppid]) 
                {
                
                if(temp.New_Sales__c!=Null)
                {
                updatedOpportunityMap.get(temp.Opportunity_c__c).CPQ_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).CPQ_New_Sales_Value__c+temp.New_Sales__c;
                }
                if(temp.Renewal_sales_value__c!= Null)
                {
                updatedOpportunityMap.get(temp.Opportunity_c__c).CPQ_Renewal_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).CPQ_Renewal_Sales_Value__c+temp.Renewal_sales_value__c;
                
                }
                if(temp.Quota_New_Sales__c != Null)
                {
                 
                 updatedOpportunityMap.get(temp.Opportunity_c__c).Quota_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Quota_Value__c+temp.Quota_New_Sales__c;
                
                }// testing
                if(temp.Quota_Renewal_Sales__c != Null)
                {
                 
                 updatedOpportunityMap.get(temp.Opportunity_c__c).Quota_Renewal_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Quota_Renewal_Sales_Value__c+temp.Quota_Renewal_Sales__c;
                
                }
                


                if(temp.Platform__c== 'Learn')
                {
                if(temp.Quota_Renewal_Sales__c!= Null)
                updatedOpportunityMap.get(temp.Opportunity_c__c).Learn_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Learn_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                
                if(temp.Quota_New_Sales__c!=Null)
                updatedOpportunityMap.get(temp.Opportunity_c__c).Learn_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Learn_New_Sales_Value__c+temp.Quota_New_Sales__c;
                
                }

                // TP 16554 by Murugappan

                if(temp.Platform__c== 'MyEdu')
                {
                if(temp.Quota_Renewal_Sales__c!= Null)
                updatedOpportunityMap.get(temp.Opportunity_c__c).MyEDU_Quota_Renewal_Sales_Credit__c=updatedOpportunityMap.get(temp.Opportunity_c__c).MyEDU_Quota_Renewal_Sales_Credit__c+temp.Quota_Renewal_Sales__c;
                if(temp.Quota_New_Sales__c!=Null)
                updatedOpportunityMap.get(temp.Opportunity_c__c).MyEDU_Quota_New_Sales_Credit__c=updatedOpportunityMap.get(temp.Opportunity_c__c).MyEDU_Quota_New_Sales_Credit__c+temp.Quota_New_Sales__c;
                
                }
                // end TP 16554

                if(temp.Platform__c== 'Collaborate')
                {
                if(temp.Quota_Renewal_Sales__c!= Null)
                updatedOpportunityMap.get(temp.Opportunity_c__c).Collaborate_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Collaborate_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                if(temp.Quota_New_Sales__c!=Null)
                updatedOpportunityMap.get(temp.Opportunity_c__c).Collaborate_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Collaborate_New_Sales_Value__c+temp.Quota_New_Sales__c;
                
                }
                if(temp.Platform__c== 'Mobile')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Mobile_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Mobile_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Mobile_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Mobile_New_Sales_Value__c+temp.Quota_New_Sales__c;
                
                }
                if(temp.Platform__c== 'Analytics')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Analytics_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Analytics_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Analytics_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Analytics_New_Sales_Value__c+temp.Quota_New_Sales__c;
                
                }
                if(temp.Platform__c== 'NetSpot')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).NetSpot_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).NetSpot_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).NetSpot_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).NetSpot_New_Sales_Value__c+temp.Quota_New_Sales__c;
                }
                if(temp.Platform__c== 'Transact')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Transact_Renewal_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Transact_Renewal_Sales_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Transact_New_Sales__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Transact_New_Sales__c+temp.Quota_New_Sales__c;
                }
                if(temp.Platform__c== 'Connect')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Connect_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Connect_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Connect_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Connect_New_Sales_Value__c+temp.Quota_New_Sales__c;
                }
                if(temp.Platform__c== 'Student Services')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Student_Services_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Student_Services_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Student_Services_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Student_Services_New_Sales_Value__c+temp.Quota_New_Sales__c;
                }
                if(temp.Platform__c== 'Moodlerooms')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Moodlerooms_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Moodlerooms_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Moodlerooms_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Moodlerooms_New_Sales_Value__c+temp.Quota_New_Sales__c;
                }
                if(temp.Platform__c== 'Engage')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Engage_Services_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Engage_Services_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Engage_Services_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Engage_Services_New_Sales_Value__c+temp.Quota_New_Sales__c;
                }
                if(temp.Platform__c== 'Education Services')
                {
                  if(temp.Quota_Renewal_Sales__c!= Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Educational_Services_Renewal_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Educational_Services_Renewal_Value__c+temp.Quota_Renewal_Sales__c;
                  if(temp.Quota_New_Sales__c!=Null)
                  updatedOpportunityMap.get(temp.Opportunity_c__c).Educational_Services_New_Sales_Value__c=updatedOpportunityMap.get(temp.Opportunity_c__c).Educational_Services_New_Sales_Value__c+temp.Quota_New_Sales__c;
                }
                
                }
                
                For(Opportunity opp: updatedOpportunities)
                {
                
                // If overall value is negative. It should be considered as 0.
               if(opp.CPQ_New_Sales_Value__c <0)
                opp.CPQ_New_Sales_Value__c=0.0;
                
                 // For Quota New sales Value
                 if(opp.Quota_Value__c <0)
                   opp.Quota_Value__c=0.0;
                 
                    // testing if(opp.Renewal_Sales_Adjustment__c!=Null && opp.Renewal_Sales_Adjustment__c>0)
                     // testing opp.Quota_Renewal_Sales_Value__c=opp.CPQ_Renewal_Sales_Value__c + opp.Renewal_Sales_Adjustment__c;
                     // testing else
                     // testing opp.Quota_Renewal_Sales_Value__c=opp.CPQ_Renewal_Sales_Value__c;
                     
                } 
               //END
         }      
     }   
   //END  
     //Start New Trigger Logic for Adjustment Opportunity
        Private void UpdateAdjustmentAsset(list<Opportunity> Oldlist,list<Opportunity> newlist,Map<id,Opportunity> OldOppsMap,Map<id,Opportunity> NewOppsMap)
        {


            // Set of Opportunity Ids
             Set<id> Oppid = New Set<id>();

            // Set  of Parent Opportunity
            Set<id> ParntOppid = New Set<Id>(); 

             For(Opportunity Opp: newlist)
             {

                if(Opp.Parent_Adjustment_Opportunity__c!= Null && Opp.StageName != OldOppsMap.get(Opp.id).StageName && Opp.StageName == '(W) Won' && Opp.AccountId!=null)
                {
                    // Set of Adjusment Opportunity
                    Oppid.Add(Opp.id);
                    // Parent Opp id
                    ParntOppid.Add(Opp.Parent_Adjustment_Opportunity__c);
                }
             }
            
                
                If(Oppid.Size()>0)
                {
                    // List of asset to update 
                    List<Asset> LassettoUpdate= New List<Asset>();

                    // List of Opportunity Line Item 
                    List<OpportunityLineItem> Loppline = [Select id,Opportunityid,Data_Storage_Quantity__c,PS_Product_ID__c,Opportunity.Parent_Adjustment_Opportunity__c,Adjustment_Asset_id__c,Adjustment_Asset_id__r.Data_Storage_Quantity__c,Total_Unit_Quantity__c,Total_Net_Price_Adjustment__c,Adjustment_Asset_id__r.CPQ_currentYear__c,Adjustment_Asset_id__r.CPQ_NumQty__c,Adjustment_Asset_id__r.CPQ_Net_Price__c,PricebookEntry.Product2.Platform__c,PricebookEntry.ProductCode,Quantity,Description,CPQ_isRenewable__c,UnitPrice,CPQ_Integrated_System__c,CPQ_isCoreItem__c,CPQ_User_Band__c,CPQ_Package_Id__c from  OpportunityLineItem Where Opportunityid IN :Oppid];

                    // Map of Asset (commented  as No need)
                      List<Asset> LAst =[Select id,Data_Storage_Quantity__c,User_Quantity__c,Psft_Product_Id__c,CPQ_LineIdentifier__c,CPQ_Net_Price__c,CPQ_NumQty__c,CPQ_Current_Opportunity_ID__c from Asset Where CPQ_Current_Opportunity_ID__c IN :ParntOppid];
                    

                     // Map of String(key) and Asset
                    // Map<String,OpportunityLineItem> MOppl = New Map<String,OpportunityLineItem>();

                    // Map for future
                    Map<string,OpportunityLineItem> MfuLine= New Map<String,OpportunityLineItem>();

                    // Asset Id 
                    Set<id> Asstid= New Set<id>();

                    // Add value to Map
                    For(OpportunityLineItem Oppl :Loppline)
                    {
                        If(Oppl.Adjustment_Asset_id__c!= Null)
                        {
                           //MOppl.put(Oppl.Opportunityid+Oppl.PS_Product_ID__c,Oppl);
                            MfuLine.put(Oppl.Opportunity.Parent_Adjustment_Opportunity__c+Oppl.PS_Product_ID__c,Oppl);
                            Asstid.Add(Oppl.Adjustment_Asset_id__c);
                        }                        
                    }

                    // Map of Opportunity and  Asset
                    Map<id,Asset> OppAssetid = New Map<id,Asset>();
                    // Map of Asset for Clone
                    For(Asset ast :[SELECT AccountId,Data_Storage_Quantity__c,User_Quantity__c,API_Login__c,API_Password__c,Application_Server_OS__c,ASP_Location__c,Asset_Type__c,BbIM_SAS_Integrated__c,Bugzilla_Bug_Number__c,Clustering_of_Servers__c,CL_Test_API_Login__c,CL_Test_API_Password__c,CMS_Type__c,CMS_Version__c,Comments__c,ContactId,Core_License__c,CPQ_Active__c,CPQ_contractLength__c,CPQ_Contract_End_Date__c,CPQ_Contract_Start_Date__c,CPQ_currentYear__c,CPQ_Current_Opportunity_ID__c,CPQ_forCPQ__c,CPQ_Intergrated_System__c,CPQ_isCoreItem__c,CPQ_isMultiyear__c,CPQ_ISO_Currency_Code__c,CPQ_isRenewable__c,CPQ_LineIdentifier__c,CPQ_Net_Price__c,CPQ_NumQty__c,CPQ_Package_Id__c,CPQ_Package__c,CPQ_Parent_Item__c,CPQ_Previous_Opportunity_ID__c,CPQ_Product_Platform__c,CPQ_Selling_Exchange_Rate__c,CPQ_User_Band__c,CreatedById,CreatedDate,CurrencyIsoCode,Customer_Value__c,Database_Server_OS__c,Database__c,Date_Ordered__c,Date_Registered__c,Date_Shipped__c,Days_to_Expiration__c,Description,Development_Server_URL__c,DNS_Servers__c,Domain_Name__c,Eportfolio_Enabled__c,Eportfolio_of_Seats__c,External_Asset_Name__c,External_Description__c,External_Order_Id__c,Force_SSL__c,Front_Back_Access__c,FTE__c,Gateway_IP_Address__c,Grace_Period__c,Hardware_Key__c,Hardware_Option__c,Hosting_Contact__c,Hosting_Option__c,Hosting_Server__c,Hostname__c,IC_Custom__c,Id,Implementation_Consultant_Email__c,Implementation_Consultant__c,InstallDate,Installed_Product_ID__c,Installed_Product_Note__c,Instance_URL__c,Integration_Component__c,IsCompetitorProduct,IsDeleted,I_and_C_Support__c,JDK_Version__c,LastModifiedById,LastModifiedDate,Last_Upgrade_Date__c,License_Expiration_Date__c,License_Key__c,Login_Styles__c,Maintenance_Level__c,Managed_Hosting__c,Manager_Login__c,Manager_Password__c,Moderator_Link__c,Name,Network__c,New_Users_this_month__c,New_Users_this_week__c,Nickname__c,Number_of_Institutions_Hosted__c,Number_of_Seats__c,Number_of_Users__c,Old_Product_Id__c,Opportunity_Owner_Email__c,Opportunity_Owner_Phone__c,Opportunity_Owner_Title__c,Opportunity_Owner__c,Opportunity__c,Order_Id__c,Participant_Link__c,Phone_End_Date__c,Phone_Service_Type__c,Phone_Simulcast_Number__c,Phone_Start_Date__c,Platform__c,Price,Primary_IP__c,Product2Id,Production_Server_URL__c,Product_Category__c,Product_ID__c,Product_Type__c,Psft_Product_Id__c,PurchaseDate,Purchase_Order__c,QPQ_Reseller__c,Quantity,Recording_Link__c,Secondary_Contact_Email__c,Secondary_Contact__c,SerialNumber,Server_Customization__c,Server_Network_Mask__c,Server_OS__c,Software_URL__c,Status,Support_Email__c,Support_Level__c,Support_Phone__c,SystemModstamp,Time_Zone__c,Total_Users__c,Type__c,Upgraded_from_Product_ID__c,Upgraded__c,Upgrade_Flag__c,UsageEndDate,User_Limit__c,Version_Build__c,Version_Effective_Date__c,Version__c,Virtual_IP__c,Voice_Direct_Enabled__c,Warm_Standby_IP__c,Warranty_End_Date__c,Warranty_Name__c,Warranty_Start_Date__c,Warranty_Status__c,WebCT_Instance__c,WebCT_IP_Address__c from Asset WHERE Id IN :Asstid])
                    {
                        OppAssetid.put(ast.CPQ_Current_Opportunity_ID__c,ast);
                    }
                   //List<Asset> LAst =[SELECT AccountId,Data_Storage_Quantity__c,User_Quantity__c,API_Login__c,API_Password__c,Application_Server_OS__c,ASP_Location__c,Asset_Type__c,BbIM_SAS_Integrated__c,Bugzilla_Bug_Number__c,Clustering_of_Servers__c,CL_Test_API_Login__c,CL_Test_API_Password__c,CMS_Type__c,CMS_Version__c,Comments__c,ContactId,Core_License__c,CPQ_Active__c,CPQ_contractLength__c,CPQ_Contract_End_Date__c,CPQ_Contract_Start_Date__c,CPQ_currentYear__c,CPQ_Current_Opportunity_ID__c,CPQ_forCPQ__c,CPQ_Intergrated_System__c,CPQ_isCoreItem__c,CPQ_isMultiyear__c,CPQ_ISO_Currency_Code__c,CPQ_isRenewable__c,CPQ_LineIdentifier__c,CPQ_Net_Price__c,CPQ_NumQty__c,CPQ_Package_Id__c,CPQ_Package__c,CPQ_Parent_Item__c,CPQ_Previous_Opportunity_ID__c,CPQ_Product_Platform__c,CPQ_Selling_Exchange_Rate__c,CPQ_User_Band__c,CreatedById,CreatedDate,CurrencyIsoCode,Customer_Value__c,Database_Server_OS__c,Database__c,Date_Ordered__c,Date_Registered__c,Date_Shipped__c,Days_to_Expiration__c,Description,Development_Server_URL__c,DNS_Servers__c,Domain_Name__c,Eportfolio_Enabled__c,Eportfolio_of_Seats__c,External_Asset_Name__c,External_Description__c,External_Order_Id__c,Force_SSL__c,Front_Back_Access__c,FTE__c,Gateway_IP_Address__c,Grace_Period__c,Hardware_Key__c,Hardware_Option__c,Hosting_Contact__c,Hosting_Option__c,Hosting_Server__c,Hostname__c,IC_Custom__c,Id,Implementation_Consultant_Email__c,Implementation_Consultant__c,InstallDate,Installed_Product_ID__c,Installed_Product_Note__c,Instance_URL__c,Integration_Component__c,IsCompetitorProduct,IsDeleted,I_and_C_Support__c,JDK_Version__c,LastModifiedById,LastModifiedDate,Last_Upgrade_Date__c,License_Expiration_Date__c,License_Key__c,Login_Styles__c,Maintenance_Level__c,Managed_Hosting__c,Manager_Login__c,Manager_Password__c,Moderator_Link__c,Name,Network__c,New_Users_this_month__c,New_Users_this_week__c,Nickname__c,Number_of_Institutions_Hosted__c,Number_of_Seats__c,Number_of_Users__c,Old_Product_Id__c,Opportunity_Owner_Email__c,Opportunity_Owner_Phone__c,Opportunity_Owner_Title__c,Opportunity_Owner__c,Opportunity__c,Order_Id__c,Participant_Link__c,Phone_End_Date__c,Phone_Service_Type__c,Phone_Simulcast_Number__c,Phone_Start_Date__c,Platform__c,Price,Primary_IP__c,Product2Id,Production_Server_URL__c,Product_Category__c,Product_ID__c,Product_Type__c,Psft_Product_Id__c,PurchaseDate,Purchase_Order__c,QPQ_Reseller__c,Quantity,Recording_Link__c,Secondary_Contact_Email__c,Secondary_Contact__c,SerialNumber,Server_Customization__c,Server_Network_Mask__c,Server_OS__c,Software_URL__c,Status,Support_Email__c,Support_Level__c,Support_Phone__c,SystemModstamp,Time_Zone__c,Total_Users__c,Type__c,Upgraded_from_Product_ID__c,Upgraded__c,Upgrade_Flag__c,UsageEndDate,User_Limit__c,Version_Build__c,Version_Effective_Date__c,Version__c,Virtual_IP__c,Voice_Direct_Enabled__c,Warm_Standby_IP__c,Warranty_End_Date__c,Warranty_Name__c,Warranty_Start_Date__c,Warranty_Status__c,WebCT_Instance__c,WebCT_IP_Address__c from Asset WHERE Id IN :Asstid];
                    
                    // List of Asset to Update
                    List<Asset> Last1 = New List<Asset>();

                    For(Asset ast : LAst)
                    {
                         if(MfuLine.Containskey(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c))
                         {
                            
                            If(ast.CPQ_NumQty__c >1 )
                            {
                                ast.CPQ_NumQty__c=MfuLine.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c).Total_Unit_Quantity__c;
                            }
                            ast.User_Quantity__c=MfuLine.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c).Total_Unit_Quantity__c;
                            ast.CPQ_Net_Price__c=MfuLine.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c).Total_Net_Price_Adjustment__c;
                            if(MfuLine.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c).Data_Storage_Quantity__c!=Null)
                            {
                                if(ast.Data_Storage_Quantity__c!=null) 
                                ast.Data_Storage_Quantity__c=ast.Data_Storage_Quantity__c + MfuLine.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c).Data_Storage_Quantity__c;
                                else
                                ast.Data_Storage_Quantity__c=MfuLine.get(ast.CPQ_Current_Opportunity_ID__c+ast.Psft_Product_Id__c).Data_Storage_Quantity__c;
                            }
                            Last1.Add(ast);
                         }
                    }


                    For(OpportunityLineItem Oppl :Loppline)
                    {
                        If(Oppl.Adjustment_Asset_id__c== Null)
                        {

                            Asset asstFutr = New Asset();
                            asstFutr = OppAssetid.get(Oppl.Opportunity.Parent_Adjustment_Opportunity__c).clone(false,true,false,false);
                            if(Oppl.PricebookEntry.Product2.Platform__c== 'NetSpot'){
                                asstFutr.CurrencyIsoCode='AUD';
                            }else{
                                asstFutr.CurrencyIsoCode='USD'; 
                            }
                            asstFutr.CPQ_NumQty__c =Oppl.Quantity;
                            asstFutr.Psft_Product_Id__c = Oppl.PricebookEntry.ProductCode;
                            asstFutr.Description = Oppl.Description;
                            asstFutr.Product2Id = Oppl.PricebookEntry.Product2Id;
                            asstFutr.CPQ_isRenewable__c=Oppl.CPQ_isRenewable__c;
                            asstFutr.Price = Oppl.UnitPrice;
                            asstFutr.Data_Storage_Quantity__c=Oppl.Data_Storage_Quantity__c;
                            asstFutr.CPQ_isRenewable__c=Oppl.CPQ_isRenewable__c;
                            asstFutr.CPQ_Intergrated_System__c= Oppl.CPQ_Integrated_System__c;
                            asstFutr.CPQ_isCoreItem__c =Oppl.CPQ_isCoreItem__c;
                            asstFutr.CPQ_User_Band__c=Oppl.CPQ_User_Band__c;
                            asstFutr.CPQ_Package_Id__c = Oppl.CPQ_Package_Id__c;
                            asstFutr.Opportunity__c=Oppl.Opportunity.Parent_Adjustment_Opportunity__c;
                            if(AssetQuantityPurchased__c.getinstance(Oppl.PS_Product_ID__c)!=null)
                            asstFutr.Quantity_Purchased__c=oppl.quantity*AssetQuantityPurchased__c.getinstance(Oppl.PS_Product_ID__c).multiplier__c;
                            Last1.Add(asstFutr);
                        }
                    }    

                    //  Create Assets for New Added product


                    // Update all Assets
                    If(Last1.Size()>0)
                    {
                        Upsert Last1;
                    }

                    //Set of  future opp ids
                     Set<id> FutureOppid = New Set<id>();

                     For(Opportunity op: [Select id from Opportunity Where  CPQ_Previous_Opportunity__c IN :ParntOppid])
                     {
                        FutureOppid.Add(Op.id);
                     }

                    // Query future LineItems
                    List<OpportunityLineItem> Loppl1=[Select id,Data_Storage_Quantity__c,Quantity,UnitPrice,User_Quantity__c,Opportunityid,Opportunity.CPQ_Previous_Opportunity__c,PS_Product_ID__c,Adjustment_Asset_id__c,Total_Unit_Quantity__c,Total_Net_Price_Adjustment__c,Adjustment_Asset_id__r.CPQ_currentYear__c,Adjustment_Asset_id__r.CPQ_NumQty__c,Adjustment_Asset_id__r.CPQ_Net_Price__c from  OpportunityLineItem Where Opportunityid IN :FutureOppid];

                    // Update Future Lineitems
                    List<Opportunitylineitem> Oppl2= New List<OpportunityLineItem>();

                    For(OpportunityLineItem  Opl:Loppl1 )
                    {
                       if(MfuLine.Containskey(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c))
                       {
                        Opl.User_Quantity__c=MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Total_Unit_Quantity__c;
                        if(Opl.Quantity>1)
                        {
                            Opl.Quantity=MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Total_Unit_Quantity__c;
                             if(MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Total_Unit_Quantity__c>0)
                            Opl.Custom_Price__c=MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Total_Net_Price_Adjustment__c/MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Total_Unit_Quantity__c;
                             if(MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Data_Storage_Quantity__c!=Null)
                              {
                                 if(Opl.Data_Storage_Quantity__c!=Null)
                                 Opl.Data_Storage_Quantity__c=Opl.Data_Storage_Quantity__c+ MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Data_Storage_Quantity__c; 
                                 else
                                 Opl.Data_Storage_Quantity__c=MfuLine.get(Opl.Opportunity.CPQ_Previous_Opportunity__c+Opl.PS_Product_ID__c).Data_Storage_Quantity__c; 
                              }
                        }
                        
                        Oppl2.Add(Opl);
                       }
                    }

                    //Update OpportunityLine
                    if(Oppl2.Size()>0)
                    Update Oppl2;


                }
        }
       
    /* 
     // Added by Nikhil. Validation as per TP:11574
    private void validateContractStatus(list<Opportunity> newList)
    {
        
        
        
        // Set of opportunties Ids
        Set<id> oppid = New set<id>();
        
        // Role count for each opportunity
        Map<Id, Integer> OppRoleCount = new Map<Id, Integer>();
        
        For(Opportunity op: newList)
        {
           if(op.Isclosed==False && op.PFIN_Intgr_Record_Type__c.contains('CPQ') && op.CPQ_Contract_Status__c=='Request Contract Generation')
           {
              oppid.add(op.id);
              OppRoleCount.put(op.Id, 0);
           }
        
        }
    
        If(oppid.Size()>0)
        {
         
         for (Contact_Role_Selector__c crc : [Select Id, Contact_Role__c, Contact_Role__r.Role__c, Opportunity__c
                                              From Contact_Role_Selector__c 
                                              Where Opportunity__c IN : oppid])
            {
                    if(crc.Contact_Role__r.Role__c.contains('Docusign Contact'))
                    OppRoleCount.put(crc.Opportunity__c, OppRoleCount.get(crc.Opportunity__c) + 1 );
            
            }
            
            For(Opportunity op: newList)
            {
            if(op.PFIN_Intgr_Record_Type__c.contains('CPQ') && op.CPQ_Contract_Status__c=='Request Contract Generation' )
                {
                    if(OppRoleCount.get(op.id) !=1)
                    {
                     op.Adderror('Please add a Docusign Contact role before requesting Contract generation. Only one Docusign Contact is required per opportunity.');
                    }
                }
            }
        } 

    } */

    
}