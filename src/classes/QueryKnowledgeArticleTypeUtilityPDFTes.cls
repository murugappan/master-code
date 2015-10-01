/*
Class:QueryKnowledgeArticleTypeUtilityPDF
*/
@isTest(seealldata=true)
private class QueryKnowledgeArticleTypeUtilityPDFTes {

    static testMethod void myUnitTest() {
       
       
      
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncement('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncement('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncement('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncement('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssue('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssue('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssue('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssue('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResource('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResource('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResource('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResource('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentation('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentation('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentation('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentation('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswer('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswer('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswer('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswer('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryRelease('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryRelease('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryRelease('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryRelease('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceRelease('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceRelease('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceRelease('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceRelease('','');
        
        test.starttest();
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticle('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticle('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticle('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticle('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletin('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletin('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletin('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletin('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnology('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnology('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnology('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnology('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformation('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformation('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformation('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformation('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgram('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgram('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgram('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgram('','');
        test.stoptest();
          
       
    //   QueryKnowledgeArticleTypeUtilityPDF.createList('Learn','',articletpypes);
    //   QueryKnowledgeArticleTypeUtilityPDF.createList('','Learn',articletpypes);
       
       
    }
    
    
    static testMethod void UnitTest2()
    {
        string articletpypes= 'supported_technology,announcement,blackboard_client_program,general_article,known_issue,maintenance_release,other_resource,product_documentation,question_answer,release,support_bulletin,support_bulletin,troubleshooting_information';
       QueryKnowledgeArticleTypeUtilityPDF.createList('Learn','Learn',articletpypes);
       test.starttest();
       QueryKnowledgeArticleTypeUtilityPDF.createList('Learn','Learn','');
       QueryKnowledgeArticleTypeUtilityPDF.createList('','','');
       QueryKnowledgeArticleTypeUtilityPDF.createList('Learn','','');
       QueryKnowledgeArticleTypeUtilityPDF.createList('','Learn','');
       test.stoptest();
    }
    
    static testMethod void UnitTest3() {
       
       
      
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncementSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncementSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncementSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryAnnouncementSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssueSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssueSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssueSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryKnownIssueSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResourceSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResourceSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResourceSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryOtherResourceSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentationSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentationSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentationSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryProductDocumentationSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswerSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswerSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswerSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryQuestionAnswerSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryReleaseSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryReleaseSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryReleaseSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryReleaseSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceReleaseSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceReleaseSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceReleaseSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryMaintenanceReleaseSize('','');
        
        test.starttest();
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticleSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticleSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticleSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryGeneralArticleSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletinSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletinSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletinSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportBulletinSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnologySize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnologySize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnologySize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.querySupportedTechnologySize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformationSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformationSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformationSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryTroubleshootingInformationSize('','');
        
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgramSize('Learn','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgramSize('Learn','');
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgramSize('','Learn');
        QueryKnowledgeArticleTypeUtilityPDF.queryBlackboardClientProgramSize('','');
        test.stoptest();
          
       
    //   QueryKnowledgeArticleTypeUtilityPDF.createList('Learn','',articletpypes);
    //   QueryKnowledgeArticleTypeUtilityPDF.createList('','Learn',articletpypes);
       
       
    }
    
    static testMethod void UnitTest4()
    {
        string articletpypes= 'supported_technology,announcement,blackboard_client_program,general_article,known_issue,maintenance_release,other_resource,product_documentation,question_answer,release,support_bulletin,support_bulletin,troubleshooting_information';
       QueryKnowledgeArticleTypeUtilityPDF.QuerySize('Learn','Learn',articletpypes);
       test.starttest();
       QueryKnowledgeArticleTypeUtilityPDF.QuerySize('Learn','Learn','');
       QueryKnowledgeArticleTypeUtilityPDF.QuerySize('','','');
       QueryKnowledgeArticleTypeUtilityPDF.QuerySize('Learn','','');
       QueryKnowledgeArticleTypeUtilityPDF.QuerySize('','Learn','');
       test.stoptest();
    }
}