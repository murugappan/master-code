public class btbb_articleSearchController {

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
    private boolean cookieload=false;
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
    private transient list<KnowledgeArticleWrapperPDF> kavWrapperListPDF;
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
    private map<string,string> categorymap= new map<string,string>();
    public String defaultKBProduct {get; set;}
    public String defaultRelease {get; set;}
    public String defaultServicePack {get; set;}
    private KnowledgeArticleVersion defaultKav;
    private Boolean initialLoad = true;
    public Boolean isRunFromTest {get{if (isRunFromTest == null) return false; return isRunFromTest;} set;}
    public Integer listSize {get; set;}
    public  string BUaccess{get;set;}
    private class kbcookie{
        string selectedfilter;
        string articletypes;
        string searchText;
        string Sessioninfo;
        Integer CurrentPage;
        public void createcookie()
        {
            cookie kbsearchcookie;
            this.sessioninfo=Userinfo.getsessionid();
            string cookievalue=JSON.serialize(this);
            if(cookievalue!=null)
            {
                kbsearchcookie = new Cookie('kbsearch',cookievalue,null,-1,false);
                ApexPages.currentPage().setCookies(new Cookie[]{kbsearchcookie});
            }
        }
    }
    kbcookie cookieobject = new kbcookie() ;
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
 
    public btbb_articleSearchController() {
     categorymap=DescribeDataCategoryGroupStructures.dataCategoryLabelMap;
        system.debug('Url---'+System.URL.getCurrentRequestURL().getQuery());
        system.debug('Url#---'+System.URL.getCurrentRequestURL().getRef());
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
    public void loadDefaultProduct()
    {
        String allProductString = 'learn,learn_bu,ce/vista,ce_vista_bu,angel,angel_bu,xythos,xythos_bu,transact,transact_bu,collaborate,Moodlerooms,Analytics,xpLor';
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
            if (allProductString.containsignorecase(tempDefault))
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
                if(cookieload==false)
                {
                 cookieobject.selectedfilter=selectedfilter;
                 publicSearchText = ApexPages.currentPage().getParameters().get('searchText');
                 if (publicSearchText != null && publicSearchText != '')
                    {
                        searchText = publicSearchText + '*';
                    }
                    else
                    {
                        searchText = '';
                    }
                 cookieobject.searchText=searchtext;   
                 cookieobject.createcookie();  
                } 
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
          string versions;//TP3623
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
                                    versions=s1; //TP3615
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
                 String  tempName;
                 if (mainArticle.versions != null)
                    {
                      for (String s : mainArticle.versions.split(','))
                       {
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
                If(selectedfilter != null && selectedfilter != '')
                {
                    if(cookieload==false)
                {
                 cookieobject.selectedfilter=selectedfilter;
                 cookieobject.createcookie();
                }
                }
            }
        }       
    }
    
    private void loadArticleTypes()
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
        if(initialload==true&&cookieload == true)
        {
           for (String s : articleTypeNameList)
            {
                Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
                articleLabelNameMap.put(r.getLabel(), s);
                prefixLabelMap.put(r.getKeyPrefix(), r.getLabel());
                if(cookieobject.articletypes!= null)
                {
                articleTypeList.add(new ArticleTypeWrapper(r.getLabel(), cookieobject.articletypes.containsignorecase(r.getname())));
                }
                 else
                {
                    articleTypeList.add(new ArticleTypeWrapper(r.getLabel(), false));
                }
            }
        }
        else
        {
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
        }
       // updateArticleType();
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
      if(selectedArticleTypes!=null)  
     cookieobject.articletypes=selectedArticleTypes;
     if(cookieload==false)
      cookieobject.createcookie();
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
      if(selectedArticleTypes!=null)  
     cookieobject.articletypes=selectedArticleTypes;
    // if(cookieload==false)
      cookieobject.createcookie();
     PageReference pageRef = refreshSearchResult();   
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
        
        cookieobject.selectedfilter=selectedFilter;
        cookieobject.createcookie();
        selectedRelease = null;
        selectedCategory = null;
        PageReference pageRef = refreshSearchResult();
      //  loadSize(); size loaded in refreshsearchResult
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
        cookieobject.selectedfilter=newfilter;
        cookieobject.createcookie();
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
     //   loadSize();
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
         cookieobject.selectedfilter=newFilter;
        cookieobject.createcookie();
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
    //    loadSize();
    }
    
    public void updateTypes()
    {
        PageReference pageRef = refreshSearchResult();
     //   loadSize();
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
        cookieobject.selectedfilter=newFilter;
        cookieobject.createcookie();
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
      //  loadSize();
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
        cookieobject.selectedfilter=newfilter;
        cookieobject.createcookie();
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
        system.debug(selectedFilter);
   //     loadSize();
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
        cookieobject.selectedfilter=newFilter;
        cookieobject.createcookie();
        selectedFilter = newFilter;
        PageReference pageRef = refreshSearchResult();
     //   loadSize();
    }
    
    public PageReference exportToExcel()
    {
        return Page.btbb_KBExportToExcel;
    }
    
    public PageReference exportToPDF()
    {
        PageReference KBpdfpage = new PageReference('/apex/btbb_KBExportToPDF');
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
            cookieobject.CurrentPage=currentPage;
            cookieobject.createcookie(); 
        }
        return null;
    }    
 
    //action for previous click
    public PageReference previous() 
    {        
        if(currentPage > 1)
        {
            currentPage = currentPage - 1;
            cookieobject.CurrentPage=currentPage;
            cookieobject.createcookie();
        }
        return null;
    }
    
    public string getselectedfilterlabel(){
        string versionname=selectedFilter.substringBetween('Version:',',');
        string productname=selectedFilter.substringBetween('Product:',',');
        string FixVersionName=selectedFilter.substringAfter('Planned_First_Fix_Release:');
        string versionlabel=categorymap.get('Version:_:'+versionname);
        string productlabel=categorymap.get('Product:_:'+productname);
        string FixVersionLabel=categorymap.get('Planned_First_Fix_Release:_:'+FixVersionName);
        string filterlabel='Version:'+(versionlabel!=null?versionlabel:'')+', Product:'+(productlabel!=null?productlabel:'')+', Planned First Fix Release:'+
                            (FixVersionLabel!=null?FixVersionLabel:'');
        
        
        return filterlabel;
    }
    
    
   public void loadcategorypicklist()
   { 
    try
    {
    
        if(cookieload==true)
        {
                if(cookieobject.selectedfilter!= null && cookieobject.selectedFilter != '')
                {
                  selectedFilter=cookieobject.selectedfilter;
                }
        }
        system.debug('test1---'+selectedfilter);
        if(selectedFilter != null)
        {
            string versionname = selectedFilter.substringBetween('Version:',',');
            string productname=selectedFilter.substringBetween('Product:',',');
            string FixVersionName=selectedFilter.substringAfter('Planned_First_Fix_Release:');
            if(versionname != null )
            {
                list<String> versionlist= new list<String>();
                string temp= versionname;
                while(temp != null && temp != 'All_Solutions' && temp !='All' && Versions__c.getValues(temp.left(38).toLowerCase())!=null)
                {
                    versionlist.add(temp);
                    if(Versions__c.getValues(temp.left(38).toLowerCase())!=null)
                    {
                        temp= Versions__c.getValues(temp.left(38).toLowerCase()).parent__c;
                    }   
                }
                if(versionlist!=null)
                {
                  system.debug('versiolist--'+versionlist);
                  for(integer i = versionlist.size(); i>=0; i--)
                  { 
                    if(i==4)
                    {
                     selectedServicePack=versionlist[(versionlist.size()-4)];    
                    }
                    if(i==3)
                    {
                     selectedRelease=versionlist[(versionlist.size()-3)];    
                    }
                    else if(i==2)
                    {
                     selectedProduct= versionlist[versionlist.size()-2];   
                    }
                    else if(i==1)
                    {
                       selectedProduct=versionlist[versionlist.size()-1];
                    }
                    
                   
                  }
                }
            }
            
              if(FixVersionName != null )
            {
                    selectedFirstFix= FixVersionName;
                
            }
            
            if(productname != null )
            {
                list<String> productnamelist= new list<String>();
                string temp= productname;
                while(temp != null && temp != 'All' && Product__c.getValues(temp.left(38).toLowerCase())!=null)
                {
                    productnamelist.add(temp);
                    if(Product__c.getValues(temp.left(38).toLowerCase())!=null)
                    {
                        temp= Product__c.getValues(temp.left(38).toLowerCase()).parent__c;
                    }   
                }
                if(productnamelist!=null)
                {
                  for(integer i = productnamelist.size(); i>0; i--)
                  { 
                    if(i==4)
                    {
                     selectedSubCategory=productnamelist[(productnamelist.size()-4)];    
                    }
                    else if(i==3)
                    {
                     selectedSubCategory=productnamelist[(productnamelist.size()-3)];    
                    }
                    else if(i==2)
                    {
                        selectedCategory= productnamelist[productnamelist.size()-2];
                    }
                  }
                }
                
            }
            
        } 
    }    
    catch(exception e)
    {  
        
    }
   }
    // Action call when the new list needs to be fetched
    public PageReference refreshSearchResult() 
    {
        if (publicSearchText != null && publicSearchText != '')
        {
            searchText = publicSearchText + '*';
        }
        else
        {
            searchText = '';
        }
        
        system.debug('searchterm---'+searchText);
        maxSize = currentPage = 1;
        loadSize();
        cookieobject.searchtext=publicSearchText;
        cookieobject.createcookie();
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
        
       // kavWrapperListPDF = QueryKnowledgeArticleTypeUtilityPDF.QuerySize(searchText, categoryFilter, selectedArticleTypes);
        maxSize = QueryKnowledgeArticleTypeUtilityPDF.QuerySize(searchText, categoryFilter, selectedArticleTypes);
        // maxSize = maxSize.divide(PAGE_NUMBER,2,System.RoundingMode.UP);
    }
    
    private void loadcookie()
    {
        try
        {
            if(ApexPages.currentPage().getParameters().get('kbsearch')!=null && ApexPages.currentPage().getParameters().get('kbsearch')!='')
            {
                cookie kbsearchcookie=ApexPages.currentPage().getCookies().get('kbsearch');
                if(kbsearchcookie != null)
                {
                    cookieobject=(kbcookie)JSON.deserialize(kbsearchcookie.getvalue(),kbcookie.class);
                    if(cookieobject.searchtext!=null && cookieobject.searchtext!='')
                    {
                        searchtext=cookieobject.searchtext+'*';
                        publicsearchtext=cookieobject.searchtext;
                    }
                    else
                    {
                         searchText = '';
                    }
                    cookieload=true;
                }
            }
        }
        catch(exception e)
        {
            cookieload=false;
        }
    }
    
    public void validateaccess()
    {
        BUaccess='';
        List<user> u=[select id,contactid from user where id=:userinfo.getuserid()];
        if(u!= null && u.size()>0)
        {
            for(Contact_Role__c cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c From Contact_Role__c c where Contact__c=: u[0].ContactID AND role__c like '%Admin%' AND Expire_Role__c  = false AND Contact__c!= NULL])
            {
                if(cr.Role__c.containsignorecase('Learn')||cr.Role__c.containsignorecase('Angel')||cr.Role__c.containsignorecase('Vista')||cr.Role__c.containsignorecase('Xythos'))
                {
                    BUaccess=BUaccess+',Learn_BU,ANGEL_BU,Xythos_BU,CE_Vista_BU';
                }
                else if(cr.Role__c.containsignorecase('Collaborate'))
                {
                    BUaccess=BUaccess+',Collaborate';
                }
                 else if(cr.Role__c.containsignorecase('Moodlerooms'))
                {
                    BUaccess=BUaccess+',Moodlerooms';
                }
                else if(cr.Role__c.containsignorecase('Analytics'))
                {
                    BUaccess=BUaccess+',Analytics';
                }
                else if(cr.Role__c.containsignorecase('xpLor'))
                {
                    BUaccess=BUaccess+',xpLor';
                }
            }
        }
    }
    // This method will determine if the user is logged in and if the article passed exist
    public PageReference redirect()
    {
        PageReference pageRef;
        
        if ((gc.userRedirect == true || isRunFromTest == true) )
        {
            pageRef = new PageReference(gc.IDMRedirectURL);
            pageRef.getParameters().put('TARGET',gc.IDMTargetURL);          
            pageRef.setRedirect(true);
            return pageRef;
        }
        if(ApexPages.currentPage().getParameters().get('kbsearch')==null)
        {
            pagereference pageref2= ApexPages.currentPage();
            pageref2.getparameters().put('kbsearch','init');
            pageref2.setredirect(true);
            cookie kbsearchcookie=ApexPages.currentPage().getCookies().get('kbsearch');
            kbsearchcookie = new Cookie('kbsearch',null,null,-1,false);
            ApexPages.currentPage().setCookies(new Cookie[]{kbsearchcookie});
            loadDefaultProduct();
            loadDefaultDataCategories();
            cookieload=false;
            return pageref2;
        }
        else if(ApexPages.currentPage().getParameters().get('kbsearch')=='true')
        {
            cookieload= true;
        }
        else if(ApexPages.currentPage().getParameters().get('kbsearch')=='init')
        {    initialLoad =false;
            cookieload= false;
        }
        validateaccess();
        currentPage = 1;
        maxSize = 1;
        if(BUaccess.containsignorecase('Learn'))
        {
            selectedProduct = 'Learn_BU';
            selectedFilter = 'Version:Learn,Product:,Planned_First_Fix_Release:';
        }
        else if(BUaccess.containsignorecase('Collaborate'))
        {
            selectedProduct = 'Collaborate';
            selectedFilter = 'Version:Collaborate,Product:,Planned_First_Fix_Release:';   
        }
        else if(BUaccess.containsignorecase('Moodlerooms'))
        {
            selectedProduct = 'Moodlerooms';
            selectedFilter = 'Version:Moodlerooms,Product:,Planned_First_Fix_Release:';   
        }
        else if(BUaccess.containsignorecase('Analytics'))
        {
            selectedProduct = 'Analytics';
            selectedFilter = 'Version:Analytics,Product:,Planned_First_Fix_Release:';   
        }
        else if(BUaccess.containsignorecase('xpLor'))
        {
            selectedProduct = 'xpLor';
            selectedFilter = 'Version:xpLor,Product:,Planned_First_Fix_Release:';   
        }
        selectedRelease = '';
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
        loadcookie();
        loadArticleTypes();
        loadcategorypicklist();
        loadSize();
        if(cookieobject != null && cookieobject.CurrentPage != null && cookieload==true)
        {
            if((cookieobject.CurrentPage*Page_Number)<maxSize)
            {
                Currentpage=cookieobject.CurrentPage;
            }
        }
        initialLoad = false;   
        cookieload=false;     
        return null;
    }


}