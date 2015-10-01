public with sharing class QueryKnowledgeArticleListUtility 
{
	public static list<KnowledgeArticleWrapper> createList(list<KnowledgeArticleVersion> kavList, String selectedArticleTypes)
	{
		list<KnowledgeArticleWrapper> wrapperList = new list<KnowledgeArticleWrapper>();
		if (kavList != null && !kavList.isEmpty())
		{
			map<Id, KnowledgeArticleVersion> kavMap = new map<Id, KnowledgeArticleVersion>(kavList);
			
			if (selectedArticleTypes != null && selectedArticleTypes != '')
			{
				if (selectedArticleTypes.contains('announcement'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryAnnouncement('Announcement', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('blackboard_client_program'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryBlackboardClientProgram('Blackboard Client Program', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('general_article'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryGeneralArticle('General Article', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('known_issue'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryKnownIssue('Known Issue', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('maintenance_release'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryMaintenanceRelease('Maintenance Release', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('other_resource'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryOtherResource('Other Resource', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('product_documentation'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryProductDocumentation('Product Documentation', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('question_answer'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryQuestionAnswer('Question/Answer', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('release'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryRelease('Release', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('support_bulletin'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.querySupportBulletin('Support Bulletin', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('supported_technology'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.querySupportedTechnology('Supported Technology', kavMap.keySet()));
				}
				if (selectedArticleTypes.contains('troubleshooting_information'))
				{
					wrapperList.addAll(QueryKnowledgeArticleListUtility.queryTroubleshootingInformation('Troubleshooting Information', kavMap.keySet()));
				}
			}
			else
			{
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
		}
		return wrapperList;
	}
	
	public static list<KnowledgeArticleWrapper> queryAnnouncement(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Announcement__kav> kavMap = new map<Id, Announcement__kav>([Select a.Title, a.Summary, a.Solution_Published_Date__c, a.Related_Link_s__c, a.Product__c,a.LastPublishedDate, 
																				   a.KnowledgeArticleId, a.Id, a.ArticleNumber, a.Announcement_Details__c 
									 										From Announcement__kav a
									 										Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryKnownIssue(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Known_Issue__kav> kavMap = new map<Id, Known_Issue__kav>([Select k.Title, k.Target_Release__c, k.Symptoms__c, k.Summary, k.Steps_to_Replicate__c, 
																				 k.Service_Packs__c, k.Resolution_Workaround__c, k.Release__c, k.Product__c, k.Patch_Versions__c, 
																				 k.Patch_Information__c, k.Patch_Available__c, k.LastPublishedDate, k.KnowledgeArticleId, 
																				 k.Issue_Description__c, k.Id, k.Cause__c, k.Best_Practice_Information__c, k.ArticleNumber,
																				 k.Solution_Published_Date__c
								   										  From Known_Issue__kav k 
								   										  Where Id IN : kavIdSet]);
									 
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
				else
				{
					dcsMap.put(dcs.ParentId, new Known_Issue__DataCategorySelection[]{dcs});
				}
			}
			
			for (Known_Issue__kav k : kavMap.values())
			{
				mainArticle = new KnowledgeArticleWrapper(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
				mainArticle.articleType = articleType;
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
				mainArticle.versions = k.Service_Packs__c;
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
	
	public static list<KnowledgeArticleWrapper> queryOtherResource(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Other_Resource__kav> kavMap = new map<Id, Other_Resource__kav>([Select o.Title, o.Summary, o.Resource_Type__c, o.Resource_Link__c, o.Resource_Description__c, 
																					   o.Product__c, o.LastPublishedDate, o.KnowledgeArticleId, o.Important_Information__c, o.Id, 
																					   o.FirstPublishedDate, o.Download__c, o.ArticleNumber, o.Solution_Published_Date__c
										 										From Other_Resource__kav o
									 											Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryProductDocumentation(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Product_Documentation__kav> kavMap = new map<Id, Product_Documentation__kav>([Select p.Title, p.Summary, p.Solution_Published_Date__c, p.Service_Pack_s__c, 
																									 p.Resource_Type__c, p.Release__c, p.Product__c, p.Patch_Versions__c, 
																									 p.Patch_Available__c, p.LastPublishedDate, p.KnowledgeArticleId, p.Id, 
																									 p.Document_Type__c, p.Document_Summary__c, p.Document_Link__c, p.Document_Details__c, 
																									 p.ArticleNumber
											 												  From Product_Documentation__kav p 
											 												  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryQuestionAnswer(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Question_Answer__kav> kavMap = new map<Id, Question_Answer__kav>([Select q.UrlName, q.Title, q.Summary, q.Solution_Published_Date__c, q.Service_Pack_s__c, q.Release__c, 
																						 q.Question__c, q.Product__c, q.LastPublishedDate, q.KnowledgeArticleId, q.Id, q.ArticleNumber, 
																						 q.Answer__c 
									   											  From Question_Answer__kav q 
									   											  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryRelease(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Release__kav> kavMap = new map<Id, Release__kav>([Select r.UrlName, r.Upgrade_Paths__c, r.Title, r.Support_Policy__c, r.Summary, r.Solution_Published_Date__c, 
																		 r.Release__c, r.Reference_Material__c,r.Product__c, r.OwnerId, r.Other_Information__c, r.LastPublishedDate, 
																		 r.KnowledgeArticleId, r.Id, r.Highlights__c, r.Download__c, r.ArticleNumber, r.About__c 
							  									  From Release__kav r 
							  									  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryMaintenanceRelease(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Maintenance_Release__kav> kavMap = new map<Id, Maintenance_Release__kav>([Select m.UrlName, m.Upgrade_Paths__c, m.Title, m.Summary, m.Solution_Published_Date__c, 
												  												 m.Service_Pack_s__c, m.Release__c, m.Release_Highlights__c, m.Release_Date__c, 
												  												 m.Related_Resources__c, m.Product__c, m.LastPublishedDate, m.KnowledgeArticleId, m.Id, 
												  												 m.ArticleNumber, m.Announcing__c, m.Accessing_the_Build__c 
										   												  From Maintenance_Release__kav m 
										   												  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryGeneralArticle(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, General_Article__kav> kavMap = new map<Id, General_Article__kav>([Select g.UrlName, g.Title, g.Target_Release__c, g.Symptoms__c, g.Summary, g.Solution_Published_Date__c,
											  											 g.Service_Pack_s__c, g.Resolution_Workaround__c, g.Release__c, g.Product__c, g.Patch_Versions__c, 
											  											 g.Patch_Information__c, g.Patch_Available__c, g.LastPublishedDate, g.KnowledgeArticleId, 
											  											 g.Issue_Description__c, g.Id, g.FirstPublishedDate, g.Cause__c, g.Best_Practice_Information__c, 
											  											 g.ArticleNumber
									   											  From General_Article__kav g 
									   											  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> querySupportBulletin(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Support_Bulletin_Security_Advisory__kav> kavMap = new map<Id, Support_Bulletin_Security_Advisory__kav>([Select s.UrlName, s.Type__c, s.Title, s.Summary, 
																															   s.Solution_Published_Date__c, s.Product__c, 
																															   s.Patch_Versions__c, s.Patch_Information__c, 
																															   s.Patch_Available__c, s.LastPublishedDate, s.KnowledgeArticleId, 
																															   s.Id, s.Bulletin_Advisory_Information__c, s.ArticleNumber
																														From Support_Bulletin_Security_Advisory__kav s 
																														Where Id IN : kavIdSet]);
									 
		if (kavMap != null && !kavMap.isEmpty())
		{
			map<Id, list<Support_Bulletin_Security_Advisory__DataCategorySelection>> dcsMap = new map<Id, list<Support_Bulletin_Security_Advisory__DataCategorySelection>>();
			
			for (Support_Bulletin_Security_Advisory__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
																				  From Support_Bulletin_Security_Advisory__DataCategorySelection a 
																				  Where ParentId =: kavMap.keySet()])
			{
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
				mainArticle.articleType = articleType;
				mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
				if (k.Solution_Published_Date__c != null)
				{
					Date solDate = k.Solution_Published_Date__c;
					mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
				}
				mainArticle.dataCategoryMap = new map<String, list<String>>();
			
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
	
	public static list<KnowledgeArticleWrapper> querySupportedTechnology(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Supported_Technologies__kav> kavMap = new map<Id, Supported_Technologies__kav>([Select s.UrlName, s.Upgrade_Paths__c, s.Title, s.Summary, s.Solution_Published_Date__c, 
													 												   s.Service_Pack_s__c, s.Release__c, s.Product__c, s.Platform_Technologies__c, 
													 												   s.LastPublishedDate, s.KnowledgeArticleId, s.Id, s.Client_Technologies__c, 
													 												   s.ArticleNumber
											  													From Supported_Technologies__kav s 
											  													Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryTroubleshootingInformation(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Troubleshooting_Informational__kav> kavMap = new map<Id, Troubleshooting_Informational__kav>([Select t.UrlName, t.Title, t.Summary, t.Solution_Published_Date__c, 
																													 t.Service_Pack_s__c, t.Release__c, t.Related_System_Information__c, 
																													 t.Product__c, t.LastPublishedDate, t.KnowledgeArticleId, 
																													 t.Introduction__c, t.Functionality__c, 
																													 t.Evaluating_Related_System_Info__c, t.Common_Issues__c, 
																													 t.ArticleNumber
																											  From Troubleshooting_Informational__kav t 
																											  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryBlackboardClientProgram(String articleType, set<Id> kavIdSet)
	{
		list<KnowledgeArticleWrapper> kavWrapperList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		map<Id, Blackboard_Client_Program__kav> kavMap = new map<Id, Blackboard_Client_Program__kav>([Select b.UrlName, b.Title, b.Summary, b.Solution_Published_Date__c, 
																											 b.Section_4__c, b.Section_3__c, b.Section_2__c, b.Section_1__c, 
																											 b.Product__c, b.LastPublishedDate, b.KnowledgeArticleId, b.Id, 
																											 b.ArticleNumber 
																									  From Blackboard_Client_Program__kav b 
																									  Where Id IN : kavIdSet]);
									 
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
				mainArticle.articleType = articleType;
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
	
	public static list<KnowledgeArticleWrapper> queryRelatedKnownIssueList(KnowledgeArticleWrapper kaw)
	{
		String categoryFilter = '';
		list<KnowledgeArticleWrapper> kawList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		if (kaw.dataCategoryMap != null && !kaw.dataCategoryMap.isEmpty())
		{
			for (String s : kaw.dataCategoryMap.keySet())
 			{
 				for (String s1 : kaw.dataCategoryMap.get(s))
 				{
 					if (categoryFilter == '')
	    			{
	     				categoryFilter = s + '__c AT ' + s1 +'__c';
	    			} 
	    			else 
	    			{
	     				categoryFilter = categoryFilter + ' AND ' + s + '__c AT ' + s1  +'__c';
	    			}
 				}
 			}
 			
 			try
			{
				String qryString = 'SELECT Id, title, UrlName, ArticleNumber, KnowledgeArticleId, LastPublishedDate, LastModifiedById FROM Known_Issue__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY '+categoryFilter; 
     			list<Known_Issue__kav> articleList = Database.query(qryString);
     			if (articleList != null && !articleList.isEmpty())
     			{
     				for (Known_Issue__kav ki : articleList)
     				{
     					mainArticle = new KnowledgeArticleWrapper(ki.Id, ki.Title, ki.ArticleNumber, ki.KnowledgeArticleId);
						mainArticle.lastPublishedDate = ki.LastPublishedDate;
						kawList.add(mainArticle);
     				}
     			}
     			else
     			{
     				return null;
     			}
     			
				return kawList;
			}
			catch (Queryexception e)
			{
				return null;
			}
		}
		
		return null;
	}
	
	public static list<KnowledgeArticleWrapper> queryServicePackArticleList(KnowledgeArticleWrapper kaw)
	{
		String categoryFilter = '';
		list<KnowledgeArticleWrapper> kawList = new list<KnowledgeArticleWrapper>();
		KnowledgeArticleWrapper mainArticle;
		
		if (kaw.dataCategoryMap != null && !kaw.dataCategoryMap.isEmpty())
		{
			for (String s : kaw.dataCategoryMap.keySet())
 			{
 				for (String s1 : kaw.dataCategoryMap.get(s))
 				{
 					if (categoryFilter == '')
	    			{
	     				categoryFilter = s + '__c AT ' + s1 +'__c';
	    			} 
	    			else 
	    			{
	     				categoryFilter = categoryFilter + ' AND ' + s + '__c AT ' + s1  +'__c';
	    			}
 				}
 			}
 			
 			try
			{
				String qryString = 'SELECT Id, title, UrlName, ArticleNumber, KnowledgeArticleId, LastPublishedDate, LastModifiedById FROM Maintenance_Release__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + 
					categoryFilter + 'Order by LastPublishedDate desc'; 
     			list<Maintenance_Release__kav> articleList = Database.query(qryString);
     			if (articleList != null && !articleList.isEmpty())
     			{
     				for (Maintenance_Release__kav mr : articleList)
     				{
     					mainArticle = new KnowledgeArticleWrapper(mr.Id, mr.Title, mr.ArticleNumber, mr.KnowledgeArticleId);
						mainArticle.lastPublishedDate = mr.LastPublishedDate;
						kawList.add(mainArticle);
     				}
     			}
     			else
     			{
     				return null;
     			}
     			
				return kawList;
			}
			catch (Queryexception e)
			{
				return null;
			}
		}
		return null;
	}
}