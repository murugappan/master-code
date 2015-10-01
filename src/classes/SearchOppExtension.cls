public with sharing class SearchOppExtension {
    
    public String qryString;
    public String sortcon;
    Decimal totalamtfind{get; set;}
    Decimal totalamt{get; set;}
    
    public String totalcomfind{get; set;}
    public String totalcom{get; set;}
   
    public String FieldName1{ get; set; }
    public String FieldName2{ get; set; }
    public String FieldName3{ get; set; } 
    public String FieldName4{ get; set; }
    public String FieldName5{ get; set; }
    public String OutName1{ get; set; }
    public String OutName2{ get; set; }
    public String OutName3{ get; set; }
    public String OutName4{ get; set; }
    public String OutName5{ get; set; }
    public String Value1{ get; set; }
    public String Value2{ get; set; } 
    public String Value3{ get; set; }
    public String Value4{ get; set; }
    public String Value5{ get; set; }
    public boolean errorShow{ get; set; }
    public String errorTitle{ get; set; }
    public String errorMessage{ get; set; }
    public String errorSeverity{ get; set; } 
    public String FieldName6{ get; set; }
    public String OutName6{ get; set; }
    public String Value6{ get; set; }
    public String FieldName7{ get; set; }
    public String OutName7{ get; set; }
    public String Value7{ get; set; }
    public String FieldName8{ get; set; }
    public String OutName8{ get; set; }
    public String Value8{ get; set; }
    public String FieldName9{ get; set; }
    public String OutName9{ get; set; }
    public String Value9{ get; set; }
    public String FieldName10{ get; set; }
    public String OutName10{ get; set; }
    public String Value10{ get; set; }
    public List<Opportunity> Opportunities2;
    //Paging
    //public List<Opportunity> oppsortlist = new List<Opportunity>();
    public List<Opportunity> orgsortlist = new List<Opportunity>();
    private List<Opportunity> pageOpportunity;
    private List<Opportunity> pageOpportunity1;
    
   // public List<Opportunity> orglist ;
    
    public Integer pageNumber1;
    public Integer pageSize;
    public Integer totalPageNumber;
    public Integer totalPageNumberorg;
    public Integer pageNumber1org;
   
    public String OppName{get;set;}
    public String AccName{get;set;}
    public String PSC{get;set;}
    public String Amt{get;set;}
    public String OppOwn{get;set;}
    public String ClsDat{get;set;}
    public String Stg{get;set;}
    public String Prob{get;set;}
    public String CQN{get;set;}    
    public String RN{get;set;}
    public String OppType{get;set;}
    public String ER{get;set;}
    public String PDD{get;set;}
    public String PSD{get;set;}  
    public String DLD{get;set;}  
      
    public String OppName1{get;set;}
    public String AccName1{get;set;}
    public String PSC1{get;set;}
    public String Amt1{get;set;}
    public String OppOwn1{get;set;}
    public String ClsDat1{get;set;}
    public String Stg1{get;set;}
    public String Prob1{get;set;}
    public String CQN1{get;set;}    
    public String RN1{get;set;}
    public String OppType1{get;set;}
    public String ER1{get;set;}
    public String PDD1{get;set;}
    public String PSD1{get;set;}  
    public String DLD1{get;set;}
    //Added by Nikhil
    public String FC{get;set;}
    public String FC1{get;set;}
    public String TFC{get;set;} 
    public String TFC1{get;set;} 
    public String SC{get;set;} 
    public String SC1{get;set;}  
    public String CDPD{get;set;} 
    public String CDPD1{get;set;} 
    public String COF{get;set;} 
    public String COF1{get;set;} 
    //END
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                Set<ID> oppid = new Set<ID>();
                for(List<Opportunity> o : [select ID from Opportunity limit 25000]){
                    for(Opportunity o1 : o)
                        oppid.add(o1.ID);
                }
                System.debug(oppid.size());
                con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID, TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity where ID IN:oppid ORDER By Name LIMIT 10000]));                
               /* if(sortcon == null || sortcon == 'on'){
                    if(OppName.contains('&darr;') || !OppName.contains('uarr;'))
                        con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY NAME LIMIT 10000]));
                    else if(OppName.contains('&uarr;'))                
                        con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY NAME DESC LIMIT 10000]));
                 }else if(sortcon == 'psc'){
                     if(PSC.contains('&darr;') || !PSC.contains('uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Account.PS_Company_Id__c LIMIT 10000]));
                     else if(PSC.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Account.PS_Company_Id__c DESC LIMIT 10000]));
                 }else if(sortcon == 'amt'){
                     if(Amt.contains('&darr;') || !Amt.contains('uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Amount LIMIT 10000]));
                     else if(Amt.contains('&uarr;'))               
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Amount DESC LIMIT 10000]));
                 }else if(sortcon == 'acc'){
                      if(AccName.contains('&darr;') || !AccName.contains('uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Account.Name LIMIT 10000]));
                      else if(AccName.contains('&uarr;'))                
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Account.Name DESC LIMIT 10000]));
                 }else if(sortcon == 'oo'){
                     if(OppOwn.contains('&darr;') || !OppOwn.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Owner__r.Name LIMIT 10000]));
                     else if(OppOwn.contains('&uarr;'))
                        con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Owner__r.Name DESC LIMIT 10000]));                     
                }else if(sortcon == 'cd'){
                     if(ClsDat.contains('&darr;') || !ClsDat.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY CloseDate LIMIT 10000]));
                     else if(ClsDat.contains('&uarr;'))    
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY CloseDate DESC LIMIT 10000]));
                }else if(sortcon == 'stg'){
                     if(Stg.contains('&darr;') || !Stg.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY stageName LIMIT 10000]));
                     else if(Stg.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY stageName DESC LIMIT 10000]));                     
                }else if(sortcon == 'prob'){
                     if(Prob.contains('&darr;') || !Prob.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Probability LIMIT 10000]));
                     else if(Prob.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Probability DESC LIMIT 10000]));
                }else if(sortcon == 'cqn'){
                     if(CQN.contains('&darr;') || !CQN.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Current_Quote_Number__c LIMIT 10000]));
                     else if(CQN.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Current_Quote_Number__c DESC LIMIT 10000]));
                }else if(sortcon == 'rn'){
                     if(RN.contains('&darr;') || !RN.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Revision_Number__c LIMIT 10000]));
                     else if(RN.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Revision_Number__c DESC LIMIT 10000]));
                }else if(sortcon == 'ot'){
                     if(OppType.contains('&darr;') || !OppType.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Type LIMIT 10000]));
                     else if(OppType.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY Type LIMIT 10000]));
                }else if(sortcon == 'er'){
                     if(ER.contains('&darr;') || !ER.contains('uarr;')) 
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY ExpectedRevenue LIMIT 10000]));
                     else if(ER.contains('&uarr;'))
                         con = new ApexPages.StandardSetController(Database.getQueryLocator([Select ID,Customer_Requested_Prod_Delivery_Date__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity Where ID IN:oppid ORDER BY ExpectedRevenue LIMIT 10000]));
                }*/
                if(con.getResultSize() > 0)
                    con.setPageSize(200);
                String flt = con.getFilterID();
                con.setfilterID(flt);    
            }
            return con;
        }
        set;
    }
    
    public Pagereference updatelist(){
    
       con.first();
       List<Opportunity> o1 = new List<Opportunity>();
       o1 = con.getRecords();
       List<Opportunity> o2 = new List<Opportunity>();
       o2.addAll(o1);
    //   orglist.addAll(o1); 
       System.debug(o2.size()); 
       while(con.getHasNext()){
            System.debug('Inside while');
            con.next();
            List<Opportunity> o = new List<Opportunity>();
            o = con.getRecords();
            for(Opportunity o3 : o){
                o2.add(o3);
            }
            System.debug(o2.size());
        }
        
        sortcon = ApexPages.CurrentPage().getParameters().get('firstParam');
        if(sortcon == null)
            sortcon = 'on';
        if(sortcon == 'acc' || sortcon == 'psc' || sortcon == 'amt' || sortcon == 'on' || sortcon == 'oo' || sortcon == 'cd' || sortcon == 'stg' || sortcon == 'prob' || sortcon == 'cqn' || sortcon == 'rn' || sortcon == 'ot' || sortcon == 'er'){
            orgsortlist.clear();
            orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity WHERE ID IN: o2 ORDER By Name Limit 1000]; 
        }
      //  orgsortlist.addAll(o2);
      //  getpagedata(1);
    
        totalamt = 0;
        totalamtfind = 0;    
        sort1();  
        return null;
    }

    public Integer getTotalPageNumber()
    {       
        if (totalPageNumber == 0 && Opportunities2 !=null)
        {
            totalPageNumber = Opportunities2.size() / pageSize;            
            Integer mod = Opportunities2.size() - (totalPageNumber * pageSize);
            if (mod > 0)
                totalPageNumber++;         
        }     
        return totalPageNumber;
    }
    
    public Integer getTotalPageNumberOrg(){       
        totalPageNumberorg = 0;
        if (totalPageNumberorg == 0  && orgsortlist != null){
            System.debug('+++inside if');
            totalPageNumberorg = orgsortlist.size() / pageSize;            
            Integer mod = orgsortlist.size() - (totalPageNumberorg * pageSize);
            if (mod > 0)
                totalPageNumberorg++;         
        }    
        System.debug(totalPageNumberorg); 
        System.debug(orgsortlist.size()); 
        System.debug(pageSize); 
        return totalPageNumberorg;
    }
    
    public Boolean getPreviousButtonEnabled(){       
        return !(pageNumber1 > 1);
    }
    
    public Boolean getPreviousButtonEnabledOrg(){       
        return !(pageNumber1org > 1);
    }
    
    public Boolean getNextButtonDisabledOrg(){       
        System.debug(orgsortlist);
        System.debug(pageNumber1org);
        System.debug(pageSize);
        if (orgsortlist == null) return true;
        else{           
            return ((pageNumber1org * pageSize) >= orgsortlist.size());            
        }
    }
    
    public Boolean getNextButtonDisabled(){       
       if (Opportunities2 == null) return true;
        else{           
            return ((pageNumber1 * pageSize) >= Opportunities2.size());            
        }
    }
    
    public PageReference nextBtnClick(){ 
        errorShow = false; 
        System.debug(pageNumber1 + 1);
        getPageData1(pageNumber1 + 1);
        return null;
    }
    
    public PageReference nextBtnClickOrg(){ 
        errorShow = false; 
        getPageData(pageNumber1org + 1);
        return null;
    }

    public PageReference previousBtnClick(){ 
        errorShow = false; 
        getPageData1(pageNumber1 - 1);
        return null;
    }  
    
    public PageReference previousBtnClickorg(){ 
        errorShow = false; 
        getPageData(pageNumber1org - 1);
        return null;
    } 
    
    public PageReference lastBtnClick(){
        errorShow = false; 
        System.debug(totalPageNumber);
        getPageData1(totalPageNumber);
        return null;
    }
    
   public PageReference lastBtnClickorg(){
        errorShow = false; 
        getPageData(totalPageNumberorg);
        return null;
    }
    
    public PageReference FirstBtnClick(){ 
        errorShow = false; 
        getPageData1(1);
        return null;
    } 
    
    public PageReference FirstBtnClickOrg(){ 
        errorShow = false; 
        getPageData(1);
        return null;
    } 
    //remove error block Find
    public PageReference refreshPageFind()  {
        errorShow = false; 
        OpportunitiesData(1);
        PageReference tr = new PageReference('/apex/OpportunityMassUpdate');
        tr.setRedirect(true);
        return tr;
    }
    
       
    //remove error block for View
    public PageReference refreshPageView()  {
        System.debug('IN refreshPageView @@@@@@@');
        errorShow = false; 
        PageReference tr = new PageReference('/apex/OpportunityMassUpdate');
        tr.setRedirect(true);
        return tr;
    }
      
    public Integer getpageNumber1(){
        /*if(totalPageNumber == 0) {
            return 0;
        }*/
        if(null != Opportunities2)
            if(Opportunities2.size() == 0)
                return 0; 
        System.debug('*****'+pageNumber1);        
        return pageNumber1;
    }
    
    public Integer getpageNumber1Org(){
        /*if(totalPageNumber == 0) {
            return 0;
        }*/
        if(null != orgsortlist)
            if(orgsortlist.size() == 0)
                return 0; 
        return pageNumber1org;
    }
    
    // End Paging
    public List<Opportunity> getOpportunities2() {
        return pageOpportunity;
    }
     
    public List<Opportunity> setOpportunities2() {
        return Opportunities2;
    }   
    public SearchOppExtension(ApexPages.StandardSetController controller) {
        OppName = 'Opportunity Name &uarr;';
        AccName = 'Account Name';
        PSC = ' PS Company ID';
        Amt = 'Amount';
        OppOwn = 'Opportunity Owner';
        ClsDat = 'Close Date';
        Stg = 'Stage';
        Prob = 'Probability';
        CQN = 'Current Quote Number';
        RN = 'Revision Number';
        OppType = 'Opportunity Type';
        ER = 'Sales Value x Probability';
        PDD = 'Product Delivery Date'; 
        PSD = 'Project Start Date'; 
        DLD = 'Desired Live Date'; 
      //add by nikhil start
        FC='Forecast Comments';
        TFC='Transact Forecast Category';
        TFC1='Transact Forecast Category';
        SC='ShipOnClose';
        SC1='ShipOnClose';
        CDPD='Customer Desired Prod Delivery date';
        CDPD1='Customer Desired Prod Delivery date';
        COF='Comments for Fulfillment';
        COF1='Comments for Fulfillment';
        
       //end           
        OppName1 = 'Opportunity Name &uarr;';
        AccName1 = 'Account Name';
        PSC1 = ' PS Company ID';
        Amt1 = 'Amount';
        OppOwn1 = 'Opportunity Owner';
        ClsDat1 = 'Close Date';
        Stg1 = 'Stage';
        Prob1 = 'Probability';
        CQN1 = 'Current Quote Number';
        RN1 = 'Revision Number';
        OppType1 = 'Opportunity Type';
        ER1 = 'Sales Value x Probability';
        PDD1 = 'Product Delivery Date'; 
        PSD1 = 'Project Start Date'; 
        DLD1 = 'Desired Live Date'; 
      //add by nikhil start
        FC1='Forecast Comments';
      //end   
        controller.setPageSize(200); 
        pageNumber1 = 0;
        pageNumber1org = 0;
        totalPageNumber = 0;
        totalPageNumberorg  = 0;
        pageSize = 100;   
        String flt = controller.getFilterID();
        controller.setFilterID(flt);
       // orglist = new List<Opportunity>();
        //orglist = controller.getRecords();
        Set<ID> tmpId = new Set<ID>();
       // System.debug(orglist.size());
       // System.debug('lllll'+controller.getpagesize()); 
        //orgsortlist.addAll(orglist); 
       // orglist = controller.getRecords();
       List<Opportunity> o1 = new List<Opportunity>();
       o1 = controller.getRecords();
       List<Opportunity> o2 = new List<Opportunity>();
       o2.addAll(o1); 
        while(controller.getHasNext()){
            controller.next();
            List<Opportunity> o = new List<Opportunity>();
            o = controller.getRecords();
            o2.addAll(o);
       }
       // System.debug(orglist[0]);
       // orgsortlist= controller.getRecords();
       // orgsortlist.addAll(orglist);
       // System.debug(orgsortlist.size());
        /*for(Opportunity o : orglist){
            tmpId.add(o.ID);
        }*/
        orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity WHERE ID IN: o2 ORDER By Name Limit 1000]; 

