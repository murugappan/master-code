public without sharing class CPQQuoteMgr {

          
         public CPQQuoteMgr(){} 
            
           string approvalrouting;//added for TP4942
            public static Boolean hasRun {get {if (hasRun == null) return false; return hasRun;} set;}
            
             public void processAfterSyncUpdate(List<CameleonCPQ__QuoteContent__c> NewList,Map<id,CameleonCPQ__QuoteContent__c>  CamNewMap) {
             
             
                if(!hasRun)
                {
                     System.debug('If loop'+hasrun);    
                     // to prevent recursive call of this trigger 
                     hasRun=True;
     
                     //Set of cameleon Quote  content ids
                     Set<id> camconid = New Set<id>();
                     
                     
                     //Set of Cameleon Quoteid
                     Set<id> CamQuoteid = New Set<id>();

                     For(CameleonCPQ__QuoteContent__c con : NewList)
                     {
                        
                        camconid.add(con.id);
                        
                        if(con.CameleonCPQ__QuoteId__c != Null)
                        {
                                CamQuoteid.add(con.CameleonCPQ__QuoteId__c);
                                System.debug('loop2'+CamQuoteid);
                        }           
                    
                     }
                     
                     //List of Cameleon Quote related to Cameleon Content quoute
                     Map<id,CameleonCPQ__Quote__c> LCamQuote = New Map<id,CameleonCPQ__Quote__c>([SELECT Id, OpportunityId__c, OpportunityId__r.Pricebook2Id, CameleonCPQ__Status__c FROM CameleonCPQ__Quote__c  WHERE Id IN : CamQuoteid]);
                    
                    // Set of Opportunityid related to Cameleon quote
                    
                    Set<id> Opportunityid = New Set<id>();
                    
                    For(CameleonCPQ__Quote__c CamQuote : LCamQuote.Values())
                     {

                            if(CamQuote.OpportunityId__c != Null)
                            {
                                    
                                    Opportunityid.add(CamQuote.OpportunityId__c);
                            }       
                     
                     }
                                         
                    // Map of Opportunity related to Quote 
                    Map<id,Opportunity> Mopp =New Map<id,Opportunity>([SELECT Id, Pricebook2Id,Is_Standalone__c,CurrencyIsoCode, CPQActiveRelease__c,PFIN_Intgr_Record_Type__c,Start_Date__c,End_Date__c FROM Opportunity WHERE Id IN : Opportunityid]);
                    
                    
                    
                    //Remove old Cameleon Quote Line Items / Opportunity Line Items
                    try{delete [SELECT id FROM CameleonQuoteLineItem__c WHERE Cameleon_Quote__c IN :CamQuoteid];}catch(Exception e){System.debug('caught quotelines deletion exception');}
                    try{delete [SELECT id FROM OpportunityLineItem WHERE OpportunityId IN : Opportunityid];}catch(Exception e){System.debug('caught opp line deletion exception ');}    
                    
                    
                    //Attachment[] att = [SELECT Id, Name, Body FROM Attachment WHERE parentId =: content.Id AND Name LIKE '%_content'];
                    
                    // Map of parentid and Attachment 
                    Map<id,List<Attachment>> Matt = New Map<id,List<Attachment>>();
                                        
                    For(Attachment att : [SELECT Id, Name,parentId,Body FROM Attachment WHERE  Name LIKE '%_content' and parentId IN : camconid])
                    {
                     
                            if(att.parentId != Null)    
                            {
                                        if(Matt.containsKey(att.parentId))
                                        {
                                           
                                            List<Attachment> Lat = Matt.get(att.Parentid);
                                            Lat.add(att);
                                            Matt.put(att.parentId,Lat); 
                                            
                                        }       
                                     
                                        Else{
                                          
                                          List<Attachment> Latt = New List<Attachment>();
                                          Latt.add(att);
                                          Matt.put(att.Parentid,Latt);


                                        }
                                                                             
                            }
                    }
                                        
                    //get id for default pricebook for all CPQ opportuniities
                    Pricebook2 cpqPb = [SELECT Id FROM Pricebook2 WHERE Name = 'CPQ'];
                    Id cpqpbId = cpqPb.Id; 
                    
                 
                 
                   //List of opportunity
                    List<Opportunity> Lopp = New List<Opportunity>();
                                        
                    
                    // Update Opp pricebook if Opps pricebook is Null Or Not Equal to CPQ(Start)
                     
                      For(CameleonCPQ__QuoteContent__c content :NewList)
                      {
                      
                                if(content.CameleonCPQ__QuoteId__c != Null)
                                 {
                                         if(LCamQuote.get(content.CameleonCPQ__QuoteId__c).OpportunityId__c != Null)
                                            {
                                   
                                                   if(Mopp.get(LCamQuote.get(content.CameleonCPQ__QuoteId__c).OpportunityId__c).Pricebook2Id == null || Mopp.get(LCamQuote.get(content.CameleonCPQ__QuoteId__c).OpportunityId__c).Pricebook2Id !=cpqpbId)
                                                      {
                                                       
                                                       Mopp.get(LCamQuote.get(content.CameleonCPQ__QuoteId__c).OpportunityId__c).Pricebook2Id=cpqpbId;
                                                       Lopp.Add(Mopp.get(LCamQuote.get(content.CameleonCPQ__QuoteId__c).OpportunityId__c));
                                                      
                                                      }
                                            
                                            
                                            }             
                              
                                 }
                      }
                      
                      if(Lopp.Size()>0)                    
                       Update Lopp;

                       System.debug('Lopp'+lopp);
                       
                       Lopp.clear();
                                          
                      // End of Update Pricebookentry
                      
                     

                    // Preparation for instertion in database (Put Opportunity Line Items from a Map to a List)                                      
                     List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                      
                     // Preparation for instertion in database (Put the Cameleon Quote Line Items from a Map to a List)
                     List<CameleonQuoteLineItem__c> cqliList = new List<CameleonQuoteLineItem__c>();
                     
                     //List of Quote to update
                     List<CameleonCPQ__Quote__c> Lquota  = New List<CameleonCPQ__Quote__c>();
                     
                     //List of Opp to update
                     List<Opportunity> Loppp = New List<Opportunity>();
                                         
                                        
                    For(CameleonCPQ__QuoteContent__c content :NewList)
                    {
                         
                                                   
                            // Cameleon Quotecontent and Cameleon having mater detail relationship 
                            // Initialization
                            CameleonCPQ__Quote__c quote =LCamQuote.get(content.CameleonCPQ__QuoteId__c); 

                            
                            

                            // CPQ Quote processing
                            // Get Cameleon quote content XML from Attachment (note '_content' suffix)
                                Attachment att =Matt.get(content.Id)[0];
                                Blob quoContentXML=att.Body;
                        
                            
                            
                            //Invoke the Parser utility
                                CPQParser quoteParser = new CPQParser(quoContentXML);
                                CPQParser.Quote parsedQuote = quoteParser.getQuote();
                                List<CPQParser.QuoteLine> CP7lines = parsedQuote.getLines('CP7');
                            
                                Boolean requApproval=false;
                            
                            //Get Quota status  and Record Type information from XMl 
                                String quoStatus=parsedQuote.getField('ChangeAndControlTab.CurrentStatus');
                                String recordType = parsedQuote.getField('CartInfoTab.RecordType');
                                Double contTotal = Double.valueOf(parsedQuote.getField('ContractTotal'));
                                
                            
                            
                            // Only if quote has an opportunity
                            if (quote.OpportunityId__c != null) 
                            {
                                            
                                    //Get Opporunity related to Cameleon Quote
                                    Opportunity opp = Mopp.get(quote.OpportunityId__c);
                          
                                       opp.CPQActiveRelease__c = quote.id;
                                       
                                        
                                        quote.Contract_Total__c = 0;
                                        opp.CPQ_Payment_Terms__c = null;
                                        
                                       
                                        if(quoStatus == 'Approved'){
                                            
                                            opp.CPQ_Quote_Status__c = 'Approved Price Quote';
                                        }
                                        // Added by Nikhil.TP : 15646
                                        else if(quoStatus =='Draft')
                                        {
                                         opp.CPQ_Quote_Status__c ='';
                                        }
                                        
                                        else if(parsedQuote.getField('CartInfoTab.OppCur') == 'AUD' && quoStatus =='Draft')
                                        {
                                         opp.CPQ_Quote_Status__c ='';
                                        }
                                        
                                        else if(quoStatus == 'SubmittedForApproval')
                                        {
                                        
                                            opp.CPQ_Quote_Status__c = 'Pending Price Quote Approval';
                                            
                                            requApproval=true;
                                        
                                        }
                                        
                                        System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr Status: ' + quoStatus);
                                       // opp.This_Year_Amount__c = 0;
                                        //opp.Year_1_Amount__c=0;
                                        opp.Year_2_Amount__c = 0;
                                        opp.Year_3_Amount__c = 0;
                                        opp.Year_4_Amount__c = 0;
                                        opp.Year_5_Amount__c = 0;
                                        opp.CPQ_Year_1_Discount_Value__c = 0;
                                        opp.CPQ_Year_2_Discount_Value__c = 0;
                                        opp.CPQ_Year_3_Discount_Value__c = 0;
                                        opp.CPQ_Year_4_Discount_Value__c = 0;
                                        opp.CPQ_Year_5_Discount_Value__c = 0;
                                        
                                        // Auxiliary variables
                                        Boolean PayTermUpdated = false;
                                        Boolean multiyearUpdated = false;
                                        Boolean startDateUpdated=false;
                                        Boolean isComplete = true;
                                       // Commented By Nikhil
                                       // Id pricebook2Id = opp.Pricebook2Id;
                                        //added start and end date for the opp for bug 506
                                        Date endDate;
                                        Date startDate;
                                            
                                                     
                                        // Approval Map
                                        Map<String,Boolean> approvalMap = new Map<String,Boolean>();
                                        approvalrouting='';
                                        approvalMap.put('IsDiscountApproval', false);
                                        approvalMap.put('IsHostedApproval', false);
                                        approvalMap.put('IsPerpetualApproval', false);
                                        approvalMap.put('IsServiceApproval', false);
                                        approvalMap.put('IsSpecificProductApproval', false);
                                        approvalMap.put('IsTMApproval', false);
                                        approvalMap.put('IsTreasuryApproval', false);
                                        String CurrencyCode = opp.CurrencyIsoCode;
                                        Map<String,CameleonQuoteLineItem__c> cqliMap = new Map<String,CameleonQuoteLineItem__c>();
                                        Map<string,OpportunityLineItem> oliMap = new Map<String,OpportunityLineItem>();
                                                        
                                        // Check if every configuration are comlete
                                        System.debug('CP7lines' + CP7lines);
                                         
                                         // Set of Asset ids (12707)
                                         set<Id> Astid= New Set<Id>();
                                        
                                        For (CPQParser.QuoteLine Line : CP7lines) {
                                            
                                            Map<String,String> m = Line.getColumns();
                                            System.debug('Line.getColumns()' + m);
                                          
                                           //Adding here to avoid another loop
                                           if(m.get('bpSiteReference') != Null  && m.get('bpSiteReference') != '' && (m.get('bpSiteReference').length()==15 || m.get('bpSiteReference').length()==18)  && m.get('bpSiteReference').Startswith('02') )
                                             {
                                               Astid.Add(m.get('bpSiteReference'));
                                               System.debug('==A==' + Astid);
                                             }
                                             System.debug('==A==' + Astid);
                                            if(!Boolean.valueOf(m.get('isComplete')) && isComplete){
                                                isComplete = false;
                                            }
                                        }
                                         //add all aligned prods to a list, using the line Unique identifier since it is unique by Account 
                                         Set<String> alignedLines = new Set<String>();
                                            
                                        if(isComplete){
                                        
                                          //to Avoid some trigger not to fire on Quote Update
                                           runrenewaltrigger.CPQQuoteRUn =True;
                                        
                                           //Query for Current opportunity from Asset id(12707) 
                                            
                                            System.debug('==A==' + Astid);
                                            Map<id,Asset>  MapAst = New Map<id,Asset>([Select id,CPQ_Current_Opportunity_ID__c from Asset Where id  IN : Astid]);
                                                
                                            Double rate = Double.valueOf(parsedQuote.getField('CartInfoTab.ExchangeRate'));
                                            
                                            if(parsedQuote.getField('CartInfoTab.OppCur') == 'AUD')
                                                rate = Double.valueOf(1);
                                            
                                            
                                            //Calculate year amount
                                           // opp.This_Year_Amount__c = Double.valueof(parsedQuote.getField('Year1Total'));
                                            
                                            opp.CPQ_Year_1_Amount__c = Double.valueof(parsedQuote.getField('Year1Total'));
                                            opp.Year_2_Amount__c = Double.valueof(parsedQuote.getField('Year2Total'));
                                            opp.Year_3_Amount__c = Double.valueof(parsedQuote.getField('Year3Total'));
                                            opp.Year_4_Amount__c = Double.valueof(parsedQuote.getField('Year4Total'));
                                            opp.Year_5_Amount__c = Double.valueof(parsedQuote.getField('Year5Total'));
                                            
                                            if(Double.valueof(parsedQuote.getField('Year1ListTotal')) > 0){opp.CPQ_Year_1_Discount_Value__c = Double.valueof(parsedQuote.getField('DiscAmtYear1Total')) *100 / Double.valueof(parsedQuote.getField('Year1ListTotal'));}else{opp.CPQ_Year_1_Discount_Value__c = 0;}
                                            if(Double.valueof(parsedQuote.getField('Year2ListTotal')) > 0){opp.CPQ_Year_2_Discount_Value__c = Double.valueof(parsedQuote.getField('DiscAmtYear2Total')) *100 / Double.valueof(parsedQuote.getField('Year2ListTotal'));}else{opp.CPQ_Year_2_Discount_Value__c = 0;}
                                            if(Double.valueof(parsedQuote.getField('Year3ListTotal')) > 0){opp.CPQ_Year_3_Discount_Value__c = Double.valueof(parsedQuote.getField('DiscAmtYear3Total')) *100 / Double.valueof(parsedQuote.getField('Year3ListTotal'));}else{opp.CPQ_Year_3_Discount_Value__c = 0;}
                                            if(Double.valueof(parsedQuote.getField('Year4ListTotal')) > 0){opp.CPQ_Year_4_Discount_Value__c = Double.valueof(parsedQuote.getField('DiscAmtYear4Total')) *100 / Double.valueof(parsedQuote.getField('Year4ListTotal'));}else{opp.CPQ_Year_4_Discount_Value__c = 0;}
                                            if(Double.valueof(parsedQuote.getField('Year5ListTotal')) > 0){opp.CPQ_Year_5_Discount_Value__c = Double.valueof(parsedQuote.getField('DiscAmtYear5Total')) *100 / Double.valueof(parsedQuote.getField('Year5ListTotal'));}else{opp.CPQ_Year_5_Discount_Value__c = 0;}
                                                            
                                            // Put productCode of every objects (Only one time) in the quote into a List
                                            // Update Multi_Year_Deal__c and Payment_Terms__c in the opportunity
                                              Set<String> ProductNames = new Set<String>();
                                              Set<String> ProductNamesFilter = new Set<String>();
                                        
                                          
                                           
                                           
                                            String contLength='';
                                            //TP:12295
                                            opp.Is_Standalone__c=True; 
                                            
                                            // New Approval Requirement
                                            Opp.Maximum_SLEC_Discount__c=-500.0;
                                            Opp.Maximum_Margin_Differential__c=-500.0;
                                            
                                            //to uncheck the flag 
                                            Boolean EducationService=False;
                                            Boolean CarrerMarketPlace=False;
                                            Boolean StudentServiceMER=False;
                                            Boolean EducatiobServiceSLE=False;
                                            Boolean EducatiobServiceOthr=False;
                                            
                                            For (CPQParser.QuoteLine Line : CP7lines) {
                                                Map<String,String> m = Line.getColumns();
                                                System.debug('NikhilTest' + Line.getId());
                                                // Update Payment_Terms__c in the opportunity
                                                if(!PayTermUpdated && m.get('PayTerm') != ''){
                                                    
                                                    opp.CPQ_Payment_Terms__c = m.get('PayTerm');
                                                    
                                                    PayTermUpdated = true;
                                                }
                                                 // Update Multi_Year_Deal__c in the opportunity
                                                 contLength = m.get('ContractLengthHidden');
                                                 System.debug('Nik++deply' + m.get('bpDelayDate'));
                                                
                                                 // Added By Nikhil(start)11630 
                                                 if(Line.getId()=='1' && m.get('bpDelayDate')!='1900-01-01T12:00:00.000-06:00')
                                                 {
                                                   opp.Is_Delayed_Invoicing__c=TRUE;
                                                   opp.Delayed_Invoicing__c= date.valueOf(m.get('bpDelayDate'));
                                                   
                                                 }
                                                 Else if(Line.getId()=='1' && m.get('bpDelayDate')=='1900-01-01T12:00:00.000-06:00')
                                                 {
                                                   opp.Is_Delayed_Invoicing__c=FALSE;
                                                   opp.Delayed_Invoicing__c=Null; 
                                                   
                                                 }  
                                                 
                                                 
                                                 if(Line.getId()=='1' && (m.get('bpSplitType')!=Null && m.get('bpSplitType')!=''))
                                                 {
                                                   opp.Is_Split_Invoicing__c=TRUE;
                                                   //TP12478
                                                   opp.Split_Invoicing__c= m.get('bpSplitType');
                                                   
                                                 }
                                                 Else if(Line.getId()=='1')
                                                 {
                                                   opp.Is_Split_Invoicing__c=FALSE;
                                                   //TP12478
                                                    opp.Split_Invoicing__c='';
                                                 } 
                                                 //END
                                                 //Start 12478 Start
                                                 /*
                                                 if(Line.getId()=='1' && (m.get('bpDelayDate')!=Null && m.get('bpDelayDate')!=''))
                                                 {
                                                    opp.Delayed_Invoicing__c= date.valueOf(m.get('bpDelayDate'));
                                                    
                                                    //opp.Delayed_Invoicing__c= date.valueOf(m.get('bpDelayDate').substring(5,7)+'/'+m.get('bpDelayDate').substring(8,10)+'/'+m.get('bpDelayDate').substring(0,4));
                                                 }
                                                 else if(Line.getId()=='1')
                                                 {

                                                  opp.Delayed_Invoicing__c=Null;  
                                                 }
                                                 */
                                                 //END
                                                 //TP:12295
                                                 if(m.get('isPackage')=='true' && opp.Is_Standalone__c==True &&!m.get('Description').contains('DIAMOND HOSTING') && !m.get('Description').contains('GOLD HOSTING') &&!m.get('Description').contains('PLATINUM HOSTING'))
                                                 {
                                                   opp.Is_Standalone__c=False;     
                                                 }
                                                 
                                                 //TP 12707
                                                 System.debug('Adjustment');
                                                 if(opp.Parent_Adjustment_Opportunity__c== Null && m.get('bpSiteReference')!= NUll && m.get('bpSiteReference')!= '' && (m.get('bpSiteReference').length()==15 || m.get('bpSiteReference').length()==18) && m.get('bpSiteReference').Startswith('02'))
                                                 {
                                                   if(MapAst.containsKey(m.get('bpSiteReference')) && MapAst.get(m.get('bpSiteReference')).CPQ_Current_Opportunity_ID__c!=opp.id)
                                                   opp.Parent_Adjustment_Opportunity__c=MapAst.get(m.get('bpSiteReference')).CPQ_Current_Opportunity_ID__c;
                                                 }
                                                 
                                                 // New Approval requirement(start)
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('DiscPct')!='' && m.get('DiscPct')!=Null && m.get('ProductCategory')!='' && m.get('ProductCategory')!=Null && m.get('ProductCategory')=='SLEC' && Decimal.valueof(m.get('DiscPct'))>Opp.Maximum_SLEC_Discount__c)
                                                 {
                                                 
                                                    Opp.Maximum_SLEC_Discount__c=Decimal.valueof(m.get('DiscPct'));
                                                 }
                                                 
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('MarginDifferential')!='' && m.get('MarginDifferential')!=Null &&Decimal.valueof(m.get('MarginDifferential')) >0 && Decimal.valueof(m.get('MarginDifferential'))>Opp.Maximum_Margin_Differential__c  )
                                                 {
                                                 
                                                    Opp.Maximum_Margin_Differential__c=Decimal.valueof(m.get('MarginDifferential'));
                                                 }
                                                 else if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('MarginDifferential')!='' && m.get('MarginDifferential')!=Null &&Decimal.valueof(m.get('MarginDifferential')) <0 )
                                                 {
                                                    if(Opp.Maximum_Margin_Differential__c==-500)
                                                    Opp.Maximum_Margin_Differential__c=Decimal.valueof(m.get('MarginDifferential'));
                                                    else if(Opp.Maximum_Margin_Differential__c >Decimal.valueof(m.get('MarginDifferential')))
                                                    Opp.Maximum_Margin_Differential__c=Decimal.valueof(m.get('MarginDifferential'));
                                                 }
                                                 //END
                                                
                                                 
                                                 //Approval logic for Education services
                                                 
                                                 
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('ProductCategory')!='' && m.get('ProductCategory')!=Null && m.get('ProductCategory')=='ENTERPRISE CONS')
                                                 {
                                                     Opp.Is_Enterprise_Consulting_Approval__c=true;
                                                     EducationService=True;
                                                 }
                                                 else if(EducationService==False)
                                                 {
                                                    Opp.Is_Enterprise_Consulting_Approval__c=False;
                                                 
                                                 }
                                                 
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('ProductCategory')!='' && m.get('ProductCategory')!=Null && m.get('ProductCategory')=='CAREER MKTPL')
                                                 {
                                                     Opp.Is_Career_Marketplace_Approval__c=true;
                                                     CarrerMarketPlace=True;
                                                 }
                                                 else if(CarrerMarketPlace==False)
                                                 {
                                                    Opp.Is_Career_Marketplace_Approval__c=False;
                                                 
                                                 }
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('ProductCategory')!='' && m.get('ProductCategory')!=Null && m.get('ProductCategory')=='MER')
                                                 {
                                                     Opp.Is_Student_Services_MER_Approval__c=true;
                                                     StudentServiceMER=True;
                                                 }
                                                 else if(StudentServiceMER==False)
                                                 {
                                                    Opp.Is_Student_Services_MER_Approval__c=False;
                                                 
                                                 }
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('ProductCategory')!='' && m.get('ProductCategory')!=Null && m.get('ProductCategory')=='SLEC')
                                                 {
                                                     Opp.Is_Student_Services_SLEC_Approval__c=true;
                                                     EducatiobServiceSLE=True;
                                                 }
                                                 else if(EducatiobServiceSLE==False)
                                                 {
                                                    Opp.Is_Student_Services_SLEC_Approval__c=False;
                                                 
                                                 }
                                                 if(m.get('EducationServicesApproval')!= '' && m.get('EducationServicesApproval')!= NUll &&m.get('EducationServicesApproval')=='true' && m.get('ProductCategory')!='' && m.get('ProductCategory')!=Null && m.get('ProductCategory')!='ENTERPRISE CONS' && m.get('ProductCategory')!='CAREER MKTPL' && m.get('ProductCategory')!='MER' && m.get('ProductCategory')!='SLEC')
                                                 {
                                                     Opp.Is_Student_Services_Other_Approval__c=true;
                                                     EducatiobServiceOthr=True;
                                                 }
                                                 else if(EducatiobServiceOthr==False)
                                                 {
                                                    Opp.Is_Student_Services_Other_Approval__c=False;
                                                 
                                                 }
                                                 // TP:14921
                                                 if(Opp.Contract_Term_End_Date__c==Null && m.get('ContractEndDateHidden')!='' && m.get('ContractEndDateHidden')!=Null)
                                                 Opp.Contract_Term_End_Date__c=parseDate(m.get('ContractEndDateHidden'));
                                                 
                                                 //END
                                                 System.debug('multiyear blank: ' + m.get('ContractLengthHidden'));
                                                if(!multiyearUpdated){
                                                    
                                                    System.debug('multiyear blank: ' + m.get('ContractLengthHidden'));
                                                    if(contLength == null || contLength.equals('')){
                                                        //do nothing and keep current value
                                                        System.debug('multiyear blank: ' + m.get('ContractLengthHidden'));
                                                    }
                                                    else if(Double.valueof(contLength) < 12){
                                                        opp.Multi_Year_Deal__c = 'No';
                                                    }
                                                    else if(Double.valueof(contLength) < 24){
                                                        opp.Multi_Year_Deal__c = 'No';
                                                    }
                                                    else if(Double.valueof(contLength) < 36){
                                                        opp.Multi_Year_Deal__c = '2 year';
                                                    }
                                                    else if(Double.valueof(contLength) < 48){
                                                        opp.Multi_Year_Deal__c = '3 year';
                                                    }
                                                    else if(Double.valueof(contLength) < 60){
                                                        opp.Multi_Year_Deal__c = '4 year';
                                                    }
                                                    else{
                                                        opp.Multi_Year_Deal__c = '5 year';
                                                    }
                                                    multiyearUpdated = true;
                                                }
                                              
                                                // Product Key  
                                               String prodKey = '';
                                               // Logic Changed TP 15739
                                                //if(opp.PFIN_Intgr_Record_Type__c.contains('CPQ New Sales Opportunity Record Type')){
                                                  if(m.get('ProductStatus').equals('New') && m.get('UID')==null || m.get('UID')=='')
                                                  //This has been added for TP:11629
                                                  {
                                                    prodKey = m.get('ProductCode')+ m.get('Product_Instance__c');
                                                    System.debug('ProductKey'+prodkey);
                                                    
                                                }
                                               else{
                                                   // prodKey=m.get('ProductCode') + '~' + Line.getId() + '~' + m.get('year');
                                                    prodKey = m.get('ProductCode')+ m.get('UID');
                                                    System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey: ' + prodKey);
                                               }
                                                //update expected contract start date based on inputed fields

                                                if((!startDateUpdated && quoStatus != 'Approved') || (opp.Start_Date__c == null || opp.End_Date__c==null) ){
                                                    if(Double.valueof(m.get('ContractLengthHidden')) < 24){
                                                    
                                                        startDate=parseDate(m.get('ContractStartDateHidden'));
                                                        endDate= parseDate(m.get('ContractEndDateHidden'));
                                                        opp.Start_Date__c = startDate;
                                                        opp.End_Date__c = endDate;
                                                    
                                                    }else if(Math.mod(Integer.valueof(m.get('ContractLengthHidden')),12) != 0){
                                                        
                                                        Integer addMonth = Math.mod(Integer.valueof(m.get('ContractLengthHidden')),12);
                                                        startDate =parseDate(m.get('ContractStartDateHidden'));
                                                        endDate = startDate.addMonths(addMonth+12);
                                                        opp.Start_Date__c = startDate;
                                                        opp.End_Date__c =  endDate;                             
                                                    
                                                    }
                                                    else{
                                                    
                                                        startDate =parseDate(m.get('ContractStartDateHidden'));
                                                        opp.Start_Date__c = startDate;
                                                        endDate = startDate + 364;
                                                        opp.End_Date__c =endDate;
                                                        // Added By Nikhil
                                                        if((Date.isLeapYear(startDate.Year()) && startDate.month()<=2) || (Date.isLeapYear((endDate+1).Year()) &&((endDate+1).month() >2))|| (Date.isLeapYear((endDate+1).Year()) && (endDate+1).month() ==2 && (endDate+1).day() ==29))
                                                        {
                                                           endDate=endDate+1;
                                                           opp.End_Date__c =endDate;
                                                        }   
                                                    }
                                                    startDateUpdated=true;  
                                                }else{
                                                        
                                                        startDate=opp.Start_Date__c;
                                                        endDate= opp.End_Date__c;
                                                }                                          
                                                                     
                                                // Put productCode of every objects (Only one time) in the quote into a List
                                                if(addTest(m,0) || addTest(m,1)){
                                                
                                                    ProductNames.add(prodKey);
                                                    ProductNamesFilter.add(m.get('ProductCode'));
                                                    System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey 0-1: ' + m.get('ProductCode'));
                                                
                                                }else if(addTest(m,2)){
                                                
                                                    ProductNames.add(prodKey);
                                                    ProductNamesFilter.add(m.get('ProductCode'));
                                                    System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey 2: ' + m.get('ProductCode'));
                                                
                                                }else if(addTest(m,3)){
                                                
                                                    ProductNames.add(prodKey);
                                                    ProductNamesFilter.add(m.get('ProductCode'));
                                                    System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey 3: ' + m.get('ProductCode') + ' prod key: ' + prodKey);
                                                
                                                }else if(addTest(m,4)){
                                                
                                                    ProductNames.add(prodKey);
                                                    ProductNamesFilter.add(m.get('ProductCode'));
                                                    System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey 4: ' + m.get('ProductCode'));
                                                
                                                }else if(addTest(m,5)){
                                                
                                                    ProductNames.add(prodKey);
                                                    ProductNamesFilter.add(m.get('ProductCode'));
                                                    System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey 5: ' + m.get('ProductCode'));
                                                
                                                }
                                            }
                                            
                                            // Put PricebookEntry for every ProductCode (=ProductName) in a table
                                            PricebookEntry[] dbPbes = [SELECT Id, Product2.ProductCode 
                                                                        FROM PricebookEntry
                                                                        WHERE Pricebook2.Name ='CPQ' AND CurrencyIsoCode =: CurrencyCode AND Product2.ProductCode IN: ProductNamesFilter and Isactive=True];
                                            
                                            // Associate a productCode with her PricebookEntry in a Map
                                            Map<String, PricebookEntry> productsPBEId = new Map<String, PricebookEntry>();
                                            for (PricebookEntry p : dbPbes) {
                                            
                                                productsPBEId.put(p.Product2.ProductCode, p);
                                            
                                            }                  
                                           
                            
                                            // Loop through all lines to prepare information and populate the Opportunity Line Items Map and the Cameleon Quote Line Items Map (Protection from Governor Limits)
                                            for (CPQParser.QuoteLine Line : CP7lines) {
                                                
                                                Map<String,String> m = Line.getColumns();
                                                String prodKey = '';
                                                contLength = m.get('ContractLengthHidden');
                                                System.debug('multiyear blank: ' + m.get('ContractLengthHidden'));
                                                
                                                //TP:15739
                                                //if(opp.PFIN_Intgr_Record_Type__c.contains('CPQ New Sales Opportunity Record Type')){
                                                 if(m.get('ProductStatus').equals('New') && m.get('UID')==null || m.get('UID')=='')
                                                 {
                                                   
                                                      prodKey = m.get('ProductCode')+ m.get('Product_Instance__c');
                                                      System.debug('ProductKey'+prodkey);
                                                }
                                                else{
                                                  //  prodKey=m.get('ProductCode') + '~' + Line.getId() + '~' + m.get('year');
                                                   prodKey = m.get('ProductCode')+ m.get('UID');
                                                   System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr prodKey: ' + prodKey);
                                                 
                                                }
                                                
                                                //check if the product is being realigned
                                                if(m.get('ProductStatus').equals('Aligned') && !alignedLines.contains(m.get('UID'))){
                                                    alignedLines.add(m.get('UID') + '.' + m.get('bpPrevOppId'));
                                                }
                                                // For Approval for each cart line
                                                updateApprovalMap(m, approvalMap, quoStatus);
                                                System.debug('PRDLine' + m.get('ProductCode'));
                                                if(addTest(m,0) || addTest(m,1)){
                                                
                                                  //  updateApprovalMap(m, approvalMap, quoStatus);
                                                    if(productsPBEId.keyset().contains(m.get('ProductCode'))){
                                                    
                                                    
                                                        // Create opportunity line item
                                                        OpportunityLineItem oli = createOpportunityLineItem(m, productsPBEId.get(m.get('ProductCode')).Id, quote.OpportunityId__c,startDate,endDate);
                                                        oliMap.put(prodKey,oli);
                                                        System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr add prod year 1: ' + prodKey + ' oli ' + oli);
                                                    
                                                    }    
                                                        
                                                    // Create Cameleon Quote line item
                                                    CameleonQuoteLineItem__c cqli = createCameleonQuoteLineItem(m, quote.Id);
                                                    cqliMap.put(prodKey,cqli);
                                                        
                                                }
                                                else if(addTest(m,2)){
                                                
                                                  
                                                    
                                                   // updateApprovalMap(m, approvalMap, quoStatus);
                                                    // Update Year 2 Net Price of the Opportunity Line Items and the Cameleon Quote Line Items
                                                    if(oliMap.keyset().contains(prodKey)){
                                                        
                                                        OpportunityLineItem oli = oliMap.get(prodKey);
                                                        oli.CPQ_Year_2_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                        if(Boolean.valueOf(m.get('Renewable'))){
                                                        
                                                            Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                          // As comment on TP:4876  
                                                         //   if(!(recordType == 'CPQ Renewal Opportunity Record Type')){
                                                                
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_NetPrice__c + oli.CPQ_Year_2_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                                System.debug(LoggingLevel.DEBUG,'yr 2 annualized ' + oli.CPQ_Year_2_Amount__c +  ' net '+ oli.CPQ_NetPrice__c + ' dates ' + oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate));
                                                         //   }                                       
                                                            
                                                        }else{
                                                            
                                                            oli.CPQ_Annualized_Product_Amount__c=0;
                                                        }
                                                    }else{
                                                        if(productsPBEId.keyset().contains(m.get('ProductCode'))){
                                                            
                                                            // Create opportunity line item
                                                            OpportunityLineItem oli = createOpportunityLineItem(m, productsPBEId.get(m.get('ProductCode')).Id, quote.OpportunityId__c,startDate,endDate);
                                                           
                                                            oli.CPQ_Year_2_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                            if(Boolean.valueOf(m.get('Renewable'))){
                                                                Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_Year_2_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                                System.debug(LoggingLevel.DEBUG,'yr 2 annualized ' + oli.CPQ_Year_2_Amount__c + ' dates ' + oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1);
                                                            }else{
                                                                oli.CPQ_Annualized_Product_Amount__c=0;
                                                            }
                                                            oliMap.put(prodKey,oli);
                                                        }
                                                        else{
                                                            System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr year 2 pricebook entry does not exist: ' + prodKey);
                                                        }   
                                                    }
                                                    if(cqliMap.keyset().contains(prodKey)){
                                                    
                                                        cqliMap.get(prodKey).NetYear2__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    
                                                    }else{
                                                    
                                                         // Create Cameleon Quote line item
                                                        CameleonQuoteLineItem__c cqli = createCameleonQuoteLineItem(m, quote.Id);
                                                        cqliMap.put(prodKey,cqli);
                                                        cqliMap.get(prodKey).NetYear1__c = 0;
                                                        cqliMap.get(prodKey).NetYear2__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }
                                                    
                                                }
                                                else if(addTest(m,3)){
                                                
                                                  //  updateApprovalMap(m, approvalMap, quoStatus);
                                                    // Update Year 3 Net Price of the Opportunity Line Items and the Cameleon Quote Line Items
                                                    if(oliMap.keyset().contains(prodKey)){
                                                        OpportunityLineItem oli = oliMap.get(prodKey);
                                                        oli.CPQ_Year_3_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                        if(Boolean.valueOf(m.get('Renewable'))){
                                                            Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                            System.debug('Check1' +oli.CPQ_Product_Start_Date__c);
                                                            System.debug('Check2' + oli.CPQ_NetPrice__c);
                                                            System.debug('Check3' + oli.CPQ_Year_2_Amount__c);
                                                            System.debug('Check4' + oli.CPQ_Year_3_Amount__c);
                                                            System.debug('Check5' + actualEndDate);
                                                            System.debug('Test me' + Line.getid());
                                                        //Commented as per keith comment on TP:4876
                                                        //  if(!(recordType == 'CPQ Renewal Opportunity Record Type')){
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_NetPrice__c + oli.CPQ_Year_2_Amount__c + oli.CPQ_Year_3_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate))) * 365;
                                                            System.debug(LoggingLevel.DEBUG,'yr 3 annualized yr:3' + oli.CPQ_Year_3_Amount__c  + ' yr2:' + oli.CPQ_Year_2_Amount__c +  ' net '+ oli.CPQ_NetPrice__c + ' dates ' + oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate));
                                                          //  }    
                                                        }else{
                                                            oli.CPQ_Annualized_Product_Amount__c=0;
                                                        }
                                                    }else{
                                                           System.debug('Check1Nik');
                                                        if(productsPBEId.keyset().contains(m.get('ProductCode'))){
                                                           System.debug('Check2Nik'); 
                                                            // Create opportunity line item
                                                            OpportunityLineItem oli = createOpportunityLineItem(m, productsPBEId.get(m.get('ProductCode')).Id, quote.OpportunityId__c,startDate,endDate);
                                                            oli.CPQ_Year_2_Amount__c = 0;
                                                            oli.CPQ_Year_3_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                            
                                                            if(Boolean.valueOf(m.get('Renewable'))){
                                                                Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_Year_3_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                            }else{
                                                                oli.CPQ_Annualized_Product_Amount__c=0;
                                                            }
                                                            oliMap.put(prodKey,oli);
                                                        }   
                                                    }
                                                    if(cqliMap.keyset().contains(prodKey)){
                                                        cqliMap.get(prodKey).NetYear3__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }else{
                                                         // Create Cameleon Quote line item
                                                        CameleonQuoteLineItem__c cqli = createCameleonQuoteLineItem(m, quote.Id);
                                                        cqliMap.put(prodKey,cqli);
                                                        cqliMap.get(prodKey).NetYear1__c = 0;
                                                        cqliMap.get(prodKey).NetYear2__c = 0;
                                                        cqliMap.get(prodKey).NetYear3__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }
                                                }
                                                else if(addTest(m,4)){
                                                    
                                                //   updateApprovalMap(m, approvalMap, quoStatus);
                                                    // Update Year 4 Net Price of the Opportunity Line Items and the Cameleon Quote Line Items
                                                    if(oliMap.keyset().contains(prodKey)){
                                                        OpportunityLineItem oli = oliMap.get(prodKey);
                                                        oli.CPQ_Year_4_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                         if(Boolean.valueOf(m.get('Renewable'))){   
                                                            Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                         // Commented as per keith comment on TP:4876  
                                                         //  if(!(recordType == 'CPQ Renewal Opportunity Record Type')){
                                                               System.debug('++NNN++' + oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate));
                                                               System.debug('++CC++' + oli.CPQ_NetPrice__c);
                                                               System.debug('++CC++' + oli.CPQ_Year_2_Amount__c);
                                                               System.debug('++CC++' + oli.CPQ_Year_3_Amount__c);
                                                               System.debug('++CC++' + oli.CPQ_Year_4_Amount__c);
                                                               System.debug('++MM++' + (oli.CPQ_NetPrice__c + oli.CPQ_Year_2_Amount__c + oli.CPQ_Year_3_Amount__c + oli.CPQ_Year_4_Amount__c));
                                                              
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_NetPrice__c + oli.CPQ_Year_2_Amount__c + oli.CPQ_Year_3_Amount__c + oli.CPQ_Year_4_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                                System.debug('++p++' + oli.CPQ_Annualized_Product_Amount__c);
                                                          //  }      
                                                        }else{
                                                            oli.CPQ_Annualized_Product_Amount__c=0;
                                                        }
                                                    }else{
                                                        if(productsPBEId.keyset().contains(m.get('ProductCode'))){
                                                            // Create opportunity line item
                                                            OpportunityLineItem oli = createOpportunityLineItem(m, productsPBEId.get(m.get('ProductCode')).Id, quote.OpportunityId__c,startDate,endDate);
                                                            oli.CPQ_Year_2_Amount__c = 0;
                                                            oli.CPQ_Year_3_Amount__c = 0;
                                                             oli.CPQ_Year_4_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                            if(Boolean.valueOf(m.get('Renewable'))){
                                                                Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_Year_4_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                            }else{
                                                                oli.CPQ_Annualized_Product_Amount__c=0;
                                                            }
                                                            oliMap.put(prodKey,oli);
                                                        }   
                                                    }
                                                    if(cqliMap.keyset().contains(prodKey)){
                                                        cqliMap.get(prodKey).NetYear4__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }else{
                                                         // Create Cameleon Quote line item
                                                        CameleonQuoteLineItem__c cqli = createCameleonQuoteLineItem(m, quote.Id);
                                                        cqliMap.put(prodKey,cqli);
                                                        cqliMap.get(prodKey).NetYear1__c = 0;
                                                        cqliMap.get(prodKey).NetYear2__c = 0;
                                                        cqliMap.get(prodKey).NetYear3__c = 0;
                                                        cqliMap.get(prodKey).NetYear4__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }
                                                }
                                                else if(addTest(m,5)){
                                                //    updateApprovalMap(m, approvalMap, quoStatus);
                                                    // Update Year 5 Net Price of the Opportunity Line Items and the Cameleon Quote Line Items
                                                    if(oliMap.keyset().contains(prodKey)){
                                                        OpportunityLineItem oli = oliMap.get(prodKey);
                                                        oli.CPQ_Year_5_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                         if(Boolean.valueOf(m.get('Renewable'))){
                                                            Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                       // Commented as per keith comment on TP:4876    
                                                           // if(!(recordType == 'CPQ Renewal Opportunity Record Type')){
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_NetPrice__c + oli.CPQ_Year_2_Amount__c + oli.CPQ_Year_3_Amount__c + oli.CPQ_Year_4_Amount__c + oli.CPQ_Year_5_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                          //  } 
                                                            
                                                        }else{
                                                            oli.CPQ_Annualized_Product_Amount__c=0;
                                                        }
                                                    }else{
                                                        if(productsPBEId.keyset().contains(m.get('ProductCode'))){
                                                            // Create opportunity line item
                                                            OpportunityLineItem oli = createOpportunityLineItem(m, productsPBEId.get(m.get('ProductCode')).Id, quote.OpportunityId__c,startDate,endDate);
                                                            oli.CPQ_Year_2_Amount__c = 0;
                                                            oli.CPQ_Year_3_Amount__c = 0;
                                                             oli.CPQ_Year_4_Amount__c = 0;
                                                             oli.CPQ_Year_5_Amount__c = Double.valueof(m.get('NetPriceCC'));
                                                             
                                                            if(Boolean.valueOf(m.get('Renewable'))){
                                                                Date actualEndDate = parseDate(m.get('ContractEndDateHidden'));
                                                                oli.CPQ_Annualized_Product_Amount__c = ((oli.CPQ_Year_5_Amount__c) / (oli.CPQ_Product_Start_Date__c.daysBetween(actualEndDate) + 1)) * 365;
                                                            }else{
                                                                oli.CPQ_Annualized_Product_Amount__c=0;
                                                            }
                                                            oliMap.put(prodKey,oli);
                                                        }   
                                                    }
                                                    if(cqliMap.keyset().contains(prodKey)){
                                                        cqliMap.get(prodKey).NetYear5__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }else{
                                                         // Create Cameleon Quote line item
                                                        CameleonQuoteLineItem__c cqli = createCameleonQuoteLineItem(m, quote.Id);
                                                        cqliMap.put(prodKey,cqli);
                                                        cqliMap.get(prodKey).NetYear1__c = 0;
                                                        cqliMap.get(prodKey).NetYear2__c = 0;
                                                        cqliMap.get(prodKey).NetYear3__c = 0;
                                                        cqliMap.get(prodKey).NetYear4__c = 0;
                                                        cqliMap.get(prodKey).NetYear5__c = Double.valueof(m.get('NetPriceCC'));
                                                        updateDiscountApproval(cqliMap,m,prodKey);
                                                    }
                                                }
                                            }
                             
                                            // Preparation for instertion in database (Put Opportunity Line Items from a Map to a List)
                                            //List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
                                            for (String pc : oliMap.keyset()) {
                                               oliList.add(oliMap.get(pc));
                                               System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr look through oliMap: ' + pc + ' oli: ' + oliMap.get(pc));
                                            }
                                            // Insert Opportunity Line Items
                                            //insert oliList;
                                            
                                            // Preparation for instertion in database (Put the Cameleon Quote Line Items from a Map to a List)
                                            //List<CameleonQuoteLineItem__c> cqliList = new List<CameleonQuoteLineItem__c>();
                                            for (String pc : cqliMap.keyset()) {
                                                cqliList.add(cqliMap.get(pc));
                                            }
                                            // Insert Cameleon Quote Line Items
                                            //insert cqliList;
                                        
                                            // Update Contract Total Price of the Cameleon Quote
                                            if(!cqliList.isEmpty()){
                                                quote.Contract_Total__c = Decimal.valueof(parsedQuote.getField('ContractTotal'));
                                            }
                                        }
                                        Lquota.Add(quote);
                                        //update quote;
                                        
                                        //update approval for Netspot
                                       //Commented for TP# 13404
                                       /* if(contTotal > 50000 && CurrencyCode == 'AUD'){
                                            approvalMap.put('IsDiscountApproval',true);
                                        }*/
                                        
                                        // Update Approval Flags of the Opportunity
                                        opp.CPQ_Is_Discount_Approval__c = approvalMap.get('IsDiscountApproval');
                                        system.debug('Value of opp.CPQ_Is_Discount_Approval__c is:'+approvalMap.get('IsDiscountApproval'));
                                        system.debug('Value of opp.CPQ_Is_Discount_Approval__c is One:'+opp.CPQ_Is_Discount_Approval__c);
                                        opp.CPQ_Is_Hosted_Approval__c = approvalMap.get('IsHostedApproval');
                                        opp.CPQ_Is_Perpetual_Approval__c = approvalMap.get('IsPerpetualApproval');
                                        system.debug('Value of opp.CPQ_Is_Perpetual_Approval__c is:'+approvalMap.get('IsPerpetualApproval'));
                                        system.debug('Value of opp.CPQ_Is_Perpetual_Approval__c is One:'+opp.CPQ_Is_Perpetual_Approval__c);
                                        opp.CPQ_Is_Service_Approval__c = approvalMap.get('IsServiceApproval');
                                        opp.CPQ_Is_Specific_Product_Approval__c = approvalMap.get('IsSpecificProductApproval');
                                        //only needed for Moodleroom
                                        //opp.CPQ_Is_T_M_Approval__c = approvalMap.get('IsTMApproval');
                                        opp.CPQ_Is_Treasury_Approval__c = approvalMap.get('IsTreasuryApproval');
                                        
                                        //Added by Varghese for TP4942
                                        if(approvalrouting != null && approvalrouting != '')
                                        {
                                            opp.Approval_routing__c=approvalrouting;
                                        }
                                        else
                                        {
                                            opp.Approval_routing__c='';
                                        }
                                        
                                        System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr Opp  disc approval: ' + approvalMap.get('IsDiscountApproval'));
                                        System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr Opp  serv approval: ' + approvalMap.get('IsServiceApproval'));
                                        
                                        //If(approvalMap.get('IsDiscountApproval') == false && approvalMap.get('IsHostedApproval')==false && approvalMap.get('IsPerpetualApproval')==false && approvalMap.get('IsServiceApproval')==false &&approvalMap.get('IsSpecificProductApproval')==false && approvalMap.get('IsTMApproval')==false && approvalMap.get('IsTreasuryApproval')==false){
                                          if(quoStatus == 'Approved' && !(opp.CPQ_Quote_Status__c=='Approved Price Quote')){
                                            opp.CPQ_Quote_Status__c = 'Approved Price Quote';
                                          }             
                                        //}   
                                        
                                        //set field if there are any items being aligned
                                        String itemsAligned='';
                                        for(String a : alignedLines){
                                            if(itemsAligned.equals('')){
                                                itemsAligned=a;
                                            }
                                            else{
                                                itemsAligned='~' + a;
                                            }
                                        }
                                        
                                        if(!itemsAligned.equals(opp.CPQ_Products_for_Realignment__c)){
                                            opp.CPQ_Products_for_Realignment__c= itemsAligned;
                                        }
                                         
                                        if(Opp.Maximum_SLEC_Discount__c==-500.00)   
                                        Opp.Maximum_SLEC_Discount__c=0.0;
                                        
                                        if(Opp.Maximum_Margin_Differential__c==-500)
                                        Opp.Maximum_Margin_Differential__c=0.0;   
                                        //update opp;
                                        Loppp.Add(opp);
                                                        
                            }
                    
                    }                               
                                                                                    
                    
                    //Insert Opportunity Line Item
                    if(oliList.Size()>0)
                     Insert oliList;
                     
                     
                     //Insert cameleon Line Item
                     if(cqliList.Size()>0)
                     Insert cqliList;
                    
                    //Update Quota 
                    if(Lquota.Size()>0)
                     Update Lquota;
                    
                    //Update Opporunity
                    if(Loppp.Size()>0)
                    Update Loppp;                   
                                                                            
                
                
                
                }
   }             
     // Creation of the Opportunity Line Item
    //updated for bug 506 with adding start and end date as parameters
    private OpportunityLineItem createOpportunityLineItem(Map<String,String> m, Id PricebookEntryId, Id OpportunityId, Date startDate,Date endDate) {
        
                    
                    
                    OpportunityLineItem oli = new OpportunityLineItem();
                    oli.OpportunityId = OpportunityId;
                    oli.PricebookEntryId = PricebookEntryId;
                    Double netPrice =Double.valueof(m.get('NetPriceCC')); 
                    oli.UnitPrice = netPrice;
                    //updated to use local currency converted price
                    Double qty = Double.valueof(m.get('Qty'));
                    Double listPr = Double.valueof(m.get('ListPriceCC'));
                    oli.Quantity = qty;
                    
                    Double price = (listPr==null || listPr==0 ? netPrice : listPr);
                    //oli.Custom_Price__c= listPr; //-- not sending to prod right away using in place of ListPrice, when the opp is updated the prices aren't zeroed out
                    oli.Custom_Price__c= (qty != 0 ? price/qty : 0); //using in place of ListPrice, when the opp is updated the prices aren't zeroed out
                    //oli.Pricing_Type__c='Test';
                    //oli.Custom_Price__c=Double.valueof(m.get('ListPrice'));       
                    oli.Discount_Value__c = Decimal.valueof(m.get('DiscPct'));
                    oli.Discount_Type__c = 'Percent';
                    oli.CPQ_Current_Opportunity_ID__c = OpportunityId;
                    oli.CPQ_NetPrice__c = Double.valueof(m.get('NetPriceCC'));
                    oli.CPQ_Previous_Opportunity__c = m.get('bpPrevOppId');
                    oli.CPQ_Product_Status__c = m.get('ProductStatus');
                    oli.CPQ_isService_Product__c = Boolean.valueOf(m.get('isService'));
                    oli.CPQ_Product_Start_Date__c = parseDate(m.get('ContractStartDateHidden'));
                    
                    // TP:12701( Cameleon has to assure to pass this value on correct place)
                    Double DataStroage=0.0;
                    try{DataStroage=Double.valueof(m.get('Data_Storage_Quantity__c'));}catch(Exception e){DataStroage=0.0;}
                    oli.Data_Storage_Quantity__c=DataStroage;
                    
                    //Requested BY Anjan,
                    
                    
                    Double prevPrice =0.0;
                    try{prevPrice=Double.valueof(m.get('bpPrevPrice'));}catch(Exception e){prevPrice=0.0;}
                    
                    oli.CPQ_Previous_Year_Net_Price__c=(prevPrice==null ? 0.0 : prevPrice);
                    Boolean conlengChg=false;
                    try{conlengChg=Boolean.valueOf(m.get('bpConLenChg'));}catch(Exception e){conlengChg=false;}
                    oli.CPQ_Contract_Extended__c =conlengChg;
                    
                    
                    //updated for bug 506, calculating dates once at start to pass in 
                    //Date startDate = parseDate(m.get('ContractStartDateHidden'));
                    //Date endDate = (Double.valueof(m.get('ContractLengthHidden')) < 24 ? parseDate(m.get('ContractEndDateHidden')) : startDate + 364);

                    //oli.CPQ_Product_End_Date__c = endDate.addDays(-1);
                    oli.CPQ_Product_End_Date__c = endDate;
                    oli.CPQ_User_Band__c = m.get('Band');
                    oli.CPQ_Integrated_System__c = m.get('Integration');
                    oli.CPQ_isCoreItem__c=Boolean.valueOf(m.get('isCore'));
                    oli.CPQ_isRenewable__c = Boolean.valueOf(m.get('Renewable'));
                    oli.CPQ_Package_Id__c =m.get('ParentPackage');
                    oli.Renewal_Unique_Line_ID__c = m.get('UID');
                    // Added By Nikhil As per TP:11629
                    oli.Product_Instance__c=m.get('Product_Instance__c');
                    
                    //Requested by Anjan(Start)
                    Double userQuantity =0.0;
                    try{userQuantity =Double.valueof(m.get('bpNumUsersRUC'));}catch(Exception e){userQuantity=0.0;}
                    oli.User_Quantity__c =userQuantity;
                    
                    Double PriceType=0.0;
                    try{PriceType=Double.valueof(m.get('bpPricingStrategy'));}catch(Exception e){PriceType=0.0;}
                    oli.Price_Type__c= PriceType;
                   //oli.User_Band__c =m.get('bpBand');
                    
                    //END Anajn
                    Integer daysBetween = oli.CPQ_Product_Start_Date__c.daysBetween(oli.CPQ_Product_End_Date__c);
                    System.debug(LoggingLevel.DEBUG,'**CPQQuote for 1 year annualization ' + daysBetween + ' start ' + oli.CPQ_Product_Start_Date__c + ' end ' + oli.CPQ_Product_End_Date__c);
                    
                    /*if(daysBetween >= 365){
                        daysBetween = 364;
                    }*/
                    if(Boolean.valueOf(m.get('Renewable'))){
                        oli.CPQ_Annualized_Product_Amount__c = (oli.CPQ_NetPrice__c / (daysBetween + 1)) * 365;
                        
                    }else{
                        oli.CPQ_Annualized_Product_Amount__c=0;
                    }
                    
                    // Added by Nikhil TP:12707( for Adjustment , Needs to be update in existing Asset)
                    if(m.get('bpSiteReference')!=Null && m.get('bpSiteReference')!='' && (m.get('bpSiteReference').length()==15 || m.get('bpSiteReference').length()==18) && m.get('bpSiteReference').Startswith('02'))
                    {
                        oli.Adjustment_Asset_id__c=m.get('bpSiteReference');
                        
                        Double TotalNetPriceAdjust =0.0;
                        try{TotalNetPriceAdjust =Double.valueof(m.get('bpTotalNewPrice'));}catch(Exception e){TotalNetPriceAdjust =0.0;}
                        oli.Total_Net_Price_Adjustment__c=TotalNetPriceAdjust;
                        
                        Double TotalQuantity =0.0;
                        try{TotalQuantity =Double.valueof(m.get('bpTotalUnitQty'));}catch(Exception e){TotalQuantity =0.0;}
                        oli.Total_Unit_Quantity__c=TotalQuantity;
                    }   
                    // New Approval Requirement
                    System.debug('====+==='+m.get('MarginPercentage'));
                    try{oli.Quote_Margin__c=Decimal.valueof(m.get('MarginPercentage'));}catch(Exception e){oli.Quote_Margin__c=0.0;}
                    try{oli.Quote_Margin_Differential__c=Decimal.valueof(m.get('MarginDifferential'));}catch(Exception e){oli.Quote_Margin_Differential__c=0.0;}
                    try{oli.Change_number_of_Users__c = m.get('QuantityChanged');}catch(Exception e){oli.Change_number_of_Users__c ='--None--';}
                    try{oli.CPQ_Product_Long_Description__c = m.get('Description');}catch(Exception e){}
                    return oli;
    }
    
    // Creation of the Cameleon Quote Line Item
    private CameleonQuoteLineItem__c createCameleonQuoteLineItem(Map<String,String> m, Id quoteId) {
                    
                    
                    CameleonQuoteLineItem__c cqli = new CameleonQuoteLineItem__c();
                    cqli.Cameleon_Quote__c = quoteId;
                    cqli.Name = m.get('ProductCode');
                    cqli.Description__c = m.get('Description');
                    cqli.NetYear1__c = Decimal.valueof(m.get('NetPriceCC'));
                    cqli.DiscountPctYear1__c = Decimal.valueof(m.get('DiscPct'));
                    cqli.HostedLocation__c = m.get('HostedLocation');
                    cqli.Parent_Item__c = m.get('ParentItem');
                    cqli.Platform__c = m.get('Platform');
                    cqli.CPQPackage__c=m.get('ParentPackage');
                    cqli.Product_Category__c = m.get('ProductCategory');
                    cqli.Product_Status__c = m.get('ProductStatus');
                    cqli.ProductRequiresApproval__c = Boolean.valueOf(m.get('ProductRequiresApproval'));
                    cqli.RequiresDiscountApproval__c = Boolean.valueOf(m.get('RequiresDiscountApproval'));
                    cqli.IsCoreItem__c = Boolean.valueOf(m.get('isCore'));
                    cqli.IsHosted__c = Boolean.valueOf(m.get('isHosted'));
                    cqli.Renewable__c = Boolean.valueOf(m.get('Renewable'));
                    cqli.Service__c = Boolean.valueOf(m.get('isService'));
                    cqli.UID__c= m.get('UID');
                    
                    //cqli.ServiceApproval__c = Boolean.valueOf(m.get('???'));
                    //cqli.IsEndOfLife__c = Boolean.valueOf(m.get('???'));
                    //cqli.Product_ID__c = "";
                    //cqli.PreviousOpp__c = "";
                    //cqli.PaymentTerms__c = "";
                    //cqli.ContractType__c = "";
                    //cqli.ExchangeRate__c = 0;
                    //cqli.CurrentOpp__c = "";
                
                    return cqli;
    }
    
