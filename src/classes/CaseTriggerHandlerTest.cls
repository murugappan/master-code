@istest
 Private class CaseTriggerHandlerTest
  {
 
 static TestMethod void testHandler()
    {
        Account a = TestMethodUtility.createAccount();
        insert a;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        
        // Have to work on increasing because of single thread
        Test.startTest();           
            Case c = TestMethodUtility.createCase(con, cl, a, m);
            insert c;
            learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
            insert lj;
            Related_Bug__c rb = TestMethodUtility.createRelatedBug(lj);
            insert rb;
        Test.stopTest();
        
    }
    static testMethod void testHandler1()
    {
        
        Account a = TestMethodUtility.createAccount();
        insert a;
        
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Moodlerooms';
        insert cr;
        
       // Asset as = TestMethodUtility.createAsset(a, cr);
       // insert as;
       
        Asset aa = new Asset(Name = 'TestAsset',Core_License__c = cr.Id,Status = 'Installed', AccountId = a.Id);
        insert aa;
        
        Module__c m = TestMethodUtility.createModule(cr);
        insert m;    
        
        list<case> caselist=new list<case>();
        
        Case c1 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c2 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c3 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c4 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c5 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c6 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c7 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c8 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c9 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c10 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);
        caselist.add(c5);
        caselist.add(c6);
        caselist.add(c7);
        caselist.add(c8);
        caselist.add(c9);
        caselist.add(c10);
        insert caselist;
Test.startTest(); 
         caselist=[select id,casenumber from case limit 10];
         id mrrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
        list<learnJIRA__c> silist=new list<learnJIRA__c>();
        learnJIRA__c lj1= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[0].CaseNumber,Master_Case__c=caselist[0].id,OriginCaseID__c = caselist[0].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj2= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[1].CaseNumber,Master_Case__c=caselist[1].id,OriginCaseID__c = caselist[1].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj3= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[2].CaseNumber,Master_Case__c=caselist[2].id,OriginCaseID__c = caselist[2].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj4= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[3].CaseNumber,Master_Case__c=caselist[3].id,OriginCaseID__c = caselist[3].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj5= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[4].CaseNumber,Master_Case__c=caselist[4].id,OriginCaseID__c = caselist[4].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj6= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[5].CaseNumber,Master_Case__c=caselist[5].id,OriginCaseID__c = caselist[5].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj7= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[6].CaseNumber,Master_Case__c=caselist[6].id,OriginCaseID__c = caselist[6].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj8= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[7].CaseNumber,Master_Case__c=caselist[7].id,OriginCaseID__c = caselist[7].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj9= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[8].CaseNumber,Master_Case__c=caselist[8].id,OriginCaseID__c = caselist[8].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj10= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[9].CaseNumber,Master_Case__c=caselist[9].id,OriginCaseID__c = caselist[9].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);

        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        insert silist;

        CaseTriggerHandler.hasbeforeupdaterun=false;
        CaseTriggerHandler.hasafterupdaterun=false;
        LearnJIRATriggerHandler.hasbeforeupdaterun=false; 
        LearnJIRATriggerHandler.hasafterupdaterun=false; 

        c1.LearnJIRA_SI__c = lj1.id;
        c2.LearnJIRA_SI__c = lj2.id;
        c3.LearnJIRA_SI__c = lj3.id;
        c4.LearnJIRA_SI__c = lj4.id;
        c5.LearnJIRA_SI__c = lj5.id;
        c6.LearnJIRA_SI__c = lj6.id;
        c7.LearnJIRA_SI__c = lj7.id;
        c8.LearnJIRA_SI__c = lj8.id;
        c9.LearnJIRA_SI__c = lj9.id;
        c10.LearnJIRA_SI__c =lj10.id;
        caselist=new list<case>();
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);
        caselist.add(c5);
        caselist.add(c6);
        caselist.add(c7);
        caselist.add(c8);
        caselist.add(c9);
        caselist.add(c10);
        update caselist;
        resetflags(); 
        lj1.Status__c = 'Open';
        lj1.Tier_2_Assessment__c = 'This is a bug';

        lj2.Status__c = 'On Hold' ;
        lj2.Tier_2_Assessment__c ='This is a bug' ;
        lj2.On_Hold_Reason__c ='Waiting on Moodle Development';
       // update lj;
        //resetflags();
        lj3.Status__c = 'On Hold';
        lj3.Tier_2_Assessment__c = 'This is a bug';
        lj3.On_Hold_Reason__c = 'Waiting on 3rd Party Development';
       // update lj;
        //resetflags();
        lj4.Status__c = 'On Hold';
        lj4.Tier_2_Assessment__c = 'This is a bug';
        lj4.On_Hold_Reason__c = 'Waiting for Client Support Response';
     //   update lj;
      //  resetflags();
        lj5.Status__c = 'On Hold';
        lj5.Tier_2_Assessment__c = 'This is a bug';
        lj5.On_Hold_Reason__c = 'Waiting for Client Response';
        
        lj6.Status__c = 'In Testing';
        lj6.Tier_2_Assessment__c = 'This is a Bug';

        lj7.Status__c = 'Resolved';
        lj7.Tier_2_Assessment__c = 'This is a Bug';
     
        lj8.Status__c = 'Closed';
        lj8.Tier_2_Assessment__c = 'This is a bug';
        lj8.Resolution__c = 'Duplicate';
      
        lj9.Status__c = 'Closed';
        lj9.Tier_2_Assessment__c = 'This is a bug';
        lj9.Resolution__c = 'Will Not Fix';
        
        lj10.Status__c = 'Closed';
        lj10.Tier_2_Assessment__c = 'This is a bug';
        lj10.Resolution__c = 'Functioning as Designed';
    
        silist=new list<learnJIRA__c>();
        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        update silist;

        resetflags();
       
