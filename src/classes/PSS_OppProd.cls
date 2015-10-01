global with sharing class PSS_OppProd extends BALINK1.BALINK_ProductSelection{
    private Map<String, Schema.SObjectField> MapFields = Schema.SObjectType.Product2.fields.getMap();
    public string ProductSize{get;set;}
    public string SelectedUOM{get;set;}
    public string SelectedType{get;set;}
    

    
    public List<SelectOption> getUOM() 
    {
          List<SelectOption> optionList = new List<SelectOption>();
          optionList.add(new SelectOption('','--None--'));
          Schema.DescribeFieldResult fieldResult = Product2.Unit_of_Measure__c.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          for( Schema.PicklistEntry f : ple)
            optionList.add(new SelectOption(f.getLabel(), f.getValue()));
          return optionList;   
    }
    
    public List<SelectOption> getType() 
    {
          List<SelectOption> optionList = new List<SelectOption>();
          optionList.add(new SelectOption('','--None--'));
          Schema.DescribeFieldResult fieldResult = Product2.Type__c.getDescribe();
          List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
          for( Schema.PicklistEntry f : ple)
            optionList.add(new SelectOption(f.getLabel(), f.getValue()));
          return optionList;   
    }
/********************************************Constructor***************************************/
    public PSS_OppProd(ApexPages.StandardController controller)
    {
        showErrorMessage = false;
        try{
           if(currentOpp == null)
           {
                retID=controller.getId();
                this.currentOpp = (Opportunity)controller.getRecord();
                string currentOppSQL ; 
                if(!MC)
                    currentOppSQL ='select id ,name,pricebook2id from Opportunity where id =\''+String.escapeSingleQuotes(retId)+'\'';
                else
                    currentOppSQL='select id,name,pricebook2id,currencyisocode from Opportunity where id =\''+String.escapeSingleQuotes(retId)+'\'';
                 currentOpp =database.query(currentOppSQL);
                 if(currentOpp.Id==null)
                 {
                    e.setMessage('Error');
                    throw e;
                 }
           }
        }
        catch(Exception err)
        {
            isId=false;
            showErrorMessage = true;
            Apexpages.addMessages(err);
        }
    }
    
    
    global override PageReference init()
    {
    
        try
        {
            sql = 'Select Id, Pricebook2Id,Product2.description,Product2.Name,Product2.Family,Product2.ProductCode,Product2.Unit_of_Measure__c, Product2.Type__c, Product2.External_Long_Description__c ,Product2Id, UnitPrice, IsActive, ProductCode FROM PricebookEntry ';
            PageReference p = initAction();
           
            if(p!=null)
            {
                
                Pagereference p1 = Page.PSS_OppProd;///apex/BALINK_ProductSelection
                string h = p1.getUrl() + '?id='+currentopp.id+'&sURL=';
                p.getParameters().put('retURL',h);
                p.getParameters().put('id' , currentopp.id);
                return p;
            }
            setpaging(new BALINK1.Common_Paging('PricebookEntry',25,sql,'Product2.ProductCode'));
            CreateGrid();
        }
        catch(Exception er)
        {
            showErrorMessage = true;
            Apexpages.addMessages(er);
        }
        return null;
    }
    global override void CreateGrid()
    { 
        
        string f='PricebookEntry.IsActive = true AND Pricebook2.isactive =true AND PricebookEntry.PriceBook2Id = \'' + currentOpp.PriceBook2Id +'\'';
        if(MC)
        {
            SObject c = currentOpp;
            //this.currentOpp.CurrencyIsoCode
            f+=' AND currencyisocode = \'' + c.get('CurrencyIsoCode') + '\' ';
        }
        
        if(SelectedUOM!=null)
        {
            f+=' AND Product2.Unit_of_Measure__c = \'' + SelectedUOM + '\' ';
        } 
        
        if(SelectedType!=null)
        {
            f+=' AND Product2.Type__c = \'' + SelectedType + '\' ';
        }   
               
        f+= ' AND ( (Product2.Family=\'\') ';
       
        string moreFilter =getfilter().buildFilter(); 
        f+= 'OR ( ';
        if(getProFamily() != null)
        {
            f+=' Product2.Family= \''+ String.escapeSingleQuotes(getProFamily()) +'\' ' ;
        }
        if(getProFamily() == null)
        {
            f+=' Product2.Family != \'\' ' ;
        }
        if(ProductSize != null)
            f+=' AND Product2.size__c= \''+ String.escapeSingleQuotes(ProductSize) +'\' ' ;
         
        if(moreFilter.length() > 3)
            f += ' and '+  getfilter().buildFilter() ;
        f+= ' ) ) ';
        getfilter().setSObjectName('Product2');
        f+=getfilter().CreateFilterByKeyWord(getsearchKeyWord(),MapFields);
        getpaging().setCustomFilters( f);
        getpaging().GetSearchResult();
        
        setTxtTitle(' 1 of ' + string.valueOf(getpaging().getPageIndexLimit()));
    }
    global override PageReference selectProd()
    {
        return Page.PSS_OppProdGrid;
    }

    global override PageReference AddMoreProduct()
    {
        try
        {
            list <opportunityLineItem> op = new list <opportunityLineItem>();
            for(BALINK1.BALINK_OpportunityLineItemDS o : getListItem())
            {
                   op.add(o.getlineItem());
            }   
            upsert op;
            PageReference acctPage = Page.PSS_OppProd;
            return acctPage;
        }
        catch(Exception err)
        {
            showErrorMessage = true;
            Apexpages.addMessages(err);
            return null;
        }
        
    }
     static testMethod void myTest() {
        
        Opportunity opp = [Select o.Name, o.Id,o.StageName,o.Pricebook2Id,o.CurrencyIsoCode From Opportunity o where o.Pricebook2Id !=null limit 1];
        ApexPages.StandardController con = new ApexPages.StandardController(opp);
        PSS_OppProd ps = new PSS_OppProd(con);  
        ps.setisTest(true);  
        ps.SelectedType='Hardware'; 
       // ps.SelectedUOM='Day';
        //ps.ProductSize='20'; 
       // ps.CreateGrid(); 
        ps.setOpportunity(opp);
        ps.getUOM();
        ps.getType();
        ps.initAction();
        ps.init();
        ps.AddMoreProduct();
        ps.selectProd(); 
       // ps.ProductSize='20';
        ps.SelectedUOM='Day';
        ps.CreateGrid();
         
     }
    
}