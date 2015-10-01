@istest
private class publickbarticleviewTest {
    static testmethod void publickbarticleviewTest ()
    {
    publickbarticleview controller = new publickbarticleview(); 
    controller.loadArticleTypes();
    controller.loadArticleVersion();
    controller.loadArticle();
    controller.laodFeedbackOptionList();
    //controller.loadCaseAttachmentList();
    /*controller.loadFeeback();
    controller.loadCase(); 
    controller.addFeedback();
    
    controller.attachArticleToCase();
    controller.closeCaseWithArticle();
    controller.closeCase();
    controller.attachArticle();
    controller.rejectArticle();*/
    controller.getFollowDisplay();
    //controller.doFollow(); 
    
    
          
          
   }
}