Test.stopTest();
      lj1.Status__c='Closed';
        lj1.Tier_2_Assessment__c='This is a bug';
        lj1.Resolution__c='Cannot Reproduce';

        lj2.Status__c='Closed';
        lj2.Tier_2_Assessment__c='This is a bug';
        lj2.Resolution__c='Fixed Released';

        lj3.Status__c='Closed';
        lj3.Tier_2_Assessment__c='This is a bug';
        lj3.Resolution__c = 'test';

        lj4.Status__c='New';
        lj4.Tier_2_Assessment__c='Enhancement';

        lj5.Status__c='Open';
        lj5.Tier_2_Assessment__c='Enhancement';

        lj6.Status__c='On Hold';
        lj6.Tier_2_Assessment__c='Enhancement';
        lj6.On_Hold_Reason__c ='Waiting for Client Support Response';

        lj7.Status__c='Closed';
        lj7.Tier_2_Assessment__c='Enhancement';
        lj7.Resolution__c='Accepted';

        lj8.Status__c='Closed';
        lj8.Tier_2_Assessment__c='Enhancement';
        lj8.Resolution__c='Denied';
         
        silist=new list<learnJIRA__c>();
        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        update silist;       
        
            
     }

     static void resetflags()
     {
        CaseTriggerHandler.hasbeforeupdaterun=false;
        CaseTriggerHandler.hasafterupdaterun=false;
        LearnJIRATriggerHandler.hasbeforeupdaterun=false; 
        LearnJIRATriggerHandler.hasafterupdaterun=false; 
     }

     static testMethod void testHandler2()
    {
        
        Account a = TestMethodUtility.createAccount();
        insert a;
        
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Collaborate';
        insert cr;
        
       // Asset as = TestMethodUtility.createAsset(a, cr);
       // insert as;
       
        Asset aa = new Asset(Name = 'TestAsset',Core_License__c = cr.Id,Status = 'Installed', AccountId = a.Id);
        insert aa;

            
        Module__c m = TestMethodUtility.createModule(cr);
        insert m;    
         list<case> caselist=new list<case>();

        Case c1 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c2 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c3 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c4 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c5 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c6 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c7 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c8 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c9 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c10 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c11 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c12 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c13 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c14 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);
        caselist.add(c5);
        caselist.add(c6);
        caselist.add(c7);
        caselist.add(c8);
        caselist.add(c9);
        caselist.add(c10);
        caselist.add(c11);
        caselist.add(c12);
        caselist.add(c13);
        caselist.add(c14);
        insert caselist;

         caselist=[select id,casenumber from case limit 14];
         id mrrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Collaborate').getRecordTypeId();
        list<learnJIRA__c> silist=new list<learnJIRA__c>();
        learnJIRA__c lj1= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[0].CaseNumber,Master_Case__c=caselist[0].id,OriginCaseID__c = caselist[0].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj2= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[1].CaseNumber,Master_Case__c=caselist[1].id,OriginCaseID__c = caselist[1].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj3= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[2].CaseNumber,Master_Case__c=caselist[2].id,OriginCaseID__c = caselist[2].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj4= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[3].CaseNumber,Master_Case__c=caselist[3].id,OriginCaseID__c = caselist[3].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj5= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[4].CaseNumber,Master_Case__c=caselist[4].id,OriginCaseID__c = caselist[4].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj6= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[5].CaseNumber,Master_Case__c=caselist[5].id,OriginCaseID__c = caselist[5].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj7= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[6].CaseNumber,Master_Case__c=caselist[6].id,OriginCaseID__c = caselist[6].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj8= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[7].CaseNumber,Master_Case__c=caselist[7].id,OriginCaseID__c = caselist[7].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj9= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[8].CaseNumber,Master_Case__c=caselist[8].id,OriginCaseID__c = caselist[8].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj10= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[9].CaseNumber,Master_Case__c=caselist[9].id,OriginCaseID__c = caselist[9].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj11= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[10].CaseNumber,Master_Case__c=caselist[10].id,OriginCaseID__c = caselist[10].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj12= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[11].CaseNumber,Master_Case__c=caselist[11].id,OriginCaseID__c = caselist[11].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj13= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[12].CaseNumber,Master_Case__c=caselist[12].id,OriginCaseID__c = caselist[12].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);
        learnJIRA__c lj14= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[13].CaseNumber,Master_Case__c=caselist[13].id,OriginCaseID__c = caselist[13].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Module_moodlerooms__c = 'Test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=mrrecordtypeid);

        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        silist.add(lj11);
        silist.add(lj12);
        silist.add(lj13);
        silist.add(lj14);
        insert silist;
     
       c1.LearnJIRA_SI__c = lj1.id;
        c2.LearnJIRA_SI__c = lj2.id;
        c3.LearnJIRA_SI__c = lj3.id;
        c4.LearnJIRA_SI__c = lj4.id;
        c5.LearnJIRA_SI__c = lj5.id;
        c6.LearnJIRA_SI__c = lj6.id;
        c7.LearnJIRA_SI__c = lj7.id;
        c8.LearnJIRA_SI__c = lj8.id;
        c9.LearnJIRA_SI__c = lj9.id;
        c10.LearnJIRA_SI__c =lj10.id;
        c11.LearnJIRA_SI__c = lj11.id;
        c12.LearnJIRA_SI__c = lj12.id;
        c13.LearnJIRA_SI__c = lj13.id;
        c14.LearnJIRA_SI__c =lj14.id;
        caselist=new list<case>();
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);
        caselist.add(c5);
        caselist.add(c6);
        caselist.add(c7);
        caselist.add(c8);
        caselist.add(c9);
        caselist.add(c10);
        caselist.add(c11);
        caselist.add(c12);
        caselist.add(c13);
        caselist.add(c14);
        update caselist;
