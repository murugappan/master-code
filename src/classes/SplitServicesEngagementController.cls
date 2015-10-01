/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          SplitServicesEngagementController
    @abstract       splits one Services Engagement object into two
    @since          2011.0715
    @discussion     Class split Services Engagements
*/
public with sharing class SplitServicesEngagementController 
{
    
    // ------------------------------------------------
    // Class Variables
    // ------------------------------------------------
    Decimal totalAmount;
    Services_Engagement__c oldServicesEngagement;
    List<Services_Engagement__c> newServicesEngagements;
    
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public SplitServicesEngagementController() {
        this.oldServicesEngagement = [SELECT Name, CurrencyIsoCode, Opportunity__c, Services_Project__c, Delivery_Date__c, Start_Date__c, End_Date__c, Dollar_Value__c, Primary_Contact__c, Status__c, Service_Type__c, Service_Sub_Type__c, Account__c, Product__c, Trainer__c 
                                      FROM Services_Engagement__c 
                                      WHERE Id = :System.currentPageReference().getParameters().get('id')];
        
        totalAmount = this.oldServicesEngagement.Dollar_Value__c;
        newServicesEngagements = new List<Services_Engagement__c>();
        addServicesEngagement();
        
    }
    
    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
    public Services_Engagement__c getOldServicesEngagement() {
        return oldServicesEngagement;
    }
    
    public List<Services_Engagement__c> getNewServicesEngagements()
    {
        return newServicesEngagements;
    }
    
    // ------------------------------------------------
    // Navigation
    // ------------------------------------------------

    //Adds on Services Engagement to the list
    public PageReference addServicesEngagement() {
        newServicesEngagements.add(new Services_Engagement__c(Opportunity__c = oldServicesEngagement.Opportunity__c,
                                                              Account__c = oldServicesEngagement.Account__c,
                                                              Services_Project__c = oldServicesEngagement.Services_Project__c,
                                                              Name = oldServicesEngagement.Name,
                                                              CurrencyIsoCode = oldServicesEngagement.CurrencyIsoCode,
                                                              Dollar_Value__c = 0,
                                                              Primary_Contact__c = oldServicesEngagement.Primary_Contact__c,
                                                              Trainer__c = oldServicesEngagement.Trainer__c));
        return null;
    }
    

    //Removes on Services Engagement to the list
    public PageReference removeServicesEngagement() {
        if(newServicesEngagements.size() > 1) newServicesEngagements.remove(newServicesEngagements.size() -1);
        return null;
    }
    
    public PageReference cancel() {
        PageReference opptyPage = new PageReference('/' + oldServicesEngagement.Services_Project__c);
        opptyPage.setRedirect(true);
        return opptyPage;
    }
    
    //Creates the Master Services object and the Services Engagements 
    public PageReference save() {
        
        Decimal amount = 0;
        for(Services_Engagement__c se : newServicesEngagements)
        {
            amount += se.Dollar_Value__c;
        }
        if(amount + oldServicesEngagement.Dollar_Value__c != totalAmount)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'The sum of Services Engagements Amounts should be equal to ' + totalAmount));
            return null;
        }
        try{
            update oldServicesEngagement;
            insert newServicesEngagements;
        }
        catch(Exception e)
        {
            ApexPages.addMessages(e);
            return null;
        }
        
        // Finally, send the user to the detail page for the new Master Services object.
        PageReference opptyPage = new PageReference('/' + oldServicesEngagement.Services_Project__c);
        opptyPage.setRedirect(true);
        return opptyPage;
    }
}