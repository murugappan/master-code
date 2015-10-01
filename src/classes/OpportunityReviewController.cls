// This class is the controller for the VF page 'OpportunityReview'
// Written by Dominic Baker on 
// Last modified by Dominic Baker on
public with sharing class OpportunityReviewController 
{
	// This is not being used but is reference somewhere else and I cannot delete it
	// I used the same wrapper name as somewhere else and it cause a conflict
    public class AttachmentWrapper
    {
        
    }
    
    public Opportunity opp {get; set;} // This is the Opportunity controlling this page
    public Attachment attachObj {get; set;} // This is the Attachment being saved to this page
    transient public list<Attachment> attachmentList {get; set;} // This is the list of attachments stored on this object
    public list<OpportunityPartner> partnerList {get; private set;} // This is the list of Opp Partners on this Opp
    public list<Contact_Role_Selector__c> fullContactRoleList {get; private set;} // This is the full list of Contact Role Selectors for this Opp
    public list<OpportunityLineItem> lineItemList {get; private set;} // This is a list of all line items on this opp
    public Boolean hasErrors {get{if (hasErrors == null) return false; return hasErrors;} private set;} // This is true if an error is on pageload
    public Integer customerValidationResult {get; set;} // This is the code for what validation message to display for customer validation
    public String poMessage {get; set;}
    public Boolean hasPartners {get{if (hasPartners == null) return false; return hasPartners;} private set;} // This is true if the Opp has partners
    public Boolean hasPCs {get{if (hasPCs == null) return false; return hasPCs;} private set;} // This is true if the opp has at least 1 Primary Contact
    public Boolean hasSAs {get{if (hasSAs == null) return false; return hasSAs;} private set;} // This is true if the opp has at least 1 System Admin
    public Boolean isEdit {get{if (isEdit == null) return false; return isEdit;} private set;} // This is true if the user has entered edit mode of the page
    public Boolean hasYear2 {get{if (hasYear2 == null) return false; return hasYear2;} private set;} // This is true if there is a year 2 price on the Opp
    public Boolean hasYear3 {get{if (hasYear3 == null) return false; return hasYear3;} private set;} // This is true if there is a year 3 price on the Opp
    public Boolean hasYear4 {get{if (hasYear4 == null) return false; return hasYear4;} private set;} // This is true if there is a year 4 price on the Opp
    public Boolean hasYear5 {get{if (hasYear5 == null) return false; return hasYear5;} private set;} // This is true if there is a year 5 price on the Opp
    public Integer fileSize {get; set;} // This is the size of the file that is being uploaded
    public String selectedAttachmentType {get; set;} // This is the Type of document that should be set to the name of the attachment uploaded
    public String viewMode {get {if (isEdit) return 'edit'; return 'view';} private set;} // This is the string that flips based on edit or view
    private String theId; // This is the id passed to the VF page
    
    /* Constructors */
    
    // This is a constructor for this page
    public OpportunityReviewController(ApexPages.StandardController stdController)
    {
        theId = ApexPages.currentPage().getParameters().get('id'); // This gets the id from the page
        String edit = ApexPages.currentPage().getParameters().get('edit'); // This determines if the user is in edit mode
        if (theId == null) // If there is no id passed to the page
        {
            theId = stdController.getId(); // set it by the standard controller
        }
        if (edit == '1') // If the edit int is 1
        {
            isEdit = true; // then the user is in edit mode
        }
        loadOpportunity(); // method called to query the opp based on 'theId'
        if (opp != null) // if the query does not return null
        {
            loadPartners(); // method loads partners for this opp
            loadAttachments(); // method loads attachments for this opp
            loadContactRoles(); // method loads contact roles for this opp
            loadLineItems(); // method loads opp line items for this opp
            attachObj = new Attachment(); // Creates a new attachment for use on the page
        }
    }
    
    /* End of Constructors */
    
    /* Helper methods */
    
    // This method queries the opp based on 'theId'
    private void loadOpportunity()
    {
        try // To trap all errors 
        {
        	// Query all fields needed to display on the VF page
            opp = [Select Id, Name, CPQ_PO_Received__c, CPQ_PO_Validated__c, Billing_Contact__c, Billing_Contact__r.MailingStreet, CPQ_Consortium_Buying_Agreement__c,
                          CPQ_Payment_Terms__c, Comments_for_Finance__c, CPQ_Web_Portal_Billing_Required__c, AccountId, Account.CPQ_Tax_Certificate_ID__c, Account.CPQ_Tax_Exempt_Status__c,
                          Account.Name, Account.CPQ_AR_Past_Due_60_days__c, Account.CPQ_Credit_Risk_Score__c, Account.CPQ_PO_Required__c, Customer_Requested_Prod_Delivery_Date__c, 
                          CPQ_Requires_Special_PFIN_Setup__c, CPQ_NonBinding_MultiYear__c, CPQ_PO_Required__c, Account.BillingStreet, Account.BillingCity, Account.BillingState, 
                          Account.BillingPostalCode, Account.BillingCountry, Account.PS_Company_Id__c, Account.Industry,
                          CPQ_Ship_To_Account_Name__c, CPQ_Ship_To_Account_Name__r.ShippingCountry, CPQ_Ship_To_Account_Name__r.ShippingPostalCode, 
                          CPQ_Ship_To_Account_Name__r.ShippingState, CPQ_Ship_To_Account_Name__r.ShippingCity, CPQ_Ship_To_Account_Name__r.ShippingStreet, 
                          CPQ_Ship_To_Account_Name__r.PS_Company_Id__c, Account.CPQ_Web_Portal_Billing_Required__c, 
                          CPQ_Bill_To_Account_Name__c, CPQ_Bill_To_Account_Name__r.BillingCountry, CPQ_Bill_To_Account_Name__r.BillingPostalCode, CPQ_Bill_To_Account_Name__r.BillingState, 
                          CPQ_Bill_To_Account_Name__r.BillingCity, CPQ_Bill_To_Account_Name__r.BillingStreet, CPQ_Bill_To_Account_Name__r.PS_Company_Id__c, Amount, Multi_Year_Deal__c,
                          Year_2_Amount__c, Year_3_Amount__c, Year_4_Amount__c, Year_5_Amount__c, CurrencyIsoCode, CPQ_Approval_to_Invoice_wo_PO_Attached__c, 
                          CPQ_Partner_Billing_Instructions__c, CPQ_PO_Number__c, CPQ_Reseller_New_Software_Commission__c, CPQ_Reseller_New_Services_MH_Commission__c, 
                          CPQ_Reseller_Renewal_Commission__c, VAT_ID_Number__c
                   From Opportunity 
                   Where Id =: theId];
            
            // These ifs check how many amounts have been saved to the opp for use on the VF page       
            if (opp.Year_2_Amount__c > 0)
            {
                hasYear2 = true;
            }
            if (opp.Year_3_Amount__c > 0)
            {
                hasYear3 = true;
            }
            if (opp.Year_4_Amount__c > 0)
            {
                hasYear4 = true;
            }
            if (opp.Year_5_Amount__c > 0)
            {
                hasYear5 = true;
            }
        }
        catch (Queryexception qe) // Catches all query exceptions
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your opportunity was not found.')); // Adds message to the page
            hasErrors = true; // Flips error flag to true
        }
    }
    
    // This method loads all Partners associated with this Opp
    private void loadPartners()
    {
        hasPartners = false; // Sets the flag initially to false
        // Queries all partners on the account
        partnerList = [Select o.Role, o.ReversePartnerId, o.OpportunityId, o.IsPrimary, o.Id, o.AccountToId, o.AccountTo.Name, AccountTo.PS_Company_Id__c 
                       From OpportunityPartner o 
                       Where OpportunityId =: opp.Id
                       // This last And is the stop partners for coming in twice because they are stored twice in SF for some reason
                       And AccountToId !=: opp.AccountId];
        
        if (partnerList != null && !partnerList.isEmpty()) // Check if any partners were added
        {
            hasPartners = true; // Flip flag to true if so
        }
    }
    
    // This method will load all the Attachments for this Opp and determine which ones are missing
    public void loadAttachments()
    {
        attachmentList = new list<Attachment>(); // The attachment list for the VF page set to new
        customerValidationResult = 0; // Reset the validation code
        poMessage = '';
        
        // Loop thru the queried Attachments
        for (Attachment att : [Select a.ParentId, a.OwnerId, a.Name, a.LastModifiedDate, a.LastModifiedById, a.Id, a.Description, a.CreatedDate, a.CreatedById, a.ContentType, a.BodyLength, 
                                      a.Body, a.CreatedBy.Name
                               From Attachment a
                               Where ParentId =: opp.Id])
        {
            attachmentList.add(att); // Add to the attachment list
            if (att.Name.startsWith('Purchase Order Exemption')) // Check to see if the attachment is marked as PO Exempt
            {
                //customerValidationResult = 1; // 1 means yes it has the email
            }
        }
        
        if (opp.CPQ_PO_Required__c == 'Unknown' || opp.CPQ_PO_Required__c == null || opp.CPQ_PO_Required__c == '') // Check if the 'PO Required?' field does not have Yes or No
        {
            poMessage = 'You must select if a PO is required or not';
        }
        else if (opp.Account.CPQ_PO_Required__c == 'No' && opp.CPQ_PO_Required__c == 'No') // Check if the 'PO Required?' field on the Opp and Account are No
        {
            poMessage = 'The Account on this Opportunity does not require Customer Validations';
        }
        else if (opp.CPQ_PO_Required__c == 'Yes') // Check if 'PO Required?' is Yes
        {
        	if (!opp.CPQ_PO_Received__c && !opp.CPQ_PO_Validated__c)
        	{
        		poMessage = 'Please confirm PO receipt and validation';
        	}
            else if (opp.CPQ_PO_Received__c && !opp.CPQ_PO_Validated__c)
            {
            	poMessage = 'Please validate PO and confirm attached to Opportunity';
            }
        }
        else if (opp.CPQ_PO_Required__c == 'No')
        {
        	if (!opp.CPQ_Approval_to_Invoice_wo_PO_Attached__c)
        	{
        		poMessage = 'In order to close this opportunity, please confirm receipt of confirmation from customer that a PO is not required';
        	}
        }
    }
    
    // This method will load the contact role selectors on the Opp
    private void loadContactRoles()
    {
    	// Reset all variables for contact role selectors
        fullContactRoleList = new list<Contact_Role_Selector__c>();
        hasPCs = false;
        hasSAs = false;
        
        // Loop thru the queried Contact Role Selectors on the Opp
        for (Contact_Role_Selector__c crc : [Select c.Contact_Role__r.Contact_Role_Address__c, c.Contact_Role__r.Role__c, c.Contact_Role__r.Contact__c, c.Contact_Role__r.Contact__r.Name, 
                                                     c.Contact_Role__c, c.Contact_Role__r.Contact__r.PS_Person_Id__c, c.Contact_Role__r.Contact__r.Email 
                                              From Contact_Role_Selector__c c
                                              Where Opportunity__c =: opp.Id])
        {
            if (crc.Contact_Role__r.Role__c.contains('Primary Sales Contact')) // Check if the contact role is a Primary Sales Contact
            {
                hasPCs = true; // Set to true if yes
            }
            else if (crc.Contact_Role__r.Role__c.contains('Primary Sales Technical Contact')) // Check if the contact role is a Primary Sales Technical Contact
            {
                hasSAs = true; // Set to true if yes
            }
            fullContactRoleList.add(crc); // Add to contact role list for VF page
        }       
    }
    
    // This method loads all opp line items for this Opp
    private void loadLineItems()
    {
    	// Queries all line items for display on the page
        lineItemList = [Select o.UnitPrice, o.TotalPrice, o.PricebookEntry.Name, o.PricebookEntryId, o.ListPrice, o.Quantity, o.CPQ_Delivery_Date__c,
        					   o.CPQ_Product_Status__c
                        From OpportunityLineItem o
                        Where OpportunityId =: opp.Id];
    }
    
    // This method is for uploading an attachment to Salesforce
    public PageReference uploadFile()
    {
        try // To trap any errors
        {
            attachObj.ParentId = opp.Id; // Sets the parent id
            attachObj.Name = selectedAttachmentType + ' - ' + attachObj.Name; // Puts the type of attachment at the fron of the name for easy referencing and use in validations
            insert attachObj; // inserts the new attachment
            attachObj = new Attachment(); // resets the page attachment to new
            loadAttachments(); // And refreshes the attachment list
        }
        catch (Dmlexception de) // Catch any DML errors
        {
            ApexPages.addMessages(de); // Add the message to the VF page
        }
        return null;
    }
    
    // This method will reload the page in edit mode
    public PageReference doEdit()
    {
        PageReference pageRef = Page.OpportunityReview;
        pageRef.getParameters().put('id', opp.Id);
        pageRef.getParameters().put('edit', '1'); // edit = 1 is for edit mode
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    // This method will cancel all transactions on the page and return to the Opp detail page
    public PageReference doCancel()
    {
        PageReference pageRef = Page.OpportunityReview;
        pageRef.getParameters().put('id', opp.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    // This method will save all changes made to the Opp fields
    public PageReference doSave()
    {
        try // to trap all errors
        {
            update opp; // update the Opp
        }
        catch (Dmlexception de) // To catch DML errors
        {
            ApexPages.addMessages(de); // This will add the messages to the VF page
            return null; // this wil reload the page with errors shown
        }
        PageReference pageRef = Page.OpportunityReview; // This will reload the detail Opp Review VF page
        pageRef.getParameters().put('id', opp.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
}