Test.startTest();    
        resetflags();
        lj1.Status__c='New';
        lj1.Tier_2_Assessment__c='Operations Issue';

        lj2.Status__c='New';
        lj2.Tier_2_Assessment__c='Software Issue';

        lj3.Status__c='Open';
        lj3.Tier_2_Assessment__c='Operations Issue';

        lj4.Status__c='Open';
        lj4.Tier_2_Assessment__c='Software Issue';

        lj5.Status__c='On Hold';
        lj5.Tier_2_Assessment__c='Operations Issue';
        lj5.On_Hold_Reason__c='Waiting for Operations';

        lj6.Status__c='On Hold';
        lj6.Tier_2_Assessment__c='Operations Issue';
        lj6.On_Hold_Reason__c='Waiting on 3rd party';


        lj7.Status__c='On Hold';
        lj7.Tier_2_Assessment__c= 'Software Issue';
        lj7.On_Hold_Reason__c='Waiting on 3rd party';

        lj8.Status__c='On Hold';
        lj8.Tier_2_Assessment__c='Operations Issue' ;
        lj8.On_Hold_Reason__c='Waiting for Client Support Response';


        lj9.Status__c='On Hold';
        lj9.Tier_2_Assessment__c= 'Software Issue';
        lj9.On_Hold_Reason__c='Waiting for Client Support Response';

        lj10.Status__c='Closed';
        lj10.Tier_2_Assessment__c='Operations Issue' ;
        lj10.Resolution__c='Cloned to Bug';

        lj11.Status__c='Closed';
        lj11.Tier_2_Assessment__c= 'Software Issue';
        lj11.Resolution__c='Cannot Reproduce';

        lj12.Status__c='Closed';
        lj12.Tier_2_Assessment__c='Operations Issue';
        lj12.Resolution__c='Duplicate';

        lj13.Status__c='Closed';
        lj13.Tier_2_Assessment__c= 'Software Issue';
        lj13.Resolution__c='Duplicate';

        lj14.Status__c='New';
        lj14.Tier_2_Assessment__c='Enhancement';


        silist=new list<learnJIRA__c>();
        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        silist.add(lj11);
        silist.add(lj12);
        silist.add(lj13);
        silist.add(lj14);
        update silist;
        resetflags();

        lj1.Status__c='Closed';
        lj1.Tier_2_Assessment__c= 'Software Issue';
        lj1.Resolution__c='Cloned to Bug';

        lj2.Status__c='Closed';
        lj2.Tier_2_Assessment__c='Operations Issue' ;
        lj2.Resolution__c='Operations Fixed';

        lj3.Status__c='Closed';
        lj3.Tier_2_Assessment__c= 'Software Issue';
        lj3.Resolution__c='Operations Fixed';

        lj4.Status__c='Closed';
        lj4.Tier_2_Assessment__c='Operations Issue' ;
        lj4.Resolution__c='Fixed Released';

        lj5.Status__c='Closed';
        lj5.Tier_2_Assessment__c= 'Software Issue';
        lj5.Resolution__c='Fixed Released';

        lj6.Status__c='Closed';
        lj6.Tier_2_Assessment__c='Operations Issue';
        lj6.Resolution__c='Will Not Fix';

        lj7.Status__c='Closed';
        lj7.Tier_2_Assessment__c= 'Software Issue';
        lj7.Resolution__c='Will Not Fix';

        lj8.Status__c='Closed';
        lj8.Tier_2_Assessment__c='Operations Issue';
        lj8.Resolution__c='Functioning as Designed';

        lj9.Status__c='Closed';
        lj9.Tier_2_Assessment__c= 'Software Issue';
        lj9.Resolution__c='Functioning as Designed';

        lj10.Status__c='Closed';
        lj10.Tier_2_Assessment__c='Operations Issue';
        lj10.Resolution__c='Cannot Reproduce';

        lj11.Status__c='Open';
        lj11.Tier_2_Assessment__c='Enhancement';

        lj12.Status__c='Closed';
        lj12.Tier_2_Assessment__c='Enhancement';
        lj12.Resolution__c='Accepted';

        lj13.Status__c='Closed';
        lj13.Tier_2_Assessment__c='Enhancement';
        lj13.Resolution__c='Denied';


        silist=new list<learnJIRA__c>();
        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        silist.add(lj11);
        silist.add(lj12);
        silist.add(lj13);
        update silist;
         Test.stopTest();
    }

    static testMethod void AnalyticsSI()
    { 
        Account a = TestMethodUtility.createAccount();
        insert a;
        
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        
        Core_License__c cr = new  Core_License__c();
        cr.Name = 'Analytics';
        insert cr;
       
        Asset aa = new Asset(Name = 'TestAsset',Core_License__c = cr.Id,Status = 'Installed', AccountId = a.Id);
        insert aa;
        
        Module__c m = TestMethodUtility.createModule(cr);
        insert m;    
        
        list<case> caselist=new list<case>();
        
        Case c1 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c2 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c3 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c4 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c5 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c6 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c7 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c8 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c9 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c10 = new Case(ContactId = con.Id,AccountId = a.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);
        caselist.add(c5);
        caselist.add(c6);
        caselist.add(c7);
        caselist.add(c8);
        caselist.add(c9);
        caselist.add(c10);
        insert caselist;

        Test.startTest(); 
         caselist=[select id,casenumber from case limit 10];
         id ANrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Analytics').getRecordTypeId();
        list<learnJIRA__c> silist=new list<learnJIRA__c>();
        learnJIRA__c lj1= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[0].CaseNumber,Master_Case__c=caselist[0].id,OriginCaseID__c = caselist[0].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj2= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[1].CaseNumber,Master_Case__c=caselist[1].id,OriginCaseID__c = caselist[1].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj3= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[2].CaseNumber,Master_Case__c=caselist[2].id,OriginCaseID__c = caselist[2].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj4= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[3].CaseNumber,Master_Case__c=caselist[3].id,OriginCaseID__c = caselist[3].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj5= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[4].CaseNumber,Master_Case__c=caselist[4].id,OriginCaseID__c = caselist[4].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj6= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[5].CaseNumber,Master_Case__c=caselist[5].id,OriginCaseID__c = caselist[5].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj7= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[6].CaseNumber,Master_Case__c=caselist[6].id,OriginCaseID__c = caselist[6].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj8= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[7].CaseNumber,Master_Case__c=caselist[7].id,OriginCaseID__c = caselist[7].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj9= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[8].CaseNumber,Master_Case__c=caselist[8].id,OriginCaseID__c = caselist[8].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
        learnJIRA__c lj10= new learnJIRA__c(Name = 'Test4',Origin_Case_Number__c = caselist[9].CaseNumber,Master_Case__c=caselist[9].id,OriginCaseID__c = caselist[9].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);

        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        insert silist;

        resetflags();

        c1.LearnJIRA_SI__c = lj1.id;
        c2.LearnJIRA_SI__c = lj2.id;
        c3.LearnJIRA_SI__c = lj3.id;
        c4.LearnJIRA_SI__c = lj4.id;
        c5.LearnJIRA_SI__c = lj5.id;
        c6.LearnJIRA_SI__c = lj6.id;
        c7.LearnJIRA_SI__c = lj7.id;
        c8.LearnJIRA_SI__c = lj8.id;
        c9.LearnJIRA_SI__c = lj9.id;
        c10.LearnJIRA_SI__c =lj10.id;
        caselist=new list<case>();
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);
        caselist.add(c5);
        caselist.add(c6);
        caselist.add(c7);
        caselist.add(c8);
        caselist.add(c9);
        caselist.add(c10);
        update caselist;
        resetflags(); 

        lj1.Status__c = 'Open';
        lj1.Tier_2_Assessment__c = 'This is a bug';

        lj2.Status__c = 'On Hold' ;
        lj2.Tier_2_Assessment__c ='This is a bug' ;
        lj2.On_Hold_Reason__c ='Waiting for Development';

        lj3.Status__c = 'On Hold' ;
        lj3.Tier_2_Assessment__c ='This is a bug' ;
        lj3.On_Hold_Reason__c ='Waiting for Pyramid';

        lj4.Status__c = 'On Hold' ;
        lj4.Tier_2_Assessment__c ='This is a bug' ;
        lj4.On_Hold_Reason__c ='Waiting for Client Support Response';

        lj5.Status__c = 'On Hold' ;
        lj5.Tier_2_Assessment__c ='This is a bug' ;
        lj5.On_Hold_Reason__c ='Waiting for Client Response';

        lj6.Status__c = 'Resolved';
        lj6.Tier_2_Assessment__c = 'This is a Bug';
     
        lj7.Status__c = 'Closed';
        lj7.Tier_2_Assessment__c = 'This is a bug';
        lj7.Resolution__c = 'Will Not Fix';

        lj8.Status__c = 'Closed';
        lj8.Tier_2_Assessment__c = 'This is a bug';
        lj8.Resolution__c = 'Functioning as Designed';

        lj9.Status__c = 'Closed';
        lj9.Tier_2_Assessment__c = 'This is a bug';
        lj9.Resolution__c = 'Cannot Reproduce';

        lj10.Status__c = 'Closed';
        lj10.Tier_2_Assessment__c = 'This is a bug';
        lj10.Resolution__c = 'Fixed Released';
       
        silist=new list<learnJIRA__c>();
        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);
        silist.add(lj5);
        silist.add(lj6);
        silist.add(lj7);
        silist.add(lj8);
        silist.add(lj9);
        silist.add(lj10);
        update silist;

        resetflags();
       
        Test.stopTest();

        lj1.Status__c = 'Closed';
        lj1.Tier_2_Assessment__c = 'This is a bug';
        lj1.Resolution__c = 'Duplicate';

        silist=new list<learnJIRA__c>();
        silist.add(lj1);

        update silist;
     }
     static testMethod void AnalyticsSI1()
     {
        Account acc = TestMethodUtility.createAccount();
        insert acc;
        
        Contact con = TestMethodUtility.createContact(acc);
        insert con;
        
        List<Core_License__c> crr = new List<Core_License__c>();

        Core_License__c cr=TestMethodUtility.createCoreLicense();
        cr.Name='Learn';
        crr.add(cr);

        Core_License__c cr1=TestMethodUtility.createCoreLicense();
        cr1.Name='Moodlerooms';
        crr.add(cr1);

        Core_License__c cr2=TestMethodUtility.createCoreLicense();
        cr2.Name='Collaborate';
        crr.add(cr2);

        Core_License__c cr3=TestMethodUtility.createCoreLicense();
        cr3.Name='Analytics';
        crr.add(cr3);
       
        insert crr;

        List<Asset> assetlist = new List<Asset>();

       Asset a = TestMethodUtility.createAsset(acc,cr);
       a.Name = 'testasset';
       a.Contact = con;
       a.Status = 'Installed';
       a.version__c = 'test';
       a.version_build__c='test';
       assetlist.add(a);

       Asset a1 = TestMethodUtility.createAsset(acc,cr1);
       a1.Name = 'testasset';
       a1.Contact = con;
       a1.Status = 'Installed';
       a1.version__c = 'test';
       a1.version_build__c='test';
       assetlist.add(a1);

       Asset a2 = TestMethodUtility.createAsset(acc,cr2);
       a2.Name = 'testasset';
       a2.Contact = con;
       a2.Status = 'Installed';
       a2.version__c = 'test';
       a2.version_build__c='test';
       assetlist.add(a2);

       Asset a3 = TestMethodUtility.createAsset(acc,cr3);
       a3.Name = 'testasset';
       a3.Contact = con;
       a3.Status = 'Installed';
       a3.version__c = 'test';
       a3.version_build__c='test';
       assetlist.add(a3);
      
       insert assetlist;

       List<Module__c> mod = new List<Module__c>();

       Module__c m = TestMethodUtility.createModule(cr);
       mod.add(m);

       Module__c m1 = TestMethodUtility.createModule(cr1);
       mod.add(m1);

       Module__c m2 = TestMethodUtility.createModule(cr2);
       mod.add(m2);

       Module__c m3 = TestMethodUtility.createModule(cr3);
       mod.add(m3);

       insert mod;
        
        list<case> caselist=new list<case>();  

        Case c1 = new Case(ContactId = con.Id,AccountId = acc.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr.Id, Module__c = m.Id,Status = 'New');
        Case c2 = new Case(ContactId = con.Id,AccountId = acc.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr1.Id, Module__c = m1.Id,Status = 'New');
        Case c3 = new Case(ContactId = con.Id,AccountId = acc.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr2.Id, Module__c = m2.Id,Status = 'New');
        Case c4 = new Case(ContactId = con.Id,AccountId = acc.Id,Subject = 'subject',Description = 'description',Steps_to_Replicate__c = 'steps to replicate',Core_License__c = cr3.Id, Module__c = m3.Id,Status = 'New');
        
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);

        insert caselist;

        Test.startTest(); 
         caselist=[select id,casenumber from case limit 4];

         id LNrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Learn').getRecordTypeId();
         id MRrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Moodlerooms').getRecordTypeId();
         id CBrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Collaborate').getRecordTypeId();
         id ANrecordtypeid=Schema.SObjectType.learnJIRA__c.getRecordTypeInfosByName().get('Analytics').getRecordTypeId();

        list<learnJIRA__c> silist=new list<learnJIRA__c>();
        learnJIRA__c lj1= new learnJIRA__c(Name = 'Test',Origin_Case_Number__c = caselist[0].CaseNumber,Master_Case__c=caselist[0].id,OriginCaseID__c = caselist[0].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=LNrecordtypeid);
        learnJIRA__c lj2= new learnJIRA__c(Name = 'Test1',Origin_Case_Number__c = caselist[1].CaseNumber,Master_Case__c=caselist[1].id,OriginCaseID__c = caselist[1].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=MRrecordtypeid);
        learnJIRA__c lj3= new learnJIRA__c(Name = 'Test2',Origin_Case_Number__c = caselist[2].CaseNumber,Master_Case__c=caselist[2].id,OriginCaseID__c = caselist[2].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=CBrecordtypeid);
        learnJIRA__c lj4= new learnJIRA__c(Name = 'Test3',Origin_Case_Number__c = caselist[3].CaseNumber,Master_Case__c=caselist[3].id,OriginCaseID__c = caselist[3].Id,Summary__c = 'Test Summary',Tier_2_Assessment__c = 'This is a Bug',Type__c = 'test',Source__c = 'Test',Reproduced__c = 'Test', Status__c = 'New',recordtypeid=ANrecordtypeid);
     
        silist.add(lj1);
        silist.add(lj2);
        silist.add(lj3);
        silist.add(lj4);

        insert silist; 

        resetflags();

        c1.LearnJIRA_SI__c = lj1.id;
        c2.LearnJIRA_SI__c = lj2.id;
        c3.LearnJIRA_SI__c = lj3.id;
        c4.LearnJIRA_SI__c = lj4.id;
        
        caselist=new list<case>();
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4);

        update caselist;
        resetflags(); 

        c1.Override_Jira_Case_Status__c = true;
        c2.Override_Jira_Case_Status__c = true;
        c3.Override_Jira_Case_Status__c = true;
        c4.Override_Jira_Case_Status__c = true;

        caselist=new list<case>();
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4); 

        update caselist;
        resetflags();

        Test.stopTest();

        c1.Override_Jira_Case_Status__c = false;
        c2.Override_Jira_Case_Status__c = false;
        c3.Override_Jira_Case_Status__c = false;
        c4.Override_Jira_Case_Status__c = false;

        caselist=new list<case>();
        caselist.add(c1);
        caselist.add(c2);
        caselist.add(c3);
        caselist.add(c4); 

        update caselist;








     }


   }