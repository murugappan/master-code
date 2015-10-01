public with sharing class QueryKnowledgeArticleTypeUtility 
{
	public static list<KnowledgeArticleWrapper> queryAnnouncement(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Announcement__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Announcement__kav(Title, Summary, Solution_Published_Date__c, Related_Link_s__c, Product__c,LastPublishedDate, KnowledgeArticleId, Id, ' + 
    						'ArticleNumber, Announcement_Details__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Announcement__kav(Title, Summary, Solution_Published_Date__c, Related_Link_s__c, Product__c,LastPublishedDate, KnowledgeArticleId, Id, ' + 
    						'ArticleNumber, Announcement_Details__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Announcement__kav>((list<Announcement__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT Title, Summary, Solution_Published_Date__c, Related_Link_s__c, Product__c,LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber, ' + 
						'Announcement_Details__c ' + 
						'FROM Announcement__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT Title, Summary, Solution_Published_Date__c, Related_Link_s__c, Product__c,LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber, ' + 
						'Announcement_Details__c ' + 
						'FROM Announcement__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Announcement__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Announcement__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Announcement__DataCategorySelection>> dcsMap = new map<Id, list<Announcement__DataCategorySelection>>();
			
			for (Announcement__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
															From Announcement__DataCategorySelection a
															Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Announcement__DataCategorySelection[]{dcs});
				}
			}
			
			for (Announcement__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Announcement';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Announcement__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.detail = k.Announcement_Details__c;
				mainArticle.relatedLinks = k.Related_Link_s__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryKnownIssue(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Known_Issue__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Known_Issue__kav(Title, Target_Release__c, Symptoms__c, Summary, Steps_to_Replicate__c, Service_Packs__c, Resolution_Workaround__c, ' + 
    						'Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, ' + 
    						'Issue_Description__c, Id, Cause__c, Best_Practice_Information__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Known_Issue__kav(Title, Target_Release__c, Symptoms__c, Summary, Steps_to_Replicate__c, Service_Packs__c, Resolution_Workaround__c, ' + 
    						'Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, ' + 
    						'Issue_Description__c, Id, Cause__c, Best_Practice_Information__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Known_Issue__kav>((list<Known_Issue__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT Title, Target_Release__c, Symptoms__c, Summary, Steps_to_Replicate__c, Service_Packs__c, Resolution_Workaround__c, ' + 
    						'Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, ' + 
    						'Issue_Description__c, Id, Cause__c, Best_Practice_Information__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'FROM Known_Issue__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT Title, Target_Release__c, Symptoms__c, Summary, Steps_to_Replicate__c, Service_Packs__c, Resolution_Workaround__c, ' + 
    						'Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, ' + 
    						'Issue_Description__c, Id, Cause__c, Best_Practice_Information__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'FROM Known_Issue__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			system.debug(queryString);
    			list<Known_Issue__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Known_Issue__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Known_Issue__DataCategorySelection>> dcsMap = new map<Id, list<Known_Issue__DataCategorySelection>>();
			
			for (Known_Issue__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
														   From Known_Issue__DataCategorySelection a
														   Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else if (dcsMap.size() < 1000)
				{
					dcsMap.put(dcs.ParentId, new Known_Issue__DataCategorySelection[]{dcs});
				}
			}
			
			for (Known_Issue__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Known Issue';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Known_Issue__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Packs__c;
				system.debug(k.Issue_Description__c);
				mainArticle.issueDescription = k.Issue_Description__c;
				mainArticle.stepsToReproduce = k.Steps_to_Replicate__c;
				mainArticle.symptoms = k.Symptoms__c;
				mainArticle.cause = k.Cause__c;
				mainArticle.resolutionWorkaround = k.Resolution_Workaround__c;
				mainArticle.bestPracticeInformation = k.Best_Practice_Information__c;
				mainArticle.targetRelease = k.Target_Release__c;
				mainArticle.patchAvailable = k.Patch_Available__c;
				mainArticle.patchVersions = k.Patch_Versions__c;
				mainArticle.patchComments = k.Patch_Information__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryOtherResource(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Other_Resource__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Other_Resource__kav(Title, Summary, Resource_Type__c, Resource_Link__c, Resource_Description__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Important_Information__c, Id, FirstPublishedDate, Download__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Other_Resource__kav(Title, Summary, Resource_Type__c, Resource_Link__c, Resource_Description__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Important_Information__c, Id, FirstPublishedDate, Download__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Other_Resource__kav>((list<Other_Resource__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT Title, Summary, Resource_Type__c, Resource_Link__c, Resource_Description__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Important_Information__c, Id, FirstPublishedDate, Download__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'FROM Other_Resource__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT Title, Summary, Resource_Type__c, Resource_Link__c, Resource_Description__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Important_Information__c, Id, FirstPublishedDate, Download__c, ArticleNumber, Solution_Published_Date__c ' + 
    					'FROM Other_Resource__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Other_Resource__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Other_Resource__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Other_Resource__DataCategorySelection>> dcsMap = new map<Id, list<Other_Resource__DataCategorySelection>>();
			
			for (Other_Resource__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
															  From Other_Resource__DataCategorySelection a
															  Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Other_Resource__DataCategorySelection[]{dcs});
				}
			}
			
			for (Other_Resource__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Other Resource';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Other_Resource__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.resourceType = k.Resource_Type__c;
				mainArticle.resourceDescription = k.Resource_Description__c;
				mainArticle.importantInformation = k.Important_Information__c;
				mainArticle.resourceLink = k.Resource_Link__c;
				mainArticle.download = k.Download__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryProductDocumentation(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Product_Documentation__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Product_Documentation__kav(Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Resource_Type__c, Release__c, Product__c, ' + 
    						'Patch_Versions__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Document_Type__c, Document_Summary__c, ' + 
    						'Document_Link__c, Document_Details__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Product_Documentation__kav(Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Resource_Type__c, Release__c, Product__c, ' + 
    						'Patch_Versions__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Document_Type__c, Document_Summary__c, ' + 
    						'Document_Link__c, Document_Details__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Product_Documentation__kav>((list<Product_Documentation__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Resource_Type__c, Release__c, Product__c, ' + 
    						'Patch_Versions__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Document_Type__c, Document_Summary__c, ' + 
    						'Document_Link__c, Document_Details__c, ArticleNumber ' + 
    					'FROM Product_Documentation__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Resource_Type__c, Release__c, Product__c, ' + 
    						'Patch_Versions__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Document_Type__c, Document_Summary__c, ' + 
    						'Document_Link__c, Document_Details__c, ArticleNumber ' + 
    					'FROM Product_Documentation__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Product_Documentation__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Product_Documentation__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Product_Documentation__DataCategorySelection>> dcsMap = new map<Id, list<Product_Documentation__DataCategorySelection>>();
			
			for (Product_Documentation__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																	 From Product_Documentation__DataCategorySelection a 
																	 Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Product_Documentation__DataCategorySelection[]{dcs});
				}
			}
			
			for (Product_Documentation__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Product Documentation';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Product_Documentation__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Pack_s__c;
				mainArticle.documentType = k.Document_Type__c;
				mainArticle.documentSummary = k.Document_Summary__c;
				mainArticle.documentDetail = k.Document_Details__c;
				mainArticle.documentLink = k.Document_Link__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryQuestionAnswer(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Question_Answer__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Question_Answer__kav(UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Question__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Id, ArticleNumber, Answer__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Question_Answer__kav(UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Question__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Id, ArticleNumber, Answer__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Question_Answer__kav>((list<Question_Answer__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Question__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Id, ArticleNumber, Answer__c ' + 
    					'FROM Question_Answer__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Question__c, Product__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Id, ArticleNumber, Answer__c ' + 
    					'FROM Question_Answer__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Question_Answer__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Question_Answer__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Question_Answer__DataCategorySelection>> dcsMap = new map<Id, list<Question_Answer__DataCategorySelection>>();
			
			for (Question_Answer__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
															   From Question_Answer__DataCategorySelection a 
															   Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Question_Answer__DataCategorySelection[]{dcs});
				}
			}
			
			for (Question_Answer__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Question/Answer';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Question_Answer__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Pack_s__c;
				mainArticle.question = k.Question__c;
				mainArticle.answer = k.Answer__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryRelease(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Release__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Release__kav(UrlName, Upgrade_Paths__c, Title, Support_Policy__c, Summary, Solution_Published_Date__c, Release__c, ' + 
    						'Reference_Material__c,Product__c, OwnerId, Other_Information__c, LastPublishedDate, KnowledgeArticleId, Id, Highlights__c, ' + 
    						'Download__c, ArticleNumber, About__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Release__kav(UrlName, Upgrade_Paths__c, Title, Support_Policy__c, Summary, Solution_Published_Date__c, Release__c, ' + 
    						'Reference_Material__c,Product__c, OwnerId, Other_Information__c, LastPublishedDate, KnowledgeArticleId, Id, Highlights__c, ' + 
    						'Download__c, ArticleNumber, About__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Release__kav>((list<Release__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Upgrade_Paths__c, Title, Support_Policy__c, Summary, Solution_Published_Date__c, Release__c, ' + 
    						'Reference_Material__c,Product__c, OwnerId, Other_Information__c, LastPublishedDate, KnowledgeArticleId, Id, Highlights__c, ' + 
    						'Download__c, ArticleNumber, About__c ' + 
    					'FROM Release__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Upgrade_Paths__c, Title, Support_Policy__c, Summary, Solution_Published_Date__c, Release__c, ' + 
    						'Reference_Material__c,Product__c, OwnerId, Other_Information__c, LastPublishedDate, KnowledgeArticleId, Id, Highlights__c, ' + 
    						'Download__c, ArticleNumber, About__c ' + 
    					'FROM Release__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Release__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Release__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Release__DataCategorySelection>> dcsMap = new map<Id, list<Release__DataCategorySelection>>();
			
			for (Release__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
													   From Release__DataCategorySelection a 
													   Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Release__DataCategorySelection[]{dcs});
				}
			}
			
			for (Release__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Release';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Release__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				// Missing field mainArticle.servicePacks
				// Missing field mainArticle.upgradeInformation
				mainArticle.upgradePaths = k.Upgrade_Paths__c;
				// This field is missing mainArticle.productDocumentation
				mainArticle.referenceMaterial = k.Reference_Material__c;
				mainArticle.otherInformation = k.Other_Information__c;
				mainArticle.download = k.Download__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryMaintenanceRelease(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Maintenance_Release__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Maintenance_Release__kav(UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Release_Highlights__c, ' + 
    						'Release_Date__c, Related_Resources__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber, Announcing__c, ' + 
    						'Accessing_the_Build__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Maintenance_Release__kav(UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Release_Highlights__c, ' + 
    						'Release_Date__c, Related_Resources__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber, Announcing__c, ' + 
    						'Accessing_the_Build__c ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Maintenance_Release__kav>((list<Maintenance_Release__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Release_Highlights__c, ' + 
    						'Release_Date__c, Related_Resources__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber, Announcing__c, ' + 
    						'Accessing_the_Build__c ' + 
    					'FROM Maintenance_Release__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, Release_Highlights__c, ' + 
    						'Release_Date__c, Related_Resources__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber, Announcing__c, ' + 
    						'Accessing_the_Build__c ' + 
    					'FROM Maintenance_Release__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Maintenance_Release__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Maintenance_Release__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Maintenance_Release__DataCategorySelection>> dcsMap = new map<Id, list<Maintenance_Release__DataCategorySelection>>();
			
			for (Maintenance_Release__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																   From Maintenance_Release__DataCategorySelection a 
																   Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Maintenance_Release__DataCategorySelection[]{dcs});
				}
			}
			
			for (Maintenance_Release__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Maintenance Release';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Maintenance_Release__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Pack_s__c;
				mainArticle.releaseDate = k.Release_Date__c;
				mainArticle.announcing = k.Announcing__c;
				mainArticle.releaseHighlights = k.Release_Highlights__c;
				mainArticle.upgradePaths = k.Upgrade_Paths__c;
				mainArticle.releaseResources = k.Related_Resources__c;
				mainArticle.accessingTheBuild = k.Accessing_the_Build__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryGeneralArticle(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, General_Article__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'General_Article__kav(UrlName, Title, Target_Release__c, Symptoms__c, Summary, Solution_Published_Date__c, Service_Pack_s__c, ' + 
    						'Resolution_Workaround__c, Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Issue_Description__c, Id, FirstPublishedDate, Cause__c, Best_Practice_Information__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'General_Article__kav(UrlName, Title, Target_Release__c, Symptoms__c, Summary, Solution_Published_Date__c, Service_Pack_s__c, ' + 
    						'Resolution_Workaround__c, Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Issue_Description__c, Id, FirstPublishedDate, Cause__c, Best_Practice_Information__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, General_Article__kav>((list<General_Article__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Title, Target_Release__c, Symptoms__c, Summary, Solution_Published_Date__c, Service_Pack_s__c, ' + 
    						'Resolution_Workaround__c, Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Issue_Description__c, Id, FirstPublishedDate, Cause__c, Best_Practice_Information__c, ArticleNumber ' + 
    					'FROM General_Article__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Title, Target_Release__c, Symptoms__c, Summary, Solution_Published_Date__c, Service_Pack_s__c, ' + 
    						'Resolution_Workaround__c, Release__c, Product__c, Patch_Versions__c, Patch_Information__c, Patch_Available__c, LastPublishedDate, ' + 
    						'KnowledgeArticleId, Issue_Description__c, Id, FirstPublishedDate, Cause__c, Best_Practice_Information__c, ArticleNumber ' + 
    					'FROM General_Article__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<General_Article__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, General_Article__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<General_Article__DataCategorySelection>> dcsMap = new map<Id, list<General_Article__DataCategorySelection>>();
			
			for (General_Article__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
															   From General_Article__DataCategorySelection a
															   Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new General_Article__DataCategorySelection[]{dcs});
				}
			}
			
			for (General_Article__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'General Article';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (General_Article__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Pack_s__c;
				mainArticle.issueDescription = k.Issue_Description__c;
				mainArticle.symptoms = k.Symptoms__c;
				mainArticle.cause = k.Cause__c;
				mainArticle.resolutionWorkaround = k.Resolution_Workaround__c;
				mainArticle.bestPracticeInformation = k.Best_Practice_Information__c;
				mainArticle.targetRelease = k.Target_Release__c;
				mainArticle.patchAvailable = k.Patch_Available__c;
				mainArticle.patchVersions = k.Patch_Versions__c;
				mainArticle.patchComments = k.Patch_Information__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> querySupportBulletin(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Support_Bulletin_Security_Advisory__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Support_Bulletin_Security_Advisory__kav(UrlName, Type__c, Title, Summary, Solution_Published_Date__c, Product__c, Patch_Versions__c, ' + 
    						'Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Bulletin_Advisory_Information__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Support_Bulletin_Security_Advisory__kav(UrlName, Type__c, Title, Summary, Solution_Published_Date__c, Product__c, Patch_Versions__c, ' + 
    						'Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Bulletin_Advisory_Information__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Support_Bulletin_Security_Advisory__kav>((list<Support_Bulletin_Security_Advisory__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Type__c, Title, Summary, Solution_Published_Date__c, Product__c, Patch_Versions__c, ' + 
    						'Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Bulletin_Advisory_Information__c, ArticleNumber ' + 
    					'FROM Support_Bulletin_Security_Advisory__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Type__c, Title, Summary, Solution_Published_Date__c, Product__c, Patch_Versions__c, ' + 
    						'Patch_Information__c, Patch_Available__c, LastPublishedDate, KnowledgeArticleId, Id, Bulletin_Advisory_Information__c, ArticleNumber ' + 
    					'FROM Support_Bulletin_Security_Advisory__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			system.debug(queryString);
    			list<Support_Bulletin_Security_Advisory__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Support_Bulletin_Security_Advisory__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Support_Bulletin_Security_Advisory__DataCategorySelection>> dcsMap = new map<Id, list<Support_Bulletin_Security_Advisory__DataCategorySelection>>();
			
			for (Support_Bulletin_Security_Advisory__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																				  From Support_Bulletin_Security_Advisory__DataCategorySelection a 
																				  Where ParentId =: kavMap.keySet()])
			{
				system.debug(dcs);
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Support_Bulletin_Security_Advisory__DataCategorySelection[]{dcs});
				}
			}
			
			for (Support_Bulletin_Security_Advisory__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Support Bulletin/Security Advisory';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
				
				system.debug(dcsMap);
				if (dcsMap.containsKey(k.Id))
				{
					for (Support_Bulletin_Security_Advisory__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.bulletinAdvisoryInformation = k.Bulletin_Advisory_Information__c;
				mainarticle.typeC = k.Type__c;
				mainArticle.patchAvailable = k.Patch_Available__c;
				mainArticle.patchVersions = k.Patch_Versions__c;
				mainArticle.patchComments = k.Patch_Information__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> querySupportedTechnology(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Supported_Technologies__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Supported_Technologies__kav(UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Product__c, Platform_Technologies__c, LastPublishedDate, KnowledgeArticleId, Id, Client_Technologies__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Supported_Technologies__kav(UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Product__c, Platform_Technologies__c, LastPublishedDate, KnowledgeArticleId, Id, Client_Technologies__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Supported_Technologies__kav>((list<Supported_Technologies__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Product__c, Platform_Technologies__c, LastPublishedDate, KnowledgeArticleId, Id, Client_Technologies__c, ArticleNumber ' + 
    					'FROM Supported_Technologies__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Upgrade_Paths__c, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Product__c, Platform_Technologies__c, LastPublishedDate, KnowledgeArticleId, Id, Client_Technologies__c, ArticleNumber ' + 
    					'FROM Supported_Technologies__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Supported_Technologies__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Supported_Technologies__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Supported_Technologies__DataCategorySelection>> dcsMap = new map<Id, list<Supported_Technologies__DataCategorySelection>>();
			
			for (Supported_Technologies__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																	  From Supported_Technologies__DataCategorySelection a 
																	  Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Supported_Technologies__DataCategorySelection[]{dcs});
				}
			}
			
			for (Supported_Technologies__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Supported Technologies';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Supported_Technologies__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Pack_s__c;
				mainArticle.platformTechnologies = k.Platform_Technologies__c;
				mainArticle.clientTechnologies = k.Client_Technologies__c;
				mainArticle.upgradePaths = k.Upgrade_Paths__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryTroubleshootingInformation(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Troubleshooting_Informational__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Troubleshooting_Informational__kav(UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Related_System_Information__c, Product__c, LastPublishedDate, KnowledgeArticleId, Introduction__c, Functionality__c, ' +  
							'Evaluating_Related_System_Info__c, Common_Issues__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Troubleshooting_Informational__kav(UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Related_System_Information__c, Product__c, LastPublishedDate, KnowledgeArticleId, Introduction__c, Functionality__c, ' +  
							'Evaluating_Related_System_Info__c, Common_Issues__c, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Troubleshooting_Informational__kav>((list<Troubleshooting_Informational__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Related_System_Information__c, Product__c, LastPublishedDate, KnowledgeArticleId, Introduction__c, Functionality__c, ' +  
							'Evaluating_Related_System_Info__c, Common_Issues__c, ArticleNumber ' + 
    					'FROM Troubleshooting_Informational__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Title, Summary, Solution_Published_Date__c, Service_Pack_s__c, Release__c, ' + 
    						'Related_System_Information__c, Product__c, LastPublishedDate, KnowledgeArticleId, Introduction__c, Functionality__c, ' +  
							'Evaluating_Related_System_Info__c, Common_Issues__c, ArticleNumber ' + 
    					'FROM Troubleshooting_Informational__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Troubleshooting_Informational__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Troubleshooting_Informational__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Troubleshooting_Informational__DataCategorySelection>> dcsMap = new map<Id, list<Troubleshooting_Informational__DataCategorySelection>>();
			
			for (Troubleshooting_Informational__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																			 From Troubleshooting_Informational__DataCategorySelection a 
																			 Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Troubleshooting_Informational__DataCategorySelection[]{dcs});
				}
			}
			
			for (Troubleshooting_Informational__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Troubleshooting Informational';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Troubleshooting_Informational__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.release = k.Release__c;
				mainArticle.servicePacks = k.Service_Pack_s__c;
				mainArticle.introduction = k.Introduction__c;
				mainArticle.functionality = k.Functionality__c;
				mainArticle.relatedSystemInformation = k.Related_System_Information__c;
				mainArticle.evaluatingRelatedSystemInfo = k.Evaluating_Related_System_Info__c;
				mainArticle.commonIssues = k.Common_Issues__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryBlackboardClientProgram(String searchText, String categoryFilter)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		map<Id, Blackboard_Client_Program__kav> kavMap;
		String queryString;
		
		try 
  		{
  			if (searchText != null && searchText.length() > 0) 
    		{
    			if (categoryFilter != null && categoryFilter != '') 
   				{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Blackboard_Client_Program__kav(UrlName, Title, Summary, Solution_Published_Date__c, Section_4__c, Section_3__c, Section_2__c, ' + 
    						'Section_1__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
    			}
    			else
    			{
    				queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING ' + 
    					'Blackboard_Client_Program__kav(UrlName, Title, Summary, Solution_Published_Date__c, Section_4__c, Section_3__c, Section_2__c, ' + 
    						'Section_1__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
    					'where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
    			}
    			list<list<SObject>>searchList = search.query(queryString);
    			kavMap = new map<Id, Blackboard_Client_Program__kav>((list<Blackboard_Client_Program__kav>)searchList[0]);
    		}
			else 
			{
				if (categoryFilter != null && categoryFilter != '') 
   				{
					queryString = 'SELECT UrlName, Title, Summary, Solution_Published_Date__c, Section_4__c, Section_3__c, Section_2__c, ' + 
    						'Section_1__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
    					'FROM Blackboard_Client_Program__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
   				}
   				else 
    			{
    				queryString = 'SELECT UrlName, Title, Summary, Solution_Published_Date__c, Section_4__c, Section_3__c, Section_2__c, ' + 
    						'Section_1__c, Product__c, LastPublishedDate, KnowledgeArticleId, Id, ArticleNumber ' + 
    					'FROM Blackboard_Client_Program__kav ' + 
						'WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';	
    			}
    			list<Blackboard_Client_Program__kav> articleList = Database.query(queryString);
    			kavMap = new map<Id, Blackboard_Client_Program__kav>(articleList);
			}      
   		} 
   		catch (Exception e) {}
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Blackboard_Client_Program__DataCategorySelection>> dcsMap = new map<Id, list<Blackboard_Client_Program__DataCategorySelection>>();
			
			for (Blackboard_Client_Program__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																		 From Blackboard_Client_Program__DataCategorySelection a 
																		 Where ParentId =: kavMap.keySet()])
			{
				if (dcsMap.containsKey(dcs.ParentId))
				{
					dcsMap.get(dcs.ParentId).add(dcs);
				}
				else
				{
					dcsMap.put(dcs.ParentId, new Blackboard_Client_Program__DataCategorySelection[]{dcs});
				}
			}
			
			for (Blackboard_Client_Program__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = 'Blackboard Client Program';
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
				if (dcsMap.containsKey(k.Id))
				{
					for (Blackboard_Client_Program__DataCategorySelection dcs : dcsMap.get(k.Id))
					{
						if (mainArticle.dataCategoryMap.containsKey(dcs.DataCategoryGroupName))
						{
							mainArticle.dataCategoryMap.get(dcs.DataCategoryGroupName).add(dcs.DataCategoryName);
						}
						else
						{
							mainArticle.dataCategoryMap.put(dcs.DataCategoryGroupName, new String[]{dcs.DataCategoryName});
						}
					}
				}
				
				mainArticle.product = k.Product__c;
				mainArticle.field1 = k.Section_1__c;
				mainArticle.field2 = k.Section_2__c;
				mainArticle.field3 = k.Section_3__c;
				mainArticle.field4 = k.Section_4__c;
				kavWrapperList.add(mainArticle);
			}
		}
		
		return kavWrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> createList(String searchText, String categoryFilter, String selectedArticleTypes)
	{
		list<KnowledgeArticleWrapper> wrapperList = new list<KnowledgeArticleWrapper>();
		list<KnowledgeArticleVersion> articleList;
		
		if (selectedArticleTypes != null && selectedArticleTypes != '')
		{
			if (selectedArticleTypes.contains('announcement'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryAnnouncement(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('blackboard_client_program'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryBlackboardClientProgram(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('general_article'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryGeneralArticle(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('known_issue'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryKnownIssue(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('maintenance_release'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryMaintenanceRelease(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('other_resource'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryOtherResource(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('product_documentation'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryProductDocumentation(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('question_answer'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryQuestionAnswer(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('release'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryRelease(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('support_bulletin'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.querySupportBulletin(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('supported_technology'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.querySupportedTechnology(searchText, categoryFilter));
			}
			if (selectedArticleTypes.contains('troubleshooting_information'))
			{
				wrapperList.addAll(QueryKnowledgeArticleTypeUtility.queryTroubleshootingInformation(searchText, categoryFilter));
			}
		}
		else
 		{
	 		try 
	  		{
	  			String queryString;
	  			
	  			if (searchText != null && searchText.length() > 0) 
	    		{
	    			if (categoryFilter != null && categoryFilter != '') 
	   				{
	   					queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName, LastPublishedDate, LastModifiedById, KnowledgeArticleId, Summary, ArticleNumber where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200';
	     				
	   				}
	   				else
	   				{
	   					queryString = 'FIND \'' + searchText + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName, LastPublishedDate,LastModifiedById, KnowledgeArticleId, Summary, ArticleNumber where PublishStatus =\'online\' and Language = \'en_US\') limit 200';
	   				}
	   				list<list<SObject>>searchList = search.query(queryString);
	     			articleList = (list<KnowledgeArticleVersion>)searchList[0];
	    		}
	    		else
	    		{
	    			if (categoryFilter != null && categoryFilter != '') 
	   				{
	   					queryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById, KnowledgeArticleId, Summary, ArticleNumber FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + categoryFilter + ' limit 200'; 
	   				}
	   				else
	   				{
	   					queryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById, KnowledgeArticleId, Summary, ArticleNumber FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') limit 200';
	   				}
	   				articleList = Database.query(queryString);
	    		}
	    		
	    		map<Id, KnowledgeArticleVersion> kavMap = new map<Id, KnowledgeArticleVersion>(articleList);
	    		
	    		wrapperList.addAll(QueryKnowledgeArticleListUtility.queryAnnouncement('Announcement', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryBlackboardClientProgram('Blackboard Client Program', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryGeneralArticle('General Article', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryKnownIssue('Known Issue', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryMaintenanceRelease('Maintenance Release', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryOtherResource('Other Resource', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryProductDocumentation('Product Documentation', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryQuestionAnswer('Question/Answer', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryRelease('Release', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.querySupportBulletin('Support Bulletin', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.querySupportedTechnology('Supported Technology', kavMap.keySet()));
				wrapperList.addAll(QueryKnowledgeArticleListUtility.queryTroubleshootingInformation('Troubleshooting Information', kavMap.keySet()));
	   		} 
	   		catch (Exception e) {}
 		}
		return wrapperList;
	}
}