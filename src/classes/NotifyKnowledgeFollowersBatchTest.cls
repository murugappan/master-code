@istest

 Private class NotifyKnowledgeFollowersBatchTest
  {
    Static Testmethod void UnitTest()
     {
     
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
      KbManagement.PublishingService.publishArticle(kI3.knowledgearticleid,true);
     List<Knowledge_Follow__c> Lkf = new List<Knowledge_Follow__c>();
     
     Knowledge_Follow__c kf = new Knowledge_Follow__c();
     kf.User__c=userinfo.getuserid();
     kf.Following_Key__c=KI2.knowledgearticleid;
     kf.Type__c = 'Knowledge Article';
     Lkf.add(kf);
     
   Knowledge_Follow__c kf1 = new Knowledge_Follow__c();
     kf1.User__c=userinfo.getuserid();
     kf1.Following_Key__c='Known Issue';
     kf1.Type__c = 'Article Type'; 
     kf1.Product__c='Learn';
     Lkf.add(kf1); 
 
  Knowledge_Follow__c kf3 = new Knowledge_Follow__c();
     kf3.User__c=userinfo.getuserid();
     kf3.Following_Key__c=KI3.knowledgearticleid;
     kf3.Type__c = 'Knowledge Article';
     Lkf.add(kf3);
     
     Insert Lkf; 
     
     
       Test.StartTest();
      knowledgearticleversion kav = new knowledgearticleversion();
     
       NotifyKnowledgeFollowersBatch  Controller = new NotifyKnowledgeFollowersBatch(1);   
       ID batchprocessid = Database.executeBatch(Controller);
        
        
       Test.StopTest();
      }
  }
  Static Testmethod void UnitTestURLMethod(){
     Profile p=[select id from Profile where Name='System Administrator'];
    //user
    user u =TestMethodUtility.createUser(p);
    u.UserPermissionsKnowledgeUser=True;
    insert u;
    
    System.RunAs(u)
    {
      test.StartTest();
      string SiteURL='https://blackboard--dvx.cs23.my.salesforce.com';


      NotifyKnowledgeFollowersBatch  Controller = new NotifyKnowledgeFollowersBatch(1); 
      
       ID batchprocessid = Database.executeBatch(Controller);
       test.StopTest();
  


    }

  }       
 }