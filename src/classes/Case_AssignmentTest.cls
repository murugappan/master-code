@isTest(SeeAllData=false)
Private class Case_AssignmentTest{

static testmethod void CaseAssigntest(){

  List<Account> accountlist = new List<Account>();
  List<Core_License__c> crlist = new List<Core_License__c>();
  List<Asset> assetlist = new List<Asset>();
  List<Case> caselist = new List<Case>();
  List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information');
  Profile p = [select Id, Name from Profile where Name='SRV - System Administrator' limit 1];
  
  User u =TestMethodUtility.createUser(p);
  u.IsActive = true;
  Insert u;
  
  User u1 =TestMethodUtility.createUser(p);
  u1.Primary_Group__c=u.id;
  u1.IsActive = true;
  Insert u1;
  
  
  Account a1=TestMethodUtility.createAccount();
  a1.Learn_Queue__c = 'ANGEL - K12/Corp Engagement Team';
  a1.Angel_Queue__c = 'ANGEL - K12/Corp Engagement Team';
  a1.Learn_Hosted_Queue__c='ANGEL - K12/Corp Engagement Team';
  a1.Transact_Queue__c = 'Transact - Unix - Harco - Level 1'; 
  a1.Xythos_Queue__c = 'Xythos';
 // a1.Complex_Hosting__c=True;
  a1.CE_Vista_Queue__c='CE/Vista - L1 - Managed Hosting';
  a1.CE_Vista_Hosted__c='CE/Vista - L2 - Managed Hosting';
  accountlist.add(a1);
  
  Account a2=TestMethodUtility.createAccount();
  a2.Learn_Queue__c = 'ANGEL - South/West Engagement Team';
  a2.Angel_Queue__c = 'ANGEL - South/West Engagement Team';
  a2.Learn_Hosted_Queue__c='ANGEL - South/West Engagement Team';
  a2.Transact_Queue__c = 'Transact - Unix - Harco - Level 1'; 
  a2.Xythos_Queue__c = 'Xythos';
  a2.CE_Vista_Queue__c = 'CE/Vista - L2 - Managed Hosting';
  accountlist.add(a2);
  
  Account a3=TestMethodUtility.createAccount();
  a3.Learn_Queue__c = 'Learn - L1 - EMEA';
  a3.Angel_Queue__c = 'ANGEL - Managed Hosting';
  a3.Learn_Hosted_Queue__c='Learn - L1 - Managed Hosting';
  a3.Transact_Queue__c = 'Transact - Unix - Harco - Level 1'; 
  a3.Xythos_Queue__c = 'Xythos';
  a3.CE_Vista_Queue__c = 'CE/Vista - L2 - Managed Hosting';
  a3.PS_Company_Id__c ='101198';
  a3.Type='Partner';
  accountlist.add(a3);
  
  Account a4=TestMethodUtility.createAccount();
  a4.Learn_Queue__c = 'Learn - L1 - EMEA';
  a4.Angel_Queue__c = 'ANGEL - Managed Hosting';
  a4.Learn_Hosted_Queue__c='Learn - L1 - Managed Hosting';
  a4.Transact_Queue__c = 'Transact - Unix - Harco - Level 1'; 
  a4.Xythos_Queue__c = 'Xythos';
  a4.CE_Vista_Queue__c = 'CE/Vista - L2 - Managed Hosting';
  a4.PS_Company_Id__c ='332018';
  a4.Type='Partner';
  accountlist.add(a4);
  
  Account a5=TestMethodUtility.createAccount();
  a5.Learn_Queue__c = 'EMEA Queue';
  a5.Angel_Queue__c = 'Testing';
  a5.Learn_Hosted_Queue__c='ANGEL - Software Solutions';
  a5.Transact_Queue__c = 'Testing'; 
  a5.CE_Vista_Queue__c='Testing';
  a5.CE_Vista_Hosted__c='Testing';
  a5.Complex_Hosting__c=True;
  accountlist.add(a5);
  
  Account a6=TestMethodUtility.createAccount();
  a6.Learn_Queue__c = 'EMEA Queue';
  a6.Angel_Queue__c = 'EMEA Queue';
  a6.Learn_Hosted_Queue__c='EMEA Queue';
  a6.Transact_Queue__c = 'Transact - Transition'; 
  accountlist.add(a6);
  
  Account a7=TestMethodUtility.createAccount();
  a7.Learn_Queue__c = 'Learn - L1 - ANZSEA';
  a7.Angel_Queue__c = 'Learn - L1 - ANZSEA';
  a7.Learn_Hosted_Queue__c='Learn - L1 - ANZSEA';
  a7.Transact_Queue__c = 'Transact - Transition'; 
  accountlist.add(a7);
  
  Account a8=TestMethodUtility.createAccount();
  a8.Learn_Queue__c = 'Learn - L1';
  a8.Angel_Queue__c = 'Learn - L1';
  a8.Learn_Hosted_Queue__c='Learn - L1';
  a8.Transact_Queue__c = 'Transact - Transition'; 
  accountlist.add(a8);

  
  Insert accountlist;
  
   Contact c = TestMethodUtility.createContact(a1);
    c.FirstName = 'Test';
    c.LastName = 'Contact';
    c.Email = 'test@test.com';
    insert c;
  
   Set<ID> aID = new Set<ID>();
    for(Account a111 : accountlist){
        aID.add(a111.ID);
    }
    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'ANGEL';
    crlist.add(cr);

    Core_License__c cr1 = new  Core_License__c();
    cr1.Name = 'Learn';
    crlist.add(cr1);

    Core_License__c cr2 = new  Core_License__c();
    cr2.Name = 'Transact';
    crlist.add(cr2);

    Core_License__c cr3 = new  Core_License__c();
    cr3.Name = 'Xythos';
    crlist.add(cr3);

    Core_License__c cr4 = new  Core_License__c();
    cr4.Name = 'CE/Vista';
    crlist.add(cr4);


    insert crlist; 
    
    
  // below two asset(ie aset ,aset1) has been used for Angel  
    Asset aset = TestMethodUtility.createAsset(a1,cr);
    aset.Name = 'Test Asset 111';
    aset.Managed_Hosting__c = 'ANGEL - Managed Hosting';
    aset.Installed_Product_ID__c = '123';
    assetlist.add(aset);  
    
    Asset aset1 = TestMethodUtility.createAsset(a1,cr);
    aset1.Name = 'Test Asset 111';
    aset1.Installed_Product_ID__c = '133';
    assetlist.add(aset1);  
  //below  asset is for Transect
    Asset aset2 = TestMethodUtility.createAsset(a1,cr2);
    aset2.Name = 'Test Asset 111';
    aset2.Installed_Product_ID__c = '143';
    assetlist.add(aset2);   
   //below asset for Learn
    Asset aset3 = TestMethodUtility.createAsset(a1,cr1);
    aset3.Name = 'Test Asset 111';
    aset3.Installed_Product_ID__c = '153';
    assetlist.add(aset3);   
    
    Asset aset4 = TestMethodUtility.createAsset(a1,cr1);
    aset4.Name = 'Test Asset 111';
    aset4.Installed_Product_ID__c = '163';
    aset4.Managed_Hosting__c ='Learn - Managed Hosting';
    assetlist.add(aset4);  
    
    Asset aset7 = TestMethodUtility.createAsset(a1,cr1);
    aset7.Name = 'Test Asset 111';
    aset7.Installed_Product_ID__c = '193';
   assetlist.add(aset7);  
     
  //below asset for Xythos
    Asset aset5 = TestMethodUtility.createAsset(a1,cr3);
    aset5.Name = 'Test Asset 111';
    aset5.Installed_Product_ID__c = '173';
    assetlist.add(aset5);  
    
   //below asset for CE
    Asset aset6 = TestMethodUtility.createAsset(a1,cr4);
    aset6.Name = 'Test Asset 111';
    aset6.Installed_Product_ID__c = '183';
    aset6.Managed_Hosting__c ='Learn - Managed Hosting';
    assetlist.add(aset6);


    
    Insert assetlist;
  
    Module__c m1 = TestMethodUtility.createModule(cr4);
    m1.Name = 'Managed Hosting Request';
    insert m1;
    
    
    Module__c m2 = TestMethodUtility.createModule(cr4);
    m2.Name = 'ICM Support';
    insert m2;
    
    
    Module__c m3 = TestMethodUtility.createModule(cr4);
    m3.Name = 'Server/System Administration';
    insert m3;

    Functional_Area__c f = TestMethodUtility.createFunctionalArea(m3);
    f.Name = 'Security';
    insert f;
    
    Functional_Area__c f1 = TestMethodUtility.createFunctionalArea(m3);
    f1.Name = 'License Key Request';
    insert f1;

    Functional_Area__c f2 = TestMethodUtility.createFunctionalArea(m3);
    f2.Name = 'Production Inaccessible';
    insert f2;

  
  // below cases is for Angel 
    Case cas = TestMethodUtility.createCase1(a3,aset);
    cas.Case_severity__c =  '1';
    cas.Status = 'New';
    caselist.add(cas);
    
    Case cas1 =TestMethodUtility.createCase1(a3,aset1);
    cas1.Case_severity__c =  '1';
    cas1.Status = 'New';
    caselist.add(cas1);
    
    Case cas2 = TestMethodUtility.createCase1(a4,aset1);
    cas2.Case_severity__c =  '1';
    cas2.Status = 'New';
    caselist.add(cas2);
    
    Case cas3 = TestMethodUtility.createCase1(a1,aset1);
    cas3.Case_severity__c = '3';
    cas3.Status = 'New';
    caselist.add(cas3);
    
    Case cas4= TestMethodUtility.createCase1(a2,aset1);
    cas4.Case_severity__c = '3';
    cas4.Status = 'New';
    caselist.add(cas4);
    
    Case cas5= TestMethodUtility.createCase1(a5,aset1);
    cas5.Case_severity__c = '3';
    cas5.Status = 'New';
    caselist.add(cas5);
    
    Case cas51= TestMethodUtility.createCase1(a5,aset1);
    cas51.Case_severity__c = '3';
    cas51.Status = 'New';
    caselist.add(cas51);
  // below cases are for Transect
    Case cas6=TestMethodUtility.createCase1(a1,aset2);
    cas6.Case_severity__c = '3';
    cas6.Status = 'New';
    caselist.add(cas6);
    
    Case cas61= TestMethodUtility.createCase1(a5,aset2);
    cas61.Case_severity__c = '3';
    cas61.Status = 'New';
    caselist.add(cas61);
 
 //below case is for Learn
    Case cas7= TestMethodUtility.createCase1(a5,aset3);
    cas7.Case_severity__c = '3';
    cas7.Status = 'New';
    caselist.add(cas7);
    
    Case cas8= TestMethodUtility.createCase1(a2,aset4);
    cas8.ContactId=c.id;
    cas8.Case_severity__c = '3';
    cas8.Status = 'New';
    caselist.add(cas8);
    
    Case cas13= TestMethodUtility.createCase1(a1,aset4);
    cas13.ContactId=c.id;
    cas13.Case_severity__c = '3';
    cas13.Status = 'New';
    caselist.add(cas13);
  
  //below case for Xythos  
    Case cas9=TestMethodUtility.createCase1(a2,aset5);
    cas9.Case_severity__c = '1';
    cas9.Status = 'New';
    caselist.add(cas9);
    
    Case cas10=TestMethodUtility.createCase1(a2,aset5);
    cas10.Case_severity__c = '3';
    cas10.Status = 'New';
    caselist.add(cas10);
   // below case for CE 
    
    Case cas11= TestMethodUtility.createCase1(a1,aset6);
    cas11.Case_severity__c = '3';
    cas11.Status = 'New';
    cas11.Module__c=m3.id;
    cas11.Functional_Area__c=f.id;
    caselist.add(cas11);
    
    Case cas111= TestMethodUtility.createCase1(a5,aset6);
    cas111.Case_severity__c = '3';
    cas111.Status = 'New';
    caselist.add(cas111);
    
    Case cas12= TestMethodUtility.createCase1(a1,aset6);
    cas12.Case_severity__c = '1';
    cas12.Status = 'New';
    caselist.add(cas12);
    
    Case cas14= TestMethodUtility.createCase1(a1,aset7);
    cas14.contactId=c.id;
    cas14.Case_severity__c = '3';
    cas14.Status = 'New';
    cas14.Module__c=m3.id;
    cas14.Functional_Area__c=f1.id;
    caselist.add(cas14);
    
    Case cas15= TestMethodUtility.createCase1(a6,aset7);
    cas15.contactId=c.id;
    cas15.Case_severity__c = '2';
    cas15.Status = 'New';
    cas15.Module__c=m2.id;
    caselist.add(cas15);
    
    Case cas16= TestMethodUtility.createCase1(a1,aset4);
    cas16.Case_severity__c = '1';
    cas16.Status = 'New';
    cas16.Module__c=m1.id;
    cas16.Functional_Area__c=f2.id;
    caselist.add(cas16);
    
    
    Case cas17=TestMethodUtility.createCase1(a7,aset7);
    cas17.Case_severity__c = '1';
    cas17.Status = 'New';
    caselist.add(cas17);
    
    Case cas18= TestMethodUtility.createCase1(a8,aset7);
    cas18.Case_severity__c = '1';
    cas18.Status = 'New';
    caselist.add(cas18);

    
    
    Insert caselist;
    
    Set<ID> casID = new Set<ID>();
    for(Case c111 : caselist){
        casID.add(c111.ID);
    }
    
   List<case> caselist1 = [select ID,Category__c,Asset_Database__c,Functional_Area_Name__c,Module_Name__c,Account_Complex_Hosting__c,AccountID,Managed_Hosting__c,RecordTypeID,OwnerID,Invoke_Premium_Support__c,Account_Name__c,Contact_Name__c,Description,Contact_Email__c,Primary_Group_Name__c,Case_Severity__c,CaseNumber,Status,Case_record__c,Account_Id__c,core_license__c from Case where ID IN: casID];
    Case_Assignment ca = new Case_Assignment();

    Test.StartTest();
    ca.changeowner(caselist1,aID);
    
    for(Case cc : caselist1)
    ca.normalassign(cc,a1);
    for(Case cc : caselist1)
    ca.normalhostingassign(cc,a1);
    for(Case cc : caselist1)
    ca.FTShosting(cc,a1);
    Test.StopTest();
   }
   @isTest(SeeAllData=false)
   static  void CaseAssigntest1(){
   
     List<Account> accountlist = new List<Account>();
     List<Core_License__c> crlist = new List<Core_License__c>();
     List<Asset> assetlist = new List<Asset>();
     List<Case> caselist = new List<Case>();
  List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information');
    Profile p = [select Id, Name from Profile where Name='SRV - Support Tech' limit 1];
  
    User u =TestMethodUtility.createUser(p);
    u.IsActive = true;
    Insert u;
  
    User u1 =TestMethodUtility.createUser(p);
    u1.Primary_Group__c=u.id;
    u1.IsActive = true;
    Insert u1;
     
    Account a1=TestMethodUtility.createAccount();
    a1.Collaborate_Queue__c  = 'Collaborate: Technical Services';
    accountlist.add(a1);
    
    Account a2=TestMethodUtility.createAccount();
    a2.Collaborate_Queue__c  = 'Collaborate: Orders Fulfillment';
    accountlist.add(a2);
    
    Account a3=TestMethodUtility.createAccount();
    a3.Collaborate_Queue__c  = 'Collaborate: Tier 2 Support';
    accountlist.add(a3);   
    
    Insert accountlist;
    
    Contact c = TestMethodUtility.createContact(a1);
    c.FirstName = 'Test';
    c.LastName = 'Contact';
    c.Email = 'test@test.com';
    insert c;
    
    Contact c1 = TestMethodUtility.createContact(a2);
    c1.FirstName = 'Test1';
    c1.LastName = 'Contact1';
    c1.Email = 'test@test1.com';
    insert c1;
    
    Contact c2 = TestMethodUtility.createContact(a3);
    c2.FirstName = 'Test3';
    c2.LastName = 'Contact3';
    c2.Email = 'test@test3.com';
    insert c2;
    
    Set<ID> aID = new Set<ID>();
    for(Account a111 : accountlist){
        aID.add(a111.ID);
    }
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'Collaborate';
    crlist.add(cr);
    
    insert crlist;
    
    Asset aset = TestMethodUtility.createAsset(a1,cr);
    aset.Name = 'Test Asset 111';
    aset.Installed_Product_ID__c = '203';
    assetlist.add(aset); 
    
    Insert assetlist;
    
    Module__c m1 = TestMethodUtility.createModule(cr);
    m1.Name = 'Technical Services Request (ICM)';
    insert m1;
    
    Module__c m2 = TestMethodUtility.createModule(cr);
    m2.Name = 'Request Upgrade';
    insert m2;
    
    Module__c m3 = TestMethodUtility.createModule(cr);
    m3.Name = 'Large Event Request';
    insert m3;
    
    Module__c m4 = TestMethodUtility.createModule(cr);
    m4.Name = 'Test';
    insert m4;
    
    Functional_Area__c f = TestMethodUtility.createFunctionalArea(m4);
    f.Name = 'Security';
    insert f;
    
    Category__c ctr = TestMethodUtility.createCategory(f);
    ctr.Name='Request integration credentials'; 
    ctr.Functional_Area__c = f.id;
    insert ctr;
    
    
   Test.StartTest();
   system.runas(u1){   
    Case cas1= TestMethodUtility.createCase1(a1,aset);
    cas1.Case_severity__c = '3';
    cas1.Module__c = m1.id; 
    cas1.Status = 'New';
    insert cas1;
    } 
    system.runas(u1){
    Case cas2= TestMethodUtility.createCase1(a2,aset);
    cas2.Case_severity__c = '3';
    cas2.Status = 'New';
    cas2.Module__c = m2.id;
    insert cas2;
    }
    Test.StopTest();
    system.runas(u1){
    Case cas3= TestMethodUtility.createCase1(a3,aset);
    cas3.Case_severity__c = '3';
    cas3.Status = 'New';
    cas3.Module__c = m3.id;
    insert cas3;
    }
    system.runas(u1){
    case cas4 = TestMethodUtility.createCase1(a2,aset);
    cas4.Case_severity__c = '3';
    cas4.Status = 'New';
    cas4.Module__c = m4.id;
    cas4.Category__c = ctr.id;
    insert cas4; 
    }
   }
   static testmethod void CaseAssigntest2(){
    
    List<Account> accountlist = new List<Account>();
    List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
    Profile p = [select Id, Name from Profile where Name='SRV - Support Tech' limit 1];
  
    User u =TestMethodUtility.createUser(p);
    u.IsActive = true;
    Insert u;
  
    User u1 =TestMethodUtility.createUser(p);
    u1.Primary_Group__c=u.id;
    u1.IsActive = true;
    Insert u1;
    
    
    
    Account a1=TestMethodUtility.createAccount();
    a1.Collaborate_Queue__c  = 'Collaborate: Tier 2 Support';
    accountlist.add(a1);
    
    Account a2=TestMethodUtility.createAccount();
    a2.Collaborate_Queue__c  = 'Collaborate: Tier 1 Support';
    accountlist.add(a2);
    
    Insert accountlist;
    
     Set<ID> aID = new Set<ID>();
    for(Account a111 : accountlist){
        aID.add(a111.ID);
        
 
    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'Collaborate';
    insert cr;
    
    Module__c m1 = TestMethodUtility.createModule(cr);
    m1.Name = 'Large Event Request';
    insert m1;
    
    String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Collaborate End User Open'].Id;
    
    system.runas(u1){ 
      
    Case c = new Case(AccountId = a1.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id,Module__c = m1.Id,Status = 'New',Case_Severity__c = '3',Origin = 'Web',RecordTypeId=strRecordTypeId);   
    insert c;
    }
    
    
   }
  }
  static testmethod void CaseAssigntest3(){
    
    List<Account> accountlist = new List<Account>();
    List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
    Profile p = [select Id, Name from Profile where Name='SRV - Support Tech' limit 1];
  
    User u =TestMethodUtility.createUser(p);
    u.IsActive = true;
    Insert u;
  
    User u1 =TestMethodUtility.createUser(p);
    u1.Primary_Group__c=u.id;
    u1.IsActive = true;
    Insert u1;
    
    Account a2=TestMethodUtility.createAccount();
    a2.Collaborate_Queue__c  = 'Collaborate: Tier 1 Support';
    
    Insert a2;
    
    Core_License__c cr = new  Core_License__c();
    cr.Name = 'Collaborate';
    insert cr;
    
    Module__c m1 = TestMethodUtility.createModule(cr);
    m1.Name = 'test';
    insert m1;
    
    String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Case' and Name = 'Collaborate End User Open'].Id;
    system.runas(u1){ 
      
    Case c = new Case(AccountId = a2.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id,Module__c = m1.Id,Status = 'New',Case_Severity__c = '3',Origin = 'Web',RecordTypeId=strRecordTypeId);   
    insert c;
    }
    
    
   }
    
    static testmethod void UnitTestAnalyticsPositiveScenario(){
     user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information');
     system.runAs(sysuser){
    
      List<Account> accountlist = new List<Account>();
     
      Profile p = [select Id, Name from Profile where Name='SRV - Support Tech' limit 1];
    
      User u =TestMethodUtility.createUser(p);
      u.IsActive = true;
      Insert u;
    
      User u1 =TestMethodUtility.createUser(p);
      u1.Primary_Group__c=u.id;
      u1.IsActive = true;
      Insert u1;
      
      
      
      Account a1=TestMethodUtility.createAccount();
      a1.Collaborate_Queue__c  = 'Analytics: L1';
      accountlist.add(a1);
      
      Account a2=TestMethodUtility.createAccount();
      a2.Collaborate_Queue__c  = 'Analytics: L2';
      accountlist.add(a2);
      
      Insert accountlist;

      Contact cont= new Contact ();
      cont.AccountId=a1.id;
      cont.Account=a1;
      cont.LastName='abc';
      insert cont;


      
      
       Set<ID> aID = new Set<ID>();
      for(Account a111 : accountlist){
          aID.add(a111.ID);
          
   
      
      Core_License__c cr = new  Core_License__c();
      cr.Name = 'Analytics';
      insert cr;

      Asset a=new Asset();
      a.Name='abc';
      a.Core_License__c=cr.id;
      a.AccountId=a1.id;
      a.Contact=cont;
      a.Account=a1;
      insert a;
      
      Module__c m1 = TestMethodUtility.createModule(cr);
      m1.Name = 'Large Event Request';
      insert m1;

      
           
      system.runas(u1){ 
        

        Case cs=new Case();
      cs.Status='new' ;
      cs.Description='this case has to be resolved';
      //cs.Product_Group__c='abc';
      //cs.Asset='FIN AID IMPL PS 30K+';
      cs.Type='abc';cs.Subject='abc';
      cs.Case_Severity__c='sev 1';
      cs.AccountId=a1.id;
      cs.Contact=cont;
      cs.AssetID=a.ID;
      cs.Module__c=m1.id;
      insert cs;
       
      Case_Assignment ca = new Case_Assignment();  
      
      }
      
      
     }
       
     }  
   } 
   
   @testSetup

   public static void DataSetup()
   {
     
     List<Account> accountlist = new List<Account>();
     List<Asset> assetlist = new List<Asset>();
     List<Core_License__c> corelicenselist = new List<Core_License__c>();

     Profile p = [select Id, Name from Profile where Name='SRV - System Administrator' limit 1];

     User u =TestMethodUtility.createUser(p);
     u.IsActive = true;
     Insert u;
  
     User u1 =TestMethodUtility.createUser(p);
     u1.Primary_Group__c = 'Learn - L1 - Managed Hosting - Complex' ;
     u1.IsActive = true;
     u1.username='casetest@test.com';
     Insert u1;
      
     Account ac = TestMethodUtility.createAccount();
     ac.Learn_SaaS_Queue__c = 'Learn - L1';
     ac.Learn_Complex_Queue__c = 'Learn - L1 - Managed Hosting - Complex';
     ac.Moodlerooms_Queue__c = 'Moodlerooms: EMEA';
     ac.Complex_Hosting__c = True;
     accountlist.add(ac);
     
     Account ac1 = TestMethodUtility.createAccount();
     ac1.Learn_SaaS_Queue__c = 'Learn - L1 - LAC';
     accountlist.add(ac1);

     Account ac2 = TestMethodUtility.createAccount();
     ac2.Name = 'test account for saas';
     ac2.Learn_Complex_Queue__c = u1.Id;
     ac.Complex_Hosting__c = True;
     accountlist.add(ac2);

     insert accountlist;

     Contact c = TestMethodUtility.createContact(ac);
     c.FirstName = 'Test';
     c.LastName = 'Contact';
     c.PS_Person_Id__c='555666';
     c.Email = 'test@test.com';
     insert c;
     
     core_license__c cr = new Core_License__c();
     cr.Name = 'Learn';
     cr.Product__c = 'Learn SAAS';
     corelicenselist.add(cr);

     core_license__c cr1 = new Core_License__c();
     cr1.Name = 'Moodlerooms';
     corelicenselist.add(cr1);

     insert corelicenselist;

     Asset a = new Asset();
     a.Core_License__c = cr.Id;
     a.AccountId = ac.ID;
     a.name = 'SAAStest';
     a.Managed_Hosting__c = 'Learn - SaaS';
     assetlist.add(a);

     Asset Learnsaasasset = new Asset();
     Learnsaasasset.Core_License__c = cr.Id;
     Learnsaasasset.AccountId = ac1.ID;
     Learnsaasasset.name = 'SAAStest1';
     Learnsaasasset.Managed_Hosting__c = 'Learn - SaaS';
     assetlist.add(Learnsaasasset);

     Asset Learnsaasasset1 = new Asset();
     Learnsaasasset1.Core_License__c = cr.Id;
     Learnsaasasset1.AccountId = ac2.ID;
     Learnsaasasset1.name = 'SAAStest2';
     Learnsaasasset1.Managed_Hosting__c = 'Learn - SaaS';
     assetlist.add(Learnsaasasset1);

     Asset Moodleroomsasset = new Asset();
     Moodleroomsasset.Core_License__c = cr1.Id;
     Moodleroomsasset.AccountId = ac.ID;
     Moodleroomsasset.name = 'testmoodleroomsasset';
     assetlist.add(Moodleroomsasset); 

     insert assetlist;
   }

   static testmethod void UnitTestLearnSAASPositiveScenario()
   {
    
    List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
    user u1 = [select id from user where username='casetest@test.com' limit 1];
    contact c = [select id from contact where PS_Person_Id__c='555666' ];
    account complexhostingaccount = [select id from account where Learn_SaaS_Queue__c = 'Learn - L1' ];
    account Saasaccount = [select id from account where Learn_SaaS_Queue__c = 'Learn - L1 - LAC' ];
    asset a = [select id,Core_License__c from asset where name = 'SAAStest' limit 1];
    asset a1 = [select id,Core_License__c from asset where name = 'SAAStest1' limit 1];
    
    id learnrecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('Learn').getRecordTypeId();
    system.RunAs(u1)
    { 
      test.starttest();
      case ca = new case();
      ca.AccountId = complexhostingaccount.ID;
      ca.Contactid = c.id;
      ca.Status = 'new';
      ca.assetid = a.ID;
      ca.subject = 'test';
      ca.Description = 'test';
      ca.Case_Severity__c='3';
      ca.recordtypeid = learnrecordtypeid;
      ca.Core_License__c=a.Core_License__c;
      insert ca;

      case cs=[select id,owner.name,case_record__c,Core_License__c from case where id=:ca.id];
      system.debug('@@@@@@@'+ cs.case_record__c+'--'+cs.Core_License__c);

      case saascase = new case();
      saascase.AccountId = Saasaccount.ID;
      saascase.Contactid = c.id;
      saascase.Status = 'new';
      saascase.assetid = a1.ID;
      saascase.subject = 'test';
      saascase.Description = 'test';
      saascase.Case_Severity__c='3';
      saascase.recordtypeid = learnrecordtypeid;
      saascase.Core_License__c=a.Core_License__c;
      insert saascase;
      test.stoptest();

      case saassev1case = new case();
      saassev1case.AccountId = Saasaccount.ID;
      saassev1case.Contactid = c.id;
      saassev1case.Status = 'new';
      saassev1case.assetid = a1.ID;
      saassev1case.subject = 'test';
      saassev1case.Description = 'test';
      saassev1case.Case_Severity__c='1';
      saassev1case.recordtypeid = learnrecordtypeid;
      saassev1case.Core_License__c=a.Core_License__c;
      insert saassev1case;

      case saascase1 = new case();
      saascase1.AccountId = Saasaccount.ID;
      saascase1.Contactid = c.id;
      saascase1.Status = 'new';
      saascase1.assetid = a1.ID;
      saascase1.subject = 'test';
      saascase1.Description = 'test';
      saascase1.Case_Severity__c='3';
      saascase1.recordtypeid = learnrecordtypeid;
      saascase1.Core_License__c=a.Core_License__c;
      insert saascase1;
     }
     
   }
   static testmethod void UnitTestLearnSAASPositiveScenario1()
   {
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information');
     user u1 = [select id from user where username='casetest@test.com' limit 1];
     contact c = [select id from contact where PS_Person_Id__c='555666'];
     account Saasaccount1 = [select id from account where name = 'test account for saas' limit 1];
     asset a2 = [select id,Core_License__c from asset where name = 'SAAStest2' limit 1];
     id learnrecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Learn').getRecordTypeId();
     system.RunAs(u1)
     {
      case saascase2 = new case();
      saascase2.AccountId = Saasaccount1.ID;
      saascase2.Contactid = c.id;
      saascase2.Status = 'new';
      saascase2.assetid = a2.ID;
      saascase2.subject = 'test';
      saascase2.Description = 'test';
      saascase2.Case_Severity__c='3';
      saascase2.recordtypeid = learnrecordtypeid;
      saascase2.Core_License__c=a2.Core_License__c;
      insert saascase2;
     }

   } 
   static testmethod void UnitTestMoodleroomsPositiveScenario()
   {

    List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
    user u1 = [select id from user where username='casetest@test.com' limit 1];
    contact c = [select id from contact where PS_Person_Id__c='555666' ];
    account Moodleroomsaccount = [select id from account where Moodlerooms_Queue__c = 'Moodlerooms: EMEA'];
    asset Moodleroomsasset = [select id,Core_License__c from asset where name = 'testmoodleroomsasset' limit 1];
    id MRrecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
    
    Case_Assignment.MOODLEROOMSWEEKENDSEV1CASE = true;
    system.RunAs(u1)
    { 
      test.starttest();
      case Moodleroomscase = new case();
      Moodleroomscase.AccountId = Moodleroomsaccount.Id;
      Moodleroomscase.Contactid = c.id;
      Moodleroomscase.Status = 'new';
      Moodleroomscase.assetid = Moodleroomsasset.Id;
      Moodleroomscase.subject = 'test';
      Moodleroomscase.Description = 'test';
      Moodleroomscase.Case_Severity__c='3';
      Moodleroomscase.recordtypeid = MRrecordtypeid;
      Moodleroomscase.Core_License__c = Moodleroomsasset.Core_License__c;
      insert Moodleroomscase;
         
      case Moodleroomssev1case = new case();
      Moodleroomssev1case.AccountId = Moodleroomsaccount.Id;
      Moodleroomssev1case.Contactid = c.id;
      Moodleroomssev1case.Status = 'new';
      Moodleroomssev1case.assetid = Moodleroomsasset.Id;
      Moodleroomssev1case.subject = 'test';
      Moodleroomssev1case.Description = 'test';
      Moodleroomssev1case.Case_Severity__c='1';
      Moodleroomssev1case.recordtypeid = MRrecordtypeid;
      Moodleroomssev1case.Core_License__c = Moodleroomsasset.Core_License__c;
      insert Moodleroomssev1case;
      test.stoptest();
     }
   }
   static testmethod void UnitTestMoodleroomsPositiveScenario1()
   {
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
     user u1 = [select id from user where username='casetest@test.com' limit 1];
     contact c = [select id from contact where PS_Person_Id__c='555666' ];
     account Moodleroomsaccount = [select id from account where Moodlerooms_Queue__c = 'Moodlerooms: EMEA'];
     asset Moodleroomsasset = [select id,Core_License__c from asset where name = 'testmoodleroomsasset' limit 1];
     id MRrecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
     Case_Assignment.MOODLEROOMSEMEA = true;
     system.RunAs(u1)
     {
       case Moodleroomssev1case1 = new case();
       Moodleroomssev1case1.AccountId = Moodleroomsaccount.Id;
       Moodleroomssev1case1.Contactid = c.id;
       Moodleroomssev1case1.Status = 'new';
       Moodleroomssev1case1.assetid = Moodleroomsasset.Id;
       Moodleroomssev1case1.subject = 'test';
       Moodleroomssev1case1.Description = 'test';
       Moodleroomssev1case1.Case_Severity__c='1';
       Moodleroomssev1case1.recordtypeid = MRrecordtypeid;
       Moodleroomssev1case1.Core_License__c = Moodleroomsasset.Core_License__c;
       insert Moodleroomssev1case1;
     }
   } 
   static testmethod void UnitTestMoodleroomsPositiveScenario2()
   {
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
     user u1 = [select id from user where username='casetest@test.com' limit 1];
     contact c = [select id from contact where PS_Person_Id__c='555666' ];
     account Moodleroomsaccount = [select id from account where Moodlerooms_Queue__c = 'Moodlerooms: EMEA'];
     asset Moodleroomsasset = [select id,Core_License__c from asset where name = 'testmoodleroomsasset' limit 1];
     id MRrecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
     Case_Assignment.MOODLEROOMSAPAC = true;
     system.RunAs(u1)
     {
       case Moodleroomssev1case1 = new case();
       Moodleroomssev1case1.AccountId = Moodleroomsaccount.Id;
       Moodleroomssev1case1.Contactid = c.id;
       Moodleroomssev1case1.Status = 'new';
       Moodleroomssev1case1.assetid = Moodleroomsasset.Id;
       Moodleroomssev1case1.subject = 'test';
       Moodleroomssev1case1.Description = 'test';
       Moodleroomssev1case1.Case_Severity__c='1';
       Moodleroomssev1case1.recordtypeid = MRrecordtypeid;
       Moodleroomssev1case1.Core_License__c = Moodleroomsasset.Core_License__c;
       insert Moodleroomssev1case1;
     }
   } 
   static testmethod void UnitTestMoodleroomsPositiveScenario3()
   {
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
     user u1 = [select id from user where username='casetest@test.com' limit 1];
     contact c = [select id from contact where PS_Person_Id__c='555666' ];
     account Moodleroomsaccount = [select id from account where Moodlerooms_Queue__c = 'Moodlerooms: EMEA'];
     asset Moodleroomsasset = [select id,Core_License__c from asset where name = 'testmoodleroomsasset' limit 1];
     id MRrecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
     Case_Assignment.MOODLEROOMSTERRITORY = true;
     system.RunAs(u1)
     {
       case Moodleroomssev1case1 = new case();
       Moodleroomssev1case1.AccountId = Moodleroomsaccount.Id;
       Moodleroomssev1case1.Contactid = c.id;
       Moodleroomssev1case1.Status = 'new';
       Moodleroomssev1case1.assetid = Moodleroomsasset.Id;
       Moodleroomssev1case1.subject = 'test';
       Moodleroomssev1case1.Description = 'test';
       Moodleroomssev1case1.Case_Severity__c='1';
       Moodleroomssev1case1.recordtypeid = MRrecordtypeid;
       Moodleroomssev1case1.Core_License__c = Moodleroomsasset.Core_License__c;
       insert Moodleroomssev1case1;

       case cs=[select id,owner.name,case_record__c,Core_License__c,Case_Severity__c from case where id=:Moodleroomssev1case1.id];
       system.debug('@@@@@@@'+ cs.case_record__c+'--'+cs.Core_License__c+'1111111'+cs.Case_Severity__c +'oooooo'+ cs.owner.name);
     }
   }
   static testmethod void UnitTestMoodleroomsPositiveScenario4()
   {
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information'); 
     user u1 = [select id from user where username='casetest@test.com' limit 1];
     contact c = [select id from contact where PS_Person_Id__c='555666' ];
     account Moodleroomsaccount = [select id from account where Moodlerooms_Queue__c = 'Moodlerooms: EMEA'];
     asset Moodleroomsasset = [select id,Core_License__c from asset where name = 'testmoodleroomsasset' limit 1];
     id MRrecordtypeid = Schema.SObjectType.case.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
     Case_Assignment.MOODLEROOMSNORMALASSIGN = true;
     system.RunAs(u1)
     {
       case Moodleroomssev1case1 = new case();
       Moodleroomssev1case1.AccountId = Moodleroomsaccount.Id;
       Moodleroomssev1case1.Contactid = c.id;
       Moodleroomssev1case1.Status = 'new';
       Moodleroomssev1case1.assetid = Moodleroomsasset.Id;
       Moodleroomssev1case1.subject = 'test';
       Moodleroomssev1case1.Description = 'test';
       Moodleroomssev1case1.Case_Severity__c='1';
       Moodleroomssev1case1.recordtypeid = MRrecordtypeid;
       Moodleroomssev1case1.Core_License__c = Moodleroomsasset.Core_License__c;
       insert Moodleroomssev1case1;
     }
   }

   static testmethod void UnitTestxpLorPositiveScenario(){
     user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     List<SLA_Information__c> SLAInformationrecords= (List<SLA_Information__c>) System.Test.loadData(SLA_Information__c.sObjectType, 'Test_SLA_Information');
     system.runAs(sysuser){
    
      List<Account> accountlist = new List<Account>();
     
      Profile p = [select Id, Name from Profile where Name='SRV - Support Tech' limit 1];
    
      User u =TestMethodUtility.createUser(p);
      u.IsActive = true;
      Insert u;
    
      User u1 =TestMethodUtility.createUser(p);
      u1.Primary_Group__c=u.id;
      u1.IsActive = true;
      Insert u1;
      
      
      
      Account a1=TestMethodUtility.createAccount();
      a1.xpLor_Queue__c  = 'Moodlerooms: EMEA';
      accountlist.add(a1);
      
      Account a2=TestMethodUtility.createAccount();
      a2.xpLor_Queue__c  = 'Learn - L1';
      accountlist.add(a2);
      
      Insert accountlist;

      Contact cont= new Contact ();
      cont.AccountId=a1.id;
      cont.Account=a1;
      cont.LastName='abc';
      insert cont;


      
      
       Set<ID> aID = new Set<ID>();
      for(Account a111 : accountlist){
          aID.add(a111.ID);
          
   
      
      Core_License__c cr = new  Core_License__c();
      cr.Name = 'xpLor';
      insert cr;

      Asset a=new Asset();
      a.Name='abc';
      a.Core_License__c=cr.id;
      a.AccountId=a1.id;
      a.Contact=cont;
      a.Account=a1;
      insert a;
      
      Module__c m1 = TestMethodUtility.createModule(cr);
      m1.Name = 'Large Event Request';
      insert m1;

      
           
      system.runas(u1){ 
        

        Case cs=new Case();
      cs.Status='new' ;
      cs.Description='this case has to be resolved';
      //cs.Product_Group__c='abc';
      //cs.Asset='FIN AID IMPL PS 30K+';
      cs.Type='abc';cs.Subject='abc';
      cs.Case_Severity__c='sev 3';
      cs.AccountId=a1.id;
      cs.Contact=cont;
      cs.AssetID=a.ID;
      cs.Module__c=m1.id;
      insert cs;
       
      Case_Assignment ca = new Case_Assignment();  
      
      }
      
      
     }
       
     }  
   }  
 }