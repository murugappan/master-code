/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          convertToDocumentationAssetController
    @abstract       converts Material licensing Opportunity Line Items into Documentation Assets
    @since          2011.0715
    @discussion     Converts products to Documentation Assets
*/
public with sharing class convertToDocumentationAssetController 
{
    
    // ------------------------------------------------
    // Class Variables
    // ------------------------------------------------
    Opportunity opportunity;
    Documentation_Asset__c documentationAsset;
    
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public convertToDocumentationAssetController() {
        this.opportunity = [SELECT Id, Account.Id, Account.Name, Name, HasOpportunityLineItem, isWon, StageName, License_Start_Date__c, License_End_Date__c, OwnerId, Primary_Contact__c
                            FROM Opportunity 
                            WHERE id = :System.currentPageReference().getParameters().get('id')];
        
        If([SELECT Id FROM OpportunityLineItem WHERE OpportunityId = :opportunity.Id AND PriceBookEntry.Product2.Product_Category__c = 'Services' AND PriceBookEntry.Product2.Product_Sub_Category__c = 'Materials'].size() > 0)
        {            
            documentationAsset = new Documentation_Asset__c(Name = opportunity.Account.Name + ' - Material Licensing', Account__c = opportunity.Account.Id, Opportunity__c = opportunity.Id, Opportunity_Owner__c = opportunity.OwnerId, Contact__c = opportunity.Primary_Contact__c, Usage_Start_Date__c = opportunity.License_Start_Date__c, Usage_End_Date__c = opportunity.License_End_Date__c);
        }            
    }
    
    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
    public Opportunity getOpportunity() { return opportunity; }
    
    public Documentation_Asset__c getDocumentationAsset() { return documentationAsset; }


    // ------------------------------------------------
    // Navigation
    // ------------------------------------------------
   
    //Creates the Master Services object and the Services Engagements 
    public PageReference save() {
        try
        {
            insert documentationAsset;
        }
        
        catch(Exception e)
        {
            ApexPages.addMessages(e);
            return null;
        }
        
        // Finally, send the user to the detail page for the new Master Services object.
        PageReference opptyPage = new PageReference('/' + documentationAsset.Id);
        opptyPage.setRedirect(true);
        return opptyPage;
    }
}