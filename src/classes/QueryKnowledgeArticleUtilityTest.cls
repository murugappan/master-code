/*
Test Class for QueryKnowledgeArticleUtility
*/
@isTest(seealldata=True)
public class QueryKnowledgeArticleUtilityTest {
	
	static testmethod void unittest1()
	{
		knowledgearticleversion kav=[select id  from knowledgearticleversion where articletype='Announcement__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryAnnouncement('Announcement', kav);
		  
		 kav=[select id  from knowledgearticleversion where articletype='Known_Issue__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryKnownIssue('Known Issue', kav);
		  
		 kav=[select id  from knowledgearticleversion where articletype='Other_Resource__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryOtherResource('Other Resource', kav);
		  
		 kav=[select id  from knowledgearticleversion where articletype='Product_Documentation__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryProductDocumentation('Product Documentation', kav);
		  
		 kav=[select id  from knowledgearticleversion where articletype='Question_Answer__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryQuestionAnswer('Announcement', kav);
		  
		kav=[select id  from knowledgearticleversion where articletype='Release__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryRelease('Announcement', kav);
		  
		 kav=[select id  from knowledgearticleversion where articletype='Maintenance_Release__kav' and publishstatus='online' and language='en_US' limit 1];
		  knowledgearticlewrapper kaw=QueryKnowledgeArticleUtility.queryMaintenanceRelease('Announcement', kav);
		  
		 kav=[select id  from knowledgearticleversion where articletype='General_Article__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryGeneralArticle('Announcement', kav); 
		  
		kav=[select id  from knowledgearticleversion where articletype='Support_Bulletin_Security_Advisory__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.querySupportBulletin('Announcement', kav); 
		  
		kav=[select id  from knowledgearticleversion where articletype='Supported_Technologies__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.querySupportedTechnology('Announcement', kav); 
		  
		kav=[select id  from knowledgearticleversion where articletype='Troubleshooting_Informational__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryTroubleshootingInformation('Announcement', kav);  
		  
		kav=[select id  from knowledgearticleversion where articletype='Blackboard_Client_Program__kav' and publishstatus='online' and language='en_US' limit 1];
		  QueryKnowledgeArticleUtility.queryBlackboardClientProgram('Announcement', kav);
		
		  QueryKnowledgeArticleUtility.queryRelatedKnownIssueList(kaw);
		  QueryKnowledgeArticleUtility.queryResolvedIssuesList(kaw);
		   QueryKnowledgeArticleUtility.queryServicePackArticleList(kaw);
		
	}
	

}