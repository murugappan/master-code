@isTest
private class ViewSurveyControllerTest{

 private static Testmethod void testViewSurveyController() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.getAQuestion();
        System.assert(vsc.allQuestionsSize == 4);
        System.assert(tu.surveyId != null);
    }
    
    private static Testmethod void testUpdateSurveyName() {
      SurveyTestingUtil tu = new SurveyTestingUtil();
      Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
      Apexpages.Standardcontroller stc; 
      ViewSurveyController vsc = new ViewSurveyController(stc);
      vsc.surveyName = 'new name';
      system.assert(vsc.updateSurveyName() == null);
      
  }
  
  private static Testmethod void testupdateSurveyThankYouAndLink() {
    SurveyTestingUtil tu = new SurveyTestingUtil();
    Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
    Apexpages.Standardcontroller stc; 
    ViewSurveyController vsc = new ViewSurveyController(stc);
    vsc.surveyThankYouText = 'new stuff';
    vsc.surveyThankYouURL = 'more new stff';
    system.assert(vsc.updateSurveyThankYouAndLink()==null);
  }
private static Testmethod void testRefreshQuestionList() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.getAQuestion();
        
        // Retrieve questions for this survey
        List<Survey_Question__c> sq = new List<Survey_Question__c>();
        sq = [Select id, orderNumber__c from Survey_Question__c];
        
        // get question with orderNumber 1
        Survey_Question__c first = [Select id, orderNumber__c from Survey_Question__c Where orderNumber__c =: 1 and Survey__c =: tu.surveyId];
        System.assert(first.orderNumber__c == 1 );      
        
        // Specify the new order    
        List<String> newOrder = new List<String>();
        newOrder.add(vsc.allQuestions[2].id);
        newOrder.add(vsc.allQuestions[0].id);
        newOrder.add(vsc.allQuestions[1].id);
        newOrder.add(vsc.allQuestions[3].id);
        
        ViewSurveyController.updateQuestionOrder(newOrder);
        
        // Verify that the question with order 1 is not the same as the one retrieved previously
        Survey_Question__c second = [Select id, orderNumber__c from Survey_Question__c Where orderNumber__c =: 1 and Survey__c =: tu.surveyId];
        System.assert(second.id != first.id);
        
        // update the question list, and make sure it has been modified as well
        vsc.refreshQuestionList();
        System.assert(vsc.allQuestions[1].id != first.id);
        
    }
     private static TestMethod void testGetResponses() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.getAQuestion();

        List<String> resp = new List<String>();
        resp.add('one');
        resp.add('two');
        resp.add(tu.contactId);
        resp.add(tu.surveyId);
        resp.add('NONE');
        System.assert('true'==ViewSurveyController.getResponses(resp));
        
    }
     private static testmethod void testResultAndThankYouPage(){
        SurveyTestingUtil tu = new SurveyTestingUtil();
      Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
      Apexpages.Standardcontroller stc; 
      ViewSurveyController vsc = new ViewSurveyController(stc);
      vsc.getAQuestion();
      System.assert(vsc.resultPage() != null);
      System.assert(vsc.thankYouPage() != null);
        
    }
    
     private static testmethod void testDeleteRefresh(){
    SurveyTestingUtil tu = new SurveyTestingUtil();
      Apexpages.currentPage().getParameters().put('id',tu.surveyId);  
      Apexpages.Standardcontroller stc; 
      ViewSurveyController vsc = new ViewSurveyController(stc);
      System.assert(null==vsc.deleteRefresh());
  }
  
   private static TestMethod void testDeleteQuestion() {
        SurveyTestingUtil tu = new SurveyTestingUtil();
        Apexpages.currentPage().getParameters().put('id',tu.surveyId);
        Apexpages.Standardcontroller stc;   
        ViewSurveyController vsc = new ViewSurveyController(stc);
        vsc.getAQuestion();
        
        // Get a question to delete
        Survey_Question__c sq = [Select id, orderNumber__c from Survey_Question__c Where orderNumber__c =: 1 and Survey__c =: tu.surveyId];
        ViewSurveyController.deleteQuestion(sq.id);
        List<Survey_Question__c> sqs = [Select id, orderNumber__c from Survey_Question__c Where Survey__c =: tu.surveyId];
        for (Survey_Question__c s: sqs)
            System.assert(s.OrderNumber__c != 1);
        //List<question> listQ = new List<question>();
        //listQ = vsc.getAQuestion();
    }
    
    

}