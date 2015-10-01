@isTest
private class caseViewControllerTest {

	//Test Methods preexisting in Caseview Controller
	static testmethod void caseViewControllertest(){
  
  profile p =[select Id,Name from profile where Name='BTBB Profile'];
  
  User u = TestMethodUtility.createUser(p);
  insert u;
  
   

   
    Account ac=TestMethodUtility.createAccount();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= TestMethodUtility.createContact(ac);
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    
    List<Core_License__c> cr = new List<Core_License__c>();
    
    Core_License__c cl=TestMethodUtility.createCoreLicense();
    cl.Name='ANGEL';
    cr.add(cl);
    
    Core_License__c cl4=TestMethodUtility.createCoreLicense();
    cl4.Name='Transact';
    cr.add(cl4);
    
    insert cr;
    
    Asset a=TestMethodUtility.createAsset(ac,cl);
    a.Name='abc';
    a.Contact=ct;
    insert a;
    
    
    Asset a4=TestMethodUtility.createAsset(ac,cl4);
    a4.Name='abc';
    a4.Contact=ct;
    a4.version_build__c='test';
    insert a4;
    list<case> caselist= new list<case>();
    Case cs1=TestMethodUtility.createCase1(ac,a4);
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Contact=ct;
    cs1.Case_Severity__c='1';
    cs1.Core_License__c=cl4.id;
    cs1.Description = 'NotDescription for Test Class';
    cs1.Source_Build_on_Case__c='test';
    caselist.add(cs1);
    
    Case cs2=TestMethodUtility.createCase1(ac,a);
    cs2.Case_Severity__c='1';
    cs2.Primary_Group_Name__c='ANGEL - Development';
    cs2.Contact=ct;
    cs2.Case_Severity__c='1';
    cs2.Core_License__c=cl.id;
    cs2.Description = 'Description for Test Class';
    cs2.Source_Build_on_Case__c='test';
    caselist.add(cs2);
    
    insert caselist;
    
    SLA_Information__c sla= new SLA_Information__c();
    sla.Event_Type__c = 'Followup';
    sla.Severity__c=cs1.Case_Severity__c;
    sla.Core_License__c = 'Transact';
    insert sla;
    
    EmailMessage em = new EmailMessage();
    em.ParentId=cs1.id;
    em.Subject='test class';
    //em.TextBody='test ';
    em.ToAddress='test@blackboard.com';
    em.Incoming=True;
    insert em;
    
  
    
    Case_Note__c cn = new Case_Note__c();
    cn.Case__c = cs1.ID;
    cn.Type__c = 'Internal Note';
    cn.Public__c = true;
    cn.Processed_By_Email_Service__c = false;
    cn.Details__c='test detail';
    insert cn;
    
    Responsiveness__c res = new Responsiveness__c();
    res.Case__c = cs1.Id;
    res.Start_Time__c = System.now();
    insert res;
      
    Case_Attachment__c casatt = new Case_Attachment__c();
    casatt.Related_To__c = cs1.ID;
    casatt.UserID__c =u.id; 
    Insert casatt;  
    

 
    
    Update res;
   System.runas(u)
     {  
    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    caseViewController csv2 = new caseViewController();  
      csv2.Redirect();
      }  

    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    caseViewController csv = new caseViewController();
    csv.getCaseNoteAttachments();
    csv.SaveAsset();
    csv.Redirect();
    csv.getApplServerOS();
    csv.getDatabaseList();
    csv.getDbServerOS();
    csv.getJDKVersionList();
    Test.StartTest();
    csv.reopen();
    csv.addNote();
    //csv.setupPrefix();
    csv.isId('test');
    csv.isId('testtesttesttsesttest');
    csv.relevantArticles();
   
  
    
    Solution_Detail__c sd1 = new  Solution_Detail__c();
    sd1.Case__c = cs1.ID;
    sd1.Status__c = 'In Consideration';
    insert sd1;
    
    Solution_Detail__c sd3 = new  Solution_Detail__c();
    sd3.Case__c = cs2.ID;
    sd3.Status__c = 'In Consideration';
    insert sd3;
    csv.solutiondeclined();  
    

    
    
    Apexpages.currentPage().getParameters().put('id',cs2.ID);
     Test.StopTest();
    //caseViewController csv1 = new caseViewController();
   // csv1.solutionaccepted();
   
    }
static testmethod void caseViewControllertest2(){
  

    Account ac=TestMethodUtility.createAccount();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= TestMethodUtility.createContact(ac);
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    
    List<Core_License__c> cr = new List<Core_License__c>();
    
    Core_License__c cl=TestMethodUtility.createCoreLicense();
    cl.Name='ANGEL';
    insert cl;
    
    Asset a=TestMethodUtility.createAsset(ac,cl);
    a.Name='abc';
    a.Contact=ct;
    insert a;
    

    
    Case cs1=TestMethodUtility.createCase1(ac,a);
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Contact=ct;
    cs1.Case_Severity__c='1';
    cs1.Core_License__c=cl.id;
    cs1.Description = 'Not Equal to Description for Test Class';
    cs1.Source_Build_on_Case__c='test';
    insert cs1;    
    
    
    SLA_Information__c sla= new SLA_Information__c();
    sla.Event_Type__c = 'Followup';
    sla.Severity__c=cs1.Case_Severity__c;
    sla.Core_License__c = 'Angel';
    insert sla;
    
    EmailMessage em = new EmailMessage();
    em.ParentId=cs1.id;
    em.Subject='test class';
    //em.TextBody='test ';
    em.ToAddress='test@blackboard.com';
    em.Incoming=True;
    insert em;
    
  
    
    Case_Note__c cn = new Case_Note__c();
    cn.Case__c = cs1.ID;
    cn.Type__c = 'Internal Note';
    cn.Public__c = true;
    cn.Processed_By_Email_Service__c = false;
    cn.Details__c='test detail';
    insert cn;
    
    Responsiveness__c res = new Responsiveness__c();
    res.Case__c = cs1.Id;
    res.Start_Time__c = System.now();
    insert res;
      
    Attachment atch = new   Attachment();
    atch.ParentId=cs1.id;
    atch.Name='test attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    atch.body=bodyBlob;
    insert atch;    
  
    
    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    caseViewController csv = new caseViewController();
    
    Case_Attachment__c casatt = new Case_Attachment__c();
    casatt.Related_To__c = cs1.ID;
    casatt.UserID__c =userinfo.getUserId();
    Insert casatt;
    
    Solution_Detail__c sd1 = new  Solution_Detail__c();
    sd1.Case__c = cs1.ID;
    sd1.Status__c = 'In Consideration';
    insert sd1;
    Test.StartTest();

    List<selectOption>  lo =csv.versions;
    List<selectOption>  lo1=csv.sblist;
    csv.isMLAAdmin=True;
    boolean b = csv.isMLAAdmin;
    csv.closecase();
    csv.deleteatt1();
      b=csv.isreadonly;
    Test.StopTest();
    }  
    
