/*
Author: Jon La
Date:   October 26, 2010
Descr:  Altiris #164482 - rename and rewrite opportunitySetStages.trigger 
 *


ChangeLog:
2013-09-20: [LaL] Need to update user profiles to inlude Bb Sales User - CPQ

 */
@isTest
private class bb_opportunity_workflow_test
{

    static testMethod void bb_test_opportunity() 
    {
        
        // The standardPricebook
        Id stdPricebook2Id =  '01s700000006RML';
        
        // NAHE Profile Id 
        // need to include the bb Sales User profile; 2013-09-20
        Id Bb_Sales_CPQ = '00e70000001BV4Y';
        Id NAHE_ProfileId = '00e70000000z9BY';
        
        Set<Id> valid_profiles_for_test = new Set<Id>{Bb_Sales_CPQ, NAHE_ProfileId};
        
        // Perform our data preparation.      
        Integer n = 1;

        
        // Sales Users
        List<User> user = new List<User>([Select Id, Name From User Where IsActive = true AND ProfileId IN :valid_profiles_for_test Limit 10]);

        system.Debug(user[0].Name);
        
        Pricebook2 pricebook = new Pricebook2(Name = 'Test Pricebook', IsActive = true);
        insert pricebook;

        List<String> families = new List<String>();
        families.add('Transact');
       // families.add('Non Recurring Other');
       // families.add('Non-Recurring Services');
        families.add('Recurring');
        
        List<Product2> products = new List<Product2>();

        for (String family : families )
        {
            Product2 a = new Product2(Name = 'Test ' + family);
            a.ProductCode =  'Test ' + family;
            a.IsActive = true;
            a.Family = family;
            a.Internal_Long_Description__c = 'internal descr';
            a.Tier__c = '1';
            a.External_Long_Description__c = 'external descr';
            a.Unit_of_Measure__c = 'Year';
            products.add(a);
        }
        insert products;
        
        List<PricebookEntry> stds = new List<PricebookEntry>();
        for (Product2 p1 : products)
        {
            PricebookEntry std = new PricebookEntry();
            std.Pricebook2Id = stdPricebook2Id;
            std.Product2Id = p1.Id;
            std.UnitPrice = 100;
            std.IsActive = true;
            stds.add(std);
        }
        insert stds;

        List<PricebookEntry> pbes = new List<PricebookEntry>();
        for (Product2 p2 : products)
        {       
            PricebookEntry pbe = new PricebookEntry();
            pbe.Pricebook2Id = pricebook.Id;  
            pbe.Product2Id = p2.Id;                 
            pbe.UnitPrice = 100;
            pbe.IsActive = true;
            pbe.UseStandardPrice = false;
            pbes.add(pbe);
        }           
        insert pbes;

        // Create n~ Accounts      
        List<Account> accounts = new List<Account>{};
        for(Integer i = 0; i < n; i++)
        {
            Account a = new Account(Name = 'Test Account ' + i);
            a.OwnerId = user[0].Id;
            a.Industry = 'Higher Ed.';
            a.Type = 'Customer';
            a.BillingStreet = '650 Massachusetts Ave';
            a.BillingCity = 'Washington';
            a.BillingState = 'DC';
            a.BillingCountry = 'USA';       
            a.BillingPostalCode = '20001';   
            accounts.add(a);
        }      
        insert accounts;
        

        Contact c = new Contact(LastName = 'Cole');
        c.FirstName = 'Taylor';
        c.AccountId = accounts[0].Id;
        c.PS_Person_Id__c = 'TaylorCole ';
        c.MailingStreet = '650 Massachusetts Ave';
        c.MailingCity = 'Washington';
        c.MailingState = 'DC';
        c.MailingCountry = 'USA';       
        c.MailingPostalCode = '20001';   
        insert c;
        
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = accounts[0].Id;
        cr.Contact__c = c.Id;
        cr.Role__c = 'Fake Role';
        insert cr;
        
    
    
        //  Create n~ Opportunities  
        List<Opportunity> opportunities = new List<Opportunity>{};
        for(Integer k = 0; k < n; k++)
        {
            Opportunity o = new Opportunity(Name = 'Test Opportunity ' + k);
            o.OwnerId = user[0].Id;
            o.Pricebook2Id = pricebook.Id;
            o.AccountId = accounts[k].Id;
            o.Type = 'Expansion Business';
            o.CloseDate =  System.today();
            o.StageName = '(S) Suspect Qualification';
            o.Sales_Team_ID__c = 'Sales Team Id';
            o.Multi_Year_Deal__c = 'Yes';   
            opportunities.add(o);                  
        }    
        insert opportunities;

       Test.startTest(); 
        // create opp line items
        List<OpportunityLineItem> lines = new List<OpportunityLineItem>();
        for (PricebookEntry e : pbes)
        {
            OpportunityLineItem line = new OpportunityLineItem();
            line.OpportunityId = opportunities[0].Id;
            line.PricebookEntryId = e.Id;
            line.Quantity = 1;
            line.Custom_price__c = 1000;
            line.Discount_Amount__c = 10;
            line.Discount_Type__c = 'Percent';
            //line.TotalPrice = 900;
            line.UnitPrice = 900;
            lines.add(line);
        }
        insert lines;


        // work with one opportunity
        opportunities[0].StageName = '(C) Decision Due';
        opportunities[0].Cross_sell_Type__c = 'Cross-sell In';
        opportunities[0].Originating_User__c = user[3].Id;
        update opportunities[0];
    
    
        // key_account with rep
        Account kr = new Account(Name = 'Key Account With Rep');
        kr.Industry = 'Higher Ed.';
        kr.Type = 'Customer';
        kr.BillingStreet = '650 Massachusetts Ave';
        kr.BillingCity = 'Washington';
        kr.BillingState = 'DC';
        kr.BillingCountry = 'USA';       
        kr.BillingPostalCode = '20001';   
        kr.Key_Account__c = true;
        // Replaced user[4] By 3 because of 3 are active
        kr.Key_Account_Rep__c = user[3].Id;           
        insert kr;      

        opportunities[0].AccountId = kr.Id;
        opportunities[0].Originating_User__c = null;
        opportunities[0].Cross_sell_Type__c = 'Home';
        update opportunities[0];


        // key account no rep
        kr.Key_Account_Rep__c = null;
        update kr;
        
        opportunities[0].AccountId = kr.Id;
        opportunities[0].Originating_User__c = null;
        opportunities[0].Cross_sell_Type__c = 'Home';
        update opportunities[0];

        //opp.StageName = '(L) Lost';
        //update opp;    
    
        //opp.StageName = '(C) Decision Due';
        //update opp;
    
    
        //opp.Psft_Integration_Stage__c = 'Create Quote';
        //update opp;  
     
        //opp.Psft_Integration_Stage__c = 'Won Opportunity';
        //update opp;
    

        // Channel Partner (Reseller__c) Opp
        Account child = new Account(Name = 'Child Account');
        child.Industry = 'Higher Ed.';
        child.Type = 'Customer';
        child.BillingStreet = '650 Massachusetts Ave';
        child.BillingCity = 'Washington';
        child.BillingState = 'DC';
        child.BillingCountry = 'USA';       
        child.BillingPostalCode = '20001'; 
        child.Reseller__c = accounts[0].Id;  
        insert child;

        opportunities[0].AccountId = child.Id;
        update opportunities[0];
        Test.stopTest();
        
    } // end-method
     
    }