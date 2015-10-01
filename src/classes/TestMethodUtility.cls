public with sharing class TestMethodUtility 
{
    public static Account createAccount()
    {
        Account a = new Account(
            Name = 'TestClass University',
            BillingCity = 'Vienna',
            BillingCountry = 'US',
            BillingPostalCode = '22066',
            BillingState = 'VA',
            BillingStreet = '123 Miller Road',
            Learn_Queue__c = 'Learn Primary Group');
        return a;
    }
    
    public static Contact createContact(Account a)
    {
        Contact c = new Contact(
            FirstName = 'SRVTEST_FIRSTNAME',
            LastName = 'SRVTEST_LASTNAME',
            Email = 'test@email.com',
            Account = a);
        return c;
    }
    
    public static Core_License__c createCoreLicense()
    {
        Core_License__c cl = new Core_License__c(
            Name = 'Learn');
        return cl;
    }
    
    public static Module__c createModule(Core_License__c cl)
    {
        Module__c m = new Module__c(
            Name = 'Test Module',
            Core_Licence__c = cl.Id);
        return m;
    }
    
    public static Asset createAsset(Account a, Core_License__c cl)
    {
        Asset aa = new Asset(
            Name = 'TestAsset',
            Core_License__c = cl.Id,
            Status = 'Installed',
            AccountId = a.Id,
            Version__c = '9.1 SPR10');
        return aa;
    }
    
    public static Case createCase(Contact con, Core_License__c cl, Account a, Module__c m)
    {
        Case c = new Case(
            ContactId = con.Id,
            AccountId = a.Id,
            Subject = 'subject',
            Description = 'description',
            Steps_to_Replicate__c = 'steps to replicate',
            Core_License__c = cl.Id,
            Module__c = m.Id,
            Status = 'New',
            Case_Severity__c = '1',
            Origin = 'Web');
        return c;
    }
    
    public static Case createCase1(Account a, Asset  s)
    {
        Case c = new Case(
            AccountId = a.Id,
            AssetId=s.id,
            Subject = 'subject',
            Description = 'description',
            Steps_to_Replicate__c = 'steps to replicate',
            Status = 'New',
            Case_Severity__c = '1',
            Origin = 'Web');
        return c;
    }
    
    public static learnJIRA__c createSupportIncident(Case c)
    {
        learnJIRA__c lj = new learnJIRA__c(
            Name = 'Test',
            Origin_Case_Number__c = c.CaseNumber,
            OriginCaseID__c = c.Id,
            Summary__c = 'Test Summary',
            Status__c = 'New');
        return lj;
    }
    
    public static Related_Bug__c createRelatedBug(learnJIRA__c lj)
    {
        Related_Bug__c rb = new Related_Bug__c(
            Name = 'Test Version',
            Support_Incident__c = lj.Id);
        return rb;
    }
    
    public static Patch_Request__c createPatchRequest(learnJIRA__c lj)
    {
        Patch_Request__c p = new Patch_Request__c(
            Name = 'Test Version',
            Support_Incident__c = lj.Id);
        return p;
    }
    
    public static Case_Support_Incident__c createCaseSupportIncident(Case c, learnJIRA__c lj)
    {
        Case_Support_Incident__c csi = new Case_Support_Incident__c(
            Case__c = c.Id,
            Support_Incident__c = lj.Id);
        return csi;
    }
    
    public static learnJIRANote__c createSupportIncidentNote(learnJIRA__c lj)
    {
        learnJIRANote__c ljn = new learnJIRANote__c(
            Support_Incident__c = lj.Id,
            Details__c = 'Test',
            Details_HTML__c = 'Test',
            Title__c = 'Test Title');
        return ljn;
    }
    
    public static User createUser(Profile p)
    {
        Double d = Math.random() * 1000000;
        String email = 'test' + d.intValue() + '@blackboard.com';
        
        User u = new User(alias = 'standt', email = email, emailencodingkey = 'UTF-8', lastname = 'Testing', 
            languagelocalekey = 'en_US',localesidkey ='en_US', profileid = p.Id,timezonesidkey = 'America/Los_Angeles', 
            username = email, Integration_User__c = false);
        return u;
    }
    
    public static CR_Approver_Group__c createApproverGroup()
    {
        CR_Approver_Group__c cag = new CR_Approver_Group__c(Name = 'Test Group');
        return cag;
    }
  
    public static CR_Approver_Group_Member__c createApproverGroupMember(CR_Approver_Group__c cag, User u)
    {
        CR_Approver_Group_Member__c cagm = new CR_Approver_Group_Member__c(CR_Approver_Group__c = cag.Id, User__c = u.Id, Type__c = 'Primary Approver');
        return cagm;
    }
  
    public static Salesforce_Object__c createSObject()
    {
        Salesforce_Object__c so = new Salesforce_Object__c(Name = 'Test Object');
        return so;
    }
  
    public static Salesforce_Object_Approver__c createSObjectApprover(Salesforce_Object__c so, CR_Approver_Group__c cag)
    {
        Salesforce_Object_Approver__c soa = new Salesforce_Object_Approver__c(Salesforce_Object__c = so.Id, CR_Approver_Group__c = cag.Id);
        return soa;
    }
  
    public static Change_Request__c createChangeRequest(Salesforce_Object__c so)
    {
        Change_Request__c cr = new Change_Request__c(Description__c = 'Test Description', Impact__c = '2', 
            Urgency__c = '2', Salesforce_Object__c = so.Id);
        return cr;
    } 
   public static Functional_Area__c createFunctionalArea(Module__c m)
    {
    Functional_Area__c fa = new Functional_Area__c(Name='test funtion' ,Module__c=m.id);
    return fa;
    }
    public static Category__c createCategory(Functional_Area__c fa)
    {
    Category__c cg = new Category__c(Name='test catergory' ,Functional_Area__c=fa.id);
    return cg;
    }
   public static  Contact_Role__c createContactRole(Account acc)
    {
    Contact_Role__c conr = new Contact_Role__c(Account__c=acc.id);
    return conr;
    } 
   Public Static Amazon_Credentials__c createAmazonCredentials()
   {
   Amazon_Credentials__c ama = new Amazon_Credentials__c(Name='Amazon Connection');
   return ama;
   } 
   Public Static Solution Createsolution()
   {
   Solution sol = new solution(SolutionName='Test Solution');
   return sol;
   }
   Public Static KB_Internal_Article_Link__c CreateInternalArticlelink()
   {
   KB_Internal_Article_Link__c intartlink = new KB_Internal_Article_Link__c(IsRunFromTestClass__c=True);
   
   return  intartlink;
   } 
   Public static Case_Attachment__c CreateAttachment()
   {
    Case_Attachment__c cattach = new Case_Attachment__c();
    
    return cattach;
    }
  Public Static Template__c CreateTemplate()
  {
  Template__c Tem = new Template__c(Name='Test Template');
  return Tem;
  }
  Public static User_Lookup__c CreateLookupUser(User u)
   {
   User_Lookup__c Lu = new User_Lookup__c(User__c=u.id);
   return Lu;
   }
   
   Public Static  Responsiveness__c CreateResponsive(case c)
   {
   Responsiveness__c res = new Responsiveness__c(Case__c=c.id);
   return res;
  } 
  Public Static Case_Note__c CreateCaseNote(Case c)
  {
   Case_Note__c cn = new Case_Note__c(Case__c=c.id,Type__c='Test Type');
   return  cn;
  } 
  Public static Chirp_Ticket__c CreateChripTicket()
   {
   Chirp_Ticket__c cht = new Chirp_Ticket__c(subject__c='Subject');
   return cht;
   }
   Public static Solution_Detail__c CreateSolutionDetail()
   {
   Solution_Detail__c sdet = new Solution_Detail__c();
   return sdet;
   }
   
    public static Product2 createProduct()
    {
        Product2 p = new Product2(Name = 'Test Product', ProductCode = 'Test Code');
        return p;
    }
    
    public static PricebookEntry createPricebookEntry(Pricebook2 pb, Product2 p)
    {
        PricebookEntry pe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p.Id, UnitPrice = 2, IsActive = true);
        return pe;
    }
    
    public static Opportunity createOpportunity(Account a, Pricebook2 pb)
    {
        Opportunity o = new Opportunity(Name = 'Test Opportunity', CloseDate = system.now().date(), Pricebook2Id = pb.Id, 
            StageName = '(S) Suspect Qualification', AccountId = a.Id);
        return o;
    }
    
    public static Contact_Role_Selector__c createContactRoleSelector(Contact_Role__c cr)
    {
        Contact_Role_Selector__c crs = new Contact_Role_Selector__c(Contact_Role__c = cr.Id);
        return crs;
    }
    
    Public Static  Survey__c CreateSurvey()
    {
    Survey__c s = new Survey__c();
    s.Name = 'Testing Survey';
    s.Submit_Response__c = 'empty'; 
    Return s;
    }
    Public static Univs__c createUnivs(Account ac)
    {
        
        Univs__c uns = new Univs__c(Name='Test data',Account__c=ac.id);
        
        return uns;
        
        
    }  
    
    Public Static CameleonCPQ__Quote__c CreateCameleonQuote()
    {
    
    CameleonCPQ__Quote__c  CamQuote = New CameleonCPQ__Quote__c(Name='Test Class');
    
    Return CamQuote;
    }
    Public Static SLA_Information__c CreateSLAInformation()
    {
    SLA_Information__c SlaInfo = New SLA_Information__c();
    return SlaInfo; 
    
    }
    
    Public Static ChatCase__c CreatechatCase()
    {
     
     ChatCase__c chatcase = New ChatCase__c();
     return chatcase;
    }
    Public Static EndUser__c CreateEndUser()
    {
    
     EndUser__c Endusr= New EndUser__c(Name='Test User');
     return Endusr;
    
    }
    
    // Create pricebook
    Public Static Pricebook2 CreatePricebook()
    {
    
     Pricebook2 Pri= New Pricebook2(Name='Test Pricebook',IsActive=true,Description='Test Descrption');
     return Pri;
    
    }
     
}