    static testmethod void publiccaseViewControllertest3(){
  

    Account ac=TestMethodUtility.createAccount();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= TestMethodUtility.createContact(ac);
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    
    List<Core_License__c> cr = new List<Core_License__c>();
    
    Core_License__c cl=TestMethodUtility.createCoreLicense();
    cl.Name='Collaborate';
    insert cl;
    
    Asset a=TestMethodUtility.createAsset(ac,cl);
    a.Name='abc';
    a.Contact=ct;
    a.Version__c='2.0';
    a.Version_Build__c='3.0';
    insert a;
    

    
    Case cs1=TestMethodUtility.createCase1(ac,a);
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Contact=ct;
    cs1.Case_Severity__c='1';
    cs1.Core_License__c=cl.id;
    cs1.Description = 'Not Equal to Description for Test Class';
    cs1.Source_Build_on_Case__c='test';
    insert cs1;    
    
    
    SLA_Information__c sla= new SLA_Information__c();
    sla.Event_Type__c = 'Followup';
    sla.Severity__c=cs1.Case_Severity__c;
    sla.Core_License__c = 'COLLABORATE ';
    insert sla;
    
    EmailMessage em = new EmailMessage();
    em.ParentId=cs1.id;
    em.Subject='test class';
    //em.TextBody='test ';
    em.ToAddress='test@blackboard.com';
    em.Incoming=True;
    insert em;
    
  
    
    Case_Note__c cn = new Case_Note__c();
    cn.Case__c = cs1.ID;
    cn.Type__c = 'Internal Note';
    cn.Public__c = true;
    cn.Processed_By_Email_Service__c = false;
    cn.Details__c='test detail';
    insert cn;
    
    Responsiveness__c res = new Responsiveness__c();
    res.Case__c = cs1.Id;
    res.Start_Time__c = System.now();
    insert res;
      
    Attachment atch = new   Attachment();
    atch.ParentId=cs1.id;
    atch.Name='test attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    atch.body=bodyBlob;
    insert atch; 
    
    Case_Attachment__c casatt = new Case_Attachment__c();
    casatt.Related_To__c = cs1.ID;
    Insert casatt;
    
    Solution_Detail__c sd1 = new  Solution_Detail__c();
    sd1.Case__c = cs1.ID;
    sd1.Status__c = 'In Consideration';
    insert sd1;
    Test.StartTest();   
  
    
    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    caseViewController csv = new caseViewController();
    csv.version='2.0';
    csv.build='2.0';
    csv.saveasset();

    List<selectOption>  lo =csv.versions;
    List<selectOption>  lo1=csv.sblist;
    csv.isMLAAdmin=True;
    boolean b = csv.isMLAAdmin;
   
    csv.solutionaccepted();
    csv.closecase();
   
    Test.StopTest();
    }  
    
