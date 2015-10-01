public without sharing class DescribeDataCategoryGroupStructures
{
	public static List<Schema.DescribeDataCategoryGroupStructureResult> describeResult
	{
		get
		{
			if (describeResult == null)
			{
				describeResult = DescribeDataCategoryGroupStructures.getDescribeDataCategoryGroupStructureResults();
			}
			return describeResult;
		}
		private set;
	}
	
	public static map<String, String> dataCategoryLabelMap
	{
		get
		{
			if (dataCategoryLabelMap == null)
			{
				list<Schema.DescribeDataCategoryGroupStructureResult> dr = DescribeDataCategoryGroupStructures.getDescribeDataCategoryGroupStructureResults();
			}
			return dataCategoryLabelMap;
		}
		set;
	}
	
	public static List<DescribeDataCategoryGroupStructureResult> getDescribeDataCategoryGroupStructureResults()
	{
    	list<DescribeDataCategoryGroupResult> describeCategoryResult;
      	list<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
      	DescribeDataCategoryGroupStructures.dataCategoryLabelMap = new map<String, String>();
      	
      	try
      	{
         	//Making the call to the describeDataCategoryGroups to get the list of category groups associated 
         	list<String> objType = new List<String>();
         	objType.add('KnowledgeArticleVersion');
         	describeCategoryResult = Schema.describeDataCategoryGroups(objType);
         	
         	//Creating a list of pair objects to use as a parameter for the describe call 
         	list<DataCategoryGroupSobjectTypePair> pairs = new list<DataCategoryGroupSobjectTypePair>();
         
         	//Looping throught the first describe result to create the list of pairs for the second describe call 
         	for(DescribeDataCategoryGroupResult singleResult : describeCategoryResult)
         	{
            	DataCategoryGroupSobjectTypePair p = new DataCategoryGroupSobjectTypePair();
            	p.setSobject(singleResult.getSobject());
            	p.setDataCategoryGroupName(singleResult.getName());
            	pairs.add(p);
         	}
         
	         //describeDataCategoryGroupStructures() 
	         describeCategoryStructureResult = Schema.describeDataCategoryGroupStructures(pairs, false);
	
	         //Getting data from the result 
	         for(DescribeDataCategoryGroupStructureResult singleResult : describeCategoryStructureResult)
	         {
	           
	            DataCategory [] toplevelCategories = singleResult.getTopCategories();
	            
	            //Recursively get all the categories 
	            list<DataCategory> allCategories = getAllCategories(toplevelCategories);
	
	            for(DataCategory category : allCategories)
	            {
	            	DescribeDataCategoryGroupStructures.dataCategoryLabelMap.put(singleResult.getName() + ':_:' + category.getName(), category.getLabel());
	            	
	               	DataCategory [] childCategories = category.getChildCategories();
	            }
			}
		} 
		catch (Exception e) {}
      	return describeCategoryStructureResult;
	}
    
   	private static DataCategory[] getAllCategories(DataCategory [] categories)
   	{
      	if(categories.isEmpty())
      	{
         	return new DataCategory[]{};
      	} 
      	else 
      	{
         	DataCategory [] categoriesClone = categories.clone();
         	DataCategory category = categoriesClone[0];
         	DataCategory[] allCategories = new DataCategory[]{category};
         	categoriesClone.remove(0);
         	categoriesClone.addAll(category.getChildCategories());
         	allCategories.addAll(getAllCategories(categoriesClone));
         	return allCategories;
      	}
   	}
}