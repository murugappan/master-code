public with sharing class knowledgearticlewrapperPDF implements Comparable
{
    public Id articleId {get; set;} // Same as KnowledgeArticleVersion.Id
    public String name {get; set;}
    public String articleNumber {get; set;}
    public Id knowledgeArticleId {get; set;}
    public map<String, list<String>> dataCategoryMap {get; set;}
    public String articleType {get; set;}
    public Datetime lastKnowledgePublishedDate {get; set;}
    public Datetime lastSolutionPublishedDate {get; set;}
    public String release {get; set;}
    public String targetRelease {get; set;}
    public String patchAvailable {get; set;}
    public String ArticleCategory {get; set;}
    public String ArticleSubCategory {get; set;}
    map<string,string> articleCategoryMap= new map<string,string>();
     string productlist {get; set;}
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
    
    public String versionsPDF
    {
        get
        {
            String temp = '';
            map <string,string> catgorylabelMap= DescribeDataCategoryGroupStructures.dataCategoryLabelMap;//new map<string,string>();
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
                                if (catgorylabelMap != null && 
                                    catgorylabelMap.containsKey(s + ':_:' + dataCategoryMap.get(s)[i]))
                                {
                                    temp += catgorylabelMap.get(s + ':_:' + dataCategoryMap.get(s)[i]);
                                }
                                else
                                {
                                    temp += dataCategoryMap.get(s)[i];
                                }
                            }
                            else
                            {
                                if (catgorylabelMap != null && 
                                    catgorylabelMap.containsKey(s + ':_:' + dataCategoryMap.get(s)[i]))
                                {
                                    temp += catgorylabelMap.get(s + ':_:' + dataCategoryMap.get(s)[i]) + ', ';
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
            //dataCategoryMap=new map<String, list<String>> ();
            return temp;
        } 
        set;
    }
    
    
       public map<string,string> productPDF
    {
        get
        {
        	if(articleCategoryMap != null && articleCategoryMap.isEmpty())
        	{
	        	articleCategoryMap.put('ArticleCategory','');
	        	articleCategoryMap.put('ArticleSubCategory','');
	        	
	            String temp = '';
	            if (dataCategoryMap != null && !dataCategoryMap.isEmpty() && dataCategoryMap.containsKey('Product'))
	            {
	            	if(dataCategoryMap.get('Product')!=null)
	               {
		                      	for(string productname:dataCategoryMap.get('Product'))
		            				{
							             if(productname != null )
							            	{	
							                list<String> productnamelist= new list<String>();
							                string tempproduct= productname;
							                while(tempproduct != null && tempproduct != 'All' && Product__c.getValues(tempproduct.left(38).toLowerCase())!=null)
							                	{
								                    productnamelist.add(tempproduct);
								                    if(Product__c.getValues(tempproduct.left(38).toLowerCase())!=null)
								                    {
								                        tempproduct= Product__c.getValues(tempproduct.left(38).toLowerCase()).parent__c;
								                    }   
							               	 	}
							               	 if(productnamelist!=null)
							                	{
									                  for(integer i = productnamelist.size(); i>0; i--)
									                  { 
									                    if(i==3)
									                    {
									                    	if(Product__c.getValues(productnamelist[(productnamelist.size()-3)].left(38).tolowercase())!=null)
									                    	{
									                    		if(articleCategoryMap.get('ArticleSubCategory')==null || articleCategoryMap.get('ArticleSubCategory')=='' )
									                    		{
									                    			articleCategoryMap.put('ArticleSubCategory',Product__c.getValues(productnamelist[(productnamelist.size()-3)].left(38).tolowercase()).label__c);   
									                    		}
									                    		else
									                    		{
									                    			string tempvalue=articleCategoryMap.get('ArticleSubCategory');
									                    			articleCategoryMap.put('ArticleSubCategory',tempvalue+' ,'+Product__c.getValues(productnamelist[(productnamelist.size()-3)].left(38).tolowercase()).label__c);
									                    		}
									                    	}
									                          
									                    }
									                    else if(i==2)
									                    {
									                        if(Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase())!=null)
									                    	{
									                    		if(articleCategoryMap.get('ArticleCategory')==null || articleCategoryMap.get('ArticleCategory')=='' )
									                    		{
									                    			articleCategoryMap.put('ArticleCategory',Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase()).label__c);   
									                    		}
									                    		else if(articleCategoryMap.get('ArticleCategory')!= null && !articleCategoryMap.get('ArticleCategory').contains(Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase()).label__c))
									                    		{
									                    			string tempvalue=articleCategoryMap.get('ArticleCategory');
									                    			articleCategoryMap.put('ArticleCategory',tempvalue+' ,'+Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase()).label__c);
									                    		}
									                    	}
									                    }
									                  }
							                	}
							                
							           		 }
		            	}
	               }
	            }
	            
	            return articleCategoryMap;
        	}
        	else
        	{
        		return articleCategoryMap;
        	}  
        } 
        set;
    }
   


 /*   public map<string,string> productPDF
    {
        get
        {
        	if(articleCategoryMap != null && articleCategoryMap.isEmpty())
        	{
	        	articleCategoryMap.put('ArticleCategory','');
	        	articleCategoryMap.put('ArticleSubCategory','');
	        	
	            String temp = '';
	            if (dataCategoryMap != null && !dataCategoryMap.isEmpty() && dataCategoryMap.containsKey('Product'))
	            {
	            	if(dataCategoryMap.get('Product')!=null)
	                for (String s : dataCategoryMap.get('Product'))
	                {
	                    if(temp!=null && temp!='')
	                    {
	                    	temp+=','+s;
	                    }
	                    else
	                    {
	                    	temp=s;
	                    }
	                }
	            }
	            if(temp != null && temp != '')
	            {
	            	list<string>tempcategorylist=new list<string>();
	            	tempcategorylist=temp.split(',');
	            	for(string productname:tempcategorylist)
	            	{
			             if(productname != null )
			            {
			                list<String> productnamelist= new list<String>();
			                string tempproduct= productname;
			                while(tempproduct != null && tempproduct != 'All' && Product__c.getValues(tempproduct.left(38).toLowerCase())!=null)
			                {
			                    productnamelist.add(tempproduct);
			                    if(Product__c.getValues(temp.left(38).toLowerCase())!=null)
			                    {
			                        tempproduct= Product__c.getValues(tempproduct.left(38).toLowerCase()).parent__c;
			                    }   
			                }
			                if(productnamelist!=null)
			                {
			                  for(integer i = productnamelist.size(); i>0; i--)
			                  { 
			                    if(i==2)
			                    {
			                    	if(Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase())!=null)
			                    	{
			                    		if(articleCategoryMap.get('ArticleSubCategory')==null || articleCategoryMap.get('ArticleSubCategory')=='' )
			                    		{
			                    			articleCategoryMap.put('ArticleSubCategory',Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase()).label__c);   
			                    		}
			                    		else
			                    		{
			                    			string tempvalue=articleCategoryMap.get('ArticleSubCategory');
			                    			articleCategoryMap.put('ArticleSubCategory',tempvalue+' ,'+Product__c.getValues(productnamelist[(productnamelist.size()-2)].left(38).tolowercase()).label__c);
			                    		}
			                    	}
			                          
			                    }
			                    else if(i==1)
			                    {
			                        if(Product__c.getValues(productnamelist[(productnamelist.size()-1)].left(38).tolowercase())!=null)
			                    	{
			                    		if(articleCategoryMap.get('ArticleCategory')==null || articleCategoryMap.get('ArticleCategory')=='' )
			                    		{
			                    			articleCategoryMap.put('ArticleCategory',Product__c.getValues(productnamelist[(productnamelist.size()-1)].left(38).tolowercase()).label__c);   
			                    		}
			                    		else
			                    		{
			                    			string tempvalue=articleCategoryMap.get('ArticleCategory');
			                    			articleCategoryMap.put('ArticleCategory',tempvalue+' ,'+Product__c.getValues(productnamelist[(productnamelist.size()-1)].left(38).tolowercase()).label__c);
			                    		}
			                    	}
			                    }
			                  }
			                }
			                
			            }
	            	}
	            }
	            return articleCategoryMap;
        	}
        	else
        	{
        		return articleCategoryMap;
        	}  
        } 
        set;
    }
*/    
    
    public KnowledgeArticleWrapperPDF(Id i, String n, String an, Id i2)
    {
        articleId = i;
        name  = n;
        articleNumber = an;
        knowledgeArticleId = i2;
        dataCategoryMap = new map<String, list<String>>();
    }
    
    public Integer compareTo(Object compareTo)        //Added by Varghese for Sort functionality 
   {
      KnowledgeArticleWrapperPDF compareToOppy = (KnowledgeArticleWrapperPDF)compareTo;
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