    static testmethod void publiccaseViewControllertest5(){
  

    Account ac=TestMethodUtility.createAccount();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= TestMethodUtility.createContact(ac);
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    
    List<Core_License__c> cr = new List<Core_License__c>();
    
    Core_License__c cl=TestMethodUtility.createCoreLicense();
    cl.Name='COLLABORATE ';
    insert cl;
    
    Asset a=TestMethodUtility.createAsset(ac,cl);
    a.Name='abc';
    a.Contact=ct;
    a.Version__c='2.0';
    a.Version_Build__c='3.0';
    insert a;
    

    
    Case cs1=TestMethodUtility.createCase1(ac,a);
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Contact=ct;
    cs1.Case_Severity__c='1';
    cs1.Core_License__c=cl.id;
    cs1.Description = 'Not Equal to Description for Test Class';
    cs1.Source_Build_on_Case__c='test';
    insert cs1;    
    
    
    SLA_Information__c sla= new SLA_Information__c();
    sla.Event_Type__c = 'Followup';
    sla.Severity__c=cs1.Case_Severity__c;
    sla.Core_License__c = 'COLLABORATE ';
    insert sla;
    
    EmailMessage em = new EmailMessage();
    em.ParentId=cs1.id;
    em.Subject='test class';
    //em.TextBody='test ';
    em.ToAddress='test@blackboard.com';
    em.Incoming=True;
    insert em;
    
  
    
    Case_Note__c cn = new Case_Note__c();
    cn.Case__c = cs1.ID;
    cn.Type__c = 'Internal Note';
    cn.Public__c = true;
    cn.Processed_By_Email_Service__c = false;
    cn.Details__c='test detail';
    insert cn;
    
    Responsiveness__c res = new Responsiveness__c();
    res.Case__c = cs1.Id;
    res.Start_Time__c = System.now();
    insert res;
      
    Attachment atch = new   Attachment();
    atch.ParentId=cs1.id;
    atch.Name='test attachment';
    Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
    atch.body=bodyBlob;
    insert atch; 
    
    Case_Attachment__c casatt = new Case_Attachment__c();
    casatt.Related_To__c = cs1.ID;
    Insert casatt;
    
    Solution_Detail__c sd1 = new  Solution_Detail__c();
    sd1.Case__c = cs1.ID;
    sd1.Status__c = 'In Consideration';
    insert sd1;
    Test.StartTest();   
  
    
    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    publiccaseviewcontroller csv = new publiccaseviewcontroller();
    csv.version='1.0';
    csv.build='2.0';
    csv.saveasset();

    List<selectOption>  lo =csv.versions;
    List<selectOption>  lo1=csv.sblist;
    csv.isMLAAdmin=True;
    boolean b = csv.isMLAAdmin;
    
    csv.solutionaccepted();
   
    csv.deleteatt1();

    Test.StopTest();
    }    
	
