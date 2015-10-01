/*
Class :ArticleRedirectController
*/
@isTest(seealldata=True)
private class ArticleRedirectControllerTest {

    static testMethod void myUnitTest() {
        
        
         KnowledgeArticleVersion lkav = [SELECT Title,KnowledgeArticleId,Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Announcement__kav' limit 1];
         
         
         
         ApexPages.currentPage().getParameters().Put('id',lkav.KnowledgeArticleId);
        
         ArticleRedirectController  Con = new  ArticleRedirectController();
         con.redirect(); 

	    
	    Test.StartTest();
	    // Solution
	    Solution s  = new Solution();
	    s.SolutionName = 'Test';
	    s.Knowledge_Article_ID__c=lkav.KnowledgeArticleId;
	    Insert s;      
         
         ApexPages.currentPage().getParameters().Put('id',s.id);
         
         ArticleRedirectController  Con1 = new  ArticleRedirectController();
         con1.redirect(); 
         Test.StopTest();
        
    }
}