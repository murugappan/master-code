/*
Class : QueryKnowledgeArticleListUtility
*/
@isTest(seealldata=True)
private class QueryKnowledgeArticleListUtilityTest {

    static testMethod void myUnitTest() {
        
        

        List<KnowledgeArticleVersion> lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Announcement__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'announcement');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Blackboard_Client_Program__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'blackboard_client_program');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='General_Article__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'general_article');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Known_Issue__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'known_issue');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Other_Resource__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'other_resource');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Product_Documentation__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'product_documentation');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Question_Answer__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'question_answer');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Release__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'release');
        Test.StartTest();
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Support_Bulletin_Security_Advisory__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'support_bulletin');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Supported_Technologies__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'supported_technology');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Troubleshooting_Informational__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'troubleshooting_information');
         lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US'  limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'');
        lkav = [SELECT Title, Summary FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Maintenance_Release__kav' limit 10];
        QueryKnowledgeArticleListUtility.createList(lkav,'maintenance_release');
        
        KnowledgearticleVersion kav =[SELECT Title, Summary,KnowledgeArticleId FROM KnowledgeArticleVersion WHERE PublishStatus='Online' AND Language = 'en_US' and articletype='Maintenance_Release__kav' limit 1];
        
        KnowledgeArticleWrapper str = new KnowledgeArticleWrapper(kav.id,'Test1','test2',kav.KnowledgeArticleId);
        
        list<string> lstr = new List<String>{'Test','Test1'};
        map<String, list<String>> Mstr = new map<String, list<String>>();
        Mstr.put('Test2',lstr);
        
        str.dataCategoryMap=Mstr;
        
        
        QueryKnowledgeArticleListUtility.queryRelatedKnownIssueList(str);
        QueryKnowledgeArticleListUtility.queryServicePackArticleList(str);
        Test.StopTest();
        
        
    }
}