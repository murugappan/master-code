@istest
private with sharing class btbbpublichomeControllertest{

     static testmethod void unittest1(){
     
         PageReference page = new PageReference('/apex/btbb_publichome');
         Test.setCurrentPage(page);   
     
         
         
         Account ac=TestMethodUtility.createAccount();
         ac.Name='bucknell university';
         insert ac;
         // Insert the list of Univs
          List<Univs__c> LUnivs = New List<Univs__c>();
          Univs__c  U1 = new Univs__c ( Name = 'bucknell university', Website__c='test.com', Account__c=ac.id, View_Count__c=2.0, Client_Id__c=3, Active__c=true, Page_Text__c='testtest', HTML_Text__c='testtesttest');
          Univs__c  U2 = new Univs__c ( Name = 'bucknell university', Website__c='test.com', Account__c=ac.id, View_Count__c=2.0, Client_Id__c=3, Active__c=true, Page_Text__c='testtest');
          Univs__c  U3= new Univs__c ( Name = 'bucknell university',Account__c=ac.id, View_Count__c=2.0, Client_Id__c=3, Active__c=true, Page_Text__c='testtest', HTML_Text__c='testtesttest');
          LUnivs.Add(U1);
          LUnivs.Add(U2);
          LUnivs.Add(U3);
          Insert LUnivs;
          // Insert after Insertion of Univs
          btbbpublichomeController home = new btbbpublichomeController();
          home.tp='bucknell university';
          home.getsupport();
          
          home.SearchInstitutionHelpDesk();
          List<Solution>  tempp=home.getKIArticles();
          home.getSBSAArticles();
          home.getPRIArticles();
          home.getAllArticles();
          list<BtBb_Link__c> servcelinks=home.SelfServicelinks;
          list<BtBb_Link__c> Communitylinks=home.Communitylinks;
          home.recentArticles();
          home.getArticleCategories();
          home.closeannouncement();
          home.getsupport(); 
          home.createcaseredirect();
          home.SearchKnowledgeBase();
          home.getmaxsize();
          home.refreshSearchResult();
          home.loadarticle();
         
         
          
         BtBb_Announcement__c ancmnt= new BtBb_Announcement__c(Corelicense__c='Collaborate',Detail__c='test',TimeStamp__c=system.now(),Title__c='Collaboratetest',portal__c ='UnAuthenticated',isactive__c=true);
         insert ancmnt;

         list<btbb_link__c> servcelinks1=home.SelfServicelinks;
         list<btbb_link__c> Communitylinks1=home.communitylinks;
         home.selectedproduct='Collaborate';
         home.getannouncement();
         home.closeannouncement();
         home.getannouncement();
       
         BtBb_Announcement__c ancmnt2= new BtBb_Announcement__c(Corelicense__c='Collaborate',Detail__c='test',TimeStamp__c=system.now().adddays(2),Title__c='Collaboratetest',portal__c ='UnAuthenticated',isactive__c=true);
         insert ancmnt2;
   
    
        list<btbb_link__c> servcelinks2=home.SelfServicelinks;
        list<btbb_link__c> Communitylinks2=home.communitylinks;
        home.selectedproduct='Collaborate';
        home.recentarticles();
        home.getannouncement();
        home.selectedproduct='Learn';
        home.getannouncement();
        home.selectedproduct='All';
        home.recentarticles();
       
        BtBb_Announcement__c ancmnt3= new BtBb_Announcement__c(Corelicense__c='Collaborate',Detail__c='test',TimeStamp__c=system.now().adddays(2),Title__c='Collaboratetest',portal__c ='UnAuthenticated',isactive__c=true);
        insert ancmnt3;
          
        list<btbb_link__c> servcelinks3=home.SelfServicelinks;
        list<btbb_link__c> Communitylinks3=home.communitylinks;
        home.selectedproduct='Collaborate';
        home.recentarticles();
        home.getannouncement();
        home.selectedproduct='CE/Vista';
        home.getannouncement();
        home.selectedproduct='All';
        home.recentarticles();
         
        
        
        // TO excute Learn part
         ApexPages.currentPage().getParameters().put('dfprod','learn');
         btbbpublichomeController home1 = new btbbpublichomeController(); 
         Test.Starttest();
        // TO excute Mobile part
         ApexPages.currentPage().getParameters().put('dfprod','Mobile');
         btbbpublichomeController home2 = new btbbpublichomeController(); 
         // TO excute collaborate part
         ApexPages.currentPage().getParameters().put('dfprod','collaborate');
         btbbpublichomeController home3 = new btbbpublichomeController(); 
         Test.StopTest();  
          
     }



}