	@isTest(seealldata=true) static void testforCcemail() {

    Account ac=TestMethodUtility.createAccount();
    ac.Name='bucknell university';
    ac.BillingCity='abc';
    ac.BillingCountry='USA';
    ac.BillingPostalCode='abc';
    ac.BillingState='abc';
    ac.BillingStreet='abc';

    insert ac;

    Contact ct= TestMethodUtility.createContact(ac);
    ct.AccountId=ac.id;
    ct.Account=ac;
    ct.LastName='abc';
    insert ct;
    
    List<Core_License__c> cr = new List<Core_License__c>();
    
    Core_License__c cl=TestMethodUtility.createCoreLicense();
    cl.Name='ANGEL';
    cr.add(cl);
    
    Core_License__c cl4=TestMethodUtility.createCoreLicense();
    cl4.Name='Transact';
    cr.add(cl4);
    
    insert cr;
    
    Asset a=TestMethodUtility.createAsset(ac,cl);
    a.Name='abc';
    a.Contact=ct;
    insert a;
    
    
    Asset a4=TestMethodUtility.createAsset(ac,cl4);
    a4.Name='abc';
    a4.Contact=ct;
    a4.version_build__c='test';
    insert a4;
    list<case> caselist= new list<case>();
    Case cs1=TestMethodUtility.createCase1(ac,a4);
    cs1.Case_Severity__c='1';
    cs1.Primary_Group_Name__c='ANGEL - Development';
    cs1.Contact=ct;
    cs1.Case_Severity__c='1';
    cs1.Core_License__c=cl4.id;
    cs1.Description = 'NotDescription for Test Class';
    cs1.Source_Build_on_Case__c='test';
    caselist.add(cs1);
    
    Case cs2=TestMethodUtility.createCase1(ac,a);
    cs2.Case_Severity__c='1';
    cs2.Primary_Group_Name__c='ANGEL - Development';
    cs2.Contact=ct;
    cs2.Case_Severity__c='1';
    cs2.Core_License__c=cl.id;
    cs2.Description = 'Description for Test Class';
    cs2.Source_Build_on_Case__c='test';
    caselist.add(cs2);
    
    insert caselist;

    Case_Note__c cn = new Case_Note__c();
    cn.Case__c = cs1.ID;
    cn.Type__c = 'Internal Note';
    cn.Public__c = true;
    cn.Processed_By_Email_Service__c = false;
    cn.Details__c='test detail';
    insert cn;
   

    Apexpages.currentPage().getParameters().put('id',cs1.ID);
    caseViewController csv = new caseViewController();
    csv.ccRecipients='';
    csv.updateccemails();
    csv.ccRecipients='testacc;testcc';
    csv.updateccemails();
    csv.ccRecipients='test@acc1.com;test@acc2.com;test@acc3.com;test@acc4.com;test@acc5.com;test@acc6.com;';
    csv.updateccemails();
    csv.ccRecipients='test@acc1.com;test@acc2.com;test@acc3.com;test@acc4.com;test@acc5.com;';
    csv.updateccemails();
    test.starttest();
    csv.aNote.Details__c='test note';
    csv.addNote();
	test.stoptest()	;
	}


