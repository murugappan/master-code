public without sharing class FulfillmentTaskReviewClass {

    public list<Contact_Role_Selector__c> fullContactRoleList {get; private set;} // This is the full list of Contact Role Selectors for this Opp
    public Opportunity opp {get; set;} // This is the Opportunity controlling this page
    public Boolean hasPCs {get{if (hasPCs == null) return false; return hasPCs;} private set;} // This is true if the opp has at least 1 Primary Contact
    public Boolean hasSAs {get{if (hasSAs == null) return false; return hasSAs;} private set;} // This is true if the opp has at least 1 System Admin
    private String theId; // This is the id passed to the VF page
    public Attachment attachObj {get; set;} // This is the Attachment being saved to this page
    public String selectedAttachmentType {get; set;} // This is the Type of document that should be set to the name of the attachment uploaded
    transient public list<Attachment> attachmentList {get; set;} // This is the list of attachments stored on this object
    public Integer customerValidationResult {get; set;} // This is the code for what validation message to display for customer validation
    public String poMessage {get; set;}
    public Integer fileSize {get; set;} // This is the size of the file that is being uploaded
    Public List<OpportunityLineitem>  oppline{get;set;}
    Public List<Custom_Task__c>  cTask{get;set;}
    Public String  recId{get;set;}
    Public List<OpportunityLineitem>  oppline2{get;set;}
    Public String sortDirection = 'ASC';
    Public String sortExp = 'name';
    
    // Fullfillmet Task review
    Public List<Custom_Task__history> Acthistory{get;set;}
    
    
    // List of Assets to display
    Public List<Asset> Lass{get;set;} 
    
    public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

     public String getSortDirection()
     {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
        
       public void setSortDirection(String value)
         {  
           sortDirection = value;
         }
  
    
    public FulfillmentTaskReviewClass(ApexPages.StandardController controller) {
    theId = ApexPages.currentPage().getParameters().get('id'); // This gets the id from the page
    loadOpportunity(); // method called to query the opp based on 'theId'
    loadOpportunityLine();
    
    if (opp != null) // if the query does not return null
        {
        loadContactRoles();
        attachObj = new Attachment(); // Creates a new attachment for use on the page
        loadAttachments();
        }
        
        // Set Service group Delivery date to 1/1/2099
        //commenting as not needed
        /*
        For(OpportunityLineItem oppl : Oppline)
        {
          if(oppl.Product2.Type__c=='Services')
          {
             oppl.CPQ_Delivery_Date__c=date.newinstance(2099, 1, 1); 
           
          }
        }  
        */
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
                                                     c.Contact_Role__r.Contact__r.id,c.Contact_Role__c, c.Contact_Role__r.Contact__r.PS_Person_Id__c, c.Contact_Role__r.Contact__r.Email,
                                                     c.Contact_Role__r.Contact__r.MobilePhone,c.Contact_Role__r.Contact__r.MailingState,c.Contact_Role__r.Contact__r.MailingCountry,c.Contact_Role__r.Contact__r.MailingStreet,c.Contact_Role__r.Contact__r.MailingCity,c.Contact_Role__r.Contact__r.MailingPostalCode,c.Contact_Role__r.Contact__r.Phone,c.Contact_Role__r.Contact__r.NOV_isActive__c
                                              From Contact_Role_Selector__c c
                                              Where Opportunity__c =: opp.Id])
        {
          System.debug('NNN' + crc);
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
    
     // This method queries the opp based on 'theId'
    private void loadOpportunity()
    {
        try // To trap all errors 
        {
          // Query all fields needed to display on the VF page
            opp = [Select Id, Name,Owner.Email,CPQ_PO_Received__c, CPQ_PO_Validated__c, Billing_Contact__c, Billing_Contact__r.MailingStreet, CPQ_Consortium_Buying_Agreement__c,
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
        }
        catch (Queryexception qe) // Catches all query exceptions
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your opportunity was not found.')); // Adds message to the page
            //hasErrors = true; // Flips error flag to true
        }
    }
    //Load Opportunity Line item
    public void loadOpportunityLine()
    {    string sortFullExp = sortExpression  + ' ' + sortDirection;
            //sortFullExp ='Product2.Name ASC';
        try // To trap all errors 
        {    
          // Query all fields needed to display on the VF page
           
           
            oppline = Database.query(' Select id,Product2.Name,CPQ_Integrated_System__c,CPQ_Product_Status__c, CPQ_Delivery_Date__c,CPQ_Delivery_Status__c,Product2.Type__c, Product2.Product_Category__c,Product2.Product_Sub_Category__c,Store_combination__c,CPQ_Product_End_Date__c,CPQ_Product_Start_Date__c,PS_Product_ID__c,TotalPrice,Renewal_Unique_Line_ID__c,Product2id From Opportunitylineitem Where OpportunityId =: theId order by ' + sortFullExp  + ' limit 100');
            // Load Task
             cTask=[Select Name,Owner.Name,Priority__c,Status__c,Subject__c,Comments__c,Due_Date__c,Type__c,Store_combination__c,LastModifiedDate From Custom_Task__c Where Opportunity__c =: theId];
             //Load History
             Acthistory=[SELECT id,OldValue,NewValue,Field,Parentid,Parent.Name, Parent.LastModifiedById,Parent.LastModifiedBy.Name,Parent.LastModifiedDate FROM Custom_Task__history Where Parent.Opportunity__c=: theId]; 
             // Load Assets
             Lass=[Select id,Name,Status,CPQ_Net_Price__c,CPQ_Contract_Start_Date__c,CPQ_Contract_End_Date__c,CPQ_LineIdentifier__c,Product2id from Asset where Opportunity__c=:theId];
             
             oppline2 = [Select Id,Product2.Name,CPQ_Integrated_System__c,CPQ_Product_Status__c,
                          CPQ_Delivery_Date__c,CPQ_Delivery_Status__c,Product2.Type__c,
                          Product2.Product_Category__c,Product2.Product_Sub_Category__c,Store_combination__c
                   From Opportunitylineitem 
                    Where Store_combination__c =: recId AND OpportunityId =: theId ];
                  
        }
        catch (Queryexception qe) // Catches all query exceptions
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your opportunity was not found.')); // Adds message to the page
            //hasErrors = true; // Flips error flag to true
        }
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
    }
    //Override save method
    Public PageReference Save()
    { 
     Boolean Temp= True;
      try{
         for(OpportunityLineItem oppl :Oppline)
           {
             System.debug('TestDate' + oppl.CPQ_Delivery_Date__c +'TestStatus' + oppl.CPQ_Delivery_Status__c );
             if(oppl.CPQ_Delivery_Date__c ==Null  ||  oppl.CPQ_Delivery_Status__c==Null)
              {
                temp=false;
                Break;
              }
           }
        If(Temp== true)
        opp.Opportunity_Fulfilled__c=true;   
        else
        opp.Opportunity_Fulfilled__c=False; 
         
         Update Oppline;
         Update Opp;
         
       }
       catch(Dmlexception de){
          ApexPages.addMessages(de); // This will add the messages to the VF page
          return null;
       
       }
        PageReference OppPage = new PageReference('/' +  opp.Id);
        OppPage.setRedirect(true);
        oppline= Null;
        return OppPage;
        
    }
    //Override save method
    Public PageReference SendMail()
    {  
      String EmailStr=opp.Owner.Email;
      String Filteremail=opp.Owner.Email;
      
       
      List<Contact_Role_Selector__c> conrole= [select id,Contact_Email__c, Contact_Role__r.Contact__c from Contact_Role_Selector__c Where Opportunity__c= :theId];
      if(conrole.Size()>0)
      {
          Filteremail=Filteremail+conrole[0].Contact_Email__c;
      
          For(Contact_Role_Selector__c con: conrole)
          {
    
             if(!Filteremail.contains(con.Contact_Email__c))
             {
              EmailStr=EmailStr+';'+con.Contact_Email__c;
              Filteremail=Filteremail+con.Contact_Email__c;
             }
    
    
           }
     
      //List of opportunity Team member
     
      For(OpportunityTeamMember OTM :[select id,User.Email,Opportunityid from OpportunityTeamMember Where opportunityid =:theId ])
      {
             if(!Filteremail.contains(OTM.User.Email))
             {
              EmailStr=EmailStr+';'+OTM.User.Email;
              Filteremail=Filteremail+OTM.User.Email;
             }
      
      }
      EmailStr=EmailStr+';'+'ClientOperations@blackboard.com'+';'+'Elizabeth.Stalder@blackboard.com';
      
      PageReference OppPage = new PageReference('/email/author/emailauthor.jsp?retURL=/apex/FullfillmentTaskReview?id='+theId+'&p3_lkid='+theId+'&p2_lkid='+conrole[0].Contact_Role__r.Contact__c+'&p4='+EmailStr +'&p5=');
      OppPage.setRedirect(true);
      return OppPage;
      }
      else
      {
        // If no contact then show this below message
        ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.INFO,'There are not contacts');
        ApexPages.addMessage(errormsg);
        Return Null;
      }
      
 }  
    

}