public class btbb_knownissues {

    public List<Solution> solList                           {get; set;}
    public List<CategoryNode> catnode                       {get; set;}
    public List<CategoryData> catdata                       {get; set;}
    public User u                                           {get; set;}
    public btbb_kbcategory__c sCatId;
    public String UserDefaultProduct;
    public String DefaultProduct;
    public CategoryNode MasterCategoryNode;
    public List<CategoryData> ArticleCategories;
    public List<CategoryNode> SubCatList1;
    public Set<CategoryNode> SubCatIds;
    public List<CategoryNode> SubCatList2;
    public boolean isProductSel                             {get; set;}
    public String productFilter                             {get; set;}
    public String majorFilter                               {get; set;}
    public String minorFilter                               {get; set;}
    public String patchFilter                               {get; set;}
    public List<Solution> KnownIssues;
    public String Version                                   {get; set;}
    public String Product                                   {get; set;}
    public List<BTBB_KBCategory__c> btbbCatList = new List<BTBB_KBCategory__c>();
    String subCat;
    
    public String MasterCategory;
    
    public String getFullName() {
        user u = [Select FirstName, LastName from User Where Id = :UserInfo.getUserId()];
        return u.FirstName + ' ' + u.LastName;
    }
    
    public String getUserDefaultProduct(){
        return userdefaultproduct;
    }
    
    public void defaultProductSelect(){
        User curUser=[SELECT Id, BTBB_KB_Default_Prod__c FROM User where Id = :userInfo.getUserId()];
        curUser.BTBB_KB_Default_Prod__c = userdefaultproduct;
        if(userdefaultproduct != null && userdefaultproduct != 'All Products')
        product = userdefaultproduct;
        else
        userdefaultproduct = 'Learn';
    }

    public String getProduct(){
        return product;
    }
    
    public PageReference selectProduct() {         
        System.debug('product Name: >>>>>>>>>>>> '+ product);
        if(null != product && product != '') {            
            version = null;
        } 
        else
        productFilter = null;
        subCat = null;
        if(product != null && !product.equals('All Products'))
            isProductSel = true;
        else
            isProductSel = false;
        return null;
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

    public List<SelectOption> Products {
        get { 
            List<SelectOption> productList = new List<SelectOption>();
            if(userdefaultproduct == 'All Products' || userdefaultproduct == null){
            productList.add(new SelectOption('','Select a Product'));
            }
            else {
            btbb_kbcategory__c kbcat = [select id, categoryname__c from btbb_kbcategory__c where categoryname__c =:userdefaultproduct];
            productlist.add(new SelectOption(kbcat.id,userdefaultproduct));
            isProductSel = true;
            product = kbcat.id;
            }
            for(BTBB_KBCategory__c btbbCat : [Select Name,CategoryName__c, Id From BTBB_KBCategory__c where CategoryName__c != :userdefaultproduct ORDER BY Name ASC] ) {
                productList.add(new SelectOption(btbbCat.Id,btbbCat.CategoryName__c));       
            }
            return productList;
        }
        set;
    }
    
    public List<SelectOption> Versions { 
        get { 
            List<selectOption> options = new List<selectOption>();            
            options.add(new SelectOption('','Select a Version'));
            
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

    public String getDefaultProduct(){
        return DefaultProduct;
    }

    public List<Solution> getKnownIssues() {
        return KnownIssues;
    }

    public void selectMajor() {         
        KnownIssues = [SELECT Id, SolutionNumber, SolutionName, Summary__c, Version_s__c, Major_Release__c, Target_Release_New__c, Patch_Available__c, Product__c FROM Solution WHERE RecordTypeId = :RT.getId(Solution.SObjectType, RT.Name.Known_Issue) AND Major_Release__c = : Version AND Status = 'Published' AND Visible_in_Customer_Portal__c = true];  
    }
    
    public btbb_knownissues(){
        User curUser=[SELECT Id, BTBB_KB_Default_Prod__c FROM User where Id = :userInfo.getUserId()];
        if(Product != Null)
            sCatId = [select id, categoryname__c from btbb_kbcategory__c where id =:Product];
        else if(curUser.BTBB_KB_Default_Prod__c != Null && curUser.BTBB_KB_Default_Prod__c != 'All Products')
            sCatId = [select id, categoryname__c from btbb_kbcategory__c where categoryname__c =:curUser.BTBB_KB_Default_Prod__c];
        else
            sCatId = [select id, categoryname__c from btbb_kbcategory__c where categoryname__c =: 'Learn'];
        
        MasterCategoryNode = [Select Id, MasterLabel From CategoryNode Where MasterLabel =:sCatId.CategoryName__c];
        
    
    
    
    }
}