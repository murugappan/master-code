public without sharing class publickbsearch 
{
    public class ArticleTypeWrapper
    {
        public String name {get; private set;}
        public String displayName {get; private set;}
        public Boolean selected {get; set;}
        
        public ArticleTypeWrapper(String n, Boolean flag)
        {
            selected = flag;
            name = n;
        }
    }
    
    public String searchText {get; set;}
    public String publicSearchText {get; set;}
    public String selectedProduct {get; set;}
    public String selectedRelease {get; set;}
    public String selectedServicePack {get; set;}
    public String selectedFirstFix {get; set;}
    public String selectedCategory {get; set;}
    public String selectedSubCategory {get; set;}
    public String selectedTypes {get; set;}
    public String selectedFilter {get; set;}
    public String selectedArticleTypes {get; set;}
    public String debugText {get; private set;}
    private String aType;
    public list<SelectOption> productList {get; private set;}
    public list<ArticleTypeWrapper> articleTypeList {get; private set;}
    private transient list<KnowledgeArticleWrapper> kavWrapperList;
    private Static Final Integer PAGE_NUMBER = 10;
    //Keeps track of current page & max size of article list
    public Integer currentPage {get; set;}
    public Integer maxSize {get; set;}
    public Boolean isXythosOnly {get; set;}
    private map<String,Schema.SOBjectType> globalDescribeMap = Schema.getGlobalDescribe();
    private map<String, String> articleLabelNameMap;
    private map<String, String> prefixLabelMap;
    private list<KnowledgeArticleVersion> articleList;
    private GlobalComponent gc = new GlobalComponent();
    public String defaultKBProduct {get; set;}
    public String defaultRelease {get; set;}
    public String defaultServicePack {get; set;}
    private KnowledgeArticleVersion defaultKav;
    private Boolean initialLoad = true;
    public Boolean isRunFromTest {get{if (isRunFromTest == null) return false; return isRunFromTest;} set;}
    public Integer listSize {get; set;}
    private transient list<KnowledgeArticleWrapperPDF> kavWrapperListPDF;
    public Boolean isKnownIssue
    {
        get
        {
            if (selectedArticleTypes != null && selectedArticleTypes.contains('known_issue'))
            {
                return true;
            }
            return false;
        }
        private set;
    }
 
    public publickbsearch () {
    currentPage = 1;
        maxSize = 1;
        selectedProduct = 'All_Solutions';
        selectedRelease = '';
        selectedCategory = 'All';
        selectedFilter = 'Version:,Product:,Planned_First_Fix_Release:';
        publicSearchText = ApexPages.currentPage().getParameters().get('searchText');
        if (publicSearchText != null && publicSearchText != '')
        {
            searchText = publicSearchText + '*';
        }
        else
        {
            searchText = '';
        }
        aType = ApexPages.currentPage().getParameters().get('aType');
        GlobalComponent globalObj = new GlobalComponent();
        isXythosOnly = globalObj.isXythosOnly();
        loadDefaultProduct();
        loadDefaultDataCategories();
        loadArticleTypes();
        loadSize();
        initialLoad = false;  
    
    }
    
    public list<KnowledgeArticleWrapper> getkavWrapperList()
    {
        String categoryFilter = '';
        kavWrapperList = new list<KnowledgeArticleWrapper>();
        
        if (selectedFilter != null)
        {
            for (String s : selectedFilter.split(','))
            {
                if (s.substring(s.indexOf(':') + 1) != null && s.substring(s.indexOf(':') + 1).length() > 1)
                {
                    if (categoryFilter == '')
                    {
                        categoryFilter = s.substring(0, s.indexOf(':')) + '__c ABOVE_OR_BELOW ' + s.substring(s.indexOf(':') + 1)  +'__c';
                    } 
                    else 
                    {
                        categoryFilter = categoryFilter + ' AND ' + s.substring(0, s.indexOf(':')) + '__c ABOVE_OR_BELOW ' + s.substring(s.indexOf(':')  + 1)  +'__c';
                    }
                }
            }
        }
        return QueryKnowledgeArticleTypeUtility.createList(searchText, categoryFilter, selectedArticleTypes);
    }
    
    public void loadDefaultProduct()
    {
        String allProductString = 'learn,learn_bu,ce/vista,ce_vista_bu,angel,angel_bu,xythos,xythos_bu,transact,transact_bu,collaborate';
        String tempDefault = '';
        
        if (initialLoad == true)
        {
            system.debug(ApexPages.currentPage());
            system.debug(ApexPages.currentPage().getParameters());
            system.debug(ApexPages.currentPage().getParameters().containsKey('articleId'));
            system.debug(ApexPages.currentPage().getParameters().containsKey('viewAll'));
            system.debug(!ApexPages.currentPage().getParameters().containsKey('articleId') && ApexPages.currentPage().getParameters().containsKey('viewAll'));
            String articleId = ApexPages.currentPage().getParameters().get('articleId');
            String viewAll = ApexPages.currentPage().getParameters().get('viewAll');
            
            if (articleId == null && viewAll != null)
            {
                tempDefault = ApexPages.currentPage().getParameters().get('viewAll');
                tempDefault = tempDefault.toLowerCase();
            }
            if (allProductString.contains(tempDefault))
            {
                defaultKBProduct = ApexPages.currentPage().getParameters().get('viewAll');
            }
            else
            {
                User currentUser;
                try
                {
                    currentUser = [Select Id, BTBB_KB_Default_Prod__c From User Where Id =: UserInfo.getUserId()];
                }
                catch (Queryexception e)
                {
                    currentUser = new User();
                }                        
                
                if (currentUser != null && currentUser.BTBB_KB_Default_Prod__c != null && !currentUser.BTBB_KB_Default_Prod__c.contains('All'))
                {
                    defaultKBProduct = currentUser.BTBB_KB_Default_Prod__c;
                }
            }
            if (defaultKBProduct != null)
            {
                selectedProduct = defaultKBProduct.replace(' ', '_'); 
                selectedProduct = selectedProduct.replace('/', '_');
                selectedFilter = 'Version:' + selectedProduct + ',Product:,Planned_First_Fix_Release:';
            }
        }       
    }
    
    public void loadDefaultDataCategories()
    {
        if (initialLoad == true)
        {
            if (defaultKav == null)
            {
                try
                {
                    defaultKav = [Select Id, Title, KnowledgeArticleId From KnowledgeArticleVersion Where Id =: ApexPages.currentPage().getParameters().get('articleId')];
                }
                catch (Queryexception e) {}
            }
            if (defaultKav != null)
            {
                string section=ApexPages.currentPage().getParameters().get('section');//TP3623
                string tempName;//TP3615
                try
                {
                    Maintenance_Release__kav mr = [Select m.Title, m.KnowledgeArticleId, m.Id, m.ArticleNumber, m.LastPublishedDate 
                                                   From Maintenance_Release__kav m
                                                   Where Id =: defaultKav.Id];
                    
                    KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(mr.Id, mr.Title, mr.ArticleNumber, mr.KnowledgeArticleId);
                    mainArticle.dataCategoryMap = new map<String, list<String>>();
                    for (Maintenance_Release__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                                    From Maintenance_Release__DataCategorySelection a
                                                                    Where ParentId =: mr.Id])
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
                    
                    if (mainArticle != null && mainArticle.dataCategoryMap != null)
                    {
                        selectedFilter = '';
                        for (String s : mainArticle.dataCategoryMap.keySet())
                        {
                            if (s == 'Version')
                            {
                                if (selectedFilter != '')
                                {
                                    selectedFilter += ',';
                                }
                                for (String s1 : mainArticle.dataCategoryMap.get(s))
                                {
                                    selectedFilter += s + ':' + s1;
                                    break;
                                }
                            }
                        }
                        if (!selectedFilter.contains('Product'))
                        {
                            selectedFilter += ',Product:';
                        }
                        if (!selectedFilter.contains('Planned_First_Fix_Release'))
                        {
                            selectedFilter += ',Planned_First_Fix_Release:';
                            if(section=='resolved')//TP3615
                            {
                                for (String s : mainArticle.versions.split(','))
                                {
                                    system.debug('Where--');
                                    tempName = s;
                                    if (s.contains('('))
                                    {
                                        tempName = s.substring(0, s.indexOf('(') - 1);
                                        
                                    }
                                    Boolean check = pattern.matches('[a-zA-Z]+', tempname.substring(0, 1));
                                    if (!check) 
                                    {
                                        tempName = 'X' + tempName;
                                    }
                                    tempName = tempName.replace(' ', '_');
                                    tempName = tempName.replace('.', '_');
                                    tempName = tempName.replace('/', '_');
                                    selectedFilter = 'Version:,Product:,Planned_First_Fix_Release:' + tempName;
                                    break;
                                }
                            } 
                        }
                    }
                }
                catch (Queryexception e) {}
                try
                {
                    Release__kav mr = [Select m.Title, m.KnowledgeArticleId, m.Id, m.ArticleNumber
                                       From Release__kav m
                                       Where Id =: defaultKav.Id];
                    
                    KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(mr.Id, mr.Title, mr.ArticleNumber, mr.KnowledgeArticleId);
                    mainArticle.dataCategoryMap = new map<String, list<String>>();
                    for (Release__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                                    From Release__DataCategorySelection a
                                                                    Where ParentId =: mr.Id])
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
                    
                    if (mainArticle != null && mainArticle.dataCategoryMap != null)
                    {
                        selectedFilter = '';
                        for (String s : mainArticle.dataCategoryMap.keySet())
                        {
                            if (s == 'Version')
                            {
                                if (selectedFilter != '')
                                {
                                    selectedFilter += ',';
                                }
                                for (String s1 : mainArticle.dataCategoryMap.get(s))
                                {
                                    selectedFilter += s + ':' + s1;
                                    break;
                                }
                            }
                        }
                        if (!selectedFilter.contains('Product'))
                        {
                            selectedFilter += ',Product:';
                        }
                        if (!selectedFilter.contains('Planned_First_Fix_Release'))
                        {
                            selectedFilter += ',Planned_First_Fix_Release:';
                        }
                    }
                }
                catch (Queryexception e) {}
            }
        }       
    }
    
    public void loadArticleTypes()
    {
        list<String> articleTypeNameList = new list<String>();
        articleTypeList = new list<ArticleTypeWrapper>();
        articleLabelNameMap = new map<String, String>();
        prefixLabelMap = new map<String, String>();
        
        for (String s : globalDescribeMap.keySet()) 
        {
            if (s.endswith('__kav')) 
            {
                articleTypeNameList.add(s);
            }
        }
        
        articleTypeNameList.sort();
        
        for (String s : articleTypeNameList)
        {
            Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
            articleLabelNameMap.put(r.getLabel(), s);
            prefixLabelMap.put(r.getKeyPrefix(), r.getLabel());
            if (aType != null)
            {
                articleTypeList.add(new ArticleTypeWrapper(r.getLabel(), r.getLabel().contains(aType)));
            }
            else
            {
                articleTypeList.add(new ArticleTypeWrapper(r.getLabel(), false));
            }
        }
        updateArticleType();
    }
    
    public void updateArticleType()
    {
        selectedArticleTypes = null;
        
        for (ArticleTypeWrapper atw : articleTypeList)
        {
            if (atw.selected)
            {
                if (selectedArticleTypes == null)
                {
                    selectedArticleTypes = articleLabelNameMap.get(atw.name);
                }
                else
                {
                    selectedArticleTypes += ',' + articleLabelNameMap.get(atw.name);
                }
            }
        }
    }
    
    public void updateReleases()
    {
        if (selectedProduct == 'All_Solutions')
        {
            selectedFilter = 'Version:,Product:,Planned_First_Fix_Release:';
        }
        else if (selectedProduct == 'All')
        {
            selectedFilter = 'Version:,Product:,Planned_First_Fix_Release:';
        }
        else
        {
            selectedFilter = 'Version:' + selectedProduct + ',Product:,Planned_First_Fix_Release:';
        }
        selectedRelease = null;
        selectedCategory = null;
        PageReference pageRef = refreshSearchResult();
        loadSize();
    }
    
    public void updateVersionBuild()
    {
        String newFilter = '';
        for (String s : selectedFilter.split(','))
        {
            String tempS;
            
            if (s.contains('Version'))
            {
                tempS = 'Version:' + selectedRelease;
                s = tempS;
            }
            if (newFilter == '')
            {
                newFilter = s;
            }
            else
            {
                newFilter += ',' + s;
            }
        }
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
        loadSize();
    }
    
    public void updateSubCategory()
    {
        String newFilter = '';
        for (String s : selectedFilter.split(','))
        {
            String tempS;
            
            if (s.contains('Product'))
            {
                tempS = 'Product:' + selectedCategory;
                s = tempS;
            }
            if (newFilter == '')
            {
                newFilter = s;
            }
            else
            {
                newFilter += ',' + s;
            }
        }
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
        loadSize();
    }
    
    public void updateTypes()
    {
        PageReference pageRef = refreshSearchResult();
        loadSize();
    }
    
    public void updateServicePack()
    {
        String newFilter = '';
        for (String s : selectedFilter.split(','))
        {
            String tempS;
            
            if (s.contains('Version'))
            {
                tempS = 'Version:' + selectedServicePack;
                s = tempS;
            }
            if (newFilter == '')
            {
                newFilter = s;
            }
            else
            {
                newFilter += ',' + s;
            }
        }
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
        loadSize();
    }
    
    public void updateFirstFix()
    {
        String newFilter = '';
        for (String s : selectedFilter.split(','))
        {
            String tempS;
            
            if (s.contains('Planned_First_Fix_Release'))
            {
                tempS = 'Planned_First_Fix_Release:' + selectedFirstFix;
                s = tempS;
            }
            if (newFilter == '')
            {
                newFilter = s;
            }
            else
            {
                newFilter += ',' + s;
            }
        }
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
        system.debug(selectedFilter);
        loadSize();
    }
    
    public void updateSubCategoryFinal()
    {
        String newFilter = '';
        for (String s : selectedFilter.split(','))
        {
            String tempS;
            
            if (s.contains('Product'))
            {
                tempS = 'Product:' + selectedSubCategory;
                s = tempS;
            }
            if (newFilter == '')
            {
                newFilter = s;
            }
            else
            {
                newFilter += ',' + s;
            }
        }
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
        loadSize();
    }
    
    public PageReference exportToExcel()
    {
        return Page.btbb_publicExportToExcel;
    }
    
    public PageReference exportToPDF()
    {
         PageReference KBpdfpage = new PageReference('/apex/btbb_PublicExportToPDF');
        KBpdfpage.setRedirect(true);
        return KBpdfpage;
    }
    
    public PageReference printKBSearch()
    {
        return Page.btbb_KBSearchPrint;
    }
 
    // Returns whether we need to see previous button or not
    public boolean getPrevRequired() 
    {
        return currentPage > 1;
    }

    // Returns whether we need to see next button or not
    public boolean getNextRequired() 
    {
        return currentPage * PAGE_NUMBER < maxSize;
    }

    //action for next click
    public PageReference next() 
    {
        if(maxSize > currentPage * PAGE_NUMBER) 
        {
            currentPage = currentPage + 1;
        }
        return null;
    }    
 
    //action for previous click
    public PageReference previous() 
    {        
        if(currentPage > 1)
        {
            currentPage = currentPage - 1;
        }
        return null;
    }
    
    // Action call when the new list needs to be fetched
    public PageReference refreshSearchResult() 
    {
        if (searchText != null && searchText != '')
        {
            searchText = publicSearchText + '*';
        }
        else
        {
            searchText = publicSearchText;
        }
        maxSize = currentPage = 1;
        loadSize();
        return null;
    }
    
    public void loadSize()
    {
        String categoryFilter = '';
        kavWrapperList = new list<KnowledgeArticleWrapper>();
        
        if (selectedFilter != null)
        {
            system.debug(selectedFilter);
            for (String s : selectedFilter.split(','))
            {
                if (s.substring(s.indexOf(':') + 1) != null && s.substring(s.indexOf(':') + 1) != '')
                {
                    if (categoryFilter == '')
                    {
                        categoryFilter = s.substring(0, s.indexOf(':')) + '__c ABOVE_OR_BELOW ' + s.substring(s.indexOf(':') + 1)  +'__c';
                    } 
                    else 
                    {
                        categoryFilter = categoryFilter + ' AND ' + s.substring(0, s.indexOf(':')) + '__c ABOVE_OR_BELOW ' + s.substring(s.indexOf(':')  + 1)  +'__c';
                    }
                }
            }
        }
        system.debug(categoryFilter);
        
        kavWrapperList = QueryKnowledgeArticleTypeUtility.createList(searchText, categoryFilter, selectedArticleTypes);
        maxSize = kavWrapperList.size();
        // maxSize = maxSize.divide(PAGE_NUMBER,2,System.RoundingMode.UP);
    }
    

     public  list<list<KnowledgeArticleWrapperPDF>> getkavWrapperListPDF()
    {
        String categoryFilter = '';
        kavWrapperListPDF = new list<KnowledgeArticleWrapperPDF>();
        
        if (selectedFilter != null)
        {
            for (String s : selectedFilter.split(','))
            {
                if (s.substring(s.indexOf(':') + 1) != null && s.substring(s.indexOf(':') + 1).length() > 1)
                {
                    if (categoryFilter == '')
                    {
                        categoryFilter = s.substring(0, s.indexOf(':')) + '__c ABOVE_OR_BELOW ' + s.substring(s.indexOf(':') + 1)  +'__c';
                    } 
                    else 
                    {
                        categoryFilter = categoryFilter + ' AND ' + s.substring(0, s.indexOf(':')) + '__c ABOVE_OR_BELOW ' + s.substring(s.indexOf(':')  + 1)  +'__c';
                    }
                }
            }
        }
         
          // list<KnowledgeArticleWrapper> tempwrapperlist=new list<KnowledgeArticleWrapper>(QueryKnowledgeArticleTypeUtility.createList(searchText, categoryFilter, selectedArticleTypes));
           //system.debug('Lenght--'+ tempwrapperlist.size());
           //knowledgearticlewrapper.catgorylabelMap=DescribeDataCategoryGroupStructures.dataCategoryLabelMap;
           transient list<list<knowledgearticlewrapperPDF>> templist= new list<list<knowledgearticlewrapperPDF>>();
           transient list<KnowledgeArticleWrapperPDF> templist2=new list<knowledgearticlewrapperPDF>();
           Integer counter=0;
           for(knowledgearticlewrapperPDF kaw:QueryKnowledgeArticleTypeUtilityPDF.createList(searchText, categoryFilter, selectedArticleTypes) )
           {
             templist2.add(kaw);
             if(counter >= 999)
             {
               templist.add(templist2);
               templist2= new list<knowledgearticlewrapperPDF>();
               counter=0;
              }
              else
              {
              counter++;
              }
           }
           if(counter!=0)
           {
             templist.add(templist2);
           }
           listSize=templist.size();
         system.debug('counter--'+counter);  
       // return QueryKnowledgeArticleTypeUtility.createList(searchText, categoryFilter, selectedArticleTypes);
       return templist;
    }
    // This method will determine if the user is logged in and if the article passed exist
    public PageReference redirect()
    {
        PageReference pageRef;
        
        if (gc.userRedirect == true || isRunFromTest == true)
        {
            pageRef = new PageReference(gc.IDMRedirectURL);
            pageRef.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRef.setRedirect(true);
            return pageRef;
        }
        
        currentPage = 1;
        maxSize = 1;
        selectedProduct = 'All_Solutions';
        selectedRelease = '';
        selectedCategory = 'All';
        selectedFilter = 'Version:,Product:,Planned_First_Fix_Release:';
        publicSearchText = ApexPages.currentPage().getParameters().get('searchText');
        if (publicSearchText != null && publicSearchText != '')
        {
            searchText = publicSearchText + '*';
        }
        else
        {
            searchText = '';
        }
        aType = ApexPages.currentPage().getParameters().get('aType');
        GlobalComponent globalObj = new GlobalComponent();
        isXythosOnly = globalObj.isXythosOnly();
        loadDefaultProduct();
        loadDefaultDataCategories();
        loadArticleTypes();
        loadSize();
        initialLoad = false;        
        return null;
    }
}