/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          StageValidationsController
    @abstract       converts new products into assets and update assets for renewal products.
    @since          2011.0715
    @discussion     Class to manage Assets
*/

public with sharing class ManageAssetsController {
    
  // commenting out 
    
    public String action{get;set;}
    
    List<accountwrapper> childAccounts;
    List<Id> selectedAccount = new List<Id>();

    Opportunity opportunity;

    List<assetwrapper> newItemsList;
    List<Asset> selectedNewAssets = new List<Asset>();
    
    List<assetwrapper> renewalItemsList;
    List<Asset> selectedRenewalAssets = new List<Asset>();

    private Id implementationConsultant;

    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
    public ManageAssetsController() {
        //Retrieve the Opportunity information
        this.opportunity = [SELECT Id, Name, Account.Id, Account.Name, Account.ParentId, Account.BillingCountry, HasOpportunityLineItem, isWon, Total_Number_of_Authorized_Users_License__c, OwnerId, Owner.Name, LeadSource, CloseDate, License_End_Date__c, Primary_Contact__c, Technical_Contact__c, CMS_Type__c, CMS_Version__c, Deployment_server_URL__c, Testing_server_URL__c, Type,
                            (SELECT Id, OpportunityId, Product_Upgrade__c, Drop_Product__c, PriceBookEntry.Product2Id, PriceBookEntry.Product2.External_Long_Description__c, PriceBookEntry.Product2.Product_Category__c, PriceBookEntry.Product2.Product_Sub_Category__c, Quantity, TotalPrice FROM OpportunityLineItems WHERE (PriceBookEntry.Product2.Product_Sub_Category__c IN ('POC','SAAS','ASP','Standalone','Plan & Publish','vOffice','vClass','Moderator Access') OR PriceBookEntry.Product2.Product_Category__c IN ('Wimba Create'))),
                            (SELECT UserId, TeamMemberRole FROM OpportunityTeamMembers)
                            FROM Opportunity 
                            WHERE id = :System.currentPageReference().getParameters().get('id')];
        
        childAccounts = new List<accountwrapper>();
        for(Account account: [SELECT Id, Name FROM Account where ParentId = :opportunity.Account.Id OR Id = :opportunity.Account.Id])
        {
            this.childAccounts.add(new accountwrapper(account));
        }
        
        for(OpportunityTeamMember otm:this.opportunity.OpportunityTeamMembers)
        {
            if(otm.TeamMemberRole == 'Collaborate ICS') implementationConsultant = otm.UserId;
        }
    }
    
    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
        public Opportunity getOpportunity() {
            return opportunity;
        }
        
        public List<assetwrapper> getNewItems()
        {
            return newItemsList;
        }
        
        public List<assetwrapper> getRenewalItems()
        {
         System.debug('++++RRRR+++' + renewalItemsList);
            return renewalItemsList;
           
            
        }
        
        public List<accountwrapper> getChildAccounts()
        {
            return childAccounts;
        }


    // ------------------------------------------------
    // NAVIGATION
    // ------------------------------------------------
    public PageReference home() {
            PageReference home = Page.AssetManagement;
            home.getParameters().clear();
            home.getParameters().put('id', opportunity.Id);
            home.setRedirect(true);
            return home;
    }

    public PageReference pickAccounts() {
        if(childAccounts.size() == 1)
        {
            childAccounts[0].setSelected(true);
            if(action == 'New') return pickAssets();
            else if(action == 'Renewal') return pickAssetsRenewal();
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No action selected.'));
                return null;
            }
        }
        else
        {
            PageReference selectAccountPage = Page.SelectAccounts;
            selectAccountPage.getParameters().clear();
            selectAccountPage.getParameters().put('id', opportunity.Id);
            return selectAccountPage;
        }
    }

    public PageReference pickAssets() {
            selectedAccount.clear();
            for(accountwrapper wrapper : childAccounts)
            {
                if(wrapper.getSelected() == true)
                selectedAccount.add(wrapper.account.Id);
            }
            if(selectedAccount.size() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Select at least one Account'));
                return null;
            }
            newItemsList = new List<assetwrapper>();
            for(OpportunityLineItem oli : opportunity.OpportunityLineItems)
            {            
                if(opportunity.Type != 'Renewal' &&  oli.Product_Upgrade__c == false)
                {
                    Asset tmpAsset = new Asset();
                    tmpAsset.ContactId = opportunity.Primary_Contact__c;
                    tmpAsset.Secondary_Contact__c = opportunity.Technical_Contact__c;
                    tmpAsset.Opportunity__c = opportunity.Id;
                    tmpAsset.Product2Id = oli.PriceBookEntry.Product2Id;
                    tmpAsset.Name = opportunity.Account.Name + ' - ' + oli.PriceBookEntry.Product2.External_Long_Description__c;
                    //We are using a Custom Settings to get the latest version of a Collaborate Product
                    //When a new version of a product is released, the custom setting Collaborate_Products has to be updated.
                    tmpAsset.Version__c = Collaborate_Products__c.getInstance(oli.PriceBookEntry.Product2.Product_Category__c) != null?Collaborate_Products__c.getInstance(oli.PriceBookEntry.Product2.Product_Category__c).Version__c:null; 
                   //tmpAsset.Version__c ='Latest'; 
                    tmpAsset.PurchaseDate = opportunity.CloseDate;
                    tmpAsset.UsageEndDate = opportunity.License_End_Date__c;
                    tmpAsset.Price = oli.TotalPrice;
                    tmpAsset.Quantity = oli.Quantity;
                    tmpAsset.CMS_Type__c = opportunity.CMS_Type__c;
                    tmpAsset.CMS_Version__c = opportunity.CMS_Version__c;
                    tmpAsset.Type__c = oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'SAAS'?'ASP':oli.PriceBookEntry.Product2.Product_Sub_Category__c;
                    tmpAsset.Support_Email__c = 'technicalsupport@wimba.com';
                    tmpAsset.Support_Phone__c = '(866) 350-4978';
                    tmpAsset.User_Limit__c = oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'License'?oli.Quantity.format():'Unlimited';
                    tmpAsset.Comments__c = '';
                    tmpAsset.Hosting_Option__c = 'Shared';
                    tmpAsset.Asset_Type__c = 'New'; 
                    tmpAsset.Production_Server_URL__c = opportunity.Deployment_server_URL__c; 
                    tmpAsset.Development_Server_URL__c = opportunity.Testing_server_URL__c;
                    if((oli.PriceBookEntry.Product2.Product_Category__c == 'Wimba Classroom' || oli.PriceBookEntry.Product2.Product_Category__c == 'Wimba Voice') && oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'SAAS'){
                        if(opportunity.Account.BillingCountry != null && (opportunity.Account.BillingCountry.toLowerCase() == 'canada' || opportunity.Account.BillingCountry.toLowerCase() == 'ca')) tmpAsset.ASP_Location__c = 'CA';
                        else if(opportunity.Account.BillingCountry != null && (opportunity.Account.BillingCountry.toLowerCase() == 'united states' || opportunity.Account.BillingCountry.toLowerCase() == 'united states of america' || opportunity.Account.BillingCountry.toLowerCase() == 'usa' || opportunity.Account.BillingCountry.toLowerCase() == 'u.s.a.')) tmpAsset.ASP_Location__c = 'US';
                        else tmpAsset.ASP_Location__c = 'UK';
                    }
                    tmpAsset.Hosting_Contact__c = UserInfo.getUserId();
                    tmpAsset.Implementation_Consultant__c = implementationConsultant;
                    tmpAsset.Opportunity_Owner__c = opportunity.OwnerId;
                    if(oli.PriceBookEntry.Product2.Product_Category__c == 'Wimba Classroom') tmpAsset.Login_Styles__c = opportunity.CMS_Type__c != 'D2L'?'Default':'Room ID';
                    newItemsList.add(new assetwrapper(tmpAsset));
                }
            }
            
            PageReference selectNewAssetPage = Page.SelectNewAssets;
            selectNewAssetPage.getParameters().clear();
            selectNewAssetPage.getParameters().put('id', opportunity.Id);
            return selectNewAssetPage;
        }


    public PageReference pickAssetsRenewal() {
            selectedAccount.clear();
            for(accountwrapper wrapper : childAccounts)
            {
                if(wrapper.getSelected() == true)
                selectedAccount.add(wrapper.account.Id);
            }
            if(selectedAccount.size() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Select at least one Account'));
                return null;
            }
            renewalItemsList = new List<assetwrapper>();
            Map<String,Product2> productFamilies = new Map<String,Product2>();

            //Set of Categories and SubCategories for Asset query
            Set<String> assetCategories = new Set<String>();
            Set<String> assetSubCategories = new Set<String>();

            for(OpportunityLineItem oli : opportunity.OpportunityLineItems)
            {
                if((opportunity.Type == 'Renewal' && oli.Drop_Product__c != 'Yes') || oli.Product_Upgrade__c == true)
                {
                    if(oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'Plan & Publish')
                    {
                        if(oli.PriceBookEntry.Product2.External_Long_Description__c.contains('Plan')) productFamilies.put('Plan',oli.PriceBookEntry.Product2);
                        else { productFamilies.put('Publish',oli.PriceBookEntry.Product2);
                        
                        assetSubCategories.add(oli.PriceBookEntry.Product2.Product_Sub_Category__c);
                        System.debug('+++PPP+++' + oli.PriceBookEntry.Product2);}
                    }
                    
                    else if(oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'vOffice' || oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'vClass' || oli.PriceBookEntry.Product2.Product_Sub_Category__c == 'Moderator Access')
                    {
                        productFamilies.put(oli.PriceBookEntry.Product2.Product_Sub_Category__c,oli.PriceBookEntry.Product2);
                        assetSubCategories.add(oli.PriceBookEntry.Product2.Product_Sub_Category__c);
                    }
                    else 
                    {
                        productFamilies.put(oli.PriceBookEntry.Product2.Product_Category__c,oli.PriceBookEntry.Product2);
                        assetCategories.add(oli.PriceBookEntry.Product2.Product_Category__c);
                    }
                }
            }
                        
            try
            {
                List<Asset> assets = [SELECT Id, Name, Product2Id, Product2.Product_Category__c, Product2.Product_Sub_Category__c, Product2.External_Long_Description__c, UsageEndDate, Bugzilla_Bug_Number__c, Type__c, Status, Version__c, Account.Name FROM Asset WHERE Psft_Product_Id__c = null AND Status != 'Obsolete' AND ((Product2.Product_Category__c IN :assetCategories AND Product2.Product_Sub_Category__c NOT IN :assetSubCategories) OR Product2.Product_Sub_Category__c IN :assetSubCategories) and AccountId IN :selectedAccount ];
                System.debug('+++++HHHHH ++++' + assets);
                for(Asset asset: assets)
                {
                    //Updating Asset with up-to-date Product and Opportunity information
                    if(asset.Product2.Product_Sub_Category__c == 'Plan & Publish')
                    {
                        if(asset.Product2.External_Long_Description__c.contains('Plan'))
                        {
                            asset.Product2Id = productFamilies.get('Plan') != null?productFamilies.get('Plan').Id:asset.Product2Id;
                            asset.Name = productFamilies.get('Plan') != null?asset.Account.Name + ' - ' + productFamilies.get('Plan').External_Long_Description__c:asset.Account.Name + ' - ' + asset.Product2.External_Long_Description__c;
                        }
                        else
                        {
                            asset.Product2Id = productFamilies.get('Publish') != null?productFamilies.get('Publish').Id:asset.Product2Id;
                            asset.Name = productFamilies.get('Publish') != null?asset.Account.Name + ' - ' + productFamilies.get('Publish').External_Long_Description__c:asset.Account.Name + ' - ' + asset.Product2.External_Long_Description__c;
                            System.debug('+++++NNNNN+++' + asset.Name);
                            System.debug('+++N1N1n1++++'+ asset.Product2Id);
                        }
                    }
                    else if(asset.Product2.Product_Sub_Category__c == 'vOffice' || asset.Product2.Product_Sub_Category__c == 'vClass' || asset.Product2.Product_Sub_Category__c == 'Moderator Access')
                    {
                        asset.Product2Id = productFamilies.get(asset.Product2.Product_Sub_Category__c) != null?productFamilies.get(asset.Product2.Product_Sub_Category__c).Id:asset.Product2Id;
                        asset.Name = productFamilies.get(asset.Product2.Product_Sub_Category__c) != null?asset.Account.Name + ' - ' + productFamilies.get(asset.Product2.Product_Sub_Category__c).External_Long_Description__c:asset.Account.Name + ' - ' + asset.Product2.External_Long_Description__c;
                    }
                    else
                    {
                        asset.Product2Id = productFamilies.get(asset.Product2.Product_Category__c) != null?productFamilies.get(asset.Product2.Product_Category__c).Id:asset.Product2Id;
                        asset.Name = productFamilies.get(asset.Product2.Product_Category__c) != null?asset.Account.Name + ' - ' + productFamilies.get(asset.Product2.Product_Category__c).External_Long_Description__c:asset.Account.Name + ' - ' + asset.Product2.External_Long_Description__c;
                    }  
                    asset.Opportunity__c = opportunity.Id;
                    
                    asset.Implementation_Consultant__c = null;
                    asset.Opportunity_Owner__c = opportunity.OwnerId;
                    this.renewalItemsList.add(new assetwrapper(asset));
                    system.debug('++++RBBBBB+++' +  this.renewalItemsList);
                }
            }
            catch(QueryException e)
            {
                return null;
            }            
            
            PageReference selectRenewalAssetPage = Page.SelectRenewalAssets;
            selectRenewalAssetPage.getParameters().clear();
            selectRenewalAssetPage.getParameters().put('id', opportunity.Id);
            return selectRenewalAssetPage;
        }

        
        //Creates the Assets 
        public PageReference saveAssets() {
            selectedNewAssets.clear();
            for(assetwrapper wrapper : newItemsList)
            {
                if(wrapper.selected == true){
                    for(accountwrapper acctwrapper : childAccounts)
                    {
                        if(acctwrapper.selected == true){
                            Asset cloneAsset = wrapper.asset.clone();
                            cloneAsset.AccountId = acctwrapper.account.Id;
                            selectedNewAssets.add(cloneAsset);
                        }
                    }
                }
            }
            if(selectedNewAssets.size() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Select at least one product'));
                return null;
            }
            try
            {
                insert selectedNewAssets;
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                return null;
            }      
            // Finally, send the user to the detail page for
            // the new opportunity.
            // Note that using '/' in the new PageReference object keeps
            // the user in the current instance of salesforce, rather than
            // redirecting him or her elsewhere.
            PageReference opptyPage = new PageReference('/' + opportunity.Account.Id);
            opptyPage.setRedirect(true);
            return opptyPage;
        }

        //Creates the Assets 
        public PageReference updateAssets() {
            selectedRenewalAssets.clear();
            for(assetwrapper wrapper : renewalItemsList)
            {
                if(wrapper.selected == true){
                    wrapper.asset.Opportunity__c = this.opportunity.Id;
                    selectedRenewalAssets.add(wrapper.asset);                  
                }
            }
            if(selectedRenewalAssets.size() == 0)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Please Select at least one product'));
                return null;
            }
            try
            {
                update selectedRenewalAssets;
            }
            catch(Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,e.getMessage()));
                return null;
            }      
            // Finally, send the user to the detail page for
            // the new opportunity.
            // Note that using '/' in the new PageReference object keeps
            // the user in the current instance of salesforce, rather than
            // redirecting him or her elsewhere.
            PageReference opptyPage = new PageReference('/' + opportunity.Account.Id);
            opptyPage.setRedirect(true);
            return opptyPage;
        }
                

        public class assetwrapper
        {
            public Asset asset;
            public Boolean selected;
            
            public Asset getAsset() { return this.asset; }
            public void setAsset(Asset asset) { this.asset=asset; }

            public Boolean getSelected() { return this.selected; }
            public void setSelected(Boolean selected) { this.selected=selected; }

            public String getCategory()
            {
                return [SELECT Product_Category__c FROM Product2 WHERE Id = :asset.Product2Id].Product_Category__c;
            }
            
            public assetwrapper(Asset a)
            {
                asset = a;
                selected = false;
            }
        }

        public class accountwrapper
        {
            public Account account;
            public Boolean selected;
            
            public Account getAccount() { return this.account; }
            public void setAccount(Account account) { this.account=account; }

            public Boolean getSelected() { return this.selected; }
            public void setSelected(Boolean selected) { this.selected=selected; }
            
            public accountwrapper(Account a)
            {
                account = a;
                selected = false;
            }
        }
        
       // commenting out */
    }