    static testmethod void UnitTestAnalyticsPositiveScenarios(){
  
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     
    System.runAs(sysuser){

        profile p =[select Id,Name from profile where Name='BTBB Profile'];
  
          User u = TestMethodUtility.createUser(p);
          insert u;

          Account ac=new Account();
            ac.Name='bucknell university';
            ac.BillingCity='abc';
            ac.BillingCountry='USA';
            ac.BillingPostalCode='abc';
            ac.BillingState='abc';
            ac.BillingStreet='abc';
            insert ac;

            Contact ct= new Contact ();
            ct.AccountId=ac.id;
            ct.Account=ac;
            ct.LastName='abc';
            insert ct;

            Core_License__c cl=new Core_License__c();
            cl.Name='Analytics';
            insert cl;

            Asset a=new Asset();
            a.Name='abc';
            a.Core_License__c=cl.id;
            a.AccountId=ac.id;
            a.Managed_Hosting__c='Learn - Managed Hosting';
            a.Contact=ct;
            a.Account=ac;
            insert a;

            Module__c m=new  Module__c(); 
            m.Name='abc'; 
            m.Core_Licence__c=cl.id; 
            insert m;

            Functional_Area__c fa=new Functional_Area__c();
            fa.Name='abc';
            fa.Module__c=m.id;
            insert fa;

            Category__c c=new Category__c();
            c.Name='abc';
            c.Functional_Area__c=fa.id; 
            insert c;

            Template__c t=new Template__c();
            t.Name='abc';
            insert t;
          id ANrecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('Analytics').getRecordTypeId();

           
            Case cs=new Case();
            cs.Status='new' ;
            cs.Description='this case has to be resolved';
            //cs.Product_Group__c='abc';
            //cs.Asset='FIN AID IMPL PS 30K+';
            cs.Type='abc';cs.Subject='abc';
            cs.Case_Severity__c='sev 1';
            cs.AccountId=ac.id;
            cs.ContactId=ct.id;
            cs.AssetID=a.ID;
            cs.Functional_Area__c=fa.id;
            cs.Module__c=m.id;
            cs.Category__c=c.id;
            cs.Primary_Group_Name__c='Analytics';
             cs.RecordTypeId=ANrecordtypeid;        

            //cs.Owner.id=UserInfo.getUserId();
            insert cs;

          
  


            system.debug('case record'+cs.RecordType.Name);

            SLA_Information__c sla= new SLA_Information__c();
            sla.Event_Type__c = 'Followup';
            sla.Severity__c=cs.Case_Severity__c;
            sla.Core_License__c = 'Analytics';
            insert sla;

            System.runAs(u){
                system.currentpagereference().getParameters().put('id',cs.id);
        
                caseViewController cv=new caseViewController();

            }

            
	} 
}

