public class ViewTasks{

    public ViewTasks() {

    }

   Private Id theId;
   Private Set<Id> proId = new set<id>();
   Private Id opId;
   Private String storeid;
   public Opportunity opp1 {get; set;} 
   Public List<OpportunityLineitem>  oppline{get;set;}
   Public List<Custom_Task__c > task ;
   Public List<Asset> Lass {get;set;}
   public Custom_Task__c opp {get; set;} 
   public list<Contact_Role_Selector__c> fullContactRoleList {get; private set;}

   public ViewTasks(ApexPages.StandardController con)
     {  //  SendEmail();
          theId = ApexPages.currentPage().getParameters().get('id');
          storeId =[Select Store_combination__c, Opportunity__c from Custom_Task__c where id=:theId  ].Store_combination__c;
          opId =[Select Store_combination__c, Opportunity__c from Custom_Task__c where id=:theId  ].Opportunity__c ;
          //storeId = (String)task.Store_combination__c;
          //oppId= task.Opportunity__c ;
          oppline = [Select Id,Product2Id, Product2.Name,CPQ_Integrated_System__c,CPQ_Product_Status__c,
                          CPQ_Delivery_Date__c,CPQ_Delivery_Status__c,Product2.Type__c,
                          Product2.Product_Category__c,Product2.Product_Sub_Category__c,Store_combination__c
                          From Opportunitylineitem where  Store_combination__c=: storeId and opportunityId =: opId ];
                          
        loadOpportunity();                   
        system.debug('Oppline--'+oppline.size() );
         for(Opportunitylineitem oli:oppline ){
              proId.add(oli.Product2Id);
              system.debug('ProductId--'+oli.Product2Id);
              
          }
          
          system.debug('ProductIdList--'+proId);
          
        
         // for(Id i : ProId)
          //{
              
               Lass   =[Select id,Name,Status,CPQ_Net_Price__c,CPQ_Contract_Start_Date__c,
                          CPQ_Contract_End_Date__c,CPQ_LineIdentifier__c,Product2id from Asset where Product2ID IN :proId and Opportunity__c=:opId];
                         
         //  }            
          
 fullContactRoleList = [Select c.Contact_Role__r.Contact_Role_Address__c, c.Contact_Role__r.Role__c, c.Contact_Role__r.Contact__c, 
                      c.Contact_Role__r.Contact__r.Name, c.Contact_Role__r.Contact__r.id,c.Contact_Role__c, 
                      c.Contact_Role__r.Contact__r.PS_Person_Id__c, c.Contact_Role__r.Contact__r.Email,
                      c.Contact_Role__r.Contact__r.MobilePhone,c.Contact_Role__r.Contact__r.MailingState,
                      c.Contact_Role__r.Contact__r.MailingCountry,c.Contact_Role__r.Contact__r.MailingStreet,c.Contact_Role__r.Contact__r.MailingCity,
                      c.Contact_Role__r.Contact__r.MailingPostalCode,c.Contact_Role__r.Contact__r.Phone,c.Contact_Role__r.Contact__r.NOV_isActive__c
                      From Contact_Role_Selector__c c Where Opportunity__c =: opId];
     
     }
     Public List<OpportunityLineitem>  getoppline()
     {
     return oppline; 
    }
    
    
    
      private void loadOpportunity()
    {
        
        try // To trap all errors 
        {
          // Query all fields needed to display on the VF page
            opp1 = [Select Id, Name,Owner.Email From Opportunity where id =: opId ];
        }
        catch (Queryexception qe) // Catches all query exceptions
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Your opportunity was not found.')); // Adds message to the page
            //hasErrors = true; // Flips error flag to true
        }
    }
    
    
    
    
    
    
     public PageReference SendMail()
    {  
      String EmailStr=opp1.Owner.Email;
      String Filteremail=opp1.Owner.Email;
      
       
      List<Contact_Role_Selector__c> conrole= [select id,Contact_Email__c, Contact_Role__r.Contact__c from Contact_Role_Selector__c Where Opportunity__c= :opId];
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
     
      For(OpportunityTeamMember OTM :[select id,User.Email,Opportunityid from OpportunityTeamMember Where opportunityid =:opId ])
      {
             if(!Filteremail.contains(OTM.User.Email))
             {
              EmailStr=EmailStr+';'+OTM.User.Email;
              Filteremail=Filteremail+OTM.User.Email;
             }
      
      }
      EmailStr=EmailStr+';'+'ClientOperations@blackboard.com'+';'+'Elizabeth.Stalder@blackboard.com';
      
      PageReference OppPage = new PageReference('/email/author/emailauthor.jsp?retURL=/apex/FullfillmentViewProducts?id='+theId+'&p3_lkid='+theId+'&p2_lkid='+conrole[0].Contact_Role__r.Contact__c+'&p4='+EmailStr +'&p5=');
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