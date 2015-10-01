public class publicarticleSearchController {   
    // The soql without any filters
    private String soql;
    //Top right filters
    public String productFilter { get; set; }
    public String majorFilter { get; set; }    
    public List<Categories> articleFilters {get; set;}   
    public List<Categories> minorFilterList {get; set;}
    public List<Categories> targetFilterList {get; set;}
    public List<Categories> catFilters {get; set;}
    public List<Categories> subCatFilters {get; set;}
    public String patchFilter { get; set;}

    public List<String> subCateList{get; set; }
    public Integer articlesSize { get; set; }
    public String version {get; set; }
   
    public Boolean isSearchText { get; set; }
    public Boolean isXythosOnly { get; set; }
    
    public List<CategoryNode> catNodeList;  
    List<RecordType> recordTypes;     
    Map<String, Id> mapOfParentCatIdWithName = new Map<String, Id>();
    Map<Id, String> mapOfCatNameWithId = new Map<Id, String>();
    Map<Id, Set<Id>> mapOfSetCatIdWithParent = new Map<Id, Set<Id>>();
    Map<Id, String> mapOfRecordTypeNameWithId = new Map<Id, String>();
    Map<Id, String> mapOfcateIdName = new Map<Id, String>();
    Set<Id> catIdSet = new Set<Id>();
    Set<Id> childCatIdSet = new Set<Id>();
    
    public boolean isProductSel { get; set; }
    public boolean isKnownIssue { get; set; }
    
    String tarRelease;
    String servPack;
    String subCat;
    String childCat;
    public String articleTypes {get; set;}
    String patchValue;
    String topFilter;
    Boolean isFilterSelect;
    Boolean isRemove;
    List<User> u;
    List<Categories> catList;    
    Categories cateObj;    
    List<Solution> solList;
    public List<ArticleWrapper> articleList { get; set; }    
    public String product { get; set; }
    public List<BTBB_KBCategory__c> btbbCatList = new List<BTBB_KBCategory__c>(); 
    
    public boolean errorShow {get; set; }
    public String errorTitle  {get; set; }
    public String errorMessage {get; set; }
    public String errorSeverity {get; set; }
    
    public String searchText { get; set; } 
    
    public Integer getResultSize(){
        return ArticleList.Size();
    }
        
    public List<SelectOption> Products { 
        get { 
            List<SelectOption> productList = new List<SelectOption>();
            //productList.add(new SelectOption('All Products','All Products'));
            for(BTBB_KBCategory__c btbbCat : btbbCatList) {
                mapOfcateIdName.put(btbbCat.Id, btbbCat.CategoryName__c);
                productList.add(new SelectOption(btbbCat.Id,btbbCat.CategoryName__c));       
            }
                        
            return productList;
        }
        set;
    }
    
    public Boolean isProdSel {
        get {
                System.debug('versions: >>>>>>>>>>>> ' + versions);
                if(null != versions && versions.size() > 1)       
                    return false;
                else
                    return true;
        }
        set;
    }
    
    public Boolean isCatSel {
        get {
                System.debug('catFilters : >>>>>>>>>>>> ' + catFilters);
                if(null != catFilters && catFilters.size() > 0)       
                    return true;
                else
                    return false;
        }
        set;
    }
    
    public PageReference selectProduct() {         
        System.debug('product Name: >>>>>>>>>>>> '+ product);
        if(null != product && product != 'All Products') {
            catFilters = null;
            minorFilterList = new List<Categories>();
            version = null;
            majorFilter = null;
            
                      
        } else
            productFilter = null;
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        System.debug('soql : >>>>>>>>>>>> '+ soql);
        servPack = null;
        subCat = null;
        childCat = null;
        runArticleSearch();      
        if(product != null && !product.equals('All Products'))
            isProductSel = true;
        else
            isProductSel = false;
        return null;
    }
    
    public List<SelectOption> Versions { 
        get { 
            List<selectOption> options = new List<selectOption>();            
            options.add(new SelectOption('','-- Filter by Version --'));
            
            if (product != null) {

                    for(BTBB_KBVersion__c btbbVer : [Select Name,Version__c, Id From BTBB_KBVersion__c where BTBB_KBCategory__c = :product ORDER BY Version__c ASC] ) {
                        
                        options.add(new SelectOption(btbbVer.Version__c,btbbVer.Version__c));
                        System.debug('Version__c >>>>>>>>' + btbbVer.Version__c);       
                    }
            }
            return options;
        }
        set;
    }
    
    public List<Categories> getMinVersion() {  
        catList = new List<Categories>();
        if (product != null) {

            for(BTBBminorVersion__c btbbmVer : [Select Name,VersionName__c, Id From BTBBminorVersion__c where BTBB_KBCategory__c = :product ORDER BY VersionName__c ASC] ) {
                
                cateObj = new Categories();
                    cateObj.NodeId = btbbmVer.VersionName__c;
                    cateObj.NodeName = btbbmVer.VersionName__c;
                    if(minorFilterList != null && minorFilterList.size() > 0) {
                        for(Categories serPack:minorFilterList) {
                            if(serPack.NodeName.Equals(btbbmVer.VersionName__c))
                                cateObj.selected = true;
                        }
                    }    
                    catList.add(cateObj);                
            }
            }         
       return catList;
    }
    
    public List<Categories> getTargetRelease() {
        catList = new List<Categories>();        

        for(BTBBminorVersion__c btbbmVer : [Select Name,VersionName__c, Id From BTBBminorVersion__c ORDER BY VersionName__c ASC] ) {
            
            cateObj = new Categories();
                cateObj.NodeId = btbbmVer.VersionName__c;
                cateObj.NodeName = btbbmVer.VersionName__c;
                if(targetFilterList != null && targetFilterList.size() > 0) {
                    for(Categories tarRelease:targetFilterList) {
                        if(tarRelease.NodeName.Equals(btbbmVer.VersionName__c))
                            cateObj.selected = true;
                    }
                }    
                catList.add(cateObj);                
        }
                        
       return catList;
    }

    public PageReference selectMajor() {         
        if(null != version && version != '') {
            majorFilter = version;            
        } else
            majorFilter = null;
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        runArticleSearch();
        return null;
    }
        
    //default product code
    public String defaultProfileCategory {
                
        get { 
            
            if(null != aType && isRemove == false && ApexPages.currentPage().getparameters().get('homepage') != 'true') {               
                if(null != isXythosOnly && isXythosOnly == true) {
                    defaultProfileCategory = 'Xythos';
                } else if(u.size() > 0 && u[0].BTBB_KB_Default_Prod__c != null)
                {
                    defaultProfileCategory = u[0].BTBB_KB_Default_Prod__c;                                                        
                }
            } else 
                defaultProfileCategory = null;
            return defaultProfileCategory ;
        }
        set { 
            if(value != null) defaultProfileCategory = value;
        }        
    }
    public String defaultCategory {
                
        get { 
                if(isFilterSelect == false && (topFilter == null || topFilter == '') 
                && ApexPages.currentPage().getparameters().get('viewall') != null
                && ApexPages.currentPage().getparameters().get('viewall') != 'All'
                && ApexPages.currentPage().getparameters().get('viewall') != '' && product == null) {
                    String nodeId = ApexPages.currentPage().getparameters().get('viewall');                    
                    defaultCategory = mapOfCatNameWithId.get(nodeId);                                                                     
                }
                else if(product == 'All Products' || topFilter != null){
                    
                    defaultCategory = null;                 
                }
            return defaultCategory;
        }
        set { 
            if(value != null) defaultCategory = value;
        }        
     }
   
     public String defaultProduct {
                
        get { 
            
            if(ApexPages.currentPage().getparameters().get('page') != null && product == null) {
                String page = ApexPages.currentPage().getparameters().get('page');
                if(page.equals('selfservice')) {
                        User curUser=[SELECT Id, BTBB_KB_Default_Prod__c FROM User where Id = :userInfo.getUserId()];                        
                        if(null != curUser && curUser.BTBB_KB_Default_Prod__c != null) {
                                defaultProduct = curUser.BTBB_KB_Default_Prod__c;                               
                        }
                }
            }
            return defaultProduct;
        }
        set { 
            if(value != null) defaultProduct = value;
        }        
    }
    
    //End of Default Product code
    
    public publicarticleSearchController() {
      
       System.debug('<<<<<<<<< In Controller >>>>>>>>>>');
       //soql = 'Select ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
       if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
       GlobalComponent globalObj = new GlobalComponent();
       isXythosOnly = globalObj.isXythosOnly();
       catNodeList = [Select ParentId, MasterLabel, Id From CategoryNode];
       btbbCatList = [Select Id, CategoryName__c From BTBB_KBCategory__c ORDER BY CategoryName__c ASC];
       recordTypes = [select id, name from recordtype where sobjecttype = 'Solution' and name != 'Process/Procedure' and name != 'General' order by name];
       u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]);   
      
       for(CategoryNode catNode : catNodeList) {
           if(catNode.ParentId == null) {               
               mapOfParentCatIdWithName.put(catNode.MasterLabel, catNode.Id);
           }
           mapOfCatNameWithId.put(catNode.Id, catNode.MasterLabel);
           catIdSet.add(catNode.Id);
       }
       for(Id catId : catIdSet) {
           childCatIdSet = new Set<Id>();  
           childCatIdSet.add(catId);
           mapOfSetCatIdWithParent.put(catId, childCatIdSet);
           for(CategoryNode catNode : catNodeList) {
               if(catNode.ParentId == catId)
                   mapOfSetCatIdWithParent.get(catId).add(catNode.Id);                                 
           }
       }       
       if(ApexPages.currentPage().getparameters().get('searchText') != null) {
           searchText = ApexPages.currentPage().getparameters().get('searchText');                
       }
       isRemove = false;
       isFilterSelect = false;
       runArticleSearch();
       
    } 
    
    public String aType { 
        get { 
            System.debug('articleFilters >>>>>>>>>>>>>>>>>' + articleFilters);
            if(isRemove == false && ApexPages.currentPage().getparameters().get('aType') != null) {
                aType = ApexPages.currentPage().getparameters().get('aType');                
            } else {
            
                aType = null;
            }
            return aType;
        }
        set { 
            if(value != null) aType = value;
        }
    }
      
     public PageReference runSearch() {
     
        System.debug('<<<<<<<<<<<<< In runSearch >>>>>>>>>>>>>>>');
        tarRelease = Apexpages.currentPage().getParameters().get('tarRelease'); 
        servPack = Apexpages.currentPage().getParameters().get('servPack');         
        subCat = Apexpages.currentPage().getParameters().get('subCat');       
        childCat = Apexpages.currentPage().getParameters().get('childCat');
        articleTypes = Apexpages.currentPage().getParameters().get('articleTypes'); 
        patchValue = Apexpages.currentPage().getParameters().get('patchValue');    
        topFilter = Apexpages.currentPage().getParameters().get('topFilterPage'); 
        searchText = Apexpages.currentPage().getParameters().get('searchTextPage');
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';        
        
        
        if (!tarRelease.equals('')) {
            
        } else            
            targetFilterList = new List<Categories>();
        
        if (!servPack.equals('')) {
            
        } else            
            minorFilterList = new List<Categories>();
        
        if (!subCat.equals('')) {
            
        } else            
            catFilters = new List<Categories>();
            
        if (!childCat.equals('')) {
            System.debug('childCate>>>>>>>>>>>>>>>'+childCat);
           
        } else            
            subCatFilters = new List<Categories>();
            
        if (!articleTypes.equals('')) {
            System.debug('articleTypes >>>>>>>>>>>>>>>'+articleTypes);
            isFilterSelect = true;
        } else {
            articleFilters = new List<Categories>();
            targetFilterList = new List<Categories>();
            isKnownIssue = false;
            isRemove = true;
        }
        
        if (!patchValue.equals('')) {
            isFilterSelect = true;
            System.debug('patchValue>>>>>>>>>>>>>>>'+patchValue);
        } else
            patchFilter = null;
            
        if (!searchText.equals('')) {
                isSearchText = true;
        }    
        if(!topFilter.equals('')) {
            System.debug('topFilter >>>>>>>>>>>>'+ topFilter);
            if(topFilter.equals('Product')) {
                product = null;
                version = null;
                isProductSel = false;
                productFilter = null;
                majorFilter = null;
                minorFilterList = new List<Categories>();
                catFilters = new List<Categories>();
                subCatFilters = new List<Categories>();
                
            } else if(topFilter.equals('Major Release')) {
            
                version = null;
                majorFilter = null;
                           
            } else if(topFilter.equals('Patch Available'))
                patchFilter = null;      
            isRemove = true;
        
        }
     
        runArticleSearch();
     
        return null;
    }    
    
    
    
    public List<Categories> getRecordTypeList() {  
        catList = new List<Categories>();
        for(RecordType rt : [select id, name from recordtype where sobjecttype = 'Solution' and name != 'Process/Procedure' and name != 'General' order by name]){
            cateObj = new Categories();
            cateObj.NodeId = rt.Id;
            cateObj.NodeName = rt.Name;            
            if(articleFilters != null && articleFilters.size() > 0) {
                for(Categories artType:articleFilters) {
                    if(artType.NodeId == rt.Id) 
                        cateObj.selected = true;
                }
            }                    
            catList.add(cateObj);
            mapOfRecordTypeNameWithId.put(rt.Id, rt.Name);
       }
       return catList;
    }
  
  
    public List<Categories> getChildCategories() {

        if(null != mapOfcateIdName && mapOfcateIdName.size() == 0) {
        
            for(BTBB_KBCategory__c btbbCat : btbbCatList)
                mapOfcateIdName.put(btbbCat.Id, btbbCat.CategoryName__c);                       
        }
        catList = new List<Categories>();
        if(null != product && product != 'All Products') { 
            String prodId = mapOfParentCatIdWithName.get(mapOfcateIdName.get(product));
            
            subCateList = new List<String>();
            for(CategoryNode catNode : catNodeList) {
                
                if(null != catNode.ParentId && null != prodId && (prodId.contains(catNode.ParentId) || prodId == catNode.ParentId)) {
                    cateObj = new Categories();
                    cateObj.NodeId = catNode.Id;
                    cateObj.NodeName = catNode.MasterLabel;
                    
                    //if Any top filter selected for Subcategory then it will select bydefault true
                    if(catFilters != null && catFilters.size() > 0) {
                        for(Categories catFilter :catFilters) {
                            if(catNode.MasterLabel.equals(catFilter.NodeName))
                                cateObj.selected = true;
                        } 
                    }
                    subCateList.add(catNode.MasterLabel);                   
                    catList.add(cateObj);               
                }
                
            } 
        }
        
        return catList;       
    }
    
    public List<Categories> getSubChildCategories() {
                
        catList = new List<Categories>();
        if(null != catFilters) {            
            for(Categories childCate : catFilters) {
                for(CategoryNode catNode : catNodeList) {
                    if(childCate.NodeId == catNode.ParentId) {
                   
                        cateObj = new Categories();
                        cateObj.NodeId = catNode.Id;
                        cateObj.NodeName = catNode.MasterLabel;
                        //if Any top filter selected for child Subcategory then it will select bydefault true
                        if(subCatFilters != null && subCatFilters.size() > 0) {
                            for(Categories subCatFilter :subCatFilters) {
                                if(catNode.MasterLabel.equals(subCatFilter.NodeName))
                                    cateObj.selected = true;
                            } 
                        }
                        catList.add(cateObj); 
                    }
                }                
            }             
        }        
        return catList;       
    }
    public Id cId { 
        get { 
            if(ApexPages.currentPage().getparameters().get('cid') != null) {
                cId = ApexPages.currentPage().getparameters().get('cid');
            }
            return cId;
        }
        set { 
            if(value != null) cId = value;
        }
    }
    
    public String subCategoryName { 
        get { 
            if(ApexPages.currentPage().getparameters().get('cid') != null) {                
                subCategoryName = mapOfCatNameWithId.get(cid);
            }
            return subCategoryName;
        }
        set { 
            if(value != null) subCategoryName = value;
        }
    }
    Map<Id, Set<Id>> mapofSetofCatIdWithsolId = new Map<Id, Set<Id>>();
   
    //public List<ArticleWrapper> getArticleList() {
    public void runArticleSearch() {
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and IsPublishedInPublicKb = true';
        articleList = new List<ArticleWrapper>();       
        List<String> majVerList = new List<String>();
        String prodId;
        Integer catFlag = 0;
        String category;
        Integer flag = 0;
        String searchSolIds;
                
        if(product == null && null != defaultProfileCategory && defaultProfileCategory.equals('All Products'))
            product = 'All Products';
        if(product != 'All Products' && (defaultProduct != null 
            || product != null || defaultCategory != null 
            || (defaultProfileCategory != null && !defaultProfileCategory.equals('All Products')) || (subCat != null && !subCat.equals('')))) {            
            
            //String category;
            catIdSet = new Set<Id>();            
            if(subCat == null || subCat.equals('')) {
                if(product != null && product != 'All Products') {                   
                    productFilter = mapOfcateIdName.get(product);
                    prodId = mapOfParentCatIdWithName.get(productFilter); 
                }
                else if(defaultProduct != null || defaultCategory != null || defaultProfileCategory != null) {
                    if(defaultProfileCategory != null) 
                        category = defaultProfileCategory;
                    else if(defaultProduct != null)
                        category = defaultProduct;
                    else 
                        category = defaultCategory;                               
                    
                    //product = mapOfParentCatIdWithName.get(category);
                    for(BTBB_KBCategory__c btbbCat : btbbCatList) {
                        if(btbbCat.CategoryName__c.equalsIgnoreCase(category)) {
                            product = btbbCat.Id;                                
                            productFilter = category;
                            isProductSel = true;  //will set true in case default product selection
                            break;        
                        }
                    }                
                    prodId = mapOfParentCatIdWithName.get(category);
                }                
                catIdSet =  mapOfSetCatIdWithParent.get(prodId);
                //Add all child level categories
                Set<Id> tempSet1 = new Set<Id>();
                Set<Id> tempSet2 = new Set<Id>();
                if(null != catIdSet)
                    tempSet1.addAll(catIdSet);
                for(Integer i = 0; i < 3; i++) {
                    tempSet2 = new Set<Id>(); 
                    for(Id catId : tempSet1) {
                         catIdSet.addAll(mapOfSetCatIdWithParent.get(catId));
                         tempSet2.addAll(mapOfSetCatIdWithParent.get(catId));
                         
                    }
                    tempSet1 = new Set<Id>();
                    if(tempSet2.size() > 0)
                        tempSet1.addAll(tempSet2);
                    else
                        break;
                    
                }                
                //System.debug('Contains >>>>' + catIdSet.contains('02n70000000HGvG'));
            } else if(subCat != null && (childCat == null || childCat.equals(''))) {
                catFilters = new List<Categories>();
                for(Id subCatStr : subCat.split(',',-1)) {  
                    if(null != catIdSet && catIdSet.size() > 0)
                        catIdSet.addAll(mapOfSetCatIdWithParent.get(subCatStr));
                    else
                        catIdSet = mapOfSetCatIdWithParent.get(subCatStr);                
                    
                    //Preparing list of sub category filters for top right of the page                    
                    cateObj = new Categories();
                    cateObj.NodeName = mapOfCatNameWithId.get(subCatStr);
                    CateObj.NodeId = subCatStr;                                        
                    catFilters.add(CateObj);
                }
                
                //Add all child level categories
                Set<Id> tempSet1 = new Set<Id>();
                Set<Id> tempSet2 = new Set<Id>();
                tempSet1.addAll(catIdSet);
                for(Integer i = 0; i < 2; i++) {
                    tempSet2 = new Set<Id>(); 
                    for(Id catId : tempSet1) {
                        
                         catIdSet.addAll(mapOfSetCatIdWithParent.get(catId));
                         tempSet2.addAll(mapOfSetCatIdWithParent.get(catId));
                         
                    }
                    tempSet1 = new Set<Id>();
                    if(tempSet2.size() > 0)
                        tempSet1.addAll(tempSet2);
                    else
                        break;
                    
                }
            } else {
                subCatFilters = new List<Categories>();
                for(Id subCatStr : childCat.split(',',-1)) {  
                    if(null != catIdSet && catIdSet.size() > 0)
                        catIdSet.addAll(mapOfSetCatIdWithParent.get(subCatStr));
                    else
                        catIdSet = mapOfSetCatIdWithParent.get(subCatStr);                
                    
                    //Preparing list of sub category filters for top right of the page                   
                    cateObj = new Categories();
                    cateObj.NodeName = mapOfCatNameWithId.get(subCatStr);
                    CateObj.NodeId = subCatStr;                                        
                    subCatFilters.add(CateObj);
                }
                
                //Add all child level categories
                Set<Id> tempSet1 = new Set<Id>();
                Set<Id> tempSet2 = new Set<Id>();
                tempSet1.addAll(catIdSet);
                for(Integer i = 0; i < 1; i++) {
                    tempSet2 = new Set<Id>(); 
                    for(Id catId : tempSet1) {
                        
                         catIdSet.addAll(mapOfSetCatIdWithParent.get(catId));
                         tempSet2.addAll(mapOfSetCatIdWithParent.get(catId));
                         
                    }
                    tempSet1 = new Set<Id>();
                    if(tempSet2.size() > 0)
                        tempSet1.addAll(tempSet2);
                    else
                        break;
                    
                }
            
            }            
            // For searchText
            
            if(searchText != null && !searchText.equals('')) {
                isSearchText = true;
                childCatIdSet = new Set<Id>();
                if(null != catIdSet)
                    for(Id catId : catIdSet) {                        
                        if(mapOfCatNameWithId.get(catId).contains(searchText))
                            childCatIdSet.add(catId);                                                      
                    }                
                mapofSetofCatIdWithsolId = new Map<Id, Set<Id>>();
                for(CategoryData catData : [Select RelatedSobjectId, Id,CategoryNodeId From CategoryData Where CategoryNodeId IN :childCatIdSet]) {
                    
                    //solIdSet.add(catData.RelatedSobjectId);
                    if(!mapofSetofCatIdWithsolId.containsKey(catData.RelatedSobjectId)) {
                        childCatIdSet = new Set<Id>();
                        childCatIdSet.add(catData.CategoryNodeId);
                        mapofSetofCatIdWithsolId.put(catData.RelatedSobjectId,catIdSet);
                    } else
                        mapofSetofCatIdWithsolId.get(catData.RelatedSobjectId).add(catData.CategoryNodeId);
                }
                System.debug('mapofSetofCatIdWithsolId map size>>>>>>>>>>>>>' + mapofSetofCatIdWithsolId.size());
                if(mapofSetofCatIdWithsolId.size() > 0) {
                    
                    for(Id solId: mapofSetofCatIdWithsolId.keySet()) {
                        if(searchSolIds != null)
                            searchSolIds += '\',\'' + solId;
                        else
                            searchSolIds = '(\''+solId;                    
                    }
                    
                    if(searchSolIds != null)
                                searchSolIds += '\')';
                } 
                   
            }
            //End of Search Text
            
            mapofSetofCatIdWithsolId = new Map<Id, Set<Id>>();
            if(null != catIdSet)
                for(CategoryData catData : [Select RelatedSobjectId, Id,CategoryNodeId From CategoryData Where CategoryNodeId IN :catIdSet]) {
                    
                    //solIdSet.add(catData.RelatedSobjectId);
                    if(!mapofSetofCatIdWithsolId.containsKey(catData.RelatedSobjectId)) {
                        catIdSet = new Set<Id>();
                        catIdSet.add(catData.CategoryNodeId);
                        mapofSetofCatIdWithsolId.put(catData.RelatedSobjectId,catIdSet);
                    } else
                        mapofSetofCatIdWithsolId.get(catData.RelatedSobjectId).add(catData.CategoryNodeId);
                }
            
            if(mapofSetofCatIdWithsolId.size() > 0) {
                String solIds;
                for(Id solId: mapofSetofCatIdWithsolId.keySet()) {
                    if(solIds != null)
                        solIds += '\',\'' + solId;
                    else
                        solIds = '(\''+solId;                    
                }
                if(solIds != null) {
                        
                    solIds += '\')';
                    soql += ' and Id IN '+ solIds;                                            
                }
            } else
                catFlag = 1;
                
        }
        System.debug('Soql Before search criteria >>>>>>> '+ soql);
        
        if(searchText != null && !searchText.equals('')) {
                
           soql = 'FIND {"' + searchText + '"} ' + soql;          
        }
        if(version != null)
            soql += ' and Major_Release__c includes (\''+ version + '\')';
        if(servPack != null && !servPack.equals('')) {
                String servicePack; 
            minorFilterList = new List<Categories>();       
            for(String servPackStr : servPack.split(',',-1)) {                             
                if(null != servicePack)
                    servicePack = servicePack + ',\'' + servPackStr + '\'';
                else
                    servicePack = '\'' + servPackStr + '\'';               
                
                //Preparing list of service Pack filters for top right of the page                    
                cateObj = new Categories();
                cateObj.NodeName = servPackStr;
                CateObj.NodeId = servPackStr;                                        
                minorFilterList.add(CateObj);
            }
            soql += ' and Version_s__c includes ('+ servicePack + ')';
        }
        
        //TP # 1775
        if(tarRelease != null && !tarRelease.equals('') && isKnownIssue == true) {
            String targetRelease; 
            targetFilterList = new List<Categories>();       
             for(String tarReleaseStr : tarRelease.split(',',-1)) {                             
                if(null != targetRelease)
                    targetRelease = targetRelease + ',\'' + tarReleaseStr + '\'';
                else
                    targetRelease = '\'' + tarReleaseStr + '\'';               
                
                //Preparing list of Target Release filters for top right of the page for Known issue                   
                cateObj = new Categories();
                cateObj.NodeName = tarReleaseStr;
                CateObj.NodeId = tarReleaseStr;                                        
                targetFilterList.add(CateObj);
            }
            soql += ' and Target_Release_New__c IN ('+ targetRelease + ')';
        } else {
                
                targetFilterList = new List<Categories>();
        }
        
        //Ebd Of TP #1775
        
        System.debug('Soql After search criteria >>>>>>> '+ soql);         
          
        System.debug('In Search articleTypes >>>>>>>>>>>>'+ articleTypes);  
        System.debug('In Search aType >>>>>>>>>>>>'+ aType);  
        if((articleTypes != null && !articleTypes.equals('')) || aType != null) {
            
            String articleTypeFilter;
            articleFilters = new List<Categories>();
            //If it is coming from Home page            
            if(aType != null && (articleTypes == null || articleTypes.equals(''))) {
            
                for(RecordType rt: recordTypes) {
                    
                     if(aType.equals('Downloads') && (rt.Name.Contains('Release') 
                        || rt.Name.Contains('Maintenance Release') || rt.Name.Contains('Other Resource'))) {
                        CateObj = new Categories();
                        cateObj.NodeId = rt.Id;
                        cateObj.NodeName = rt.name;
                        articleFilters.add(cateObj);
                        /*if(articleTypeFilter == null || articleTypeFilter.equals(''))
                            articleTypeFilter = '(\'' + rt.Id;
                        else
                            articleTypeFilter = articleTypeFilter += '\',\'' + rt.Id;*/
                        if(articleTypes == null || articleTypes.equals(''))
                            articleTypes = rt.Id;
                        else
                            articleTypes = articleTypes + ',' + rt.Id;
                     }else if(aType.equals('Release') && (rt.Name.Contains('Release') 
                        || rt.Name.Contains('Maintenance Release'))) {
                        CateObj = new Categories();
                        cateObj.NodeId = rt.Id;
                        cateObj.NodeName = rt.name;
                        articleFilters.add(cateObj);
                        if(articleTypeFilter == null || articleTypeFilter.equals(''))
                            articleTypeFilter = '(\'' + rt.Id;
                        else
                            articleTypeFilter = articleTypeFilter += '\',\'' + rt.Id;
                        if(articleTypes == null || articleTypes.equals(''))
                            articleTypes = rt.Id;
                        else
                            articleTypes = articleTypes + ',' + rt.Id;
                     
                     } else if(rt.Name.Contains(aType)) {                            
                        CateObj = new Categories();
                        cateObj.NodeId = rt.Id;
                        cateObj.NodeName = rt.name;
                        articleFilters.add(cateObj);
                        articleTypeFilter = '(\''+rt.Id;
                        articleTypes = rt.Id;
                        break;  
                    }                   
                }  
            } else if(aType == null && articleTypes != null && !articleTypes.equals('')) {                   
                
                isKnownIssue = false;
                for(String str : articleTypes.split(',',-1)) {
                    if(articleTypeFilter != null) 
                            articleTypeFilter += '\',\'' + str;
                        else
                            articleTypeFilter = '(\''+str;                                     
                    
                    //preparing list for top right filters
                    
                    for(RecordType rt : recordTypes){                   
                       
                        if(rt.Id == str) {  
                            //If Known issue selected
                            if(rt.Name.equals('Known Issue'))
                                isKnownIssue = true;    
                            CateObj = new Categories();
                            cateObj.NodeId = rt.Id;
                            cateObj.NodeName = rt.name;
                            articleFilters.add(cateObj);
                        }
                    }
                    
                    
                } 
            } else {
                
                isKnownIssue = false;
                for(String str : articleTypes.split(',',-1)) {
                    if(articleTypeFilter != null) 
                            articleTypeFilter += '\',\'' + str;
                        else
                            articleTypeFilter = '(\''+str;    
                    //preparing list for top right filters
                    for(RecordType rt : recordTypes){                   
                        
                        if(rt.Id == str) {
                            //If Known issue selected
                            if(rt.Name == 'Known Issue')
                                isKnownIssue = true;
                            CateObj = new Categories();
                            cateObj.NodeId = rt.Id;
                            cateObj.NodeName = rt.name;
                            articleFilters.add(cateObj);
                            break;
                        }
                    } 
                }                
            }
            if(articleTypeFilter != null) {
                articleTypeFilter += '\')';
                soql += ' and recordTypeId IN '+ articleTypeFilter;
            } 
        }
           
        if(patchValue != null && !patchValue.equals('')) {
            soql += ' and Patch_Available__c = \''+ patchValue + '\'';
            patchFilter = 'Patch Available';
        }
        //Added on 27Feb 2012 to implement TP#1629
        if(isXythosOnly == true) {
            soql += ' and RecordType.Name != \'' +'Known Issue' +'\'';            
        }
        //end of TP#1629
        
        //TP #1772
        if(null != aType && aType.equals('Downloads')) {
                System.debug('<<<<<<<<<<< In Dowmnload section >>>>>>>>>>>>');
                String soql1 = soql + ' and RecordType.Name = \'' +'Release' +'\' ORDER BY Published_Date__c DESC LIMIT 20';
                 System.debug('In Search soql 1 >>>>>>>>> '+ soql1);
                String soql2 = soql + ' and RecordType.Name = \'' +'Maintenance Release' +'\' ORDER BY Published_Date__c DESC LIMIT 20';
                 System.debug('In Search soql 2 >>>>>>>>> '+ soql2);  
                String soql3 = soql + ' and RecordType.Name = \'' +'Other Resource' +'\' ORDER BY SolutionName ASC, LastModifiedDate DESC LIMIT 20';
                 System.debug('In Search soql 3 >>>>>>>>> '+ soql3);
                try {
                   solList = Database.query(soql1);
                   articleList = ArticlesList(solList);                   
                   solList = Database.query(soql2);                   
                   articleList.addALL(ArticlesList(solList));
                   solList = Database.query(soql3);                   
                   articleList.addALL(ArticlesList(solList));
                } catch (Exception e) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
                }               
                
                
        }
        //end of TP#1772
        else {
                System.debug('<<<<<<<<<<< In Dowmnload Else section >>>>>>>>>>>>');
                if(searchText != null && !searchText.equals(''))   
                    if(isKnownIssue == true)
                        soql += ' ORDER BY SolutionName ASC, LastModifiedDate DESC LIMIT 200)';
                    else            
                        soql += ' ORDER BY SolutionName ASC, LastModifiedDate DESC LIMIT 60)';
                else      
                    if(isKnownIssue == true)
                        soql += ' ORDER BY SolutionName ASC, LastModifiedDate DESC LIMIT 300';
                    else      
                        soql += ' ORDER BY SolutionName ASC, LastModifiedDate DESC LIMIT 60';
                
                System.debug('In Search soql >>>>>>>>> '+ soql);
                
                
                try {
                        if(searchText != null && !searchText.equals('')) {
                                List<List<Sobject>> solList1 = search.query(soql);
                                solList = solList1[0];
                        } else
                                solList = Database.query(soql);
                } catch (Exception e) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
                }
                
                if(catFlag == 1)
                    solList = new List<Solution>();
                
                articleList = ArticlesList(solList);
        }        
        System.debug('Total articleList >>>>>>> ' + articleList);   
        if(articleList.size() == 0)
            articlesSize = 0;
         else
             articlesSize = articleList.size();
        //return articleList;
    }
    
    //Returns the list of Articles
    public List<ArticleWrapper> ArticlesList(List<Solution> solList) {
        ArticleWrapper article;
        List<ArticleWrapper> articles = new List<ArticleWrapper>();
        for(solution sol: solList) {
            System.debug('Atype Values >>>>>> ' + aType + ' <<<>>> ' + sol.RecordType.Name + ' <<<>>> '+ sol.ResourceType__c);
            if(null != aType && aType.equals('Downloads') && sol.RecordType.Name == 'Other Resource' && sol.ResourceType__c != 'Download')
                continue;
            article = new ArticleWrapper();
            article.articleId = sol.Id;
            article.articleName = sol.SolutionName;
            article.articleNumber = sol.SolutionNumber;
            article.articleTypeName = sol.RecordType.Name;
            article.TargetRelease = sol.Target_Release__c;
            article.Category = sol.Product__c;
            article.majorRelease = sol.Major_Release__c;
            if(sol.RecordType.Name == 'Known Issue')
                article.articleStyleName = 'btbbArticle knownIssue';
            else if(sol.RecordType.Name == 'Announcement')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Blackboard Client Program')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'General Article')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Other Resource')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Product Documentation')
                article.articleStyleName = 'btbbArticle documentation';
            else if(sol.RecordType.Name == 'Question/Answer')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Release')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Maintenance Release')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Supported Technologies Information')
                article.articleStyleName = 'btbbArticle';
            else if(sol.RecordType.Name == 'Support Bulletin/Security Advisory')
                article.articleStyleName = 'btbbArticle downloads';
            else if(sol.RecordType.Name == 'Troubleshooting/Informational')
                article.articleStyleName = 'btbbArticle';
            
             
            article.summary = sol.summary__c;
            article.patchAvailable = sol.Patch_Available__c;
            if(sol.Major_Release__c != null) {
                article.majorRelease = sol.Major_Release__c;
                article.majorReleases = sol.Major_Release__c.split(';',-1);
                                
            } 
            System.debug('Version_s__c >>>>>>>>>>>>>>>>>' + sol.Version_s__c);
            if(sol.Version_s__c != null) {
                
                article.version = sol.Version_s__c;
                article.Versions = sol.Version_s__c.split(';',-1);                                                  
            } 
            articles.add(article);                   
        }
        
        return articles;
    }
    
    public PageReference exportToExcel() {
        
        return Page.btbb_PublicExportToExcel;
    }
    
    public PageReference exportToPDF() {
        
        return Page.btbb_PublicExportToPDF;
    }
    
    public PageReference printKBSearch() {
        
        return Page.btbb_PublicSearchPrint;
    }
    
    class Categories {
        Categories() {}
        public String NodeId { get; set; }
        public String NodeName { get; set; }
        public Boolean selected { get; set;}
    }
    
    class ArticleWrapper {
        ArticleWrapper() {}
        public String articleId { get; set; }
        public String articleName { get; set; }
        public String articleNumber { get; set; }
        public String articleTypeName { get; set; }
        public String version { get; set; }
        public String majorRelease { get; set; }
        public String TargetRelease { get; set; }
        public String Category { get; set; }
        public List<String> Versions { get; set; }
        public List<String> majorReleases { get; set; }
        public String summary { get; set; }
        public String patchAvailable { get; set; }
        public String articleStyleName {get; set;} 
    }   
     
}