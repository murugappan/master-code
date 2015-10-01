@istest(seealldata=true)

 Private class KipublishstatusTest
  {
    Static Testmethod void UnitTest()
     {
     /*
      //Profile
    Profile p=[select id from Profile where Name='System Administrator'];
    //user
    user u =TestMethodUtility.createUser(p);
    u.UserPermissionsKnowledgeUser=True;
    insert u;
    
    System.RunAs(u)
    {
      //List of Knowledge Follow object records
      known_issue__kav kI=new known_issue__kav(title='test-aa',summary='test-abc',urlname='test-aa',IsVisibleInCsp=true,IsVisibleInPkb=true);
  //   KI.selectDataCategory('Version','Learn');
      insert kI;
       known_issue__kav k2=new known_issue__kav(title='test-aad',summary='test-abcd',urlname='test-aad',IsVisibleInCsp=true,IsVisibleInPkb=true);
      insert k2; 
      list <known_issue__DataCategorySelection> KIdatalist= new list <known_issue__DataCategorySelection>();
      known_issue__DataCategorySelection KIdata = new known_issue__DataCategorySelection(DataCategoryGroupName='Version',DataCategoryName='Learn',ParentId=KI.id);
        KIdatalist.add(KIdata);
       known_issue__DataCategorySelection KIdata2 = new known_issue__DataCategorySelection(DataCategoryGroupName='Version',DataCategoryName='Learn',ParentId=K2.id);
      KIdatalist.add(KIdata2);
      insert KIdatalist;
      known_issue__kav kI2=[select id,knowledgearticleid from known_issue__kav  where id=:KI.id ];
      known_issue__kav kI3=[select id,knowledgearticleid from known_issue__kav  where id=:K2.id ];
    
     KbManagement.PublishingService.publishArticle(KI2.knowledgearticleid,true);
     
      Account a = TestMethodUtility.createAccount();
        insert a;
        Core_License__c cl = TestMethodUtility.createCoreLicense();
        insert cl;
        Contact con = TestMethodUtility.createContact(a);
        insert con;
        Module__c m = TestMethodUtility.createModule(cl);
        insert m;
        Case c = TestMethodUtility.createCase(con, cl, a, m);
        insert c;       
        learnJIRA__c lj = TestMethodUtility.createSupportIncident(c);
        insert lj;
        lj.Article_Id__c=KI2.knowledgearticleid;
        update lj;
   
      Test.StartTest();
      Kipublishstatus testrun = new Kipublishstatus(); 
     String jobId = System.schedule('testBasicScheduledApex','00 00 06 6 11 ? 2022',testrun);
     CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];

   Test.StopTest();
     }*/
     }
  }