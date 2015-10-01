public without sharing class KnowledgeArticleWrapper implements Comparable
{
	public Id articleId {get; set;} // Same as KnowledgeArticleVersion.Id
	public String name {get; set;}
	public String articleNumber {get; set;}
	public Id knowledgeArticleId {get; set;}
	public map<String, list<String>> dataCategoryMap {get; set;}
	public String articleType {get; set;}
	public Datetime lastKnowledgePublishedDate {get; set;}
	public Datetime lastSolutionPublishedDate {get; set;}
	public String product {get; set;}
	public String detail {get; set;}
	public String relatedLinks {get; set;}
	public String release {get; set;}
	public String servicePacks {get; set;}
	public String issueDescription {get; set;}
	public String stepsToReproduce {get; set;}
	public String symptoms {get; set;}
	public String cause {get; set;}
	public String resolutionWorkaround {get; set;}
	public String bestPracticeInformation {get; set;}
	public String targetRelease {get; set;}
	public String patchAvailable {get; set;}
	public String patchVersions {get; set;}
	public String patchComments {get; set;}
	public String resourceType {get; set;}
	public String resourceDescription {get; set;}
	public String importantInformation {get; set;}
	public String resourceLink {get; set;}
	public String download {get; set;}
	public String documentType {get; set;}
	public String documentSummary {get; set;}
	public String documentDetail {get; set;}
	public String documentLink {get; set;}
	public String question {get; set;}
	public String answer {get; set;}
	public String upgradeInformation {get; set;}
	public String upgradePaths {get; set;}
	public String productDocumentation {get; set;}
	public String referenceMaterial {get; set;}
	public String otherInformation {get; set;}
	public String bulletinAdvisoryInformation {get; set;}
	public String typeC {get; set;}
	public String platformTechnologies {get; set;}
	public String clientTechnologies {get; set;}
	public String introduction {get; set;}
	public String functionality {get; set;}
	public String relatedSystemInformation {get; set;}
	public String evaluatingRelatedSystemInfo {get; set;}
	public String commonIssues {get; set;}
	public Date releaseDate {get; set;}
	public String announcing {get; set;}
	public String releaseHighlights {get; set;}
	public String releaseResources {get; set;}
	public String accessingTheBuild {get; set;}
	public String field1 {get; set;}
	public String field2 {get; set;}
	public String field3 {get; set;}
	public String field4 {get; set;}
	public Datetime lastPublishedDate
	{
		get
		{
			Datetime migrationDate = Datetime.newInstance(2012, 8, 10);
			if (lastSolutionPublishedDate == null)
			{
				return lastKnowledgePublishedDate;
			}
			if (lastKnowledgePublishedDate != null && lastKnowledgePublishedDate.isSameDay(migrationDate))
			{
				return lastSolutionPublishedDate;
			}
			return lastKnowledgePublishedDate;
		} 
		set;
	}
	public String dataCategories
	{
		get
		{
			String temp;
			
			if (dataCategoryMap != null && !dataCategoryMap.isEmpty())
			{
				for (String s : dataCategoryMap.keySet())
				{
					if (temp == null)
					{
						temp = s + ':';
					}
					else
					{
						temp += '; ' + s + ':';
					}
					for (Integer i = 0; i < dataCategoryMap.get(s).size(); i++)
					{
						if (i == dataCategoryMap.get(s).size() - 1)
						{
							temp += dataCategoryMap.get(s)[i];
						}
						else
						{
							temp += dataCategoryMap.get(s)[i] + ',';
						}
					}
				}
			}
			
			return temp;
		} 
		set;
	}
	
	public String dataCategorieslabel
	{
		get
		{
		    map<string,string> categorymap= new map<string,string>();
			categorymap.putall(DescribeDataCategoryGroupStructures.dataCategoryLabelMap);
			String temp;
			
			if (dataCategoryMap != null && !dataCategoryMap.isEmpty())
			{
				for (String s : dataCategoryMap.keySet())
				{
					if (temp == null)
					{
						temp = s.replace('_', ' ') + ':';
					}
					else
					{
						temp += '; ' + s.replace('_', ' ') + ':';
					}
					for (Integer i = 0; i < dataCategoryMap.get(s).size(); i++)
					{
						if (i == dataCategoryMap.get(s).size() - 1)
						{
							temp += categorymap.get(s+':_:'+dataCategoryMap.get(s)[i]);
						}
						else
						{
							temp += categorymap.get(s+':_:'+dataCategoryMap.get(s)[i])+ ',';
						}
					}
				}
			}
			categorymap.clear();
			return temp;
		} 
		set;
	}
	public String versions
	{
		get
		{
			 map<string,string> categorymap= new map<string,string>();
			 //DescribeDataCategoryGroupStructures.dataCategoryLabelMap=new map<string,string>();
			categorymap=DescribeDataCategoryGroupStructures.dataCategoryLabelMap;
			system.debug('ver---'+categorymap);
			String temp = '';
			
			if (dataCategoryMap != null && !dataCategoryMap.isEmpty())
			{
				for (String s : dataCategoryMap.keySet())
				{
					if (s == 'Version')
					{
						for (Integer i = 0; i < dataCategoryMap.get(s).size(); i++)
						{
							if (i == dataCategoryMap.get(s).size() - 1)
							{
								if (categorymap != null && 
									categorymap.containsKey(s+':_:'+dataCategoryMap.get(s)[i]))
								{
									temp += categorymap.get(s+':_:'+dataCategoryMap.get(s)[i]);
								}
								else
								{
									temp += dataCategoryMap.get(s)[i];
									
								}
							}
							else
							{
								if (categorymap != null && categorymap.containsKey(s +':_:'+dataCategoryMap.get(s)[i]))
								{
									temp += categorymap.get(s +':_:'+dataCategoryMap.get(s)[i])+', ';
								}
								else
								{
									temp += dataCategoryMap.get(s)[i] + ', ';
									
								}
							}
						}
					}
				}
			}
			return temp;
		} 
		set;
	}
	public String products
	{
		get
		{
			String temp = '';
			
			if (dataCategoryMap != null && !dataCategoryMap.isEmpty())
			{
				for (String s : dataCategoryMap.keySet())
				{
					if (s == 'Product')
					{
						for (Integer i = 0; i < dataCategoryMap.get(s).size(); i++)
						{
							if (i == dataCategoryMap.get(s).size() - 1)
							{
								if (DescribeDataCategoryGroupStructures.dataCategoryLabelMap != null && 
									DescribeDataCategoryGroupStructures.dataCategoryLabelMap.containsKey(s + ':_:' + dataCategoryMap.get(s)[i]))
								{
									temp += DescribeDataCategoryGroupStructures.dataCategoryLabelMap.get(s + ':_:' + dataCategoryMap.get(s)[i]);
								}
								else
								{
									temp += dataCategoryMap.get(s)[i];
								}
							}
							else
							{
								if (DescribeDataCategoryGroupStructures.dataCategoryLabelMap != null && 
									DescribeDataCategoryGroupStructures.dataCategoryLabelMap.containsKey(s + ':_:' + dataCategoryMap.get(s)[i]))
								{
									temp += DescribeDataCategoryGroupStructures.dataCategoryLabelMap.get(s + ':_:' + dataCategoryMap.get(s)[i]) + ', ';
								}
								else
								{
									temp += dataCategoryMap.get(s)[i] + ', ';
								}
							}
						}
					}
				}
			}
			return temp;
		} 
		set;
	}
	public String firstFix
	{
		get
		{
			String temp = '';
			
			if (dataCategoryMap != null && !dataCategoryMap.isEmpty())
			{
				for (String s : dataCategoryMap.keySet())
				{
					if (s == 'Planned_First_Fix_Release')
					{
						for (Integer i = 0; i < dataCategoryMap.get(s).size(); i++)
						{
							if (i == dataCategoryMap.get(s).size() - 1)
							{
								if (DescribeDataCategoryGroupStructures.dataCategoryLabelMap != null && 
									DescribeDataCategoryGroupStructures.dataCategoryLabelMap.containsKey(s + ':_:' + dataCategoryMap.get(s)[i]))
								{
									temp += DescribeDataCategoryGroupStructures.dataCategoryLabelMap.get(s + ':_:' + dataCategoryMap.get(s)[i]);
								}
								else
								{
									temp += dataCategoryMap.get(s)[i];
								}
							}
							else
							{
								if (DescribeDataCategoryGroupStructures.dataCategoryLabelMap != null && 
									DescribeDataCategoryGroupStructures.dataCategoryLabelMap.containsKey(s + ':_:' + dataCategoryMap.get(s)[i]))
								{
									temp += DescribeDataCategoryGroupStructures.dataCategoryLabelMap.get(s + ':_:' + dataCategoryMap.get(s)[i]) + ', ';
								}
								else
								{
									temp += dataCategoryMap.get(s)[i] + ', ';
								}
							}
						}
					}
				}
			}
			return temp;
		} 
		set;
	}
	
	public KnowledgeArticleWrapper(Id i, String n, String an, Id i2)
	{
		articleId = i;
		name  = n;
		articleNumber = an;
		knowledgeArticleId = i2;
		dataCategoryMap = new map<String, list<String>>();
	}
	
	public Integer compareTo(Object compareTo)        //Added by Varghese for Sort functionality 
   {
      KnowledgeArticleWrapper compareToOppy = (KnowledgeArticleWrapper)compareTo;
      Integer returnValue = 0;
      if (lastPublishedDate < compareToOppy.lastPublishedDate)
       {
         returnValue = 1;
       } 
      else if (lastPublishedDate > compareToOppy.lastPublishedDate) 
       {
        returnValue = -1;
       }
      return returnValue;
   }
}