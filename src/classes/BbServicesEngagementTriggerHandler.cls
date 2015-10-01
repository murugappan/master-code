/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          BlackboardServicesEngagementTriggerHandler
    @abstract       handles all the logic for triggers on ServicesEngagement
    @since          2011.0915
    @discussion     Class to execute ServicesEngagement triggers logic
*/
public with sharing class BbServicesEngagementTriggerHandler {
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public BbServicesEngagementTriggerHandler(){
    }
        
    // ------------------------------------------------
    // Triggers Methods
    // ------------------------------------------------
    public void OnBeforeInsert(Services_Engagement__c[] newServicesEngagements){

    }
    
    public void OnAfterInsert(Services_Engagement__c[] newServicesEngagements, Map<ID, Services_Engagement__c > insertedServicesEngagementMap){
        updateServicesMasterObjectDates(newServicesEngagements);
    }
        
    public void OnBeforeUpdate(Services_Engagement__c[] oldServicesEngagements, Services_Engagement__c[] updatedServicesEngagements, Map<ID, Services_Engagement__c > oldServicesEngagementMap, Map<ID, Services_Engagement__c > updatedServicesEngagementMap){

    }
    
    public void OnAfterUpdate(Services_Engagement__c[] oldServicesEngagements, Services_Engagement__c[] updatedServicesEngagements, Map<ID, Services_Engagement__c > oldServicesEngagementMap, Map<ID, Services_Engagement__c > updatedServicesEngagementMap){
        updateServicesMasterObjectDates(updatedServicesEngagements);
        createTaskForServicesEngagementStaff(oldServicesEngagements,updatedServicesEngagements,oldServicesEngagementMap,updatedServicesEngagementMap);
    }


    // ------------------------------------------------
    // Class Methods
    // ------------------------------------------------
    
    //Updates the dates on the Services Project
    private void updateServicesMasterObjectDates(Services_Engagement__c[] servicesEngagements) {
    
        List<Services_Project__c> servicesProjectToUpdate = new List<Services_Project__c>();
    
        Set<Id> servicesProjectIds = new Set<Id>();
    
        for(Services_Engagement__c servicesEngagement:servicesEngagements) 
        {
            if(servicesEngagement.Services_Project__c != null) servicesProjectIds.add(servicesEngagement.Services_Project__c);
        }
    
    
        if(servicesProjectIds.size() > 0)
        {         
            for (Services_Project__c services : [SELECT Id, Start_Date__c, End_Date__c, (SELECT Dollar_Value__c, Status__c, Delivery_Date__c, Start_Date__c, End_Date__c FROM Services_Engagements__r)
                                                    FROM Services_Project__c 
                                                    WHERE Id IN :servicesProjectIds])
            {
                for (Services_Engagement__c se: services.Services_Engagements__r)
                {
                    if(se.Start_Date__c != null && se.Start_Date__c < services.Start_Date__c) services.Start_Date__c = se.Start_Date__c;
                    if(se.End_Date__c != null && se.End_Date__c > services.End_Date__c) services.End_Date__c = se.End_Date__c;
                }
                servicesProjectToUpdate.add(services);
            }
            update servicesProjectToUpdate;
        }
    }
    
    
    //Creates notification task when a user is assigned to a Services Engagement
    private void createTaskForServicesEngagementStaff(Services_Engagement__c[] oldServicesEngagements, Services_Engagement__c[] updatedServicesEngagements, Map<ID, Services_Engagement__c > oldServicesEngagementMap, Map<ID, Services_Engagement__c > updatedServicesEngagementMap) {
    
        List<Task> tasks = new List<Task>();
    
        for (Services_Engagement__c newSe : updatedServicesEngagements) { 
            Services_Engagement__c oldSe = oldServicesEngagementMap.get(newSe.id);
            
            //Notify user when Trainer__c is added or modified
            if (newSe.Trainer__c != null && oldSe.Trainer__c != newSe.Trainer__c) 
            { 
                tasks.add(new Task(WhatId = newSe.Id, Subject = 'You have been assigned to a Services Engagement', ActivityDate = Date.today(), OwnerId = newSe.Trainer__c, Type = 'Other')); 
            }
        }
        
        Database.DMLOptions dlo = new Database.DMLOptions(); 
        dlo.EmailHeader.triggerUserEmail = true; 
        if(tasks.size() > 0) database.insert(tasks, dlo); 
    }
}