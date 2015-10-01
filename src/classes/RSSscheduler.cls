global class RSSscheduler implements Schedulable{

      list<string> generalarticles = new list<string>{'General_Article__kav','Known_Issue__kav','Other_Resource__kav','Process_Procedure__kav',
                                  'Product_Documentation__kav','Question_Answer__kav','Supported_Technologies__kav','Supported_Technologies__kav',
                                    'Troubleshooting_Informational__kav','Blackboard_Client_Program__kav'};
      
       global void execute(SchedulableContext SC) {
            RSSscheduler M = new RSSscheduler();
            M.DeleteRSS();
          list<knowledgeRSS__c> RSSList=new  list<knowledgeRSS__c>();
          RSSList.addAll(sbsatype () );
          RSSList.addAll(Releasetype () );
          RSSList.addAll(Announcementtype () );
          RSSList.addAll(Generallist () );
          RSSList.addall(KnownIssue ());
          insert RSSList;
          
         
       }
    
    
        public void DeleteRSS(){
        List<knowledgeRSS__c> deleteRSS = [select id from knowledgeRSS__c ] ;
        delete deleteRSS;
        
        }
        
        
        
       public list<knowledgeRSS__c> sbsatype () 
       {
           list<knowledgeRSS__c> RSSlist =new list<knowledgeRSS__c>();
           list<Support_Bulletin_Security_Advisory__kav> sbsaLearnlist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Support_Bulletin_Security_Advisory__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Support_Bulletin_Security_Advisory__kav k :sbsaLearnlist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='LearnALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='sbsa'));
               } 
                                               
            list<Support_Bulletin_Security_Advisory__kav> sbsaAngellist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Support_Bulletin_Security_Advisory__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Angel__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Support_Bulletin_Security_Advisory__kav k :sbsaAngellist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='AngelALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='sbsa'));
               }  
               
              list<Support_Bulletin_Security_Advisory__kav> sbsaXythoslist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Support_Bulletin_Security_Advisory__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Support_Bulletin_Security_Advisory__kav k :sbsaXythoslist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='XythosALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='sbsa'));
               }   
               
               list<Support_Bulletin_Security_Advisory__kav> sbsaCElist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Support_Bulletin_Security_Advisory__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Support_Bulletin_Security_Advisory__kav k :sbsaCElist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='CE_VistaALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='sbsa'));
               }  
              return    RSSlist;                                     
                                                   
       }
       
       
       public list<knowledgeRSS__c> Releasetype () 
       {
           list<knowledgeRSS__c> RSSlist =new list<knowledgeRSS__c>();
           list<Release__kav> ReleaseLearnlist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Release__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Release__kav k :ReleaseLearnlist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='LearnALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Release'));
               } 
                                               
            list<Release__kav> ReleaseAngellist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Release__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Angel__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Release__kav k :ReleaseAngellist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='AngelALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Release'));
               }  
               
              list<Release__kav> ReleaseXythoslist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Release__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Release__kav k :ReleaseXythoslist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='XythosALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Release'));
               }   
               
               list<Release__kav> ReleaseCElist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Release__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Release__kav k :ReleaseCElist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='CE_VistaALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Release'));
               }  
              return    RSSlist;                                     
                                                   
       }
        
        
        public list<knowledgeRSS__c> Announcementtype () 
       {
           list<knowledgeRSS__c> RSSlist =new list<knowledgeRSS__c>();
           list<Announcement__kav> AnnouncementLearnlist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Announcement__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Announcement__kav k :AnnouncementLearnlist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='LearnALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Announcement'));
               } 
                                               
            list<Announcement__kav> AnnouncementAngellist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Announcement__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Angel__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Announcement__kav k : AnnouncementAngellist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='AngelALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Announcement'));
               }  
               
              list<Announcement__kav> AnnouncementXythoslist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Announcement__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Announcement__kav k :AnnouncementXythoslist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='XythosALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Announcement'));
               }   
               
               list<Announcement__kav> AnnouncementCElist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Announcement__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Announcement__kav k :AnnouncementCElist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='CE_VistaALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='Announcement'));
               }  
              return    RSSlist;                                     
                                                   
       }
       
       
        public list<knowledgeRSS__c> KnownIssue () 
       {
           list<knowledgeRSS__c> RSSlist =new list<knowledgeRSS__c>();
           list<Known_Issue__kav> KnownIssueLearnlist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Known_Issue__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Known_Issue__kav k :KnownIssueLearnlist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='LearnALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='KI'));
               } 
                                               
            list<Known_Issue__kav> KnownIssueAngellist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Known_Issue__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Angel__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Known_Issue__kav k : KnownIssueAngellist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='AngelALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='KI'));
               }  
               
              list<Known_Issue__kav> KnownIssueXythoslist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Known_Issue__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Known_Issue__kav k :KnownIssueXythoslist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='XythosALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='KI'));
               }   
               
               list<Known_Issue__kav>KnownIssueCElist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Known_Issue__kav Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Known_Issue__kav k :KnownIssueCElist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='CE_VistaALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='KI'));
               }  
              return    RSSlist;                                     
                                                   
       }
        
        public list<knowledgeRSS__c> Generallist () 
       {
           list<knowledgeRSS__c> RSSlist =new list<knowledgeRSS__c>();
           list<Knowledgearticleversion> GeneralLearnlist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Knowledgearticleversion Where (PublishStatus ='online' And Language ='en_US') 
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Knowledgearticleversion k :GeneralLearnlist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='LearnALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='General'));
               } 
                                               
            list<Knowledgearticleversion> GeneralAngellist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Knowledgearticleversion Where (PublishStatus ='online' And Language ='en_US')  
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Angel__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Knowledgearticleversion k :GeneralAngellist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='AngelALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='General'));
               }  
               
              list<Knowledgearticleversion> GeneralXythoslist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Knowledgearticleversion Where (PublishStatus ='online' And Language ='en_US')  
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Knowledgearticleversion k :GeneralXythoslist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='XythosALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='General'));
               }   
               
               list<Knowledgearticleversion> GeneralCElist= [Select Title, Summary, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber  
                                                                    From Knowledgearticleversion Where (PublishStatus ='online' And Language ='en_US')
                                                                      WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c Order by LastPublishedDate desc limit 50 ];
        
               
               for(Knowledgearticleversion k :GeneralCElist )  
               {
                RSSList.add(new KnowledgeRSS__c(title__c=k.title,Summary__c=k.summary,Product__c='CE_VistaALL',LastPublished__c=k.LastPublishedDate,
                             ArticleNumber__c=k.Articlenumber,Article_Id__c=k.KnowledgeArticleId,AritclType__c='General'));
               }  
              return    RSSlist;                                     
                                                   
       } 
}