public with sharing class SearchOppLineItemExtension {

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
    public SearchOppLineItemExtension(ApexPages.StandardController controller) {
        oppID = Apexpages.currentPage().getParameters().get('oppVal'); 
    }
    
    public SearchOppLineItemExtension () {}
    
    public void setOppName(String oppName) {
        this.oppName = oppName;
    }
    
     //remove error block
    public PageReference refreshPage()  {
        errorShow = false; 
        return null;
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
            queryString='Select ts_line_product_delivery_date__c,ts_line_project_start_date__c,ts_line_desired_live_date__c,Transact_Desired_Prod_Date__c, PricebookEntry.Product2.Name,PricebookEntry.Product2.ProductCode,PricebookEntry.Product2.Internal_Long_Description__c ,PricebookEntry.Product2.Type__c,UnitPrice, ACCT_Description__c, Transact_Desired_Live_Date__c, Quantity, Psft_Capture_ID__c, Product_Type__c, Discount_Amount__c, Customer_Price__c, Custom_Price__c, Converted_To_Order__c From OpportunityLineItem where OpportunityId=' + '\''+ oppID+ '\'';
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
            return null;                           
        }
        catch (Exception e){
            errorTitle = 'Updating Error!';
            errorMessage = e.getMessage();
            errorSeverity = 'error';
            errorShow = true;  
            System.debug('@@@@@ In Catch @@@@'+e.getMessage());           
            return null;
        }           
    }
}