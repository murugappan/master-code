public class feildReview {

private String theId; // This is the id passed to the VF page
public Boolean hasErrors {get{if (hasErrors == null) return false; return hasErrors;} private set;} // This is true if an error is on pageload
public Opportunity opp{get;set;}
public list<OpportunityLineItem> lineItemList {get; private set;} // This is a list of all line items on this opp
public Boolean hasYear2 {get{if (hasYear2 == null) return false; return hasYear2;} private set;} // This is true if there is a year 2 price on the Opp
public Boolean hasYear3 {get{if (hasYear3 == null) return false; return hasYear3;} private set;} // This is true if there is a year 3 price on the Opp
public Boolean hasYear4 {get{if (hasYear4 == null) return false; return hasYear4;} private set;} // This is true if there is a year 4 price on the Opp
public Boolean hasYear5 {get{if (hasYear5 == null) return false; return hasYear5;} private set;} // This is true if there is a year 5 price on the Opp
public Boolean isAdminprofile {get;set;}
public string profileName {get;set;}


    public feildReview(ApexPages.StandardController stdController) {
    this.opp = (Opportunity)stdController.getRecord();

    isAdminprofile = null;
    theId = ApexPages.currentPage().getParameters().get('id'); // This gets the id from the page
    loadOpportunity();
    loadLineItems(); // method loads opp line items for this opp
    
    Id profileId=userinfo.getProfileId();
    profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    system.debug('MG ProfileName'+profileName);
    
    if(profileName == 'Tier 1 System Administrator'){
        isAdminprofile = true;
    }
    
    else if(profileName =='Tier 2 Sys Admin'){
        isAdminprofile = true;
    }
    
    else if(profileName =='System Administrator'){
        isAdminprofile = true;
    }
    
    else if(profileName == 'Tier 1 Sys Administrator'){
        isAdminprofile = true;
    }
    
    else{
        isAdminprofile = false;
    }
    
    
    

    }
    
    
      // This method queries the opp based on 'theId'
    public void loadOpportunity()
    {
        
        
        
        try // To trap all errors 
        {
            // Query all fields needed to display on the VF page
              opp = [Select Id, Name,Analytics_New_Sales_Value__c,Collaborate_New_Sales_Value__c,Collaborate_Renewal_Value__c,Analytics_Renewal_Value__c,
                    Connect_New_Sales_Value__c,
                    Connect_Renewal_Value__c,
                    Educational_Services_New_Sales_Value__c,
                    Educational_Services_Renewal_Value__c,
                    Engage_Services_New_Sales_Value__c,
                    Engage_Services_Renewal_Value__c,
                    Learn_New_Sales_Value__c,
                    Learn_Renewal_Value__c,
                    Mobile_New_Sales_Value__c,
                    Mobile_Renewal_Value__c,
                    Moodlerooms_New_Sales_Value__c,
                    Moodlerooms_Renewal_Value__c,
                    NetSpot_New_Sales_Value__c,
                    NetSpot_Renewal_Value__c,
                    Student_Services_Renewal_Value__c,
                    Student_Services_New_Sales_Value__c,
                    Transact_New_Sales__c,
                    Transact_Renewal_Sales_Value__c,
                    Is_Career_Marketplace_Approval__c,
                    Is_Delayed_Invoicing__c,
                    CPQ_Is_Discount_Approval__c,
                    Is_Enterprise_Consulting_Approval__c,
                    CPQ_Is_Hosted_Approval__c,
                    CPQ_Is_Perpetual_Approval__c,
                    CPQ_Is_Service_Approval__c,
                    CPQ_Is_Specific_Product_Approval__c,
                    Is_Student_Services_MER_Approval__c,
                    Is_Student_Services_Other_Approval__c,
                    Is_Student_Services_SLEC_Approval__c,
                    CPQ_Is_T_M_Approval__c,
                    CPQ_Is_Treasury_Approval__c,
                    Maximum_Margin_Differential__c,
                    Maximum_SLEC_Discount__c,
                    Renewal_Transaction_Owner__c,
                    MyEDU_Quota_New_Sales_Credit__c,
                    MyEDU_Quota_Renewal_Sales_Credit__c,
                    CurrencyIsoCode,
                    Amount,
                    Multi_Year_Deal__c,
                    Year_2_Amount__c,
                    Year_3_Amount__c,
                    Year_4_Amount__c,
                    Year_5_Amount__c
                    From Opportunity 
                    Where Id =: theId];
            
           
        }
        catch (Queryexception qe) // Catches all query exceptions
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your opportunity was not found.')); // Adds message to the page
            hasErrors = true; // Flips error flag to true
        }
    }
    
      // This method loads all opp line items for this Opp
    public void loadLineItems()
    {
        // Queries all line items for display on the page
        lineItemList = [Select o.UnitPrice, o.TotalPrice,o.Discount,o.Discount_Value__c, o.BALINK1__Sales_Discount__c, o.CPQ_Platform__c,o.Type__c,o.ACCT_Product_Type__c, o.PricebookEntry.Name, o.PricebookEntryId, o.ListPrice, o.Quantity, o.CPQ_Delivery_Date__c,
                               o.CPQ_Product_Status__c
                        From OpportunityLineItem o
                        Where OpportunityId =: theId];
    }
    
    
    public pagereference saveMethod(){
    update opp;
    pagereference pf= new pagereference('/'+opp.id);
    return pf;
    
    }
  
   
    

}