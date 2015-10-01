public class articleSearchController {
    GlobalComponent gc = new GlobalComponent();
    // The soql without any filters
    private String soql;
    //Top right filters
    public String productFilter { get; set; }
    public String majorFilter { get; set; } 
  //  public String title { get; set; }
  //  public String summary { get; set; }       
    public List<Categories> articleFilters {get; set;}   
    public List<Categories> minorFilterList {get; set;}
    public List<Categories> targetFilterList {get; set;}
    public List<Categories> catFilters {get; set;}
    public List<Categories> subCatFilters {get; set;}
    public String patchFilter { get; set;}

    public List<String> subCateList{get; set; }
    public Integer articlesSize { get; set; }
    public String version {get; set; }
    public String documentType {get; set; }
    public string sbsatypevalue{get; set;}
    public String resourceType {get; set; }
    public String docTypeFilter { get; set; }
    public String resTypeFilter { get; set; }
   public string sbsatypeFilter{get; set;}
    public Boolean isSearchText { get; set; }
    public Boolean isWordSearch { get; set; }
    public Boolean isXythosOnly { get; set; }
    public Boolean bulletinadvisory{get;set;}
   
    
    
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
    public boolean isProdDoc { get; set; }
    public boolean isOtherResource { get; set; }
    
    public String tarRelease{get;set;}
    public String servPack{get;set;}
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
   public List<Solution> solList = new List<Solution>();
    List<Solution> topSolList;
    List<Solution> restSolList;
    public Transient List<ArticleWrapper> articleList { get; set; }
    public List<ArticleWrapper> articleForExcel { get{return ArticlesList(solList);} set;}
    public List<ArticleWrapper> articleForPDF {get; set;}    
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
    
    //Added to implement TP#2062
    public List<SelectOption> DocumentTypes { 
        get {
            List<SelectOption> DocumentTypeList = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult =
            Solution.Document_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
            for( Schema.PicklistEntry f : ple)
            {
               DocumentTypeList.add(new SelectOption(f.getLabel(), f.getValue()));
            }                                              
            return DocumentTypeList;
        }
        set;
    }
    //TP2244
    public List<SelectOption> bulletinadvisoryTypes { 
        get {
            List<SelectOption> bulletinadvisoryTypeList = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult =
            Solution.Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
            for( Schema.PicklistEntry f : ple)
            {
               bulletinadvisoryTypeList.add(new SelectOption(f.getLabel(), f.getValue()));
            }                                              
            return bulletinadvisoryTypeList;
        }
        set;
    }
    
    public List<SelectOption> ResourceTypes { 
        get { 
            List<SelectOption> ResourceTypeList = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = Solution.ResourceType__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
                
            for( Schema.PicklistEntry f : ple)
            {
               ResourceTypeList.add(new SelectOption(f.getLabel(), f.getValue()));
            }                       
                              
            return ResourceTypeList;
        }
        set;
    }
    //End of added to implement TP#2062
        
    public List<SelectOption> Products { 
        get { 
            List<SelectOption> productList = new List<SelectOption>();
            productList.add(new SelectOption('All Products','All Products'));
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
                if(null != versions && versions.size() > 1)       
                    return false;
                else
                    return true;
        }
        set;
    }
    
    public Boolean isCatSel {
        get {                
                if(null != catFilters && catFilters.size() > 0)       
                    return true;
                else
                    return false;
        }
        set;
    }
    
    public PageReference selectProduct() {                 
        if(null != product && product != 'All Products') {
            catFilters = null;
            minorFilterList = new List<Categories>();
            version = null;
            majorFilter = null;
            
                      
        } else
            productFilter = null;
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        
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

                    for(BTBB_KBVersion__c btbbVer : [Select Name,Version__c, Id From BTBB_KBVersion__c where BTBB_KBCategory__c = :product ORDER BY Version__c DESC ] ) {
                        
                        options.add(new SelectOption(btbbVer.Version__c,btbbVer.Version__c));
                    }
            }
            return options;
        }
        set;
    }
    
    public List<Categories> getMinVersion() {  
        catList = new List<Categories>();
        if (product != null) {

            for(BTBBminorVersion__c btbbmVer : [Select Name,VersionName__c, Id From BTBBminorVersion__c where BTBB_KBCategory__c = :product ORDER BY VersionName__c DESC] ) {
                
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

        for(TargetReleaseMap__c  TrgRmap : [Select Name, Id From TargetReleaseMap__c where BTBB_KBCategory__c = :product ORDER BY Name DESC] ) {
            
            cateObj = new Categories();
                cateObj.NodeId = TrgRmap.Name ;
                cateObj.NodeName = TrgRmap.Name ;
                if(targetFilterList != null && targetFilterList.size() > 0) {
                    for(Categories tarRelease:targetFilterList) {
                        if(tarRelease.NodeName.Equals(TrgRmap.Name))
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
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        runArticleSearch();
        return null;
    }
    
    public PageReference selectDocType() {  
           
        if(null != DocumentType && DocumentType != '') {
            docTypeFilter = DocumentType;            
        } else
            docTypeFilter = null;
       
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        runArticleSearch();
        return null;
    }
    
    public PageReference selectResType() { 
        
        if(null != ResourceType && ResourceType != '') {
            resTypeFilter = ResourceType;            
        } else
            resTypeFilter = null;
        
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        runArticleSearch();
        return null;
    }
public PageReference selectSBSAType() { 
        
        if(null != sbsatypevalue && sbsatypevalue != '') {
            sbsatypeFilter = sbsatypevalue;            
        } else
            sbsatypeFilter = null;
        
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release_New__c,Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release_New__c ,Target_Release__c, ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
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
    
    public articleSearchController() {
          isWordSearch = false; 
      System.debug('what value does isWordSearch  >>>>>>>>> '+ isWordSearch );
       //soql = 'Select ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
       if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
       GlobalComponent globalObj = new GlobalComponent();
       isXythosOnly = globalObj.isXythosOnly();
       catNodeList = [Select ParentId, MasterLabel, Id From CategoryNode];
       btbbCatList = [Select Id, CategoryName__c From BTBB_KBCategory__c ORDER BY CategoryName__c ASC];
       
       if(isXythosOnly == true)
                recordTypes = [select id, name from recordtype where sobjecttype = 'Solution' and name != 'Process/Procedure' and name != 'Known Issue' and name != 'General' order by name];
       else
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
   /*    if(ApexPages.currentPage().getparameters().get('isKISearch') == 'true'){
       servPack = Apexpages.currentPage().getParameters().get('servicePack');
       // aType = ApexPages.currentPage().getparameters().get('aType');
       isKnownIssue = true ;
       }*/       
       isFilterSelect = false;
       if(ApexPages.currentPage().getparameters().get('isKISearch') == 'true'){
       for(BTBB_KBCategory__c btbbCat : btbbCatList) {
                mapOfcateIdName.put(btbbCat.Id, btbbCat.CategoryName__c);
          }
        solution temp_solution = [select id,Major_Release__c,version_s__c from solution where id =:Apexpages.currentPage().getParameters().get('sourceID')];
        if(temp_solution.version_s__c != null)
        for(string s: temp_solution.version_s__c.split(';',-1))
        {
        if(servPack != null && servPack == '')
        {
        servpack = servpack +','+s;
        }
        else
        {
        servpack = s;
        } 
        }
        
    //servPack = Apexpages.currentPage().getParameters().get('servicePack');
       product =  Apexpages.currentPage().getParameters().get('Id'); 
       if(product !=null && product !='')
       {
       isProductSel = true;
       }
       version =  temp_solution.Major_Release__c.split(';',-1)[0] ; 
       system.debug('---productid123---'+ product+'--bbcatlist--'+btbbCatList.size());
       majorFilter=version;
       if(Apexpages.currentPage().getParameters().get('isTarget')=='true')
       {
       servpack = null;
       for(TargetReleaseMap__c t : [Select Service_Pack__c, Name From TargetReleaseMap__c where BTBB_KBCategory__c=:product and service_pack__c IN:temp_solution.version_s__c.split(';',-1)])
       {
    //   system.debug('----target_populate---' + t.name);
       if(tarRelease != null && tarRelease != '')
       {
       tarrelease = tarrelease+','+t.name;
       }
       else
       {
       tarrelease=t.name;
       } 
       }
       }
          isFilterSelect = true;
 isKnownIssue = true ;
       
}
       if(ApexPages.currentPage().getparameters().get('searchText') != null) {
           searchText = ApexPages.currentPage().getparameters().get('searchText');                
       }
       isRemove = false;
   //    isFilterSelect = false;
       runArticleSearch();
       
    } 
    
    public String aType { 
        get {             
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
        system.debug('++++++Inside Run');
        tarRelease = Apexpages.currentPage().getParameters().get('tarRelease'); 
        servPack = Apexpages.currentPage().getParameters().get('servPack');         
        subCat = Apexpages.currentPage().getParameters().get('subCat');       
        childCat = Apexpages.currentPage().getParameters().get('childCat');
        articleTypes = Apexpages.currentPage().getParameters().get('articleTypes'); 
        patchValue = Apexpages.currentPage().getParameters().get('patchValue');    
        topFilter = Apexpages.currentPage().getParameters().get('topFilterPage'); 
        searchText = Apexpages.currentPage().getParameters().get('searchTextPage');
        system.debug('++++++searchText'+searchText);
        if(searchText == null || searchText.equals(''))
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';        
        
        
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
            
           
        } else            
            subCatFilters = new List<Categories>();
            
        if (!articleTypes.equals('')) {
            
            isFilterSelect = true;
        } else {
            articleFilters = new List<Categories>();
            targetFilterList = new List<Categories>();
            isKnownIssue = false;
            isProdDoc = false;
            isOtherResource = false;
            isRemove = true;
            bulletinadvisory=false;   //TP2244
        }
        
        if (!patchValue.equals('')) {
            isFilterSelect = true;           
        } else
            patchFilter = null;
            
        if (!searchText.equals('')) {
                isSearchText = true;
        }    
        if(!topFilter.equals('')) {
            
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
            
            } else if(topFilter.equals('Document Type')) {
            
                DocumentType = null;
                docTypeFilter = null;
                           
            }else if(topfilter.equals('Bulletin_Advisory'))
            {
            sbsatypevalue=null;
            sbsatypefilter=null;
            }
            else if(topFilter.equals('Resource Type')) {
            
               ResourceType = null;
               resTypeFilter = null;
                                  
            } else if(topFilter.equals('Patch Available'))
                patchFilter = null;      
            isRemove = true;
        
        }
        system.debug('+++over here');
        runArticleSearch();
     
        return null;
    }    
    
    
    
    public List<Categories> getRecordTypeList() {  
        catList = new List<Categories>();
        for(RecordType rt : [select id, name from recordtype where sobjecttype = 'Solution' and name != 'Process/Procedure' and name != 'General' order by name]){
            cateObj = new Categories();
            cateObj.NodeId = rt.Id;
            cateObj.NodeName = rt.Name;
            if(isXythosOnly == true && rt.Name == 'Known Issue')
                continue;
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
    
    // Added by Dominic 6/12/12
    private String createSearchString(String s)
    {
        Boolean isDigit = Pattern.matches('[\\d]+', s);
        
        if (isDigit) 
        {
            return ('*' + s + '*');
        }
        else
        {
            return s;
        }
    }
    
    //public List<ArticleWrapper> getArticleList() {
    public void runArticleSearch() {
        if(searchText == null || searchText == '')
                soql = 'Select Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName From Solution Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        else
                soql = 'RETURNING Solution(Product__c, Target_Release__c , ResourceType__c, Id, RecordTypeId, RecordType.Name, Patch_Available__c , summary__c, Major_Release__c, Version_s__c, SolutionNumber, SolutionName Where RecordType.Name != \'' +'Process/Procedure' +'\' and Status = \''+ 'Published' + '\'and Visible_in_Customer_Portal__c = true';
        articleList = new List<ArticleWrapper>();
        articleForExcel = new List<ArticleWrapper>();
        articleForPDF = new List<ArticleWrapper>();       
        List<String> majVerList = new List<String>();
        String prodId;
        Integer catFlag = 0;
        String category;        
        String searchSolIds;        
        System.debug('Passss 1  >>>>>>>>> '+ soql);        
        if(product == null && null != defaultProfileCategory && defaultProfileCategory.equals('All Products'))
            product = 'All Products';
        if(product != 'All Products' && (defaultProduct != null 
            || product != null || defaultCategory != null 
            || (defaultProfileCategory != null && !defaultProfileCategory.equals('All Products')) || (subCat != null && !subCat.equals('')))) {            
            
            //String category;
            catIdSet = new Set<Id>();            
            if(subCat == null || subCat =='') {
            system.debug('#####Pass 1####'+product);
                if(product != null && product != 'All Products') {                   
                    productFilter = mapOfcateIdName.get(product);
                    system.debug('#####Pass 2####'+mapOfcateIdName);
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
                    System.debug('Passss 1  >>>>>>>>> '+ prodId);
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
                isWordSearch = true;
                System.debug('what value does isWordSearch2  >>>>>>>>> '+ isWordSearch );
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
        
        String soql2;
        
        if(searchText != null && !searchText.equals('')) {
           String searchString = createSearchString(searchText);
           soql2 = soql;     
           soql = 'FIND {"' + searchString + '"} ' + soql;
           soql2 = 'FIND {' + searchString.replace(' ', ' OR ') + '} '+ soql2;          
        }
        if(version != null)
        {
            soql += ' and Major_Release__c includes (\''+ version + '\')';
            soql2 += ' and Major_Release__c includes (\''+ version + '\')';
        }
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
            soql += ' and (Version_s__c includes ('+ servicePack + ') or Version_s__c = null)';
            soql2 += ' and (Version_s__c includes ('+ servicePack + ') or Version_s__c = null)';
        }
        System.debug('Passss 23  >>>>>>>>> '+ soql);
        system.debug('Passss 23  >>>>>>>>> '+ soql2);
        
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
            soql += ' and Target_Release__c IN ('+ targetRelease + ')';
            soql2 += ' and Target_Release__c IN ('+ targetRelease + ')';
            System.debug('Passss 234  >>>>>>>>> '+ soql);
            system.debug('Passss 234  >>>>>>>>> '+ soql2);
        } else {
                
                targetFilterList = new List<Categories>();
        }
        
        //Ebd Of TP #1775
        
          
        if((articleTypes != null && !articleTypes.equals('')) || aType != null) {
            Integer docFlag = 0;
            Integer otherFlag = 0;
            Integer SBSAflag = 0;
            String articleTypeFilter;
            articleFilters = new List<Categories>();
            //If it is coming from Home page            
            if(aType != null && (articleTypes == null || articleTypes.equals(''))) {
                isKnownIssue = false;
                bulletinadvisory=false;  //TP2244
                
                for(RecordType rt: recordTypes) {
                     if(aType.equals('Known')) {
                        isKnownIssue = true;
                     }
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
                isProdDoc = false;
                isOtherResource = false;                
                for(String str : articleTypes.split(',',-1)) {
                    if(articleTypeFilter != null) 
                            articleTypeFilter += '\',\'' + str;
                        else
                            articleTypeFilter = '(\''+str;                                     
                    
                    //preparing list for top right filters
                    System.debug('Passss 11  >>>>>>>>> '+ articleTypeFilter);
                    for(RecordType rt : recordTypes){                   
                       
                        if(rt.Id == str) {  
                            //If Known issue selected                            
                            if(rt.Name.equals('Known Issue'))
                                isKnownIssue = true;
                            if(rt.Name.equals('Product Documentation')){
                                isProdDoc = true; 
                                docFlag = 1;
                            } 
                            if(rt.Name.equals('Other Resource')) {
                                isOtherResource = true;   
                                otherFlag = 1;
                            }
                            if(rt.Name.equals('Support Bulletin/Security Advisory')){ 
                            bulletinadvisory=true; 
                              SBSAflag =1;    //TP2244
                            }
                            
                            CateObj = new Categories();
                            cateObj.NodeId = rt.Id;
                            cateObj.NodeName = rt.name;
                            articleFilters.add(cateObj);
                        }
                    }
                }                
                if(docFlag == 0) {
                        DocumentType = null;
                        docTypeFilter = null;
                    }
                    if(otherFlag == 0) {
                        ResourceType = null;
                        resTypeFilter = null;
                    }                    
                     if(SBSAflag ==0)
                {
                sbsatypevalue=null;
            sbsatypefilter=null;
                } 
            } else {
                
                isKnownIssue = false;
                isProdDoc = false;
                isOtherResource = false;                
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
                            if(rt.Name.equals('Product Documentation')){
                                isProdDoc = true; 
                                docFlag = 1;
                            } 
                            if(rt.Name.equals('Other Resource')) {
                                isOtherResource = true;   
                                otherFlag = 1;
                            }
                            
                            if(rt.Name.equals('Support Bulletin/Security Advisory')){ 
                            bulletinadvisory=true;   //TP2244
                            SBSAflag= 1;
                            }
                            CateObj = new Categories();
                            cateObj.NodeId = rt.Id;
                            cateObj.NodeName = rt.name;
                            articleFilters.add(cateObj);
                            break;
                        }
                    }                   
                }
                if(docFlag == 0) {
                    DocumentType = null;
                    docTypeFilter = null;
                }
                if(otherFlag == 0) {
                    ResourceType = null;
                    resTypeFilter = null;
                }  
                if(SBSAflag ==0)
                {
                sbsatypevalue=null;
            sbsatypefilter=null;
                }                              
            }
            if(articleTypeFilter != null) {
            	String notFixedReasons = '(\'Will Not Fix\',\'Duplicate\',\'Functioning As Designed\')';
        		soql += ' and Not_Fixed_Reason__c Not IN '+ notFixedReasons;
        		soql2 += ' and Not_Fixed_Reason__c Not IN '+ notFixedReasons;
                articleTypeFilter += '\')';
                soql += ' and recordTypeId IN '+ articleTypeFilter;
                soql2 += ' and recordTypeId IN '+ articleTypeFilter;
                System.debug('Passss 221  >>>>>>>>> '+ soql);
                system.debug('Passss 221  >>>>>>>>> '+ soql2);
            } 
        } else {
            
            DocumentType = null;
            ResourceType = null;
            docTypeFilter = null;
            resTypeFilter = null;
            sbsatypevalue=null;
            sbsatypefilter=null;
        }        
        
        if(patchValue != null && !patchValue.equals('')) {
            soql += ' and Patch_Available__c = \''+ patchValue + '\'';
            soql2 += ' and Patch_Available__c = \''+ patchValue + '\'';
            patchFilter = 'Patch Available';
        }
        if((DocumentType != null && !DocumentType.equals('')) || (ResourceType != null && !ResourceType.equals('')) ||(sbsatypevalue != null && !sbsatypevalue.equals('')))
    {
    soql += 'and(';
    soql2 += 'and(';
        if(DocumentType != null && !DocumentType.equals('')) {
            if(ResourceType != null && !ResourceType.equals('')|| (sbsatypevalue != null && !sbsatypevalue.equals(''))) 
            {
                soql += '(recordType.Name = \'' + 'Product Documentation' +'\' AND Document_Type__c = \''+ DocumentType + '\')';
                soql2 += '(recordType.Name = \'' + 'Product Documentation' +'\' AND Document_Type__c = \''+ DocumentType + '\')';
                }
            else
            {
                soql += 'recordType.Name = \'' + 'Product Documentation' +'\' AND Document_Type__c = \''+ DocumentType + '\'';
                soql2 += 'recordType.Name = \'' + 'Product Documentation' +'\' AND Document_Type__c = \''+ DocumentType + '\'';         
            }
        } 
        
        if(ResourceType != null && !ResourceType.equals('')) {
            
            if(DocumentType != null && !DocumentType.equals(''))
            {
                 soql += ' OR (recordType.Name=\'' + 'Other Resource' +'\' AND ResourceType__c = \''+ ResourceType + '\')';
                 soql2 += ' OR (recordType.Name=\'' + 'Other Resource' +'\' AND ResourceType__c = \''+ ResourceType + '\')';
             }    
            else if(sbsatypevalue != null && !sbsatypevalue.equals(''))               
            {
                soql += '(recordType.Name=\'' + 'Other Resource' +'\' AND ResourceType__c = \''+ ResourceType + '\')'; 
                soql2 += '(recordType.Name=\'' + 'Other Resource' +'\' AND ResourceType__c = \''+ ResourceType + '\')';
             }
             else{
                 soql += 'recordType.Name=\'' + 'Other Resource' +'\' AND ResourceType__c = \''+ ResourceType + '\''; 
                 soql2 += 'recordType.Name=\'' + 'Other Resource' +'\' AND ResourceType__c = \''+ ResourceType + '\'';      
                 }
            }
         
         if(sbsatypevalue != null && !sbsatypevalue.equals(''))  
         {
         if((DocumentType != null && !DocumentType.equals('')) || (ResourceType != null && !ResourceType.equals('')))
         {
         soql += ' OR (recordType.Name=\'' + 'Support Bulletin/Security Advisory' +'\' AND Type__c = \''+ sbsatypevalue + '\')';
         soql2 += ' OR (recordType.Name=\'' + 'Support Bulletin/Security Advisory' +'\' AND Type__c = \''+ sbsatypevalue + '\')';
         }else
         {
         soql += 'recordType.Name=\'' + 'Support Bulletin/Security Advisory' +'\' AND Type__c = \''+sbsatypevalue+ '\'';
         soql2 += 'recordType.Name=\'' + 'Support Bulletin/Security Advisory' +'\' AND Type__c = \''+sbsatypevalue+ '\'';
         }
         } 
       soql += ')'  ;
       soql2 += ')'  ; 
     }    
        //Added on 27Feb 2012 to implement TP#1629
        if(isXythosOnly == true) {
            soql += ' and RecordType.Name != \'' +'Known Issue' +'\'';
            soql2 += ' and RecordType.Name != \'' +'Known Issue' +'\'';      
            System.debug('Passss 21  >>>>>>>>> '+ soql);  
            system.debug('Passss 21  >>>>>>>>> '+ soql2);     
        }
        //end of TP#1629
        
        //TP #1772
        /*if(null != aType && aType.equals('Downloads')) {
            
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
        else {*/      
        system.debug('++++++searchText'+searchText);        
                if(searchText != null && !searchText.equals('')) 
                { 
                    if(isKnownIssue == true)
                    {
                        //soql += ' ORDER BY TimesUsed DESC nulls last THEN BY LastModifiedDate DESC LIMIT 200)';
                        soql += ' ORDER BY LastModifiedDate DESC LIMIT 400)';
                        soql2 += ' ORDER BY LastModifiedDate DESC LIMIT 400)';
                    }    
                    else
                    {            
                        //soql += ' ORDER BY TimesUsed DESC nulls last THEN BY LastModifiedDate DESC LIMIT 60)';
                        soql += ' ORDER BY LastModifiedDate DESC LIMIT 60)';
                        soql2 += ' ORDER BY LastModifiedDate DESC LIMIT 60)';
                    }
                }       
                else
                {      
                    if(isKnownIssue == true)
                    {
                        soql += ' ORDER BY TimesUsed DESC nulls last,LastModifiedDate DESC, SolutionName ASC LIMIT 400';
                        soql2 += ' ORDER BY TimesUsed DESC nulls last,LastModifiedDate DESC, SolutionName ASC LIMIT 400';
                    }
                    else
                    {    
                        soql += ' ORDER BY TimesUsed DESC nulls last,LastModifiedDate DESC, SolutionName ASC LIMIT 60';
                        soql2 += ' ORDER BY TimesUsed DESC nulls last,LastModifiedDate DESC, SolutionName ASC LIMIT 60';
                    }
                }
                System.debug('In Search soql321 >>>>>>>>> '+ soql);
                system.debug('In Search soql321 >>>>>>>>> '+ soql2);
                System.debug('In Search line 1072 >>>>>>>>> '+ solList);
                
                try {
                		system.debug(searchtext);
                        if(searchText != null && !searchText.equals('')) {
                                List <List<Sobject>> solList1 = search.query(soql);
                                solList = solList1[0];
                                map<Id, Solution> solutionMap = new Map<Id, Solution>(solList);
                                List <List<Sobject>> solList2 = search.query(soql2);
                                list<Solution> tempSols = solList2[0];
                                for (Solution s : tempSols)
                                {
                                    if (!solutionMap.containsKey(s.Id))
                                    {
                                        solList.add(s);
                                    }
                                }
                        } else
                                solList = Database.query(soql);
                                system.debug('++++values'+solList );
                } catch (Exception e) {
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
                }
                System.debug('Passss my logic  >>>>>>>>> '+ SolList);
                 System.debug('isWordSearch  >>>>>>>>> '+ isWordSearch +'  '+ searchText);
                if (solList.size() > 0){
            if(searchText != null){
              if(solution.summary__c != null){
            System.debug('what value does isWordSearch3  >>>>>>>>> '+ isWordSearch );
                topSolList = new List<Solution>();
                restSolList = new List<Solution>();
                
                String WordSearched = searchText.ToLowercase() ;
                
                for(Integer i=0 ;i< solList.size();i++){
     
              String title = string.valueof(solList[i].SolutionName) ;
              String summary = string.valueof(solList[i].summary__c) ;
             
                System.debug('title >>>>'+ title+ ' <<< summary__c >>>>' + summary + '  ' +title.Contains(searchText));
                if(((title != null) && title.ToLowercase().Contains(WordSearched)) || ((summary != null) && summary.ToLowercase().Contains(WordSearched))){
                            topSolList.add(solList[i]);
                   }
              else {
                             restSolList.add(solList[i]);
                }
                }
                System.debug('Passss234 134 see what it is returning1  >>>>>>>>> '+ restSolList);
                System.debug('Passss234 134 see what it is returning2  >>>>>>>>> '+ topSolList);
                topSolList.addall(restSolList);
                //articleList = ArticlesList(topSolList);
                solList = topSolList;
                System.debug('Passss234 134 see what it is returning3  >>>>>>>>> '+ articleList);
                }
}   
}            
                if(catFlag == 1)
                    solList = new List<Solution>();
             
             
                articleList = ArticlesList(solList);
                  
        if(articleList.size() == 0)
            articlesSize = 0;
         else
             articlesSize = articleList.size();
        //return articleList;
    
    }
    //Returns the list of Articles
    public List<ArticleWrapper> ArticlesList(List<Solution> solList) {
      map<id,solution>   soltdmap = new map<id,solution>(solList);
        map <id,categorynode> catnodlist= new map <id,categorynode>([select id,masterlabel from categorynode ]);
        list<categorydata> catdatalist = [select id,categorynodeid,RelatedSobjectId from categorydata where RelatedSobjectId in:soltdmap.keySet() ];
        map<id,list<categorydata>> solcatdatmap = new map<id,list<categorydata>>();
        for (categorydata ct :catdatalist )
        {
        if(solcatdatmap.get(ct.RelatedSobjectId) == null)
        {
        list<categorydata> temp = new list<categorydata>();
        temp.add(ct);
        solcatdatmap.put(ct.RelatedSobjectId,temp)  ;
        }
        else
        {
        solcatdatmap.get(ct.RelatedSobjectId).add(ct);  
        }
        
        }   
        
        ArticleWrapper article;
        List<ArticleWrapper> articles = new List<ArticleWrapper>();
        if (solList.size() > 0){
        for(solution sol: solList) {            
            if(null != aType && aType.equals('Downloads') && sol.RecordType.Name == 'Other Resource' && sol.ResourceType__c != 'Download')
                continue;
            article = new ArticleWrapper();
            article.articleId = sol.Id;
            article.articleName = sol.SolutionName;
            article.articleNumber = sol.SolutionNumber;
            article.articleTypeName = sol.RecordType.Name;
            article.TargetRelease = sol.Target_Release__c;
            if (solcatdatmap != null && !solcatdatmap.isEmpty() && sol != null && sol.Id != null && solcatdatmap.get(sol.Id) != null)
            {
	            for(categorydata ct: solcatdatmap.get(sol.id) )
	            {
	            	if (article != null)
	            	{
		                if(article.Category == null)
		                {
		                article.Category=   catnodlist.get(ct.categorynodeid).masterlabel;
		                }
		                else{
		            article.Category=   article.Category+', '+ catnodlist.get(ct.categorynodeid).masterlabel;
		                }
	            	}
	            }
            }
          // article.Category = sol.Product__c;
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
            
             if(sol.summary__c != null)
            article.summary = sol.summary__c.replaceall('<','&lt;').replaceall('>','&gt;');
            article.patchAvailable = sol.Patch_Available__c;
            if(sol.Major_Release__c != null) {
                article.majorRelease = sol.Major_Release__c;
                article.majorReleases = sol.Major_Release__c.split(';',-1);
             System.debug('Passss 134  >>>>>>>>> '+ soql);                   
            } 
           
            if(sol.Version_s__c != null) {
                
                article.version = sol.Version_s__c;
                article.Versions = sol.Version_s__c.split(';',-1);                                                  
            } 
            articles.add(article);                   
        }
        }
        return articles;
    }
    
    public PageReference exportToExcel() {
    articleForExcel = ArticlesList(solList);       
        return Page.btbb_KBExportToExcel;
     


    }
    
    public pagereference exportToPDF() {
        articleForExcel = ArticlesList(solList);
        system.debug('Pdf list --'+ ArticlesList(solList));
        return Page.btbb_KBExportToPDF;
       
        
    }
    
    public PageReference printKBSearch() {
        
        return Page.btbb_KBSearchPrint;
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
       // public String CategoryNodeName {get; set;} 
    }
    public PageReference Redirect() {
        if(gc.userRedirect == true){
            PageReference pageRedirect = new PageReference(gc.IDMRedirectURL);
            pageRedirect.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRedirect.setRedirect(true);
            return pageRedirect;
        } else {
            return null;
        }
    }
       
     
}