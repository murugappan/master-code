public class PublicKBSearchController {

    //public set<Id> categories = new set<Id>();
    public List<CategoryNode> catNodeList { get; set; } 
    //public List<CategoryData> catDataList { get; set; } 
    //public List<solution> articleList {get; set; }
    public Boolean xythose = true;
    public Boolean learn = true; 
    public Boolean angel = true;
    public Boolean cEVista = true;
    public String product;
    
    public Boolean getLearn() {
        return learn;
    }
    
    public void setLearn(Boolean l) {
        learn = l;
    }
       
    public void setCEVista(Boolean c) {
        CEVista = c;
    }
     public Boolean getCEVista() {
        return CEVista;
    }
    
    public void setAngel(Boolean a) {
        angel = a;
    }
     public Boolean getAngel() {
        return angel;
    }
    
    public void setXythose(Boolean x) {
        xythose = x;
    }
    public Boolean getXythose() {
        return xythose;
    }
  
    
   // String categoryStatus;
    String searchText;
    List<Solution> results;

    public String getSearchText() {
        return searchText;
    }

    public void setSearchText(String s) {
       searchText = s;
    }

    public List<Solution> getResults() {
        return results;
    }
    
    /*public String getCategoryStatus() {
        return categoryStatus;
    }
    
    public void setCategoryStatus(String s) {
        categoryStatus = s;
    }*/
    
    public String catStatus {
        get;
        // *** setter is NOT being called ***
        set {
            catStatus = value;
            System.debug('value: '+value);
        }
    }
    
     //Return picklist values for product 
     public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-- None --','-- None --'));
        options.add(new SelectOption('Blackboard Learn','Blackboard Learn'));
        options.add(new SelectOption('ANGEL','ANGEL'));
        options.add(new SelectOption('CE/Vista','CE/Vista'));
        options.add(new SelectOption('Mobile','Mobile'));
        options.add(new SelectOption('Transact','Transact'));
        options.add(new SelectOption('Xythos','Xythos'));
        return options;
    }
    
   /* public PageReference doSearch() {
        System.debug('<<<<<<< In Find Article Method >>>>>>>>');
        
        return null;
    }*/
    
    public PageReference doSearch() {
        //String catStatus = ApexPages.CurrentPage().getParameters().get('catStatus');
         
         catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                            FROM CategoryNode
                                            ORDER BY MasterLabel DESC];
         System.debug('catNodeList>>>>>>>>' + catNodeList);
         set<Id> categories = new set<Id>();
         set<Id> finalCatIdList = new set<Id>();
         set<Id> tempCatIdList1 = new set<Id>();
         set<Id> tempCatIdList2 = new set<Id>();
         for(CategoryNode catNode : catNodeList) {
            
            if(catNode.MasterLabel == 'Xythos') {
                if(xythose == true)
                    categories.add(catNode.Id);
            } else if(catNode.MasterLabel == 'Learn') {
                if(learn == true)
                    categories.add(catNode.Id);
            } else if(catNode.MasterLabel == 'CE/Vista') {
                if(CEVista == true)
                    categories.add(catNode.Id);
            } else if(catNode.MasterLabel == 'ANGEL') {
                if(angel == true)
                    categories.add(catNode.Id);
            }
              
        }
        System.debug('categories>>>>>>>>' + categories.size());
        System.debug('categories>>>>>>>>' + categories);
        
        if(categories.size() == 0 && null != searchText) 
            results = (List<Solution>)[FIND :searchText RETURNING Solution(Id, SolutionNumber, SolutionName, Status, LastModifiedDate WHERE IsPublishedInPublicKb = true LIMIT 100)][0];
            //articleList = [Select SolutionNumber, LastModifiedDate, Status, SolutionName, Link__c, IsDeleted, Id From Solution where SolutionName Like :name];
        else {
            System.debug('<<<<<<< Inside Else >>>>>>>>');
            Boolean flag = false;
            for(Integer i = 0; i < 5; i++) {
                System.debug('<<<<<<< Inside First For >>>>>>>>');
                if(flag == false) {
                    if(i == 0) {
                        if(categories.size() > 0) {
                            tempCatIdList1 = categories;
                            System.debug('tempCatIdList1>>>>>>>>' + tempCatIdList1.size());
                        } else {
                            flag = true;
                            break;
                        }
                    } else {
                        if(tempCatIdList2.size() > 0) {
                            tempCatIdList1 = tempCatIdList2;
                            tempCatIdList2 = new set<Id>();
                            
                        } else {
                            flag = true;
                            break;
                        }
                        
                    }
                    System.debug('tempCatIdList1>>>>>>>>222  ' + tempCatIdList1.size());
                    for(Id parentCatId : tempCatIdList1) {
                        
                        for(CategoryNode catNode : catNodeList) {
                            
                            if(catNode.ParentId == parentCatId) {
                                
                                tempCatIdList2.add(catNode.Id);
                                finalCatIdList.add(catNode.Id); 
                            }                       
                        }
                    }
                }
            }
            System.debug('finalCatIdList>>>>>>>>' + finalCatIdList.size());
            if(finalCatIdList.size() > 0) {
                set<Id> solIdSet = new set<Id>();
                List<CategoryData> catDataList = [Select RelatedSobjectId, IsDeleted, Id, CategoryNodeId From CategoryData where CategoryNodeId IN : finalCatIdList];
                for(CategoryData catData : catDataList) {
                    solIdSet.add(catData.RelatedSobjectId);
                }
                System.debug('solIdSet>>>>>>>>' + solIdSet.size());
                if(null != product && !product.equalsIgnoreCase('-- None --'))
                	results = (List<Solution>)[FIND :searchText RETURNING Solution(Id, SolutionNumber, SolutionName, Status, LastModifiedDate 
                		WHERE IsPublishedInPublicKb = true 
                		and product__c = :product and id IN : solIdSet LIMIT 100)][0];
                else
                   	results = (List<Solution>)[FIND :searchText RETURNING Solution(Id, SolutionNumber, SolutionName, Status, LastModifiedDate 
                   		WHERE Status = 'Published' and IsPublishedInPublicKb = true 
                   		and id IN : solIdSet LIMIT 100)][0];
                //articleList = [Select SolutionNumber, LastModifiedDate, Status, SolutionName, IsDeleted, Id From Solution where SolutionName Like :name and Id IN :solIdSet];
            }
        }
             
         //results = (List<Solution>)[FIND :searchText RETURNING Solution(Id, SolutionNumber, SolutionName, Status, LastModifiedDate WHERE Status = 'Published' LIMIT 15)][0];
      return null;
    }
    
    
    public PublicKBSearchController() {
    
        //catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                           // FROM CategoryNode
                                           // ORDER BY MasterLabel DESC];
        System.debug('<<<<<<< In PublicKBSearchController Controller >>>>>>>>');
    }

    /*public List<CategoryNode> getArticleCategories() {    
    //THIS QUERY WILL RETURN ALL ARTICLE CATEGORIES THAT ARE PRIMARY CATEGORIES (HAVE NO PARENT)
    return [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
        FROM CategoryNode
        WHERE ParentId = Null
        ORDER BY MasterLabel DESC];
        
        }*/
        
   /*public List<SelectOption> getArticleCategories() {
        List<SelectOption> options = new List<SelectOption>();
        //List<CategoryNode> catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                            //FROM CategoryNode
                                           // WHERE ParentId = Null
                                           // ORDER BY MasterLabel DESC];
        for(CategoryNode catNode : catNodeList) {
            
            if(catNode.ParentId == null)
                options.add(new SelectOption(catNode.Id,catNode.MasterLabel));
              
        }
        return options;
    }*/   
    
    public List<CategoryNode> getArticleCategories() {
        List<CategoryNode> categories = new List<CategoryNode>();
        List<CategoryNode> catNodeList = [SELECT Id, CreatedById, CreatedDate, LastModifiedById, LastModifiedDate, MasterLabel, ParentId, SortOrder, SortStyle, SystemModstamp 
                                            FROM CategoryNode
                                            WHERE ParentId = Null
                                            ORDER BY MasterLabel DESC];
        for(CategoryNode catNode : catNodeList) {
            
            if(catNode.ParentId == null)
                categories.add(catNode);
              
        }
        return categories;
    }
    
   /* public List<Solution> getArticles() {
        System.debug('categories values>>>>>>>>'+ categories);
        System.debug('inputValue values>>>>>>>>'+ inputValue);
        set<Id> finalCatIdList = new set<Id>();
        set<Id> tempCatIdList1 = new set<Id>();
        set<Id> tempCatIdList2 = new set<Id>();
        
        String name = '%'+ inputValue +'%';
        if(categories.size() == 0 && null != inputValue) 
            articleList = [Select SolutionNumber, LastModifiedDate, Status, SolutionName, Link__c, IsDeleted, Id From Solution where SolutionName Like :name];
        else {
            Boolean flag = false;
            for(Integer i = 0; i > 5; i++) {
                
                if(flag == false) {
                    if(i == 0) {
                        if(categories.size() > 0)
                            tempCatIdList1 = categories;
                        else {
                            flag = true;
                            break;
                        }
                    } else {
                        if(tempCatIdList2.size() > 0) {
                            tempCatIdList1 = tempCatIdList2;
                            tempCatIdList2 = new set<Id>();
                            
                        } else {
                            flag = true;
                            break;
                        }
                        
                    }
                    for(Id parentCatId : tempCatIdList1) {
                        
                        for(CategoryNode catNode : catNodeList) {
                            
                            if(catNode.ParentId == parentCatId) {
                                
                                tempCatIdList2.add(catNode.Id);
                                finalCatIdList.add(catNode.Id); 
                            }                       
                        }
                    }
                }
            }
            if(finalCatIdList.size() > 0) {
                set<Id> solIdSet = new set<Id>();
                List<CategoryData> catDataList = [Select RelatedSobjectId, IsDeleted, Id, CategoryNodeId From CategoryData where CategoryNodeId IN : finalCatIdList];
                for(CategoryData catData : catDataList) {
                    solIdSet.add(catData.RelatedSobjectId);
                }
                
                articleList = [Select SolutionNumber, LastModifiedDate, Status, SolutionName, IsDeleted, Id From Solution where SolutionName Like :name and Id IN :solIdSet];
            }
        }
        
        return articleList;
    }*/
    
    public String getProduct() {
            return product;
    }
        
    public void setProduct(String product) {
        this.product = product;
    }
     public PageReference Redirect() {
       Profile profileObj = [Select Name,Id From Profile where Id = : UserInfo.getprofileId()];
        if(profileObj.Name != 'SRV - BTBB User' && profileObj.Name != 'SRV - System Administrator' && profileObj.Name != 'System Administrator') {
            PageReference pageRedirect = new PageReference('http://dev.behind.blackboard.com/');
            pageRedirect.setRedirect(true);
            return pageRedirect ;           
        }
        else
            return null;
    }   
}