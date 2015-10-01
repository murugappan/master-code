public with sharing class BigMachinesEditQuoteExtension {
    
    // URLs for Visualforce pages
    private String bmEditURL = '';
    
    private BigMachines_Quote__c bmQuote;
    private Boolean bmUsesSSL;

    public BigMachinesEditQuoteExtension(ApexPages.StandardController stdCtrl) {
        this(stdCtrl, BigMachinesParameters.usesSSL);
    }
    
    public BigMachinesEditQuoteExtension(ApexPages.StandardController stdCtrl, Boolean ssl) {
        bmQuote = (BigMachines_Quote__c)stdCtrl.getRecord();
        bmUsesSSL = ssl;
        buildURL();
    }

    private void buildURL() {
        bmEditURL = 'http' + ((bmUsesSSL) ? 's' : '') + '://'
                  + BigMachinesParameters.bm_site + '.bigmachines.com/commerce/buyside/'
                  + 'document.jsp?formaction=performAction'
                  + '&action_id=' + BigMachinesParameters.action_id_open
                  + '&bm_url_capture_cookie=' + BigMachinesParameters.bm_site
                  + '&bs_id=' + bmQuote.BigMachines_Transaction_Id__c 
                  + '&_partnerOpportunityId=' + bmQuote.Opportunity__c
                  + '&_partnerAccountId=' + bmQuote.Opportunity__r.AccountId
                  + '&bm_cm_process_id=' + BigMachinesParameters.process_id
                  + '&document_id=' + BigMachinesParameters.document_id;
    }
    
    public String getEditURL() {
        return bmEditURL;
    }
 
    static testMethod void testGetEditURL() {
        Opportunity opty = new Opportunity();
        opty.Name = 'BigMachines test Opportunity for testGetEditURL';
        opty.StageName = 'Prospecting';
        opty.CloseDate = Date.today();
        
        /** 2011-01-15 jon.lal@blackboard.com **/
        Account acct = new Account(Name= 'Test Account');
        acct.Type = 'Prospect';
        acct.Industry = 'Higher Ed.';
        acct.BillingStreet = '650 Mass';
        acct.BillingCity = 'Washington';
        acct.BillingPostalCode = '20001';
        acct.BillingState = 'DC';
        acct.BillingCountry = 'USA';
        insert acct;
        
        opty.AccountId = acct.Id;
      	opty.Sales_Team_ID__c = 'Sales Team Id';
      	opty.Multi_Year_Deal__c = 'Yes';   
      	opty.Type = 'Expansion Business';
        /** 2011-01-15 end **/        
        
        
        insert opty;
        BigMachines_Quote__c quote = new BigMachines_Quote__c();
        quote.Name = 'BigMachines test quote for testGetEditURL';
        quote.Opportunity__c = opty.id;
        quote.BigMachines_Transaction_Id__c = 'BMI123';
        insert quote;
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(quote);
        BigMachinesEditQuoteExtension controller = new BigMachinesEditQuoteExtension(stdCtrl);
        controller = new BigMachinesEditQuoteExtension(stdCtrl, true);
        controller = new BigMachinesEditQuoteExtension(stdCtrl, false);
        String testEditURL = controller.getEditURL();
        System.assertNotEquals(testEditURL, '');
    }
}