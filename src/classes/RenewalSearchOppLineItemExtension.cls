public with sharing class RenewalSearchOppLineItemExtension {

    public String oppID;// { get; set; }
    public boolean errorShow;//{ get; set; }
    public String errorTitle;//{ get; set; }
    public String errorMessage;//{ get; set; }
    public String errorSeverity;//{ get; set; } 
    List<OpportunityLineItem> OppLineItemList;
    public String oppName;
    
    public void setErrorTitle(String errorTitle) {
        this.errorTitle = errorTitle;
    }
    public String getErrorTitle() {
        return this.errorTitle;
    }
    
    public void setErrorShow(boolean errorShow) {
        this.errorShow = errorShow;
    }
    public boolean getErrorShow() {
        return this.errorShow;
    }       
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    public String getErrorMessage() {
        return this.errorMessage;
    }   
    
    public void setErrorSeverity(String errorSeverity) {
        this.errorSeverity = errorSeverity;
    }
    public String getErrorSeverity() {
        return this.errorSeverity;
    }   
    
    public void setOppID(String oppID) {
        this.oppID = oppID;
    }
    public String getOppID() {
        return this.oppID;
    }   
    public RenewalSearchOppLineItemExtension(ApexPages.StandardController controller) {
        oppID = Apexpages.currentPage().getParameters().get('oppVal'); 
    }
    
    public RenewalSearchOppLineItemExtension () {}
    
    public void setOppName(String oppName) {
        this.oppName = oppName;
    }
    
     //remove error block
    public PageReference refreshPage()  {
        errorShow = false; 
        return new PageReference('/' + oppID);
    }
    
    public String getOppName() {
        
        Opportunity opp = new Opportunity();
        String queryString;
        if(null != oppID) {
            queryString = 'Select name, Id, Account.name From Opportunity where Id=' + '\''+ oppID+ '\'';
            
            opp = Database.query(queryString) ;  
        } 
              
        return opp.Account.Name + ' - '+ opp.Name;
    }
    
    public void setOpportunityLineItems(List<OpportunityLineItem> OppLineItemList) {
        
        this.OppLineItemList = OppLineItemList;
    }
    
    public List<OpportunityLineItem> getOpportunityLineItems() {
        
        String queryString;
        OppLineItemList = New List<OpportunityLineItem>();
        
        if(null != oppID) {
            queryString='Select PricebookEntry.Product2.Name,PricebookEntry.Product2.ProductCode,TotalPrice,Renewal_Quantity__c,BbCurrencyCode__c,Currency_Amount__c,MultiYearFlag__c,PriorYearPrice__c,Proposed_Price__c,Drop_Product__c,Proposed_Price_Percentage__c From OpportunityLineItem where OpportunityId=' + '\''+ oppID+ '\'';
            OppLineItemList = Database.query(queryString);  
        }             
        return (List<OpportunityLineItem>) OppLineItemList;
     }
     
    //Save OpportunityLineItems
    public PageReference save() {       
        try{            
        
            update OppLineItemList;    
            /*errorTitle = 'Update.';
            errorMessage = 'Opportunity Line Items have been updated successfully.';
            errorSeverity = 'confirm';
            errorShow = true;*/     
            return new PageReference('/' + oppID);                           
        }
        catch (Exception e){
            errorTitle = 'Updating Error!';
            errorMessage = e.getMessage();
            errorSeverity = 'error';
            errorShow = true;  
            System.debug('@@@@@ In Catch @@@@'+e.getMessage());           
            return new PageReference('/' + oppID);
        }           
    }
}