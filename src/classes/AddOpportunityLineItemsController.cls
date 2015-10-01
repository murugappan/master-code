/*
    @author         Etienne Coutant <etienne.coutant@blackboard.com>
    @class          AddOpportunityLineItemsController
    @abstract       add Product Wizard
    @since          2011.0715
    @discussion     Class to add OpportunityLineItems to an existing Opportunity
*/
public with sharing class AddOpportunityLineItemsController {


    // ------------------------------------------------
    // Class Variables
    // ------------------------------------------------
    Opportunity opportunity;
    public PageReference choosePricebookPage = null;


    //Filters
    public List<String> productCategories = new List<String>();
    public List<String> productSubCategories = new List<String>();
    public String productBand {get;set;}


    //Text in the search box
    public string searchText {
        get {
            if (searchText == null) searchText = '*'; // prefill the serach box for ease of use
            return searchText;
        }
        set;
    } 

    //The results from the search. do not init the results or a blank rows show up initially on page load
    public List<productWrapper> searchResults {get;set;}

    //The Products that were checked/selected.
    public List<productWrapper> selectedProducts {
        get {
            if (selectedProducts == null) selectedProducts = new List<productWrapper>();
            return selectedProducts;
        }
        set;
    }      

    public List<OpportunityLineItem> lineItems {
        get {
            if (lineItems == null) lineItems = new List<OpportunityLineItem>();
            return lineItems;
        }
        set;
    }      

    // ------------------------------------------------
    // Constructor Method
    // Extension of the Opportunity Standard Controller
    // ------------------------------------------------
    public AddOpportunityLineItemsController(ApexPages.StandardController controller) {
        this.opportunity = [SELECT Id, Name, Type, Revenue_Type__c, Pricebook2Id, CurrencyIsoCode, Account.Products__c 
                                FROM Opportunity 
                                WHERE id = :controller.getRecord().Id];

        //If the Opportunity does not have a pricebook selected we redirect to the choosepricebookpage
        if(this.opportunity.Pricebook2Id == null)
        {
            choosePricebookPage = new PageReference('/oppitm/choosepricebook.jsp?id='+ opportunity.Id +'&retURL=/'+ opportunity.Id +'&sUrl=/apex/product_search?id='+ opportunity.Id);
            choosePricebookPage.getParameters().put('id',opportunity.Id);
            choosePricebookPage.getParameters().put('retURL','/' + opportunity.Id);
            //EncodingUtil.urlEncode used to be required in API 18, but is not with API 21.
            //choosePricebookPage.getParameters().put('sUrl', EncodingUtil.urlEncode(Page.product_search.getUrl() + '?id='+ opportunity.Id, 'UTF-8'));
            choosePricebookPage.getParameters().put('sUrl', Page.product_search.getUrl() + '?id='+ opportunity.Id);
            choosePricebookPage.setRedirect(True);
        }
    }


    // ------------------------------------------------
    // GET/SET Methods
    // ------------------------------------------------
    public Opportunity getOpportunity() { return opportunity; }

    //Sends the User to the ChoosePricebook page if needed. Otherwise it refreshes the page.
    public PageReference choosePricebook() {
        return choosePricebookPage;
    }

    //Getter for the productCategories value
    public List<String> getProductCategories() { return this.productCategories; }

    //Setter for the productCategories value
    public void setProductCategories(List<String> productCategories) { this.productCategories = productCategories; }

    //Getter for the productSubCategories value
    public List<String> getProductSubCategories() { return this.productSubCategories; }
 
    //Setter for the productSubCategories value
    public void setProductSubCategories(List<String> productSubCategories) { this.productSubCategories = productSubCategories; }


    //Getter for the list of Product Categories
    public List<SelectOption> getProductCategoryList() {

        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption('','- All -'));

      // Loop through Pricebook Entry records to get the active Products in the User's pricebook and Currency
      for (AggregateResult ar : [SELECT Product2.Product_Category__c Category FROM PricebookEntry WHERE Product2.Platform__c = 'Collaborate' AND IsActive = True AND Product2.Product_Category__c != null AND Pricebook2Id = :opportunity.Pricebook2Id AND CurrencyIsoCode= :opportunity.CurrencyIsoCode AND Product2.Product_Category__c != 'Wimba Create Single/Five' GROUP BY Product2.Product_Category__c ORDER BY Product2.Product_Category__c Desc]){
        optionList.add(new SelectOption((String)ar.get('Category'),(String)ar.get('Category')));
      }
              return optionList;
    }

    //Getter for the list of Product Sub Categories
    public List<SelectOption> getProductSubCategoryList() {

        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption('','- All -'));

      // Loop through the Product2 records to get the Product_Sub_Category__c list for selected products
      for (AggregateResult ar : [SELECT Product2.Product_Sub_Category__c SubCategory FROM PricebookEntry WHERE Product2.Platform__c = 'Collaborate' AND IsActive = True AND Product2.Product_Sub_Category__c != null AND Pricebook2Id = :opportunity.Pricebook2Id AND Product2.Product_Category__c IN :productCategories AND isActive = True GROUP BY Product2.Product_Sub_Category__c ORDER BY Product2.Product_Sub_Category__c]){
        if(ar.get('SubCategory') != null && !(opportunity.Revenue_Type__c != 'POC' && ar.get('SubCategory') == 'POC')) optionList.add(new SelectOption((String)ar.get('SubCategory'),(String)ar.get('SubCategory')));
      }
      return optionList;     
    }

    //Getter for the list of Product Bands
    public List<SelectOption> getProductBands() {

        List<SelectOption> optionList = new List<SelectOption>();
        optionList.add(new SelectOption('','- All -'));

        // Loop through the Product2 records to get the Band list for selected products
        Boolean isBandedProduct = false;
        for (AggregateResult ar : [SELECT Band__c FROM Product2 WHERE Platform__c = 'Collaborate' AND isActive = True AND Product_Category__c IN :productCategories AND Product_Sub_Category__c IN :productSubCategories GROUP BY Band__c ORDER BY Band__c]){
            if(ar.get('Band__c') != null && ar.get('Band__c') != '')
            {
                isBandedProduct = true;
                break;
            }
        }
        
        if(isBandedProduct) {
            optionList.add(new SelectOption('1','1'));
            optionList.add(new SelectOption('2','2'));
            optionList.add(new SelectOption('3','3'));
            optionList.add(new SelectOption('4','4'));
            optionList.add(new SelectOption('5','5'));
            optionList.add(new SelectOption('6','6'));
            optionList.add(new SelectOption('7','7'));
        }
        return optionList;
    }


    // ------------------------------------------------
    // Navigation Methods
    // ------------------------------------------------

    //Return the User to the Opportunity Page
    public PageReference cancel() {
        PageReference opptyPage = new PageReference('/' + opportunity.id);
        opptyPage.setRedirect(true);
        return opptyPage;
    }


    //Returns list of Products meeting the search criteria
    public PageReference search() {

        if (searchResults == null) searchResults = new List< productWrapper >(); // init the list if it is null
        else searchResults.clear(); // clear out the current results if they exist

        String productName = searchText.replace('*','');
        // == '*'?'':searchText;
        productName = '%' + productName + '%';

        List<PricebookEntry> products = [SELECT Id, Product2.External_Long_Description__c, Product2.ProductCode, Product2.Description,IsActive, Product2.IsActive, Product2.Product_Category__c, Product2.Band__c, Product2.Product_Sub_Category__c, Name, UnitPrice
                                            FROM PricebookEntry 
                                            WHERE Product2.Platform__c = 'Collaborate' 
                                            AND Product2.IsActive = True 
                                            AND IsActive = True 
                                            AND Pricebook2Id = :opportunity.Pricebook2Id  
                                            AND CurrencyIsoCode= :opportunity.CurrencyIsoCode 
                                            AND (Product2.External_Long_Description__c LIKE :productName OR Product2.ProductCode LIKE :productName)
                                            AND Product2.Unit_of_Measure__c != 'Month'
                                            ORDER BY Product2.Product_Sub_Category__c,Product2.Band__c,Product2.ProductCode];

        for(PricebookEntry product : products) {
            if(!(opportunity.Revenue_Type__c != 'POC' && product.Product2.Product_Sub_Category__c == 'POC')) searchResults.add(new productWrapper(product));
        }
        return null;
    }   


    //Returns list of Products meeting the filter criteria
    public PageReference filter() {

        if (searchResults == null) searchResults = new List< productWrapper >(); // init the list if it is null
        else searchResults.clear(); // clear out the current results if they exist

        String productCategoriesFilter = '';
        String productSubCategoriesFilter = '';
        String bandFilter = '';

        String qry = 'SELECT Id, Product2.External_Long_Description__c, Product2.ProductCode, Product2.Description, IsActive, Product2.IsActive, Product2.Product_Category__c, Product2.Band__c, Product2.Product_Sub_Category__c, Name, UnitPrice FROM PricebookEntry WHERE Product2.Platform__c = \'Collaborate\' AND Product2.IsActive = True AND IsActive = True AND Pricebook2Id = \'' + opportunity.Pricebook2Id + '\' AND CurrencyIsoCode= \'' + opportunity.CurrencyIsoCode + '\' AND Product2.Unit_of_Measure__c != \'Month\'';
        if(opportunity.Revenue_Type__c != 'POC') qry += ' AND Product2.Product_Sub_Category__c != \'POC\'';

        //Add the Product Product_Category__c Filter if selected
        if(productCategories != null && productCategories.size() > 0)
        {
            for(String productCategory:productCategories)
            {
                if(productCategory != '') productCategoriesFilter += productCategory + '\',\'';
            }
            if(productCategoriesFilter != '') {
                productCategoriesFilter = '(\'' + productCategoriesFilter.substring(0,productCategoriesFilter.lastIndexOf('\',\'')) + '\')';
                qry += ' AND Product2.Product_Category__c IN ' + productCategoriesFilter;
            }
        }

        //Add the Product Sub Category Filter if selected
        if(productSubCategories != null && productSubCategories.size() > 0)
        {
            for(String productSubCategory:productSubCategories)
            {
                if(productSubCategory != '') productSubCategoriesFilter += productSubCategory + '\',\'';
            }
            if(productSubCategoriesFilter != '') {
                productSubCategoriesFilter = '(\'' + productSubCategoriesFilter.substring(0,productSubCategoriesFilter.lastIndexOf('\',\'')) + '\')';
                qry += ' AND Product2.Product_Sub_Category__c IN ' + productSubCategoriesFilter;
            }
        }

        //Add the Band Filter if selected
        if(productBand != null && productBand != '')
        {
            qry += ' AND (Product2.Band__c LIKE \'%' + productBand + '\' OR Product2.Band__c LIKE \'' + productBand + '%\')';
        }

        qry += ' ORDER BY Product2.Product_Sub_Category__c,Product2.Band__c,Product2.ProductCode';
        
        System.debug(qry);
        for(PricebookEntry product : Database.query(qry)) {
            searchResults.add(new productWrapper(product));
        }
        return null;
    }

    
    public PageReference next() {

        // clear out the currently selected products
        selectedProducts.clear();
        lineItems.clear();
         
        // add the selected categories to a new List
        for (productWrapper pw : searchResults) {
            if (pw.selected) selectedProducts.add(new productWrapper(pw.product));
            if (pw.selected)
            {
                lineItems.add(new OpportunityLineItem(OpportunityId = opportunity.Id, PricebookEntry = pw.getProduct(),  PricebookEntryId = pw.getProduct().Id, Quantity = 1, UnitPrice = pw.getProduct().UnitPrice));
            }       
        }

        // ensure they selected at least one Product or show an error message.
        if (lineItems.size() > 0) {
            return Page.Product_Results;
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select at least one Product.'));
            return null;
        }       
    }       


    // Goes back to the Product search page
    public PageReference back() {
        return Page.Product_Search;
    }       

    //Inserts Opportunity Line Items and redirects user to Opportunity
    public PageReference save() {
    
        insert lineItems;
        
        PageReference opptyPage = new PageReference('/' + opportunity.id);
        opptyPage.setRedirect(true);
        return opptyPage;
    } 

    //Inserts Opportunity Line Items and redirects user back to the add line items screen
    public PageReference saveAndAddMore() {
    
        insert lineItems;
        
        PageReference addProductPage = Page.product_search;
        addProductPage.getParameters().put('id',opportunity.Id);
        addProductPage.setRedirect(True);
        return addProductPage;
    } 

    // ------------------------------------------------
    // Wrapper Class
    // ------------------------------------------------
    public class productWrapper
    {
        private PricebookEntry product;
        private Boolean selected;

        public PricebookEntry getProduct() { return this.product; }
        public void setProduct(PricebookEntry product) { this.product = product; }

        public Boolean getSelected() { return this.selected; }
        public void setSelected(Boolean selected) { this.selected=selected; }

        public productWrapper(PricebookEntry product)
        {
            this.product = product;
            selected = false;
        }
    }
}