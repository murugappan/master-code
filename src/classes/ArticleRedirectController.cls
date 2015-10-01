public with sharing class ArticleRedirectController 
{
	private String recordId;
	private map<String, Schema.SOBjectType> globalDescribeMap = Schema.getGlobalDescribe();
	private map<String, String> articlePrefixLabelMap;
	
	public ArticleRedirectController()
	{
		recordId = ApexPages.currentPage().getParameters().get('id');
		loadArticleTypes();
	}
	
	public PageReference redirect()
	{
		PageReference pageRef;
		
		if (recordId != null)
		{
			try
			{
				KnowledgeArticleVersion kav = loadArticleVersion(recordId);
				String prefix, articleLabel, versionId;
				versionId = kav.Id;
				prefix = versionId.substring(0, 3);
				if (articlePrefixLabelMap.containsKey(prefix))
				{
					articleLabel = articlePrefixLabelMap.get(prefix);
					articleLabel = articleLabel.replaceAll(' ', '_');
					articleLabel = articleLabel.replaceAll('/', '_');
					pageRef = new PageReference('/articles/' + articleLabel + '/' + kav.UrlName);
					pageRef.getParameters().put('popup', 'true');
					pageRef.setRedirect(true);
				}
				else
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This is not a valid knowledge article.'));
				}
			}
			catch (Queryexception e)
			{
				try
				{
					Solution s = loadSolution();
					try
					{
						system.debug(s.Knowledge_Article_ID__c);
						KnowledgeArticleVersion kav = loadArticleVersion(s.Knowledge_Article_ID__c);
						String prefix, articleLabel, versionId;
						versionId = kav.Id;
						prefix = versionId.substring(0, 3);
						if (articlePrefixLabelMap.containsKey(prefix))
						{
							articleLabel = articlePrefixLabelMap.get(prefix);
							articleLabel = articleLabel.replaceAll(' ', '_');
							articleLabel = articleLabel.replaceAll('/', '_');
							pageRef = new PageReference('/articles/' + articleLabel + '/' + kav.UrlName);
							pageRef.setRedirect(true);
						}
						else
						{
							ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This solution does not have a valid article.'));
						}
					}
					catch (Queryexception e1)
					{
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This solution does not have a matching Knowledge Article.'));
					}
				}
				catch (Queryexception e2)
				{
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'This is not a valid solution article.'));
				}
			}
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There is no Article Id for this page.'));
		}
		
		return pageRef;
	}
	
	private void loadArticleTypes()
	{
		list<String> articleTypeNameList = new list<String>();
    	articlePrefixLabelMap = new map<String, String>();
    	
        for (String s : globalDescribeMap.keySet()) 
        {
        	if (s.endswith('__kav')) 
          	{
          		articleTypeNameList.add(s);
          		Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
          		articlePrefixLabelMap.put(r.getKeyPrefix(), r.getLabel());
          	}
        }        
	}
	
	private KnowledgeArticleVersion loadArticleVersion(String articleId)
	{
		return [Select KnowledgeArticleId, Title, ArticleNumber, Summary, UrlName 
            	From KnowledgeArticleVersion 
            	Where IsVisibleInCsp = true
            	And KnowledgeArticleId =: articleId
            	And PublishStatus = 'Online'
            	And Language = 'en_US'];
	}
	
	private Solution loadSolution()
	{
		return [Select Id, SolutionNumber, Knowledge_Article_ID__c From Solution Where Id =: recordId];
	}
}