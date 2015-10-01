@istest(seealldata=true)
private class btbb_articleFollowManagementTest
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
    
     known_issue__kav kI=new known_issue__kav(title='test-aa',summary='test-abc',urlname='test-aa',IsVisibleInCsp=true,IsVisibleInPkb=true);
     insert kI;
     
     known_issue__DataCategorySelection KIdata = new known_issue__DataCategorySelection(DataCategoryGroupName='Version',DataCategoryName='Learn',ParentId=KI.id);
     insert KIdata;
     known_issue__kav kI2=[select id,knowledgearticleid from known_issue__kav  where id=:KI.id ];
     
     KbManagement.PublishingService.publishArticle(KI2.knowledgearticleid,true);
  
    
     
     //List of Knowledge Follow object records
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
     
     Insert Lkf;
     
    
     
     
     
      
     Apexpages.StandardController con = new ApexPages.StandardController(kf);
     btbb_articleFollowManagementController Controller = New btbb_articleFollowManagementController(con);
     btbb_articleFollowManagementController Controller1 = New btbb_articleFollowManagementController();
     //This is use to excute wrapper class FollowWrapper
     btbb_articleFollowManagementController.FollowWrapper test = new btbb_articleFollowManagementController.FollowWrapper(kf,True);
     test.updateFollow();
     test.isFollowed=True;
     String ss =test.tooltip;
     
     String Data1=test.linkDisplay;
     String data2=test.styleclass;
     Knowledgearticleversion ver = new knowledgearticleversion();
     
     
     //This is use to excute wrapper class ArticleFollowWrapper
      btbb_articleFollowManagementController.ArticleFollowWrapper test1 = new btbb_articleFollowManagementController.ArticleFollowWrapper(kf,ver);
      test1.followObj=kf1;
      test1.updateFollow();
      test1.isFollowed=True;
      String ss1 =test1.tooltip;
      String Data11=test1.linkDisplay;
      String data21=test1.styleclass;
      test1.isFollowed=false;
      String ss2 =test1.tooltip;
      String Data12=test1.linkDisplay;
      String data22=test1.styleclass;
    // }
   }
}
  }