 static testmethod void UnitTestMoodleroomsPositiveScenarios(){
  
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     
    System.runAs(sysuser){

        profile p =[select Id,Name from profile where Name='BTBB Profile'];
  
          User u = TestMethodUtility.createUser(p);
          insert u;

          Account ac=new Account();
            ac.Name='bucknell university';
            ac.BillingCity='abc';
            ac.BillingCountry='USA';
            ac.BillingPostalCode='abc';
            ac.BillingState='abc';
            ac.BillingStreet='abc';
            insert ac;

            Contact ct= new Contact ();
            ct.AccountId=ac.id;
            ct.Account=ac;
            ct.LastName='abc';
            insert ct;

            Core_License__c cl=new Core_License__c();
            cl.Name='Moodlerooms';
            insert cl;

            Asset a=new Asset();
            a.Name='abc';
            a.Core_License__c=cl.id;
            a.AccountId=ac.id;
            a.Contact=ct;
            a.Account=ac;
            insert a;

            Module__c m=new  Module__c(); 
            m.Name='abc'; 
            m.Core_Licence__c=cl.id; 
            insert m;

            Functional_Area__c fa=new Functional_Area__c();
            fa.Name='abc';
            fa.Module__c=m.id;
            insert fa;

            Category__c c=new Category__c();
            c.Name='abc';
            c.Functional_Area__c=fa.id; 
            insert c;

            Template__c t=new Template__c();
            t.Name='abc';
            insert t;
          
          id ANrecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();

           
            Case cs=new Case();
            cs.Status='new' ;
            cs.Description='this case has to be resolved';
            //cs.Product_Group__c='abc';
            //cs.Asset='FIN AID IMPL PS 30K+';
            cs.Type='abc';cs.Subject='abc';
            cs.Case_Severity__c='sev 1';
            cs.AccountId=ac.id;
            cs.ContactId=ct.id;
            cs.AssetID=a.ID;
            cs.Functional_Area__c=fa.id;
            cs.Module__c=m.id;
            cs.Category__c=c.id;
            cs.Primary_Group_Name__c='Moodlerooms';
             cs.RecordTypeId=ANrecordtypeid;        

            //cs.Owner.id=UserInfo.getUserId();
            insert cs;

          
  


            system.debug('case record'+cs.RecordType.Name);

            SLA_Information__c sla= new SLA_Information__c();
            sla.Event_Type__c = 'Followup';
            sla.Severity__c=cs.Case_Severity__c;
            sla.Core_License__c = 'Moodlerooms';
            insert sla;

          system.runAs(u){


                system.currentpagereference().getParameters().put('id',cs.id);
        
                caseViewController cv=new caseViewController();

          }


            
    } 
}
static testmethod void UnitTestxpLorPositiveScenarios(){
  
    user sysuser=[select id,name from user where username like 'tsg@blackboard.com%' and isactive =true limit 1];
     
    System.runAs(sysuser){

        profile p =[select Id,Name from profile where Name='BTBB Profile'];
  
          User u = TestMethodUtility.createUser(p);
          insert u;

          Account ac=new Account();
            ac.Name='bucknell university';
            ac.BillingCity='abc';
            ac.BillingCountry='USA';
            ac.BillingPostalCode='abc';
            ac.BillingState='abc';
            ac.BillingStreet='abc';
            insert ac;

            Contact ct= new Contact ();
            ct.AccountId=ac.id;
            ct.Account=ac;
            ct.LastName='abc';
            insert ct;

            Core_License__c cl=new Core_License__c();
            cl.Name='xpLor';
            insert cl;

            Asset a=new Asset();
            a.Name='abc';
            a.Core_License__c=cl.id;
            a.AccountId=ac.id;
            a.Contact=ct;
            a.Account=ac;
            insert a;

            Module__c m=new  Module__c(); 
            m.Name='abc'; 
            m.Core_Licence__c=cl.id; 
            insert m;


            Template__c t=new Template__c();
            t.Name='abc';
            insert t;
          
          id xprecordtypeid=Schema.SObjectType.case.getRecordTypeInfosByName().get('xpLor').getRecordTypeId();

           
            Case cs=new Case();
            cs.Status='new' ;
            cs.Description='this case has to be resolved';
            cs.Type='abc';
            cs.Subject='abc';
            cs.Case_Severity__c='sev 1';
            cs.AccountId=ac.id;
            cs.ContactId=ct.id;
            cs.AssetID=a.ID;
            cs.Module__c=m.id;
    
            cs.Primary_Group_Name__c='xpLor';
            cs.RecordTypeId=xprecordtypeid;        
            insert cs;

            SLA_Information__c sla= new SLA_Information__c();
            sla.Event_Type__c = 'Followup';
            sla.Severity__c=cs.Case_Severity__c;
            sla.Core_License__c = 'xpLor';
            insert sla;

          system.runAs(u)
          {
                system.currentpagereference().getParameters().put('id',cs.id);
        
                caseViewController cv=new caseViewController();

          }

       } 
     }

}