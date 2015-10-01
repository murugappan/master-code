/*
Class:QueryKnowledgeArticleTypeUtilityPDF
*/
@isTest(seealldata=true)
public class QueryKnowledgeArticleTypeUtilityTest{
    static testMethod void myUnitTest() {
       
       
      
        QueryKnowledgeArticleTypeUtility.queryAnnouncement('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryAnnouncement('Learn','');
        QueryKnowledgeArticleTypeUtility.queryAnnouncement('','Learn');
        QueryKnowledgeArticleTypeUtility.queryAnnouncement('','');
        
        QueryKnowledgeArticleTypeUtility.queryKnownIssue('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryKnownIssue('Learn','');
        QueryKnowledgeArticleTypeUtility.queryKnownIssue('','Learn');
        QueryKnowledgeArticleTypeUtility.queryKnownIssue('','');
        
        QueryKnowledgeArticleTypeUtility.queryOtherResource('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryOtherResource('Learn','');
        QueryKnowledgeArticleTypeUtility.queryOtherResource('','Learn');
        QueryKnowledgeArticleTypeUtility.queryOtherResource('','');
        
        QueryKnowledgeArticleTypeUtility.queryProductDocumentation('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryProductDocumentation('Learn','');
        QueryKnowledgeArticleTypeUtility.queryProductDocumentation('','Learn');
        QueryKnowledgeArticleTypeUtility.queryProductDocumentation('','');
        
        QueryKnowledgeArticleTypeUtility.queryQuestionAnswer('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryQuestionAnswer('Learn','');
        QueryKnowledgeArticleTypeUtility.queryQuestionAnswer('','Learn');
        QueryKnowledgeArticleTypeUtility.queryQuestionAnswer('','');
        
        QueryKnowledgeArticleTypeUtility.queryRelease('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryRelease('Learn','');
        QueryKnowledgeArticleTypeUtility.queryRelease('','Learn');
        QueryKnowledgeArticleTypeUtility.queryRelease('','');
        
        QueryKnowledgeArticleTypeUtility.queryMaintenanceRelease('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryMaintenanceRelease('Learn','');
        QueryKnowledgeArticleTypeUtility.queryMaintenanceRelease('','Learn');
        QueryKnowledgeArticleTypeUtility.queryMaintenanceRelease('','');
        
        test.starttest();
        QueryKnowledgeArticleTypeUtility.queryGeneralArticle('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryGeneralArticle('Learn','');
        QueryKnowledgeArticleTypeUtility.queryGeneralArticle('','Learn');
        QueryKnowledgeArticleTypeUtility.queryGeneralArticle('','');
        
        QueryKnowledgeArticleTypeUtility.querySupportBulletin('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.querySupportBulletin('Learn','');
        QueryKnowledgeArticleTypeUtility.querySupportBulletin('','Learn');
        QueryKnowledgeArticleTypeUtility.querySupportBulletin('','');
        
        QueryKnowledgeArticleTypeUtility.querySupportedTechnology('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.querySupportedTechnology('Learn','');
        QueryKnowledgeArticleTypeUtility.querySupportedTechnology('','Learn');
        QueryKnowledgeArticleTypeUtility.querySupportedTechnology('','');
        
        QueryKnowledgeArticleTypeUtility.queryTroubleshootingInformation('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryTroubleshootingInformation('Learn','');
        QueryKnowledgeArticleTypeUtility.queryTroubleshootingInformation('','Learn');
        QueryKnowledgeArticleTypeUtility.queryTroubleshootingInformation('','');
        
        QueryKnowledgeArticleTypeUtility.queryBlackboardClientProgram('Learn','Learn');
        QueryKnowledgeArticleTypeUtility.queryBlackboardClientProgram('Learn','');
        QueryKnowledgeArticleTypeUtility.queryBlackboardClientProgram('','Learn');
        QueryKnowledgeArticleTypeUtility.queryBlackboardClientProgram('','');
        test.stoptest();
          
       
    //   QueryKnowledgeArticleTypeUtilityPDF.createList('Learn','',articletpypes);
    //   QueryKnowledgeArticleTypeUtilityPDF.createList('','Learn',articletpypes);
       
       
    }
    
    
    static testMethod void UnitTest2()
    {
        string articletpypes= 'supported_technology,announcement,blackboard_client_program,general_article,known_issue,maintenance_release,other_resource,product_documentation,question_answer,release,support_bulletin,support_bulletin,troubleshooting_information';
       QueryKnowledgeArticleTypeUtility.createList('Learn','Learn',articletpypes);
       test.starttest();
       QueryKnowledgeArticleTypeUtility.createList('Learn','Learn','');
       QueryKnowledgeArticleTypeUtility.createList('','','');
       QueryKnowledgeArticleTypeUtility.createList('Learn','','');
       QueryKnowledgeArticleTypeUtility.createList('','Learn','');
       test.stoptest();
    }
    
   
}