/*        for(List<Opportunity> o : [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: orglist ORDER By Name Limit 1000]){   
           for(Opportunity o1 : o){
               orgsortlist.add(o1);
          }
        }*/
      // Opportunity  o = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID =: orglist[0].ID] ;
      // orgsortlist.add(o);
      // orglist.remove(0);
      // orgsortlist.addAll(orglist);
         totalamt = 0;
         totalamtfind = 0;    
         for(Opportunity o5 : orgsortlist ){
            if(o5.Amount != null)
                totalamt = totalamt + o5.Amount;
         }  
         totalamt = totalamt.setscale(2);//,System.RoundingMode.CEILING);
         totalcom = String.valueof(totalamt).substring(0,String.valueof(totalamt).lastindexof('.'));
         totalcom = putcomma(totalamt);
         totalcom = totalcom + String.valueof(totalamt).substring(String.valueof(totalamt).lastindexof('.'),String.valueof(totalamt).length());
         System.debug('PPPPPPPPPP'+totalamt);
         getPageData(1);
    }
    
    public String putcomma(Decimal tot){
            String val  = String.valueof(math.mod(tot.intvalue(),1000));
            Integer rem = tot.intvalue() / 1000;
            if(val.length() == 0)
                 val ='000';
            else if(val.length() == 1)
                 val = '00'+val;
            else if(val.length() == 2)
                 val = '0'+ val; 
            if(rem != 0){
     //           val = ','+val;
                for(Integer i = 0 ; rem != 0; i++){
                       String val1  = String.valueof(math.mod(rem,1000));
                       rem = rem / 1000; 
                       if(rem != 0){
                           if(val1.length() == 0)
                               val1 ='000';
                           else if(val1.length() == 1)
                               val1 = '00'+val1;
                           else if(val1.length() == 2)
                               val1 = '0'+ val1;        
                       }
                       val = val1+','+val;
                }
            }
            return val;
    }
  
    public List<Opportunity> getOrgOpp(){
        System.debug('____'+pageOpportunity1.size());
        System.debug('____'+orgsortlist.size());
        return pageOpportunity1;
    }
    
  
    //Click on Search button
    public PageReference SearchOppByFilter(){
        errorShow = false;    //Disable Error Message
        totalPageNumber=0;
        Opportunities2=new list<Opportunity>();
        pageOpportunity=new list<Opportunity>();
        pageOpportunity1=new list<Opportunity>();
        orgsortlist = new List<Opportunity>();
        
        pageNumber1=0;
        getOpportunities1(1);       
        return null;
    }
    
    //Save Opportunity
    public PageReference doSave() {     
        try{               
            /*for(Opportunity TempOpportunity : pageOpportunity){
                if (TempOpportunity.StageName=='(L) Lost' && TempOpportunity.ForecastCategoryName!='Omitted')
                    TempOpportunity.ForecastCategoryName='Omitted';             
            //  else if ((TempOpportunity.StageName=='(S) Suspect Qualification' || TempOpportunity.StageName=='(E) Sponsor Qualification' || TempOpportunity.StageName=='(D) Power Sponsor Qualification' || TempOpportunity.StageName=='(C) Decision Due' || TempOpportunity.StageName=='(A) Signature Due' || TempOpportunity.StageName=='(B) Pending Contract' ) && (TempOpportunity.ForecastCategoryName!='Omitted' || TempOpportunity.ForecastCategoryName!='Pipline' || TempOpportunity.ForecastCategoryName!='Best Case'  || TempOpportunity.ForecastCategoryName!='Commit' ))
            //      TempOpportunity.ForecastCategoryName='Pipline'; 
                else if (TempOpportunity.StageName=='(W) Won' && (TempOpportunity.ForecastCategoryName!='Omitted' || TempOpportunity.ForecastCategoryName!='Closed'))
                    TempOpportunity.ForecastCategoryName='Closed';              
            }*/
            
            update pageOpportunity;         
            errorTitle = 'Update.';
            errorMessage = 'Opportunities have been updated successfully.';
            errorSeverity = 'confirm';
            errorShow = false;
            OpportunitiesData(pageNumber1);
            return null;                           
        }
        catch (Exception e){
            errorTitle = 'Updating Error!';
            errorMessage = e.getMessage();
            errorSeverity = 'error';
            errorShow = true;            
            return null;
        }           
          
    }
    
    // Design Error Message
    private String ErrorMsg(String FieldName){    
        errorTitle = 'Operator/ Value Error!';
        errorMessage = 'Operator/ Value fields in Filter criteria does not contain correct values. Please assign correct operator/ value.';//'Invalid usage of filter operator. Please change to a relevant operator for ' + FieldName;
        errorSeverity = 'warning';
        errorShow = true;
        return errorTitle;
    }
    
    // Initialize setCon and return a list of records
    public Boolean getOpportunities1(Integer newPageIndex) {
        errorShow = false;        
        OpportunitiesData(newPageIndex);
        return null;
        }

   public Boolean OpportunitiesData(Integer newPageIndex) {
        //List<Opportunity> OppList=New List<Opportunity>();    
       
        String strOpr;
        if (FieldName1!= Null && OutName1!=Null && value1!=Null && value1!=''){
            strOpr=getOprater(OutName1,value1,FieldName1);   
            if(strOpr=='Error'){
                String strTemp= ErrorMsg(fieldName1);                               
                return null;
            }
            //Nishith Sahu Jan 21, 2011 - Sales Change
            //qryString = 'Select ID,ForecastCategoryName,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ' + strOpr ;
            qryString = 'Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity WHERE ' + strOpr ;
            
            if (FieldName2!= Null && OutName2!=Null && value2!=Null && value2!=''){   
                strOpr=getOprater(OutName2,value2,FieldName2);
                if(strOpr=='Error'){
                    String strTemp= ErrorMsg(fieldName2);                               
                    return null;
                }
                qryString = qryString + ' and ' + strOpr;
                if (FieldName3!= Null && OutName3!=Null && value3!=Null && value3!=''){   
                    strOpr=getOprater(OutName3,value3,FieldName3);
                    if(strOpr=='Error'){
                        String strTemp= ErrorMsg(fieldName3);                               
                        return null;
                    }
                    qryString = qryString + ' and ' + strOpr;
                    if (FieldName4!= Null && OutName4!=Null && value4!=Null && value4!=''){   
                        strOpr=getOprater(OutName4,value4,FieldName4);
                        if(strOpr=='Error'){
                            String strTemp= ErrorMsg(fieldName4);                               
                            return null;
                        }
                        qryString = qryString + ' and ' + strOpr;
                        if (FieldName5!= Null && OutName5!=Null && value5!=Null && value5!=''){   
                            strOpr=getOprater(OutName5,value5,FieldName5);
                            if(strOpr=='Error'){
                                String strTemp= ErrorMsg(fieldName5);                               
                                return null;
                            }
                            qryString = qryString + ' and ' + strOpr;
                            if (FieldName6!= Null && OutName6!=Null && value6!=Null && value6!=''){   
                                strOpr=getOprater(OutName6,value6,FieldName6);
                                if(strOpr=='Error'){
                                    String strTemp= ErrorMsg(fieldName6);                               
                                    return null;
                                }
                                qryString = qryString + ' and ' + strOpr;
                                if (FieldName7!= Null && OutName7!=Null && value7!=Null && value7!=''){   
                                    strOpr=getOprater(OutName7,value7,FieldName7);
                                    if(strOpr=='Error'){
                                        String strTemp= ErrorMsg(fieldName7);                               
                                        return null;
                                    }
                                    qryString = qryString + ' and ' + strOpr;
                                    if (FieldName8!= Null && OutName8!=Null && value8!=Null && value8!=''){   
                                        strOpr=getOprater(OutName8,value8,FieldName8);
                                        if(strOpr=='Error'){
                                            String strTemp= ErrorMsg(fieldName8);                               
                                            return null;
                                        }
                                        qryString = qryString + ' and ' + strOpr;
                                        if (FieldName9!= Null && OutName9!=Null && value9!=Null && value9!=''){   
                                            strOpr=getOprater(OutName9,value9,FieldName9);
                                            if(strOpr=='Error'){
                                                String strTemp= ErrorMsg(fieldName9);                               
                                                return null;
                                            }
                                            qryString = qryString + ' and ' + strOpr;
                                            if (FieldName10!= Null && OutName10!=Null && value10!=Null && value10!=''){   
                                                strOpr=getOprater(OutName10,value10,FieldName10);
                                                if(strOpr=='Error'){
                                                    String strTemp= ErrorMsg(fieldName10);                              
                                                    return null;
                                                }
                                                qryString = qryString + ' and ' + strOpr;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            qryString=qryString + ' Order by Name Limit 1000';
            System.debug('QRY---->' + qryString );
            try{
                Opportunities2=Database.query(qryString ) ; 
         //       oppsortlist.clear();
         //       oppsortlist.addAll(Opportunities2);
                System.debug(Opportunities2);
                if (Opportunities2.size()==0){
                    errorTitle = 'Records!';
                    errorMessage = 'No record found';
                    errorSeverity = 'warning';
                    errorShow = true;  
                }
                pageOpportunity = new List<Opportunity>();   
                Transient Integer counter = 0;
                Transient Integer min = 0;
                Transient Integer max = 0;           
                if (newPageIndex > pageNumber1)
                {
                    min = pageNumber1 * pageSize;
                    max = newPageIndex * pageSize;
                }
                else
                {
                    max = newPageIndex * pageSize;
                    min = max - pageSize;                
                }
                for(Opportunity a : Opportunities2)
                {
                    counter++;
                    if (counter > min && counter <= max)
                        pageOpportunity.add(a);
                }
                pageNumber1 = newPageIndex;              
                System.debug('000000'+pageNumber1 );

                    
                if (pageOpportunity == null || pageOpportunity.size() <= 0)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
                        
            }
            catch (Exception e){
                //errorTitle = e.getMessage();
                //errorMessage = e.getMessage();
                errorTitle = 'Operator/ Value Error!';
                errorMessage = 'Operator/ Value fields in Filter criteria does not contain correct values. Please assign correct operator/ value.';
                errorSeverity = 'error';
                errorShow = true;               
                return null;
            }
        }
        else
        {
            errorTitle = 'Select Filter Criteria !';
            errorMessage = 'Please select atleast first filter criteria';
            errorSeverity = 'warning';
            errorShow = true;             
            //return null;
        }      
       return null;
    }
    // Get Oparator for all filter
    private string getOprater(String OutName,String Value,String FieldName){
        //CURRENCY   
        String fieldtype;//Account.PS_Company_Id__c Owner__r.Name
        if (FieldName!='Account.Name' && FieldName!='Account.PS_Company_Id__c' && FieldName!='Owner__r.Name' ){
            Map<String, Schema.sObjectField> M = Schema.SObjectType.Opportunity.fields.getMap();
            schema.DescribeFieldResult F = m.get(FieldName).getDescribe();          
            fieldtype = F.getType().name();
        }
        else
            fieldtype='STRING';
        System.debug('Atulaa------------>'+fieldtype);
        string OptrName;
        //NUMBER Percent
        if ( fieldtype=='CURRENCY' || fieldtype=='NUMBER' || fieldtype=='PERCENT' || fieldtype=='INTEGER' ){
            if (OutName=='e'){
                OptrName=FieldName + ' = ' + Value  + '';       
            }       
            else if (OutName=='n'){
                OptrName=FieldName + ' != ' + Value  + '';   
            }
            else if (OutName=='s'){
                OptrName='Error';    
            }
            else if (OutName=='c'){
                OptrName='Error';   
            }
            else if (OutName=='k'){
                OptrName='Error';   
            }
            else if (OutName=='l'){
                OptrName=FieldName + ' < ' + Value; 
            }
            else if (OutName=='g'){
                OptrName=FieldName + ' > ' + Value; 
            }
            else if (OutName=='m'){
                OptrName=FieldName + ' <= ' + Value;    
            }
            else if (OutName=='h'){
                OptrName=FieldName + ' >= ' + Value;    
            }
        }
        else if (fieldtype=='BOOLEAN'){
            if (OutName=='e'){
                OptrName=FieldName + ' = ' + Value;         
            }       
            else if (OutName=='n'){
                OptrName=FieldName + ' != ' + Value;     
            }
            else if (OutName=='s'){
                OptrName='Error';    
            }
            else if (OutName=='c'){
                OptrName='Error';   
            }
            else if (OutName=='k'){
                OptrName='Error';   
            }
            else if (OutName=='l'){
                OptrName='Error';
            }
            else if (OutName=='g'){
                OptrName='Error';
            }
            else if (OutName=='m'){
                OptrName='Error';
            }
            else if (OutName=='h'){
                OptrName='Error';
            }
        }
        else if ( fieldtype=='DATE' || fieldtype=='DATETIME'){          
            List<String> parts = Value.split('/');          
            if (parts.size()==3){
                if (fieldtype=='Date') //T00:00:00-00:00
                    Value= parts[2] + '-' + parts[0] + '-' + parts[1];
                else{                   
                    //Value= parts[2] + '-' + parts[0] + '-' + parts[1] + 'T00:00:00-00:00'; //T00:00:00.000Z
                    if (parts[1].contains(':'))
                        Value= parts[2] + '-' + parts[0] + '-' + parts[1];                  
                    else            
                        Value= parts[2] + '-' + parts[0] + '-' + parts[1] + 'T00:00:00.000Z';
                }
                    
                system.debug('Atul Singhal---------' + Value );
                
                if (OutName=='e'){
                    OptrName=FieldName + ' = ' + Value;         
                }       
                else if (OutName=='n'){
                    OptrName=FieldName + ' != ' + Value;     
                }
                else if (OutName=='s'){
                    OptrName='Error';    
                }
                else if (OutName=='c'){
                    OptrName='Error';   
                }           
                else if (OutName=='l'){
                    OptrName=FieldName + ' < ' + Value;
                }
                else if (OutName=='g'){
                    OptrName=FieldName + ' > ' + Value; 
                }
                else if (OutName=='m'){
                    OptrName=FieldName + ' <= ' + Value; 
                }
                else if (OutName=='h'){
                    OptrName=FieldName + ' >= ' + Value; 
                }  
            }
            else
                OptrName='Error';   
        }
        else{
            if (OutName=='e'){
                OptrName=FieldName + ' = \'' + Value  + '\'';       
            }       
            else if (OutName=='n'){
                OptrName=FieldName + ' != \'' + Value + '\'';    
            }
            else if (OutName=='s'){
                OptrName=FieldName + ' like \'' + Value + '%\'';     
            }
            else if (OutName=='c'){
                OptrName=FieldName + ' like \'%' + Value+ '%\'';    
            }           
            else if (OutName=='l'){
                OptrName='Error';   
            }
            else if (OutName=='g'){
                OptrName='Error';   
            }
            else if (OutName=='m'){
                OptrName='Error';   
            }
            else if (OutName=='h'){
                OptrName='Error';   
            }
        }
        return  OptrName;
    }
    /*public List<SelectOption> getcolumnNames() {
       List<SelectOption> optionsFieldName = new List<SelectOption>();
       
       optionsFieldName.add(new SelectOption('','--None--'));       
       List<Schema.SObjectType> gd = Schema.getGlobalDescribe().Values();       
      for(Schema.SObjectType f : gd)
      {
         optionsFieldName.add(new SelectOption(f.getDescribe().getName(),f.getDescribe().getLabel()));         
      }
       Schema.DescribeFieldResult f = Schema.sObjectType.Opportunity.fields.Name;
       
       return optionsFieldName ;         
   }*/
   
   //Schema of opportunity table
   
   public List<SelectOption> getcolumnNamesNew() {
    List<SelectOption> optionsFieldName = new List<SelectOption>();   
    /*sObject s = new Opportunity();
    Schema.DescribeSObjectResult r = Opportunity.sObjectType.getDescribe();
    Map<String, Schema.SObjectField> M = Schema.SObjectType.Opportunity.fields.getMap();
    List<Schema.SObjectField> Sorting=new List<Schema.SObjectField>();
    List<String> listfield=new List<String>();    
    listfield.addall(M.keyset());
    listfield.sort();
    for(string temp : listfield){
        Sorting.add(M.get(temp));
    } */  
    optionsFieldName.add(new SelectOption('','--None--'));
    optionsFieldName.Add(new SelectOption('ForecastCategoryName','Forecast category'));
    optionsFieldName.Add(new SelectOption('Account.Name','Account Name'));
    optionsFieldName.Add(new SelectOption('Account.PS_Company_Id__c','PS company ID'));
    optionsFieldName.Add(new SelectOption('Amount','Amount'));
    optionsFieldName.Add(new SelectOption('name','Opportunity Name'));    
    optionsFieldName.Add(new SelectOption('Owner__r.Name','Opportunity Owner'));
    optionsFieldName.Add(new SelectOption('CloseDate','Close Date'));
    optionsFieldName.Add(new SelectOption('stageName','Stage'));
    optionsFieldName.Add(new SelectOption('Current_Quote_Number__c','Current Quote Number'));
    optionsFieldName.Add(new SelectOption('Type','Opp Type'));
    optionsFieldName.Add(new SelectOption('Line_of_Business__c','Line of Business'));
    
    /*    for(Schema.SObjectField sf : Sorting)
        {            
            if (sf.getDescribe().getRelationshipName()==Null) 
            {
                optionsFieldName.Add(new SelectOption(sf.getDescribe().Name,sf.getDescribe().Label));
            } 
        }*/
        
        return optionsFieldName ; 
    }

   public List<SelectOption> getOperatorNames() {
       List<SelectOption> optionsFieldName = new List<SelectOption>();       
       optionsFieldName .add(new SelectOption('','--None--'));
       optionsFieldName .add(new SelectOption('e','equals'));
       optionsFieldName .add(new SelectOption('n','not equal to'));
       optionsFieldName .add(new SelectOption('s','starts with'));
       optionsFieldName .add(new SelectOption('c','contains'));   
       //optionsFieldName .add(new SelectOption('k','does not contain'));      
       optionsFieldName .add(new SelectOption('l','less than'));
       optionsFieldName .add(new SelectOption('g','greater than'));
       optionsFieldName .add(new SelectOption('m','less or equal'));
       optionsFieldName .add(new SelectOption('h','greater or equal'));              
       return optionsFieldName ;        
   }  

     public void sort1(){
       List<Opportunity> opp = new List<Opportunity>();
       Opportunities2 = new List<Opportunity>();
    //   orglist = new List<Opportunity>();
       Set<Id> oppId = new Set<ID>(); 
       sortcon = ApexPages.CurrentPage().getParameters().get('firstParam');
       if(sortcon == null)
           sortcon = 'on';
       System.debug(sortcon);
       if(sortcon != null){
           if(sortcon == 'acc' || sortcon == 'psc' || sortcon == 'amt' || sortcon == 'on' || sortcon == 'oo' || sortcon == 'cd' || sortcon == 'stg' || sortcon == 'prob' || sortcon == 'cqn' || sortcon == 'rn' || sortcon == 'ot' || sortcon == 'er'){
               System.debug(con.getResultsize());
               List<Opportunity> o1 = new List<Opportunity>();
               Set<ID> o2 = new Set<ID>();
               //o2 = orgsortlist;
              /* List<Opportunity> o2 = new List<Opportunity>();
               o2.addAll(o1);
               while(con.getHasNext()){
                    con.next();
                   /* List<Opportunity> o = new List<Opportunity>();
                    o = (List<Opportunity>)con.getRecords();
                    o2.add(o);
                   for(Opportunity  o : (List<Opportunity>)con.getRecords()){
                            o2.add(o);
                    }
               }*/

               for(Opportunity o : orgsortlist){
                   o1.add(o);
                   o2.add(o.ID);
               }
               System.debug(o2.size());
               orgsortlist.clear();
               if(sortcon == 'on'){
                    if(OppName.contains('&darr;') || !OppName.contains('uarr;')){
                        orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY NAME LIMIT 1000];
                        OppName = 'Opportunity Name &uarr;';
                    }else if(OppName.contains('&uarr;')){                
                        orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY NAME DESC LIMIT 1000];
                        OppName = 'Opportunity Name &darr;';
                    }
                    removearrow(OppName);
                }else if(sortcon == 'psc'){
                     if(PSC.contains('&darr;') || !PSC.contains('uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Account.PS_Company_Id__c LIMIT 1000];
                         PSC = 'PS Company ID &uarr;';
                     }else if(PSC.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Account.PS_Company_Id__c DESC LIMIT 1000];
                         PSC = 'PS Company ID &darr;';
                     }
                     removearrow(PSC);
                }else if(sortcon == 'amt'){
                     if(Amt.contains('&darr;') || !Amt.contains('uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Amount LIMIT 1000];
                         Amt = 'Amount &uarr;';
                     }else if(Amt.contains('&uarr;')){               
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Amount DESC LIMIT 1000];
                         Amt = 'Amount &darr;';
                     }
                     removearrow(Amt);
                }else if(sortcon == 'acc'){
                      if(AccName.contains('&darr;') || !AccName.contains('uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Account.Name LIMIT 1000];
                         AccName = 'Account Name &uarr;';
                      }else if(AccName.contains('&uarr;')){                
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Account.Name DESC LIMIT 1000];
                         AccName = 'Account Name &darr;';
                      }  
                      removearrow(AccName);
                }else if(sortcon == 'oo'){
                     if(OppOwn.contains('&darr;') || !OppOwn.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Owner__r.Name LIMIT 1000];
                         OppOwn = 'Opportunity Owner &uarr;';
                     }else if(OppOwn.contains('&uarr;')){
                        orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Owner__r.Name DESC LIMIT 1000];
                        OppOwn = 'Opportunity Owner &darr;';     
                     }  
                      removearrow(OppOwn);
                }else if(sortcon == 'cd'){
                     if(ClsDat.contains('&darr;') || !ClsDat.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY CloseDate LIMIT 1000];
                         ClsDat = 'Close Date &uarr;';
                     }else if(ClsDat.contains('&uarr;')){    
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY CloseDate DESC LIMIT 1000];
                         ClsDat = 'Close Date &darr;';               
                     }
                     removearrow(ClsDat);
                }else if(sortcon == 'stg'){
                     if(Stg.contains('&darr;') || !Stg.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY stageName LIMIT 1000];
                         Stg = 'Stage &uarr;';
                     }else if(Stg.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY stageName DESC LIMIT 1000];
                         Stg = 'Stage &darr;';               
                     }
                     removearrow(Stg);
                }else if(sortcon == 'prob'){
                     if(Prob.contains('&darr;') || !Prob.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Probability LIMIT 1000];
                         Prob = 'Probability &uarr;';
                     }else if(Prob.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Probability DESC LIMIT 1000];
                         Prob = 'Probability &darr;';               
                     }
                     removearrow(Prob);
                }else if(sortcon == 'cqn'){
                      if(CQN.contains('&darr;') || !CQN.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Current_Quote_Number__c LIMIT 1000];
                         CQN = 'Currency Quote Number &uarr;';
                     }else if(CQN.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Current_Quote_Number__c DESC LIMIT 1000];
                         CQN = 'Currency Quote Number &darr;';               
                     }
                     removearrow(CQN);
                }else if(sortcon == 'rn'){
                     if(RN.contains('&darr;') || !RN.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Revision_Number__c LIMIT 1000];
                         RN = 'Revision Number &uarr;';
                     }else if(RN.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Revision_Number__c DESC LIMIT 1000];
                         RN = 'Revision Number &darr;';                              
                     }
                     removearrow(RN);
                }else if(sortcon == 'ot'){
                     if(OppType.contains('&darr;') || !OppType.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Type LIMIT 1000];
                         OppType = 'Opportunity Type &uarr;';
                     }else if(OppType.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Type DESC LIMIT 1000];
                         OppType = 'Opportunity Type &darr;';                                            
                     }
                     removearrow(OppType);
                }else if(sortcon == 'er'){
                     if(ER.contains('&darr;') || !ER.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY ExpectedRevenue LIMIT 1000];
                         ER= 'Sales Value x Probability &uarr;';
                     }else if(ER.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY ExpectedRevenue DESC LIMIT 1000];
                         ER = 'Sales Value x Probability &darr;';               
                     }
                     removearrow(ER);
                }else if(sortcon == 'pdd'){
                     if(PDD.contains('&darr;') || !PDD.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Customer_Requested_Prod_Delivery_Date__c LIMIT 1000];
                         PDD= 'Product Delivery Date &uarr;';
                     }else if(PDD.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Customer_Requested_Prod_Delivery_Date__c DESC LIMIT 1000];
                         PDD = 'Product Delivery Date &darr;';               
                     }
                     removearrow(PDD);
                }else if(sortcon == 'psd'){
                     if(PSD.contains('&darr;') || !PSD.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY PKO_Scheduled_Date__c LIMIT 1000];
                         PSD= 'Project Start Date &uarr;';
                     }else if(PSD.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY PKO_Scheduled_Date__c DESC LIMIT 1000];
                         PSD = 'Project Start Date &darr;';               
                     }
                     removearrow(PSD);
                }else if(sortcon == 'dld'){
                     if(DLD.contains('&darr;') || !DLD.contains('uarr;')){ 
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Customer_Desired_Live_Date__c LIMIT 1000];
                         DLD= 'Desired Live Date &uarr;';
                     }else if(DLD.contains('&uarr;')){
                         orgsortlist = [Select ID,TransactForecastCategory__c,Ship_On_Close__c,Customer_Requested_Prod_Delivery_Date__c,Comments_for_Fulfillment__c,PKO_Scheduled_Date__c, Customer_Desired_Live_Date__c,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type,Forecast_Comments__c from Opportunity Where ID IN:o2 ORDER BY Customer_Desired_Live_Date__c DESC LIMIT 1000];
                         DLD = 'Desired Live Date &darr;';               
                     }
                     removearrow(DLD);
                }
                totalamt = 0;
                for(Opportunity o5 : orgsortlist ){
                   if(o5.Amount != null)
                       totalamt = totalamt + o5.Amount;
                }  
                totalamt = totalamt.setscale(2);
                totalcom = String.valueof(totalamt).substring(0,String.valueof(totalamt).lastindexof('.'));
                totalcom = putcomma(totalamt);
                totalcom = totalcom + String.valueof(totalamt).substring(String.valueof(totalamt).lastindexof('.'),String.valueof(totalamt).length());
                System.debug('PPPPPPPPPP'+totalamt);
                getPageData(1);
               }else if(sortcon == 'acc1' || sortcon == 'psc1' || sortcon == 'amt1' || sortcon == 'on1' || sortcon == 'oo1' || sortcon == 'cd1' || sortcon == 'stg1' || sortcon == 'prob1' || sortcon == 'cqn1' || sortcon == 'rn1' || sortcon == 'ot1' || sortcon == 'er1'){
            //       oppsortlist.clear();
                   String qry = qryString.substring(0,qryString.lastindexof('Order'));
                  if(sortcon == 'acc1'){
                     if(AccName1.contains('&darr;') || !AccName1.contains('uarr;')){
                       qry = qry + ' Order by Account.Name Limit 1000';
                       opp = Database.query(qry);
                     /*  for(Opportunity opplist : oppsortlist){
                              oppid.add(opplist.ID);
                       }
                       opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Account.Name];*/
                       AccName1 = 'Account Name &uarr;';
                     }else if(AccName1.contains('&uarr;')){                
                       qry = qry + ' Order by Account.Name DESC Limit 1000';
                       opp = Database.query(qry);
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Account.Name DESC];
                       AccName1 = 'Account Name &darr;';
                     }
                     removearrow(AccName1);
               }else if(sortcon == 'psc1'){
                   if(PSC1.contains('&darr;') || !PSC1.contains('uarr;')){
                       qry = qry + ' Order by Account.PS_Company_Id__c Limit 1000';
                       opp = Database.query(qry);
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Account.PS_Company_Id__c];
                       PSC1 = 'PS Company ID &uarr;';
                   }else if(PSC1.contains('&uarr;')){                
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Account.PS_Company_Id__c DESC];
                       qry = qry + ' Order by Account.PS_Company_Id__c DESC Limit 1000';
                       opp = Database.query(qry);
                       PSC1 = 'PS Company ID &darr;';
                   }
                   removearrow(PSC1);
               }else if(sortcon == 'amt1'){ 
                   if(Amt1.contains('&darr;') || !Amt1.contains('uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Amount];
                       qry = qry + ' Order by Amount Limit 1000';
                       opp = Database.query(qry);
                       Amt1 = 'Amount &uarr;';
                   }else if(Amt1.contains('&uarr;')){                
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Amount DESC];
                       qry = qry + ' Order by Amount DESC Limit 1000';
                       opp = Database.query(qry);
                       Amt1 = 'Amount &darr;';
                   }
                   removearrow(Amt1);
               }else if(sortcon == 'on1'){ 
                   if(OppName1.contains('&darr;') || !OppName1.contains('uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Name];
                       qry = qry + ' Order by Name Limit 1000';
                       opp = Database.query(qry);
                       OppName1 = 'Opportunity Name &uarr;';
                   }else if(OppName1.contains('&uarr;')){                
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Name DESC];
                       qry = qry + ' Order by Name DESC Limit 1000';
                       opp = Database.query(qry);
                       OppName1 = 'Opportunity Name &darr;';
                   }
                   removearrow(OppName1);
               }else if(sortcon == 'oo1'){ 
                  if(OppOwn1.contains('&darr;') || !OppOwn1.contains('uarr;')){ 
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Owner__r.Name];
                       qry = qry + ' Order by Owner__r.Name Limit 1000';
                       opp = Database.query(qry);
                       OppOwn1 = 'Opportunity Owner &uarr;';
                   }else if(OppOwn1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Owner__r.Name DESC];
                       qry = qry + ' Order by Owner__r.Name DESC Limit 1000';
                       opp = Database.query(qry);
                       OppOwn1 = 'Opportunity Owner &darr;';               
                   }    
                   removearrow(OppOwn1);
               }else if(sortcon == 'cd1'){ 
                    if(ClsDat1.contains('&darr;') || !ClsDat1.contains('uarr;')){ 
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY CloseDate ];
                       qry = qry + ' Order by CloseDate Limit 1000';
                       opp = Database.query(qry);
                       ClsDat1 = 'Close Date &uarr;';
                   }else if(ClsDat1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY CloseDate DESC];
                       qry = qry + ' Order by CloseDate DESC Limit 1000';
                       opp = Database.query(qry);
                       ClsDat1 = 'Close Date &darr;';               
                   }    
                   removearrow(ClsDat1);
               }else if(sortcon == 'stg1'){
                   if(Stg1.contains('&darr;') || !Stg1.contains('uarr;')){ 
                      // opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY stageName]; 
                       qry = qry + ' Order by stageName Limit 1000';
                       opp = Database.query(qry);
                       Stg1 = 'Stage &uarr;';
                   }else if(Stg1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY stageName DESC]; 
                       qry = qry + ' Order by stageName DESC Limit 1000';
                       opp = Database.query(qry);
                       Stg1 = 'Stage &darr;';               
                   }    
                   removearrow(Stg1);
               }else if(sortcon == 'prob1'){ 
                   if(Prob1.contains('&darr;') || !Prob1.contains('uarr;')){ 
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Probability]; 
                       qry = qry + ' Order by Probability Limit 1000';
                       opp = Database.query(qry);
                       Prob1 = 'Probability &uarr;';
                   }else if(Prob1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Probability DESC]; 
                       qry = qry + ' Order by Probability DESC Limit 1000';
                       opp = Database.query(qry);
                       Prob1 = 'Probability &darr;';               
                   }    
                   removearrow(Prob1);
               }else if(sortcon == 'cqn1'){ 
                   if(CQN1.contains('&darr;') || !CQN1.contains('uarr;')){ 
                      //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Current_Quote_Number__c]; 
                       qry = qry + ' Order by Current_Quote_Number__c Limit 1000';
                       opp = Database.query(qry);
                       CQN1 = 'Currency Quote Number &uarr;';
                   }else if(CQN1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Current_Quote_Number__c DESC]; 
                       qry = qry + ' Order by Current_Quote_Number__c DESC Limit 1000';
                       opp = Database.query(qry);
                       CQN1 = 'Currency Quote Number &darr;';               
                   }    
                   removearrow(CQN1);
               }else if(sortcon == 'rn1'){
                   if(RN1.contains('&darr;') || !RN1.contains('uarr;')){ 
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Revision_Number__c]; 
                       qry = qry + ' Order by Revision_Number__c Limit 1000';
                       opp = Database.query(qry);
                       RN1 = 'Revision Number &uarr;';
                   }else if(RN1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Revision_Number__c DESC]; 
                       qry = qry + ' Order by Revision_Number__c DESC Limit 1000';
                       opp = Database.query(qry);
                       RN1 = 'Revision Number &darr;';               
                   }    
                   removearrow(RN1);
               }else if(sortcon == 'ot1'){
                   if(OppType1.contains('&darr;') || !OppType1.contains('uarr;')){ 
                      // opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Type]; 
                       qry = qry + ' Order by Type Limit 1000';
                       opp = Database.query(qry);
                       OppType1 = 'Opportunity Type &uarr;';
                   }else if(OppType1.contains('&uarr;')){
                      // opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY Type DESC]; 
                       qry = qry + ' Order by Type DESC Limit 1000';
                       opp = Database.query(qry);
                       OppType1 = 'Opportunity Type &darr;';               
                   }    
                   removearrow(OppType1);
               }else if(sortcon == 'er1'){
                   if(ER1.contains('&darr;') || !ER1.contains('uarr;')){ 
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY ExpectedRevenue]; 
                       qry = qry + ' Order by ExpectedRevenue Limit 1000';
                       opp = Database.query(qry);
                       ER1= 'Sales Value x Probability &uarr;';
                   }else if(ER1.contains('&uarr;')){
                       //opp = [Select ID,Probability,ExpectedRevenue,Account.Name,Account.PS_Company_Id__c,Amount,name,Owner__r.Name,CloseDate ,stageName,Current_Quote_Number__c,Revision_Number__c,Type from Opportunity WHERE ID IN: oppid ORDER BY ExpectedRevenue DESC]; 
                       qry = qry + ' Order by ExpectedRevenue DESC Limit 1000';
                       opp = Database.query(qry);
                       ER1 = 'Sales Value x Probability &darr;';               
                   }    
                   removearrow(ER1);
               }else if(sortcon == 'pdd1'){
                     if(PDD1.contains('&darr;') || !PDD1.contains('uarr;')){ 
                         qry = qry + ' Order by Customer_Requested_Prod_Delivery_Date__c Limit 1000';
                         opp = Database.query(qry);
                         PDD1 = 'Product Delivery Date &uarr;';
                     }else if(PDD1.contains('&uarr;')){
                         qry = qry + ' Order by Customer_Requested_Prod_Delivery_Date__c DESC Limit 1000';
                         opp = Database.query(qry);
                         PDD1 = 'Product Delivery Date &darr;';               
                     }
                     removearrow(PDD1);
                }else if(sortcon == 'psd1'){
                     if(PSD1.contains('&darr;') || !PSD1.contains('uarr;')){ 
                         qry = qry + ' Order by PKO_Scheduled_Date__c Limit 1000';
                         opp = Database.query(qry);
                         PSD1= 'Project Start Date &uarr;';
                     }else if(PSD1.contains('&uarr;')){
                         qry = qry + ' Order by PKO_Scheduled_Date__c DESC Limit 1000';
                         opp = Database.query(qry);
                         PSD1 = 'Project Start Date &darr;';               
                     }
                     removearrow(PSD1);
                }else if(sortcon == 'dld1'){
                     if(DLD1.contains('&darr;') || !DLD1.contains('uarr;')){ 
                         qry = qry + ' Order by Customer_Desired_Live_Date__c Limit 1000';
                         opp = Database.query(qry);
                         DLD1= 'Desired Live Date &uarr;';
                     }else if(DLD1.contains('&uarr;')){
                         qry = qry + ' Order by Customer_Desired_Live_Date__c DESC Limit 1000';
                         opp = Database.query(qry);
                         DLD1 = 'Desired Live Date &darr;';               
                     }
                     removearrow(DLD1);
                }
               
               Opportunities2.addAll(opp); 
               totalamtfind = 0;
               for(Opportunity o1 : Opportunities2){
                   if(o1.Amount != null)
                       totalamtfind = totalamtfind + o1.Amount;
               }     
               totalamtfind  = totalamtfind.setscale(2);  
               totalcomfind = String.valueof(totalamtfind).substring(0,String.valueof(totalamtfind).lastindexof('.'));
               totalcomfind = putcomma(totalamtfind);    
               totalcomfind = totalcomfind + String.valueof(totalamtfind).substring(String.valueof(totalamtfind).lastindexof('.'),String.valueof(totalamtfind).length());
        //       oppsortlist.addAll(opp);
               getPageData1(1);
               } 
           }
       }
       
       public void removearrow(String fldname){
         
           if(OppName != fldname && (OppName.contains('&uarr;') || OppName.contains('&darr;')))
               OppName = 'Opportunity Name';
           if(AccName != fldname && (AccName.contains('&uarr;') || AccName.contains('&darr;')))
               AccName = 'Account Name';
           if(PSC != fldname && (PSC.contains('&uarr;') || PSC.contains('&darr;')))
               PSC = 'PS Company ID';
           if(Amt != fldname && (Amt.contains('&uarr;') || Amt.contains('&darr;')))    
                Amt = 'Amount';
           if(OppOwn != fldname && (OppOwn.contains('&uarr;') || OppOwn.contains('&darr;')))                    
                OppOwn = 'Opportunity Owner';
           if(ClsDat != fldname && (ClsDat.contains('&uarr;') || ClsDat.contains('&darr;')))                    
                ClsDat = 'Close Date';
           if(Stg != fldname && (Stg.contains('&uarr;') || Stg.contains('&darr;')))                    
                Stg= 'Stage';      
           if(Prob != fldname && (Prob.contains('&uarr;') || Prob.contains('&darr;')))                    
                Prob = 'Probability';      
           if(CQN != fldname && (CQN.contains('&uarr;') || CQN.contains('&darr;')))                    
                CQN = 'Current Quote Number';      
           if(RN != fldname && (RN.contains('&uarr;') || RN.contains('&darr;')))                    
                RN = 'Revision Number';      
           if(OppType != fldname && (OppType.contains('&uarr;') || OppType.contains('&darr;')))                    
                OppType = 'Opportunity Type';
           if(PDD != fldname && (PDD.contains('&uarr;') || PDD.contains('&darr;')))                    
                PDD = 'Product Delivery Date';
           if(PSD != fldname && (PSD.contains('&uarr;') || PSD.contains('&darr;')))                    
                PSD = 'Project Start Date';
           if(DLD != fldname && (DLD.contains('&uarr;') || DLD.contains('&darr;')))                    
                DLD = 'Desired Live Date';          
           if(OppName1 != fldname && (OppName1.contains('&uarr;') || OppName1.contains('&darr;')))
               OppName1 = 'Opportunity Name';
           if(AccName1 != fldname && (AccName1.contains('&uarr;') || AccName1.contains('&darr;')))
               AccName1 = 'Account Name';
           if(PSC1 != fldname && (PSC1.contains('&uarr;') || PSC1.contains('&darr;')))
               PSC1 = 'PS Company ID';
           if(Amt1 != fldname && (Amt1.contains('&uarr;') || Amt1.contains('&darr;')))    
                Amt1 = 'Amount';
           if(OppOwn1 != fldname && (OppOwn1.contains('&uarr;') || OppOwn1.contains('&darr;')))                    
                OppOwn1 = 'Opportunity Owner';
           if(ClsDat1 != fldname && (ClsDat1.contains('&uarr;') || ClsDat1.contains('&darr;')))                    
                ClsDat1 = 'Close Date';
           if(Stg1 != fldname && (Stg1.contains('&uarr;') || Stg1.contains('&darr;')))                    
                Stg1 = 'Stage';      
           if(Prob1 != fldname && (Prob1.contains('&uarr;') || Prob1.contains('&darr;')))                    
                Prob1 = 'Probability';      
           if(CQN1 != fldname && (CQN1.contains('&uarr;') || CQN1.contains('&darr;')))                    
                CQN1 = 'Current Quote Number';      
           if(RN1 != fldname && (RN1.contains('&uarr;') || RN1.contains('&darr;')))                    
                RN1 = 'Revision Number';      
           if(OppType1 != fldname && (OppType1.contains('&uarr;') || OppType1.contains('&darr;')))                    
                OppType1 = 'Opportunity Type';    
           if(ER1 != fldname && (ER1.contains('&uarr;') || ER1.contains('&darr;')))                    
                ER1 = 'Sales Value x Probability'; 
           if(PDD1 != fldname && (PDD1.contains('&uarr;') || PDD1.contains('&darr;')))                    
                PDD1 = 'Product Delivery Date';
           if(PSD1 != fldname && (PSD1.contains('&uarr;') || PSD1.contains('&darr;')))                    
                PSD1 = 'Project Start Date';
           if(DLD1 != fldname && (DLD1.contains('&uarr;') || DLD1.contains('&darr;')))                    
                DLD1 = 'Desired Live Date';                              
       }
       
       public Integer getNooftime(){
           return 1;
       }
       
       public boolean getTotalDisplay(){
           if(Opportunities2 == null || Opportunities2.size() == 0)
              return false;
           else
              return true;  
       }
     
       
       public PageReference doViewSave(){
           try{               
            /*for(Opportunity TempOpportunity : pageOpportunity){
                if (TempOpportunity.StageName=='(L) Lost' && TempOpportunity.ForecastCategoryName!='Omitted')
                    TempOpportunity.ForecastCategoryName='Omitted';             
            //  else if ((TempOpportunity.StageName=='(S) Suspect Qualification' || TempOpportunity.StageName=='(E) Sponsor Qualification' || TempOpportunity.StageName=='(D) Power Sponsor Qualification' || TempOpportunity.StageName=='(C) Decision Due' || TempOpportunity.StageName=='(A) Signature Due' || TempOpportunity.StageName=='(B) Pending Contract' ) && (TempOpportunity.ForecastCategoryName!='Omitted' || TempOpportunity.ForecastCategoryName!='Pipline' || TempOpportunity.ForecastCategoryName!='Best Case'  || TempOpportunity.ForecastCategoryName!='Commit' ))
            //      TempOpportunity.ForecastCategoryName='Pipline'; 
                else if (TempOpportunity.StageName=='(W) Won' && (TempOpportunity.ForecastCategoryName!='Omitted' || TempOpportunity.ForecastCategoryName!='Closed'))
                    TempOpportunity.ForecastCategoryName='Closed';              
            }*/
            
            update pageopportunity1;         
            errorTitle = 'Update.';
            errorMessage = 'Opportunities have been updated successfully.';
            errorSeverity = 'confirm';
            errorShow = false;
        //    OpportunitiesData(pageNumber1);
            return null;                           
        }
        catch (Exception e){
            errorTitle = 'Updating Error!';
            errorMessage = e.getMessage();
            errorSeverity = 'error';
            errorShow = true;            
            return null;
        }           
       }
       
       public void getPageData(Integer newPageIndex1){
           
                pageOpportunity1 = new List<Opportunity>();   
                Transient Integer counter = 0;
                Transient Integer min = 0;
                Transient Integer max = 0;           
                if (newPageIndex1 > pageNumber1org)
                {
                    min = (newPageIndex1 - 1) * pageSize;
                    max = newPageIndex1 * pageSize;
                }
                else
                {
                    max = newPageIndex1 * pageSize;
                    min = max - pageSize;                
                }
                System.debug('++@@@'+orgsortlist.size());
                /*for(Opportunity a : orgsortlist)
                {
                    counter++;
                    if (counter > min && counter <= max)
                        pageOpportunity1.add(a);
                }*/
                if(orgsortlist != null){
                    for(Integer i=min ; i<max ; i++ ){
                        if(orgsortlist.size() > i)
                            pageOpportunity1.add(orgsortlist[i]);
                    }
                }
                pageNumber1org = newPageIndex1;              
              //  if (pageOpportunity1 == null || pageOpportunity1.size() <= 0)
               //     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
       }
       
       public void getPageData1(Integer newPageIndex1){
           
                pageOpportunity = new List<Opportunity>();   
                Transient Integer counter = 0;
                Transient Integer min = 0;
                Transient Integer max = 0;           
                System.debug(newPageIndex1);
                System.debug(pageNumber1);                
                if (newPageIndex1 > pageNumber1)
                {
                    min = (newPageIndex1 - 1) * pageSize;
                    max = newPageIndex1 * pageSize;
                }
                else
                {
                    max = newPageIndex1 * pageSize;
                    min = max - pageSize;                
                }
               // System.debug('++@@@'+Opportunities2[0].Account.PS_Company_Id__c);
                
                for(Opportunity a : Opportunities2)
                {
                    
                    counter++;
                    if (counter > min && counter <= max)
                        pageOpportunity.add(a);
                }
                pageNumber1 = newPageIndex1;    
                System.debug(pageNumber1);          

                System.debug('ssssssssssss'+totalamtfind);    
                if (pageOpportunity == null || pageOpportunity.size() <= 0)
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));

       }
       
  
       
       
}