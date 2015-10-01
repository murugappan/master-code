/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          ConvertToServicesController
    @abstract       creates Services Projects and Services Engagements based on Services products.
    @since          2011.0715
    @discussion     Class to create Services Projects
*/

/** TODO
    - Sales Team Roles
*/

public with sharing class ConvertToServicesController 
{
        
        // ------------------------------------------------
        // Class Variables
        // ------------------------------------------------
        private Opportunity opportunity;
        private Services_Project__c servicesProject;
        private List<Services_Engagement__c> servicesEngagements;
       
        // ------------------------------------------------
        // Constructor Method
        // ------------------------------------------------
        public ConvertToServicesController() {
            this.servicesEngagements = new List<Services_Engagement__c>();
            
            this.opportunity = [SELECT Id, Account.Id, Account.Name, Name, CloseDate, Contract__c, HasOpportunityLineItem, Primary_Contact__c, isWon, StageName, CurrencyIsoCode, Amount, Owner.Name, (Select Id, User.Name, User.Id, TeamMemberRole from OpportunityTeamMembers) 
                                FROM Opportunity 
                                WHERE id = :System.currentPageReference().getParameters().get('id')];
            
            List<OpportunityLineItem> servicesLineItems = [SELECT Id, OpportunityId, PriceBookEntry.Product2Id, PriceBookEntry.Product2.External_Long_Description__c, PriceBookEntry.Product2.Product_Category__c, PriceBookEntry.Product2.Product_Sub_Category__c, Quantity, TotalPrice 
                                                           FROM OpportunityLineItem 
                                                           WHERE OpportunityId = :opportunity.Id
                                                           AND PriceBookEntry.Product2.Product_Category__c = 'Services' 
                                                           AND PriceBookEntry.Product2.Product_Sub_Category__c IN ('Implementation Service','Learning Services','Technical Service','Custom Services')];
            
           // Added By Nikhil  Start
           Contact_Role_Selector__c ConRole=[Select id,Contact_Role__r.Role__c,Contact_Role__r.Contact__c from Contact_Role_Selector__c Where Opportunity__c=:System.currentPageReference().getParameters().get('id') and Contact_Role__r.Role__c='COLLABORATE - Primary Sales Technical Contact' limit 1];
           
           // END
           
           
           
            this.servicesProject = new Services_Project__c(OwnerId = UserInfo.getUserId(), Name = opportunity.Name, Account__c = opportunity.Account.Id, Opportunity__c = opportunity.Id, CurrencyIsoCode = opportunity.CurrencyIsoCode);
           
            for(OpportunityTeamMember otm:opportunity.OpportunityTeamMembers)
            {
                if(otm.TeamMemberRole == 'Collaborate ICS') servicesProject.OwnerId = otm.User.Id;
                if(otm.TeamMemberRole == 'Collaborate Renewal Rep') servicesProject.Account_Manager__c = otm.User.Id;
            }

            for(OpportunityLineItem servicesLineItem:servicesLineItems)
            {
                Services_Engagement__c tmpServicesEngagement = new Services_Engagement__c();
                tmpServicesEngagement.Opportunity__c = opportunity.Id;
                tmpServicesEngagement.Name = servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c;
                tmpServicesEngagement.Account__c = opportunity.Account.Id;
                tmpServicesEngagement.Status__c = 'Unscheduled';
                tmpServicesEngagement.CurrencyIsoCode = opportunity.CurrencyIsoCode;
                tmpServicesEngagement.Dollar_Value__c = servicesLineItem.TotalPrice;
                tmpServicesEngagement.Trainer__c = servicesProject.OwnerId;
                // Below line is commented by Nikhil
               //tmpServicesEngagement.Primary_Contact__c = opportunity.Primary_Contact__c;
                 
                 if(ConRole!=Null)
                 tmpServicesEngagement.Primary_Contact__c = ConRole.Contact_Role__r.Contact__c;
                 tmpServicesEngagement.Product__c = '';

                String products = '';
                if(servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('All Module') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Elluminate Live!') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Web Conferencing')) products += 'eLive! v10;';
                if(servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('WC') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Classroom')) products += 'Wimba Classroom;';
                if(servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('All Module') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('WV') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Voice')) products += 'Voice Authoring;';
                if(servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('All Module') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('WP') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Pronto') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Enterprise IM')) products += 'Enterprise IM;';
                if(products.endsWith(';')) tmpServicesEngagement.Product__c = products.substring(0,products.lastIndexOf(';'));
                
                if(servicesLineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Implementation Service') tmpServicesEngagement.Service_Type__c = 'Implementation Service';
                else if(servicesLineItem.PriceBookEntry.Product2.Product_Sub_Category__c == 'Technical Service') tmpServicesEngagement.Service_Type__c = 'Technical Service';
                else if(servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('WOW') || servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Online')) tmpServicesEngagement.Service_Type__c = 'Learning Service Online';
                else if(servicesLineItem.PriceBookEntry.Product2.External_Long_Description__c.contains('Onsite')) tmpServicesEngagement.Service_Type__c = 'Learning Service Onsite';

                servicesEngagements.add(tmpServicesEngagement);
            }
        }
        
        // ------------------------------------------------
        // GET/SET Methods
        // ------------------------------------------------
        public Opportunity getOpportunity() { return opportunity; }
        
        public List<Services_Engagement__c> getServicesEngagements() { return this.servicesEngagements; }
        
        public Services_Project__c getServicesProject() { return this.servicesProject; }
        
        
        // ------------------------------------------------
        // Navigation
        // ------------------------------------------------

        public PageReference save() {

            Decimal totalAmount = 0;
            for(Services_Engagement__c servicesEngagement : this.servicesEngagements)
            {
                totalAmount += servicesEngagement.Dollar_Value__c;
            }
            this.servicesProject.Total_Amount__c = totalAmount;
            
            try
            {
                insert this.servicesProject;
            
                for(Services_Engagement__c servicesEngagement : this.servicesEngagements)
                {
                    //link the Service Engagement to the Services Project
                    servicesEngagement.Services_Project__c = this.servicesProject.Id;
                    servicesEngagement.Name = opportunity.Account.Name + ' - ' + servicesEngagement.Service_Type__c;
                    //Cusotm Object name cannot contain more than 80 characters
                    if(servicesEngagement.Name.length() > 80) servicesEngagement.Name = servicesEngagement.Name.substring(0,80);


                    //If the Services Engagement is already Scheduled or In-Progress we copy the Dates from the Services Project
                    if(servicesEngagement.Status__c != null && servicesEngagement.Status__c != 'Unscheduled')
                    {
                        servicesEngagement.Delivery_Date__c = this.servicesProject.Start_Date__c;
                        servicesEngagement.Start_Date__c = this.servicesProject.Start_Date__c;
                        servicesEngagement.End_Date__c = this.servicesProject.End_Date__c;
                    }
                    
                }
                insert this.servicesEngagements;
            }
            
            catch(Exception e)
            {
                ApexPages.addMessages(e);
                return null;
            }
            
            // Finally, send the user to the detail page for the new Services Project object.
            PageReference servicesPage = new PageReference('/' + this.servicesProject.Id);
            servicesPage.setRedirect(true);
            return servicesPage;
        }
}