// Update the Approval Flags Map
    private void updateApprovalMap(Map<String,String> m, Map<String,Boolean> approvalMap, String quoteStatus) {
        
              
                    if(quoteStatus.equalsIgnoreCase('SubmittedForApproval')){
                        
                        
                                String platform = m.get('Platform');
                                String Market =m.get('bpMarket');
                                System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr platform: ' + platform);
                                Boolean reqDisc = Boolean.valueOf(m.get('RequiresDiscountApproval')== null ? 'false' : m.get('RequiresDiscountApproval'));
                                Boolean reqTreas = Boolean.valueOf(m.get('RequiresTreasuryApproval')== null ? 'false' : m.get('RequiresTreasuryApproval'));
                                Boolean reqService = Boolean.valueOf(m.get('RequiresServiceApproval')== null ? 'false' : m.get('RequiresServiceApproval'));
                                Boolean reqProduct = Boolean.valueOf(m.get('ProductRequiresApproval')== null ? 'false' : m.get('ProductRequiresApproval'));
                                Boolean reqPerp = Boolean.valueOf(m.get('RequiresPerpetualApproval')== null ? 'false' : m.get('RequiresPerpetualApproval')); //for analytics 20% rule
                                Boolean isHosted = Boolean.valueOf(m.get('isHosted')== null ? 'false' : m.get('isHosted'));
                                Boolean isPerp =  Boolean.valueOf(m.get('isPerpetual')== null ? 'false' : m.get('isPerpetual'));
                                Boolean isService = Boolean.valueOf(m.get('isService')== null ? 'false' : m.get('isService'));
                                Boolean isTM = Boolean.valueOf(m.get('isTandM')== null ? 'false' : m.get('isTandM'));
                                Boolean LessThanYear = Boolean.valueOf(Double.valueof(m.get('ContractLengthHidden')) < 12);
                                
                                System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr disc approval: ' + reqDisc);
                                System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr treasury approval: ' + reqTreas);
                                System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr service approval: ' + reqService);
                                System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr product approval: ' + reqProduct);
                                System.debug(LoggingLevel.DEBUG,'**CPQQuoteMgr perp approval: ' + reqPerp);
                                              
                                /*            
                                if(platform.equals('Collaborate')){
                                        
                                        //needs discount approval
                                        if(!approvalMap.get('IsDiscountApproval')){ approvalMap.put('IsDiscountApproval',(reqDisc && !isService) || LessThanYear);}  //if item is not a service and needs discount approval
                                        if(!approvalMap.get('IsHostedApproval')){approvalMap.put('IsHostedApproval',isHosted);}                      //hosted items, not many for collab
                                        if(!approvalMap.get('IsPerpetualApproval')){approvalMap.put('IsPerpetualApproval',isPerp);}                  //perp items, only 1 for collab
                                        if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',(isService && reqDisc) || reqService || (isService && reqProduct));}      //if item requires service approval based on config or a service is discounted service approval needed
                                        if(!approvalMap.get('IsSpecificProductApproval')){ approvalMap.put('IsSpecificProductApproval',(reqProduct && !isService));}  //product is flagged for approval and not a service
                                        if(!approvalMap.get('IsTMApproval')) {approvalMap.put('IsTMApproval',isTM);}                                                //product is T&M - not really for collab
                                        if(!approvalMap.get('IsTreasuryApproval')) { approvalMap.put('IsTreasuryApproval',reqTreas);}                //product requires treasury approval
                                        
                                        //Added by Varghese for TP4942
                                    if(((reqDisc && !isService) || LessThanYear)==true && !approvalrouting.contains(platform+' Discount')){approvalrouting=approvalrouting+'\n'+platform+' Discount';}
                                    if(isHosted==true && !approvalrouting.contains(platform+' Hosted')){approvalrouting=approvalrouting+'\n'+platform+' Hosted';}
                                    if(isPerp==true && !approvalrouting.contains(platform+' Perpetual')){approvalrouting=approvalrouting+'\n'+platform+' Perpetual';}
                                    if(((isService && reqDisc) || reqService || (isService && reqProduct))==true && !approvalrouting.contains(platform+' Service')){approvalrouting=approvalrouting+'\n'+platform+' Service';}
                                    if((reqProduct && !isService)==true && !approvalrouting.contains(platform+' SpecificProduct')){approvalrouting=approvalrouting+'\n'+platform+' SpecificProduct';}
                                    if(isTM==true && !approvalrouting.contains(platform+' TMApproval')){approvalrouting=approvalrouting+'\n'+platform+' TMApproval';}
                                    if(reqTreas==true && !approvalrouting.contains(platform+' Treasury')){approvalrouting=approvalrouting+'\n'+platform+' Treasury';}
                                    //****TP4942change ends here*****
                                
                                }
                                if(platform.equals('Analytics')){
                                
                                        if(!approvalMap.get('IsDiscountApproval')){ approvalMap.put('IsDiscountApproval',(reqDisc && !isService));}  
                                        if(!approvalMap.get('IsHostedApproval')){approvalMap.put('IsHostedApproval',isHosted);}
                                        if(!approvalMap.get('IsPerpetualApproval')){approvalMap.put('IsPerpetualApproval',(isPerp && reqPerp));}
                                        if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',((isService && reqDisc) || reqService));}
                                        if(!approvalMap.get('IsSpecificProductApproval')){ approvalMap.put('IsSpecificProductApproval',(reqProduct && !isService));}
                                        if(!approvalMap.get('IsTMApproval')) {approvalMap.put('IsTMApproval',isTM);}
                                        if(!approvalMap.get('IsTreasuryApproval')) { approvalMap.put('IsTreasuryApproval',reqTreas);} 
                                        
                                        //Added by Varghese for TP4942
                                    if((reqDisc && !isService)==true && !approvalrouting.contains(platform+' Discount')){approvalrouting=approvalrouting+'\n'+platform+' Discount';}
                                    if(isHosted==true && !approvalrouting.contains(platform+' Hosted')){approvalrouting=approvalrouting+'\n'+platform+' Hosted';}
                                    if((isPerp && reqPerp)==true && !approvalrouting.contains(platform+' Perpetual')){approvalrouting=approvalrouting+'\n'+platform+' Perpetual';}
                                    if(((isService && reqDisc) || reqService) ==true && !approvalrouting.contains(platform+' Service')){approvalrouting=approvalrouting+'\n'+platform+' Service';}
                                    if((reqProduct && !isService)==true && !approvalrouting.contains(platform+' SpecificProduct')){approvalrouting=approvalrouting+'\n'+platform+' SpecificProduct';}
                                    if(isTM==true && !approvalrouting.contains(platform+' TMApproval')){approvalrouting=approvalrouting+'\n'+platform+' TMApproval';}
                                    if(reqTreas==true && !approvalrouting.contains(platform+' Treasury')){approvalrouting=approvalrouting+'\n'+platform+' Treasury';}
                                    //****TP4942change ends here*****
                                        
                                }
                                if(platform.equals('NetSpot')){
                                
                                        //needs discount approval
                                        if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',(isService && reqDisc) || reqService || (isService && reqProduct));}      //if item requires service approval based on config or a service is discounted service approval needed
                                        if(!approvalMap.get('IsDiscountApproval')){ approvalMap.put('IsDiscountApproval',(reqDisc && !isService) || LessThanYear);}  //if item is not a service and needs discount approval
                                        if(!approvalMap.get('IsSpecificProductApproval')){ approvalMap.put('IsSpecificProductApproval',(reqProduct && !isService));}  //product is flagged for approval and not a service
                                        if(!approvalMap.get('IsTreasuryApproval')) { approvalMap.put('IsTreasuryApproval',reqTreas);}                //product requires treasury approval
                                        
                                        
                                        //Added by Varghese for TP4942
                                    if(((isService && reqDisc) || reqService || (isService && reqProduct)) ==true && !approvalrouting.contains(platform+' Service')){approvalrouting=approvalrouting+'\n'+platform+' Service';}
                                    if(((reqDisc && !isService) || LessThanYear)==true && !approvalrouting.contains(platform+' Discount')){approvalrouting=approvalrouting+'\n'+platform+' Discount';}
                                    if((reqProduct && !isService)==true && !approvalrouting.contains(platform+' SpecificProduct')){approvalrouting=approvalrouting+'\n'+platform+' SpecificProduct';}
                                    if(reqTreas==true && !approvalrouting.contains(platform+' Treasury')){approvalrouting=approvalrouting+'\n'+platform+' Treasury';}
                                    //****TP4942change ends here*****
                                
                                }
                                        if(platform.equals('Learn')){
                                            //needs discount approval
                                            if(!approvalMap.get('IsDiscountApproval')){ approvalMap.put('IsDiscountApproval',(reqDisc && !isService && !isHosted) || LessThanYear);}  //if item is not a service, not hosted, and needs discount approval
                                            if(!approvalMap.get('IsHostedApproval')){approvalMap.put('IsHostedApproval',(isHosted && reqDisc));}                      //hosted items that require discount approval
                                            if(!approvalMap.get('IsPerpetualApproval')){approvalMap.put('IsPerpetualApproval',(isPerp));}
                                            if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',(isService && reqDisc) || (isService && reqProduct));}      //if item requires service approval based on config or a service is discounted service approval needed
                                            if(!approvalMap.get('IsSpecificProductApproval')){ approvalMap.put('IsSpecificProductApproval',(reqProduct && !isService));}  //product is flagged for approval and not a service
                                            if(!approvalMap.get('IsTMApproval')) {approvalMap.put('IsTMApproval',isTM);}                                                //product is T&M - not really for collab
                                            if(!approvalMap.get('IsTreasuryApproval')) { approvalMap.put('IsTreasuryApproval',reqTreas);}                //product requires treasury approval
                                            
                                             //Added by Varghese for TP4942
                                      if(((reqDisc && !isService && !isHosted) || LessThanYear)==true && !approvalrouting.contains(platform+' Discount')){approvalrouting=approvalrouting+'\n'+platform+' Discount';}
                                      if((isHosted && reqDisc)==true && !approvalrouting.contains(platform+' Hosted')){approvalrouting=approvalrouting+'\n'+platform+' Hosted';}
                                      if(isPerp==true && !approvalrouting.contains(platform+' Perpetual')){approvalrouting=approvalrouting+'\n'+platform+' Perpetual';}
                                      if(((isService && reqDisc) || (isService && reqProduct))==true && !approvalrouting.contains(platform+' Service')){approvalrouting=approvalrouting+'\n'+platform+' Service';}
                                      if((reqProduct && !isService)==true && !approvalrouting.contains(platform+' SpecificProduct')){approvalrouting=approvalrouting+'\n'+platform+' SpecificProduct';}
                                      if(isTM==true && !approvalrouting.contains(platform+' TMApproval')){approvalrouting=approvalrouting+'\n'+platform+' TMApproval';}
                                      if(reqTreas==true && !approvalrouting.contains(platform+' Treasury')){approvalrouting=approvalrouting+'\n'+platform+' Treasury';}
                                      //****TP4942change ends here*****
                                        
                                        }
                                        if(platform.equals('Mobile')){
                                            //needs discount approval
                                            if(!approvalMap.get('IsDiscountApproval')){ approvalMap.put('IsDiscountApproval',(reqDisc && !isService && !isHosted) || LessThanYear);}  //if item is not a service, not hosted, and needs discount approval
                                            if(!approvalMap.get('IsHostedApproval')){approvalMap.put('IsHostedApproval',(isHosted && reqDisc));}                      //hosted items that require discount approval
                                            if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',(isService && reqDisc) || (isService && reqProduct));}      //if item requires service approval based on config or a service is discounted service approval needed
                                            if(!approvalMap.get('IsSpecificProductApproval')){ approvalMap.put('IsSpecificProductApproval',(reqProduct && !isService));}  //product is flagged for approval and not a service
                                            if(!approvalMap.get('IsTMApproval')) {approvalMap.put('IsTMApproval',isTM);}                                                //product is T&M - not really for collab
                                            if(!approvalMap.get('IsTreasuryApproval')) { approvalMap.put('IsTreasuryApproval',reqTreas);}                //product requires treasury approval
                                            
                                             //Added by Varghese for TP4942
                                      if(((reqDisc && !isService && !isHosted) || LessThanYear)==true && !approvalrouting.contains(platform+' Discount')){approvalrouting=approvalrouting+'\n'+platform+' Discount';}
                                      if((isHosted && reqDisc)==true && !approvalrouting.contains(platform+' Hosted')){approvalrouting=approvalrouting+'\n'+platform+' Hosted';}
                                      if(((isService && reqDisc) || (isService && reqProduct))==true && !approvalrouting.contains(platform+' Service')){approvalrouting=approvalrouting+'\n'+platform+' Service';}
                                      if((reqProduct && !isService)==true && !approvalrouting.contains(platform+' SpecificProduct')){approvalrouting=approvalrouting+'\n'+platform+' SpecificProduct';}
                                      if(isTM==true && !approvalrouting.contains(platform+' TMApproval')){approvalrouting=approvalrouting+'\n'+platform+' TMApproval';}
                                      if(reqTreas==true && !approvalrouting.contains(platform+' Treasury')){approvalrouting=approvalrouting+'\n'+platform+' Treasury';}
                                      //****TP4942change ends here*****
                                        
                                        }
                                
                               // Below was commneted
                                /*if(Boolean.valueOf(m.get('RequiresDiscountApproval')) && !approvalMap.get('IsDiscountApproval')){approvalMap.put('IsDiscountApproval',true);}
                                if(Boolean.valueOf(m.get('isHosted')) && !approvalMap.get('IsHostedApproval')){approvalMap.put('IsHostedApproval',true);}
                                if(Boolean.valueOf(m.get('isPerpetual')) && !approvalMap.get('IsPerpetualApproval')){approvalMap.put('IsPerpetualApproval',true);}
                                if((m.get('Platform').equalsIgnoreCase('Netspot') || Boolean.valueOf(m.get('isService'))) && !approvalMap.get('IsServiceApproval')){;}
                                if(Boolean.valueOf(m.get('ProductRequiresApproval')) && !approvalMap.get('IsSpecificProductApproval')){approvalMap.put('IsSpecificProductApproval',true);}
                                if(Boolean.valueOf(m.get('isTandM')) && !approvalMap.get('IsTMApproval')){approvalMap.put('IsTMApproval',true);}
                                if(Boolean.valueOf(m.get('RequiresTreasuryApproval')) && !approvalMap.get('IsTreasuryApproval')){approvalMap.put('IsTreasuryApproval',true);}
                    } */
                //  if(Market.equals('K12') || Market.equals('HE') || Market.equals('Pro. Ed.')){
                   if(!platform.equals('Education Services') &&!platform.equals('MyEdu') && !platform.equals('Student Services'))
                  {
                  
                        if(!approvalMap.get('IsDiscountApproval')){ approvalMap.put('IsDiscountApproval',(reqDisc && !isService) || LessThanYear);}  
                        if(!approvalMap.get('IsHostedApproval')){approvalMap.put('IsHostedApproval',isHosted);}
                        if(!approvalMap.get('IsPerpetualApproval')){approvalMap.put('IsPerpetualApproval',(isPerp && reqPerp));}
                        //Below is commneted by Nikhil
                       //if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',((isService && reqDisc) || reqService));}
                        if(!approvalMap.get('IsServiceApproval')) {approvalMap.put('IsServiceApproval',(isService || reqService));}
                        if(!approvalMap.get('IsSpecificProductApproval')){ approvalMap.put('IsSpecificProductApproval',(reqProduct && !isService));}
                        if(!approvalMap.get('IsTMApproval')) {approvalMap.put('IsTMApproval',isTM);}
                        if(!approvalMap.get('IsTreasuryApproval')) { approvalMap.put('IsTreasuryApproval',reqTreas);} 
                        
                            //Added by Varghese for TP4942
                        if((reqDisc && !isService)==true && !approvalrouting.contains(platform+' Discount')){approvalrouting=approvalrouting+'\n'+platform+' Discount';}
                        if(isHosted==true && !approvalrouting.contains(platform+' Hosted')){approvalrouting=approvalrouting+'\n'+platform+' Hosted';}
                        if((isPerp && reqPerp)==true && !approvalrouting.contains(platform+' Perpetual')){approvalrouting=approvalrouting+'\n'+platform+' Perpetual';}
                        if(((isService && reqDisc) || reqService) ==true && !approvalrouting.contains(platform+' Service')){approvalrouting=approvalrouting+'\n'+platform+' Service';}
                        if((reqProduct && !isService)==true && !approvalrouting.contains(platform+' SpecificProduct')){approvalrouting=approvalrouting+'\n'+platform+' SpecificProduct';}
                        if(isTM==true && !approvalrouting.contains(platform+' TMApproval')){approvalrouting=approvalrouting+'\n'+platform+' TMApproval';}
                        if(reqTreas==true && !approvalrouting.contains(platform+' Treasury')){approvalrouting=approvalrouting+'\n'+platform+' Treasury';}
                        //****TP4942change ends here*****
                    }                    
                // }   
         }
    }

    // Return True if the line needs to be inserted in an Opportunity Line Items and a Cameleon Quote Line Items
    private Boolean addTest(Map<String,String> m, Integer year){
        Boolean test = Boolean.valueOf(m.get('isSFDC'))
            && !Boolean.valueOf(m.get('isPackage'))
            && getYear(m) == year;
        return test;
    }
    
    // Return the value of the column 'year' from the line
    private Integer getYear(Map<String,String> m){
        Integer year = 0;
        if(m.get('year') != ''){
            year = Integer.valueof(m.get('year'));
        }
        return year;
    }
    
    // Update the 'RequiresDiscountApproval' flag of the Cameleon Quote Line Item if needed (for multi year)
    private void updateDiscountApproval(Map<String,CameleonQuoteLineItem__c> cqliMap, Map<String,String> m, String prodKey){
        
        if(!cqliMap.get(prodKey).RequiresDiscountApproval__c){
            
            cqliMap.get(prodKey).RequiresDiscountApproval__c = Boolean.valueOf(m.get('RequiresDiscountApproval'));
        
        }
    }
    
    private static Date parseDate(String dateString) {
        Date resultDate = null;
        if(dateString.length() == 8){
            Integer y = Integer.valueOf(dateString.substring(4, 8));
            Integer m = Integer.valueOf(dateString.substring(0, 2));
            Integer d = Integer.valueOf(dateString.substring(2, 4));
            resultDate = Date.newinstance(y, m, d);
        }
        return resultDate;
    }           
}