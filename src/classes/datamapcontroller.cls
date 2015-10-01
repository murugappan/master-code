public class datamapcontroller {
    public List<versions__c> versionlist{get;set;} 
    //List<versions__c> versionlist =  new List<versions__c> ();
    List<Planned_First_Fix_Release__c> Fixreleaselist =  new List<Planned_First_Fix_Release__c> ();
    List<product__c> productlist =  new List<product__c> ();
    
    public datamapcontroller()
    {
            versionlist =  new List<versions__c> ();
    }
     public void datamapexecute()
     {
        
            list<versions__c> del_versionlist=[Select id from versions__c limit 50000];
            list<Planned_First_Fix_Release__c> del_Fixreleaselist=[Select id from Planned_First_Fix_Release__c limit 50000];
            list<product__c> del_productlist=[Select id from product__c limit 50000];
            
             if(del_versionlist!= null && del_versionlist.size()>0)
           {
            delete del_versionlist;
           }
           if(del_Fixreleaselist != null && del_Fixreleaselist.size()>0)
           {
            delete del_Fixreleaselist;
           }
           if(del_productlist != null && del_productlist.size()>0)
           {
            delete del_productlist;
           }
                    
            List<DescribeDataCategoryGroupResult> describeCategoryResult;
            List<DescribeDataCategoryGroupStructureResult> describeCategoryStructureResult;
            
            //Making the call to the describeDataCategoryGroups to
            //get the list of category groups associated
            List<String> objType = new List<String>();
            objType.add('KnowledgeArticleVersion');
            //objType.add('Question');
            describeCategoryResult = Schema.describeDataCategoryGroups(objType);
            //Creating a list of pair objects to use as a parameter
            //for the describe call
            List<DataCategoryGroupSobjectTypePair> pairs =
            new List<DataCategoryGroupSobjectTypePair>();
            //Looping throught the first describe result to create
            //the list of pairs for the second describe call
            for(DescribeDataCategoryGroupResult singleResult :
            describeCategoryResult){
            DataCategoryGroupSobjectTypePair p =
            new DataCategoryGroupSobjectTypePair();
            p.setSobject(singleResult.getSobject());
            p.setDataCategoryGroupName(singleResult.getName());
            pairs.add(p);
            }
            //describeDataCategoryGroupStructures()
            describeCategoryStructureResult =
            Schema.describeDataCategoryGroupStructures(pairs, false);
            
            
            for(DescribeDataCategoryGroupStructureResult singleResult: describeCategoryStructureResult)
            {
                
                    getalldatacategorymap(singleresult.getTopCategories(),'All',singleresult.getname());
                
            }
            
           if(versionlist!= null && versionlist.size()>0)
           {
            Database.insert(versionlist,false);
           }
           if(Fixreleaselist != null && Fixreleaselist.size()>0)
           {
            Database.insert( Fixreleaselist,false);
           }
           if(productlist != null && productlist.size()>0)
           {
            Database.insert(productlist,false);
           }
            
            
            
     }
     
        private  map<string,string> getalldatacategorymap(Datacategory[] categories, string parent, string categorytype)
            {
                if(categories.isempty())
                {
                    return new map<string,string>();
                }
                else{
                map<string,string> allcategorymap= new map<string,string>();
                    for(datacategory dt:categories )
                    {
                        allcategorymap.put(dt.getname(),parent);
                        if(categorytype =='Version')
                        {
                            versions__c ver= new versions__c();
                            ver.name=dt.getname().left(38).toLowerCase();
                            ver.label__c=dt.getlabel();
                            ver.parent__c=parent;
                            versionlist.add(ver);
                        }
                        else if(categorytype =='Product')
                        {
                            product__c ver= new product__c();
                            ver.name=dt.getname().left(38).toLowerCase();
                            ver.label__c=dt.getlabel();
                            ver.parent__c=parent;
                            productlist.add(ver);
                        }
                        else if(categorytype =='Planned_First_Fix_Release')
                        {
                            Planned_First_Fix_Release__c ver= new Planned_First_Fix_Release__c();
                            ver.name=dt.getname().left(38).toLowerCase();
                            ver.label__c=dt.getlabel();
                            ver.parent__c=parent;
                            Fixreleaselist.add(ver);
                        }
                        allcategorymap.putAll(getalldatacategorymap(dt.getchildcategories(),dt.getname(),categorytype));
                        
                    }
                    return allcategorymap;
                }
            }
}