/*
Class :ArticleAttachmentController
 */
@isTest(seealldata=True)
private class ArticleAttachmentControllerTest {

    static testMethod void myUnitTest() {
        
        
        Solution s  = new Solution();
        s.SolutionName = 'Test';
        Insert s;
        
        KnowledgeArticleVersion lkav = [SELECT Title,Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Announcement__kav' limit 1];
        
        ApexPages.CurrentPage().getParameters().Put('articleVersionId',lkav.ID);
        ApexPages.CurrentPage().getParameters().Put('articleID',s.ID);
        ApexPages.CurrentPage().getParameters().Put('console','false'); 
        ApexPages.CurrentPage().getParameters().Put('success','true'); 
        ApexPages.StandardController controller = new ApexPages.StandardController(s);  
        ArticleAttachmentController sf = new ArticleAttachmentController(controller);
        sf.getshowAttSec();
        sf.getadmininfo();
        sf.getBucketNames();
        sf.bucketNameToCreate = 'Hello';
        sf.createBucket();
        ApexPages.CurrentPage().getParameters().Put('flname','abc.txt');
        sf.updatefileinfo();
        sf.updatechange();
        sf.updatechange1();
        sf.delCaseAttach();
        sf.getPolicy();
        sf.getSignedPolicy();
        sf.getHexPolicy();
        sf.getShowDone();
        sf.getShowAttach();
        sf.getdisableFileInput();
        sf.getShowDelete();
        ArticleAttachmentController.getCounterString();
        sf.getShowSuccess();
        sf.getUploadCounter(); // Need to update to test Knowledge
        
        
    }
}