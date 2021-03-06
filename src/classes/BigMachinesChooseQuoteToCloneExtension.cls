public with sharing class BigMachinesChooseQuoteToCloneExtension {

    private ApexPages.StandardSetController bmStdSetCtrl;    

    private ID bmOpportunityId;
    private String bmOpportunityName;
    private ID bmSelectedQuoteId;

    public BigMachinesChooseQuoteToCloneExtension(ApexPages.StandardSetController stdSetCtrl) {
        bmOpportunityId = ApexPages.currentPage().getParameters().get('oppId');
        bmOpportunityName = [select Name from Opportunity where Id = :bmOpportunityId].Name;
        bmStdSetCtrl = stdSetCtrl;
    }

    public void setSelectedQuoteId(ID quoteId) {
        bmSelectedQuoteId = quoteId;
    }    

    public String getSelectedQuoteId() {
        return bmSelectedQuoteId;
    }

    public String getOppName() {
        return bmOpportunityName;
    }
    
    public ID getOppId() {
        return bmOpportunityId;
    }

    public Integer getStartOfRange() {
        return (bmStdSetCtrl.getPageNumber()-1) * bmStdSetCtrl.getPageSize() + 1;
    }
    
    public Integer getEndOfRange() {
        Integer rangeEnd = bmStdSetCtrl.getPageNumber() * bmStdSetCtrl.getPageSize();
        if (rangeEnd > bmStdSetCtrl.getResultSize()) {
            rangeEnd = bmStdSetCtrl.getResultSize();
        }
        return rangeEnd;
    }

    public PageReference cloneQuote() {
        if (bmSelectedQuoteId != null) {
            return new PageReference('/apex/BM_NewQuote?cloneId=' + bmSelectedQuoteId + '&oppId=' + bmOpportunityId);
        } else {
            return new PageReference('/apex/BM_CloneSelection?oppId=' + bmOpportunityId);
        }
    }

    public PageReference cancel() {
        return new PageReference('/' + bmOpportunityId);
    }

    static testMethod void testGetQuoteListFromOpty() {
        //BigMachinesController controller = new BigMachinesController();
        Opportunity opty = new Opportunity();
        opty.Name = 'BigMachines test Opportunity for testGetQuoteList';
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
        quote.Name = 'BigMachines test quote for testGetQuoteListFromOpty';
        quote.Opportunity__c = opty.id;
        insert quote;
        ApexPages.StandardSetController stdSetCtrl = new ApexPages.StandardSetController([select id from BigMachines_Quote__c limit 1]);
        ApexPages.currentPage().getParameters().put('oppId', opty.id);
        BigMachinesChooseQuoteToCloneExtension controller = new BigMachinesChooseQuoteToCloneExtension(stdSetCtrl);
        controller.getOppName();
        controller.getOppId();
        controller.getStartOfRange();
        controller.getEndOfRange();
        controller.cloneQuote();
        controller.setSelectedQuoteId(quote.id);
        controller.getSelectedQuoteId();
        controller.cloneQuote();
        controller.cancel();
    }

}