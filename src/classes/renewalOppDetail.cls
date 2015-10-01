public class renewalOppDetail {

public String paramstring { get; set; }
public String paramstringname { get; set; }

public PageReference ActionFunctionMethod() {

system.debug('###'+paramstring);
system.debug('###'+paramstringname);

    return null;
}


 
public string OppId {get;set;}
public opportunity oppvalue {get;set;}
public list< HppFieldValueStorage__c > hppvalueslist {get;set;}
//public string accountname {get;set;}
//public string pscompanyId {get;set;}
public list<Opportunitylineitem> oppplineList {get;set;}
//public list<Opportunity> oppList {get;set;}
//public Id oppAccountId {get;set;}
public boolean isChecked {get;set;}
//public list<Opportunitylineitem> oppline {get;set;}
public boolean isDisabled {get;set;}
public list<cOppLineList> oppLineItemList {get;set;}
public Map<String, Decimal> HPPoppLineItemList {get;set;}
//public boolean rbuttonvalue {get;set;}
public Opportunity opp{get;set;}
public list<cOppLineList> selectedOppLineList {get;set;}  
public string isPaymentTypeSelected {get;set;}
public boolean ischeckboxselected {get;set;}
GlobalComponent gc = new GlobalComponent();
public List<User> u {get;set;}
//public Double TotalOLIValue {get;set;}
public Decimal TotalOLIValue {get;set;}

public Double TotalTaxValue {get;set;}
//public Double TotalValue {get;set;}
public Decimal TotalValue {get;set;}
public decimal TotalTaxIntValue {get;set;}
public boolean doShow {get;set;}
public integer latefeevalue {get;set;}
public string latevaluestring {get;set;}
public Datetime latefeedatetime {get;set;}
public boolean doShowLatefee {get;set;}
public string errorString {get;set;}
public boolean latefeecheckbox {get;set;}

// string declared due to visibility issues
public string oppaccname {get;set;}
public string latevalueemailstring {get;set;}
public string oppaccpscompanyid {get;set;}
public string oppaccountbillingstreet {get;set;}
public string oppaccountbillingcity {get;set;}
public string oppaccountbiillingstate {get;set;}
public string oppaccountbillingpostalcode {get;set;}
public string oppaccountbillingcountry {get;set;}
public Integer currentyear;
public String currentDate{get;set;}
public integer suminstances {get;set;}
public list<OpportunityLineItem> oliList {get;set;}
public string getBodyvalue {get;set;}
public string redirectURL {get;set;}
public string oderidstring {get;set;}
public string errormessage {get;set;}
public list<string> selectedopplinelistname {get;set;}
public list<string> selectedopplineprice {get;set;}
public list<string> droppedlist {get;set;}
public list<attachment> att {get;set;}
public string oppaccountfax {get;set;}
public Id OppIdvalue {get;set;}

public string Hppendpoint {get;set;}
public string header_logo_url {get;set;}
public string footer_logo_url {get;set;}
public string return_url {get;set;}
public string style_url {get;set;}
public string notofication_url   {get;set;}
public string Vertex_Username {get;set;}
public string Vertex_Password {get;set;}
public string Hppusername {get;set;}
public string Hpppassword {get;set;}
public string Hppmode {get;set;}
public string trantype {get;set;}
public list<Contact> contactList {get;set;}
public set<string> emailIds {get;set;}
public boolean doAllowUser {get;set;}


public list<Opportunity> opp2Dropupdatelist {get;set;}
public list<Opportunity> opp2Dropupdatelist1 {get;set;}



public renewalOppDetail(){


BBDN_Values__c values = BBDN_Values__c.getInstance('HPP_End_Point');
BBDN_Values__c valuesa = BBDN_Values__c.getInstance('header_logo_url');
BBDN_Values__c valuesb = BBDN_Values__c.getInstance('footer_logo_url');
BBDN_Values__c valuesc = BBDN_Values__c.getInstance('return_url');
BBDN_Values__c valuesd = BBDN_Values__c.getInstance('style_url');
BBDN_Values__c valuese = BBDN_Values__c.getInstance('notofication_url');
BBDN_Values__c valuesf = BBDN_Values__c.getInstance('Vertex_Username');
BBDN_Values__c valuesg = BBDN_Values__c.getInstance('Vertex_Password');
BBDN_Values__c valuesh = BBDN_Values__c.getInstance('Hpp_Username');
BBDN_Values__c valuesi = BBDN_Values__c.getInstance('Hpp_Password');
BBDN_Values__c valuesj = BBDN_Values__c.getInstance('Hpp_Mode');
BBDN_Values__c valuesk = BBDN_Values__c.getInstance('tran_type');
system.debug('###'+values.HPP_End_Point__c);
system.debug('###'+values.header_logo_url__c);

Hppendpoint = values.HPP_End_Point__c;
Hppusername = values.Hpp_Username__c;
Hpppassword = values.Hpp_Password__c;
header_logo_url = values.header_logo_url__c;
footer_logo_url = values.footer_logo_url__c;
return_url = values.return_url__c;
style_url = values.style_url__c;
notofication_url = values.notofication_url__c;
Vertex_Username = values.Vertex_Username__c;
Vertex_Password = values.Vertex_Password__c;
Hppmode = values.Hpp_Mode__c;
trantype = values.tran_type__c;


oliList = new list<OpportunityLineItem>();
suminstances = 0;
latefeevalue = 0;
isPaymentTypeSelected = null;
latefeecheckbox = true;
//latefeedatetime =    //need to set this time
currentyear =  system.today().year();
latefeedatetime = date.parse('04/15/'+currentyear);
system.debug('...'+latefeedatetime);

if(system.today() >= latefeedatetime){ 
    doShowLatefee = true;
    latefeevalue = 250;
}

Datetime myDT = Datetime.now(); 
currentDate = myDT.format();

u = new List<User>([select ID, NAme, ContactID, Contact.Email from USer where ID =: Userinfo.getUserID()]);
system.debug('THE USER IS'+u[0].Name + 'and the email is' +u[0].Contact.Email);

OppId = ApexPages.currentPage().getParameters().get('id');
system.debug('OPPID IS'+OppId);

oderidstring = OppId + '_' + system.currentTimeMillis();

opp = [Select id, AccountId, Account.Fax, Account.BillingStreet, BbDN_Renewal_Processed__c, Account.BillingCity, Account.BillingState, Account.BillingCountry,
                   Account.BillingPostalCode, latefeevalue__c, Account.Name, Account.PS_Company_Id__c, Name from Opportunity Where Id =: OppId];
                   
emailIds = new set<String>();
contactList = [Select id, Name, Email from Contact Where AccountId =: opp.AccountId ]; 

system.debug('###'+contactList);

for(contact c: contactList){
emailIds.add(c.Email);
}
system.debug('$$$'+emailIds);

if(emailIds.contains(u[0].Contact.Email)){

     doAllowUser = true;   
     system.debug('Value of doAllowUser is'+doAllowUser);
}
else{
     doAllowUser = false;
     system.debug('Value of doAllowUser is'+doAllowUser);
}
                 
                   
                   
system.debug('Opp Value IS'+Opp); 
system.debug('TESTING 234'+ opp.BbDN_Renewal_Processed__c );
if(opp.BbDN_Renewal_Processed__c == false){
    doShow = true;
    system.debug('TESTING 123'+doShow);

} 


oppaccname = opp.Account.name; 
latevalueemailstring = opp.latefeevalue__c;
oppaccpscompanyid = opp.Account.PS_Company_Id__c; 
oppaccountbillingstreet = opp.Account.BillingStreet;
oppaccountbillingcity = opp.Account.BillingCity;
oppaccountbiillingstate = opp.Account.BillingState;
oppaccountbillingpostalcode = opp.Account.BillingPostalCode;
oppaccountbillingcountry = opp.Account.BillingCountry;
oppaccountfax = opp.Account.Fax;


                
                   
/*accountname = opp.Account.Name;
oppAccountId = opp.AccountId;
pscompanyId = opp.Account.PS_Company_Id__c;
oppList = [Select id, Name, Amount, Start_Date__c, End_Date__c  from Opportunity Where AccountId =: oppAccountId]; */
//oppplineList = [Select id, UnitPrice, PS_Product_ID__c, Product2Id, Product2.Name, OpportunityId, Opportunity.Start_Date__c, Opportunity.End_Date__c, Opportunity.Name, Opportunity.Amount from Opportunitylineitem Where OpportunityId =: OppId];
 system.debug('...........'+oppLineItemList);
loadOpplines();
 system.debug('...........'+oppLineItemList);





}

public void loadOpplines(){
oppLineItemList  = new list<cOppLineList>();
HPPoppLineItemList  = new Map<String, Decimal>();
oppplineList = [Select id,Name,UnitPrice,TotalPrice,PS_Product_ID__c, Product2Id, Product2.Name, OpportunityId, isRenewable_BbDN__c, Opportunity.Start_Date__c, Opportunity.End_Date__c, Opportunity.Name, Opportunity.Amount from Opportunitylineitem Where OpportunityId =: OppId];

if(oppplineList != null){
    
    for(Opportunitylineitem oli: oppplineList){
    
        
    
        if((oli.PS_Product_ID__c == 'AS-BDDEVPKG')||((oli.PS_Product_ID__c == 'AS-CDDEV') && (oli.TotalPrice == 0))){
           oppLineItemList.add(new cOppLineList(oli,'Renew',true, oli.UnitPrice.setscale(2), oli.Product2.Name, oli.Opportunity.Start_Date__c, oli.Opportunity.End_Date__c)) ;
            
           
        }
        else
        {
          oppLineItemList.add(new cOppLineList(oli,'Renew',false, oli.UnitPrice.setscale(2), oli.Product2.Name, oli.Opportunity.Start_Date__c, oli.Opportunity.End_Date__c)) ;
        }
        
        
        
    }

}


}

public class cOppLineList {

 public OpportunityLineItem oli{get;set;}
 public String Selected {get;set;}
 public Boolean Disabled {get;set;}
 public Decimal wunitprice {get;set;}
 public string wproduct2name {get;set;}
 public date wstartdate {get;set;}
 public date wenddate {get;set;}
 
  
 
 public cOpplineList(OpportunityLineItem o,String isSelected,Boolean isDisabled, Decimal unitPricevalue, string product2Name, date startdate, date enddate){
     oli = o;
     Selected = isSelected;
     Disabled = isDisabled;
     
     wunitprice = unitPricevalue;
     wproduct2name = product2Name;
     wstartdate = startdate;
     wenddate = enddate;
  }
}

public pagereference renew(){

  selectedopplinelistname = new list<String>();
  selectedopplineprice = new list<string>();
  droppedlist = new list<string>();
  opp2Dropupdatelist = new list<Opportunity>();
  opp2Dropupdatelist1 = new list<Opportunity>();
  system.debug('...........'+oppLineItemList);
  system.debug('$$$$$$$');
   
       
        for(cOppLineList cOLI:oppLineItemList)
        {           
           if(cOLI.Selected == 'Renew') 
            {                       
              oliList.add(cOLI.oli);
              selectedopplinelistname.add(cOLI.wproduct2name);
              selectedopplineprice.add(cOLI.wproduct2name + ' - '+'$'+ string.valueof(cOLI.wunitprice));
              //HPPoppLineItemList.add(new cOppLineList(cOLI.oli,'Renew',true, cOLI.oli.UnitPrice.setscale(2), cOLI.oli.Product2.Name, cOLI.oli.Opportunity.Start_Date__c, cOLI.oli.Opportunity.End_Date__c)) ;
              //HPPoppLineItemList.put(cOLI.oli.Product2.Name,cOLI.oli.UnitPrice.setscale(2)); 
              
              suminstances = suminstances +1;
            } 
            
            //if(cOLI.Selected == 'Drop'){
                //droppedlist.add(cOLI.wproduct2name + ' - '+'$'+ string.valueof(cOLI.wunitprice) + ' - (Dropped)');
                //Opportunity opp2Dropupdate = new Opportunity();
                //opp2Dropupdate.Id= OppId;
                //opp2Dropupdate.Sec_Oli_Dropped_Values__c = ''+droppedlist;
                //update opp2Dropupdate;
                
                
            //}                         
         }       
   system.debug('$$$$$$$'+ oliList); 
   system.debug('&&&'+selectedopplinelistname); 
    system.debug('&&&^^^'+selectedopplineprice);   
   system.debug('MMMMM'+HPPoppLineItemList);  
        
        
 // list<Opportunitylineitem> oppplineList = [Select id,UnitPrice,TotalPrice,PS_Product_ID__c, OpportunityId, Opportunity.Start_Date__c, Opportunity.End_Date__c, Opportunity.Name, Opportunity.Amount from Opportunitylineitem Where OpportunityId =: '0067000000YpjkG'];
VertexQWsdl.WS_ProviderPort stub = new VertexQWsdl.WS_ProviderPort();
VertexQRequest.Login_element cv = new VertexQRequest.Login_element();
//cv.UserName = 'bbapi';
//cv.Password = 'An0nymou$';
cv.UserName = Vertex_Username;
cv.Password = Vertex_Password;
VertexQRequest.QuotationRequest_element qe = new VertexQRequest.QuotationRequest_element();
qe.documentDate = system.today();
qe.transactionType = 'SALE';
VertexQRequest.Seller_element se = new VertexQRequest.Seller_element();
se.Company = opp.Account.Name;
se.Division = '10000';
qe.Seller = se;
VertexQRequest.Customer_element  ce = new VertexQRequest.Customer_element();
VertexQRequest.Destination_element  de = new VertexQRequest.Destination_element();
VertexQRequest.CustomerCode_element  cce = new VertexQRequest.CustomerCode_element();
cce.CustomerCodeValue = opp.Account.PS_Company_Id__c;
de.PostalCode = opp.Account.BillingPostalCode;
de.Country = opp.Account.BillingCountry;
ce.Destination = de;
ce.CustomerCode = cce;
qe.Customer = ce;
 
//list<VertexQRequest.LineItem_element> le = new list<VertexQRequest.LineItem_element>();
//Integer Size = oppplineList.size();
 Integer Size = oliList.size();
//VertexQRequest.LineItem_element[] le = new list<VertexQRequest.LineItem_element>();
 
List<VertexQRequest.LineItem_element> le = new VertexQRequest.LineItem_element[Size];
TotalOLIValue = 0;
TotalValue = 0; 
TotalTaxValue = 0;
for(Integer i=0 ;i< Size;i++){
le[i] = new VertexQRequest.LineItem_element();
le[i].lineItemNumber = i +1;
le[i].lineItemId = oliList[i].Id;
VertexQRequest.ExtendedPrice_element ee = new VertexQRequest.ExtendedPrice_element();
ee.ExtendedPriceValue = Integer.valueOf(oliList[i].UnitPrice);
VertexQRequest.Product_element  pe = new VertexQRequest.Product_element();
pe.productClass = 'SOFTWARE';
pe.productValue = oppplineList[i].Product2.Name;
le[i].ExtendedPrice = ee;
le[i].Product = pe;
TotalOLIValue =  TotalOLIValue.setscale(2) + oliList[i].UnitPrice.setscale(2);
}
qe.LineItem = le;
VertexQRequest.QuotationResponse_element  qr = new VertexQRequest.QuotationResponse_element();
system.debug('$$$$$$'+ cv);
system.debug('$$$$$$'+ qe);
VertexQResponse.VertexEnvelope_element ve = stub.WS_Provider(cv,qe,qr);
Integer vqrSize = ve.QuotationResponse.lineitem.size();
system.debug('.....'+ vqrSize);
//List []  vqrL= ve.QuotationResponse.lineitem;

for(Integer i=0 ;i< vqrSize;i++){
system.debug('.....Line Item Number '+ ve.QuotationResponse.lineitem[i].lineItemNumber);
system.debug('.....Line Item Id '+ ve.QuotationResponse.lineitem[i].lineItemId);
system.debug('....Tax Value '+ ve.QuotationResponse.lineitem[i].TotalTax.TotalTaxValue);
system.debug('....Tax TAX '+ ve.QuotationResponse.lineitem[i].TotalTax);
TotalTaxValue = TotalTaxValue  + ve.QuotationResponse.lineitem[i].TotalTax.TotalTaxValue;
TotalTaxIntValue = TotalTaxValue;
TotalTaxIntValue = TotalTaxIntValue.setscale(2);
}

TotalValue = TotalTaxValue + TotalOLIValue + latefeevalue;
TotalValue = TotalValue.setscale(2);
system.debug('TOTAL $'+TotalValue);
  //return new pagereference('/apex/RenewalConfirmationPage').setredirect(false);
  
  
  
       //inseting Hpp records
       
       list<HppFieldValueStorage__c> hppfieldvaluelist = [Select id from HppFieldValueStorage__c Where Opportunity__c =: OppId];
       
       if(hppfieldvaluelist.size() >0){
           delete hppfieldvaluelist;
       
       }
       Opportunity opp2Dropupdate = new Opportunity();
        for(cOppLineList cOLI:oppLineItemList)
        {           
           if(cOLI.Selected == 'Renew') 
            {                       
              
              
              //HPPoppLineItemList.add(new cOppLineList(cOLI.oli,'Renew',true, cOLI.oli.UnitPrice.setscale(2), cOLI.oli.Product2.Name, cOLI.oli.Opportunity.Start_Date__c, cOLI.oli.Opportunity.End_Date__c)) ;
              //HPPoppLineItemList.put(cOLI.oli.Product2.Name,cOLI.oli.UnitPrice.setscale(2)); 
              HppFieldValueStorage__c hpp = new HppFieldValueStorage__c();
              hpp.Name = cOLI.oli.Product2.Name;
              //hpp.Unit_Price__c = string.valueof(cOLI.oli.UnitPrice.setscale(2));
              string val = string.valueof(cOLI.oli.UnitPrice.setscale(2));
              hpp.Unit_Price__c = val.replace('.', '');
              
             
              
              hpp.Opportunity__c = OppId;
              insert hpp;
              //suminstances = suminstances +1;
              
              //Opportunity opp2Dropupdate = new Opportunity();
              opp2Dropupdate.Id= OppId;
              opp2Dropupdate.latefeevalue__c = '$'+string.valueof(latefeevalue) ;
              System.debug('Count===Count');
              //opp2Dropupdatelist.add(opp2Dropupdate);
              //update opp2Dropupdate;
            }
           
           if(cOLI.Selected == 'Drop'){
                droppedlist.add(cOLI.wproduct2name + ' - '+'$'+ string.valueof(cOLI.wunitprice) + ' - [Dropped]');
                //Opportunity opp2Dropupdate = new Opportunity();
                opp2Dropupdate.Id= OppId;
                opp2Dropupdate.Sec_Oli_Dropped_Values__c = ''+droppedlist;
                //opp2Dropupdatelist.add(opp2Dropupdate);
                
                
                
            }                           
         }  
         
         ///update opp2Dropupdatelist;
         ///update opp2Dropupdatelist1;
         update opp2Dropupdate;
         
         // end inserting     
       
       
       
       
       
       
       
       
       
        PageReference pageRef = new PageReference('/apex/RenewalConfirmationPage');
        pageRef.getParameters().put('OLIVALUES','$'+selectedopplinelistname);
        pageRef.getParameters().put('OLIPRICE','$'+selectedopplineprice);
        
        pageRef.setRedirect(false);
        return pageRef;

}


public List<SelectOption> getradioValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Renew','Renew'));
        options.add(new SelectOption('Drop','Drop'));
        return options;
    }

public list<cOppLineList> getSelectedOppLineItem()
   {
     selectedOppLineList = new list<cOppLineList>();     
        for(cOppLineList cOLI:oppLineItemList)
        {           
           if(cOLI.Selected == 'Renew') 
            {                       
              selectedOppLineList.add(cOLI);
              //suminstances = suminstances +1;
            }                          
         }       
        return selectedOppLineList;          
    } 

public PageReference exportToPDF()
    {
        PageReference pageRef = new PageReference('/apex/BbDN_ExportToPDF?Id='+OppId);
        //pageRef.getParameters().put('pfdsecvalues','$'+selectedopplinelistname);
        //pageRef.getParameters().put('noinstance','$'+suminstances);
        //pageRef.getParameters().put('pdftotalv','$'+TotalValue);
        //pageRef.setRedirect(true);
        return pageRef;
    }
    
 public PageReference exportToPrint()
    {
        PageReference pageRef = new PageReference('/apex/BbDN_Print?Id='+OppId);
        return pageRef;
    }


public PageReference submitrenewal()
    {
        
        system.debug('The TotalValue is: '+TotalValue);
        
        
        if(ischeckboxselected == true && TotalValue == 0.0 ){
        
            
            string cc;
            string wpo;
            string wopo;
            
             string olilistvalues = ApexPages.currentPage().getParameters().get('OLIVALUES');
             system.debug('olilistvalues are:'+olilistvalues);
             string hppolilistvalues = ApexPages.currentPage().getParameters().get('HPPOLIVALUES');
             string oliprice = ApexPages.currentPage().getParameters().get('OLIPRICE');

           
             cc= 'No';
            wpo= 'No';
            wopo='No';
            
            
            PageReference refr = Page.BbDN_ExportToPDF;
            refr.getParameters().put('Id',OppId);  
            Blob b = refr.getContentAsPDF();
        
        
         
            Attachment att=new Attachment();
            att.Body=b;
            att.Name='Argreement_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.pdf';
            att.parentId=OppId;
            insert att;
            
            
            PageReference pageRef = new PageReference('/apex/ThankYou?Id='+OppId);
            pageRef.getParameters().put('totlv', '$'+TotalValue);
            pageRef.getParameters().put('totloliv', '$'+TotalOLIValue);
            pageRef.getParameters().put('totltaxv', '$'+TotalTaxIntValue);
            pageRef.getParameters().put('secolivalues', olilistvalues);
            pageRef.getParameters().put('olipricelist', oliprice);
            pageRef.getParameters().put('ccvalue', cc);
            pageRef.getParameters().put('wpovalue', wpo);
            pageRef.getParameters().put('wopovalue', wopo);
            
            pageRef.setRedirect(true);
            return pageRef;
            
        
        
        }
        
        
        
        
        
        
        
        else if(ischeckboxselected == true){
           
        
        string olilistvalues = ApexPages.currentPage().getParameters().get('OLIVALUES');
        system.debug('olilistvalues are:'+olilistvalues);
        string hppolilistvalues = ApexPages.currentPage().getParameters().get('HPPOLIVALUES');
        string oliprice = ApexPages.currentPage().getParameters().get('OLIPRICE');
        
        PageReference refr = Page.BbDN_ExportToPDF;
        refr.getParameters().put('Id',OppId);  
        Blob b = refr.getContentAsPDF();
            
            

            
        
        
       Attachment att=new Attachment();
       att.Body=b;
       att.Name='Argreement_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.pdf';
       att.parentId=OppId;
       insert att;
         

        PageReference pageRef = new PageReference('/apex/PaymentOptions?Id='+OppId);
        pageRef.getParameters().put('totlv', '$'+TotalValue);
        pageRef.getParameters().put('totloliv', '$'+TotalOLIValue);
        pageRef.getParameters().put('totltaxv', '$'+TotalTaxIntValue);
        pageRef.getParameters().put('secolivalues', olilistvalues);
        pageRef.getParameters().put('olipricelist', oliprice);
        
        pageRef.setRedirect(true);
        return pageRef;
        
        
        
        
        
        
        }
        
        
        
        else{
            ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, 'ERROR : Please accept the terms of the agreement to proceed!');
            ApexPages.addMessage(msg);
            errormessage = 'ERROR : Please accept the terms of the agreement to proceed!';
        
        }
        
        return null;
        
    }



public List<SelectOption> getPaymentOptionsValues() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Credit Card','Credit Card'));
        options.add(new SelectOption('Invoice without a Purchase Order','Invoice without a Purchase Order. By selecting this option you agree to allow Blackboard to invoice you without a Purchase Order.'));
        options.add(new SelectOption('Invoice with a Purchase Order','Invoice with a Purchase Order. Email PO to BbPartnerRenewals@Blackboard.com'));
        
        return options;
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
    
    
public void testingwebservice(){

/*CastironVertexWSDL.WS_ProviderPort stub = new CastironVertexWSDL.WS_ProviderPort();

CastironVertexRequest.Login_element cv = new CastironVertexRequest.Login_element();
cv.UserName = 'bbapi';
cv.Password = 'An0nymou$';

CastironVertexRequest.QuotationRequest_element qe = new CastironVertexRequest.QuotationRequest_element();
CastironVertexRequest.Seller_element se = new CastironVertexRequest.Seller_element();
se.Company = 'SellerCode';
CastironVertexRequest.PhysicalOrigin_element pe = new CastironVertexRequest.PhysicalOrigin_element();
pe.Country = 'UNITED STATES';
se.PhysicalOrigin = pe;
qe.seller = se;

CastironVertexRequest.Customer_element ce = new CastironVertexRequest.Customer_element();

CastironVertexRequest.CustomerCode_element cce = new CastironVertexRequest.CustomerCode_element();
cce.classCode = 'BuyerClassCode';
ce.CustomerCode = cce;

CastironVertexRequest.Destination_element de = new CastironVertexRequest.Destination_element();
de.City = 'Berwyn';
de.MainDivision = 'PA';
de.SubDivision = 'Chester';
de.PostalCode = 19312;
de.Country = 'UNITED STATES';
ce.Destination = de;

qe.Customer = ce;

CastironVertexRequest.LineItem_element le = new CastironVertexRequest.LineItem_element();

CastironVertexRequest.Product_element pre = new CastironVertexRequest.Product_element();
pre.productClass = 'ProductClassCode';
le.Product = pre;
le.Quantity = 2.0;
le.Freight = '100';
le.UnitPrice = 1000.00;
le.lineItemNumber = '1';

qe.LineItem = le;

qe.documentDate = Date.newInstance( 2008, 7, 24 );
qe.documentNumber = 'QU-01';
qe.returnAssistedParametersIndicator = true;
qe.transactionType = 'SALE';

stub.WS_Provider(cv,qe); */

/*WCIVertexTaxWsdl.WS_ProviderPort stub = new WCIVertexTaxWsdl.WS_ProviderPort();
WCIVertexTaxRequest.Login_element cv = new WCIVertexTaxRequest.Login_element();
cv.UserName = 'bbapi';
cv.Password = 'An0nymou$';

WCIVertexTaxRequest.QuotationRequest_element qe = new WCIVertexTaxRequest.QuotationRequest_element();
WCIVertexTaxRequest.Seller_element se = new WCIVertexTaxRequest.Seller_element();
se.Company = 'SellerCode';
WCIVertexTaxRequest.PhysicalOrigin_element pe = new WCIVertexTaxRequest.PhysicalOrigin_element();
pe.Country = 'UNITED STATES';
se.PhysicalOrigin = pe;
qe.seller = se;
WCIVertexTaxRequest.Customer_element ce = new WCIVertexTaxRequest.Customer_element();
WCIVertexTaxRequest.CustomerCode_element cce = new WCIVertexTaxRequest.CustomerCode_element();
cce.classCode = 'BuyerClassCode';
ce.CustomerCode = cce;
WCIVertexTaxRequest.Destination_element de = new WCIVertexTaxRequest.Destination_element();
de.City = 'Berwyn';
de.MainDivision = 'PA';
de.SubDivision = 'Chester';
de.PostalCode = 19312;
de.Country = 'UNITED STATES';
ce.Destination = de;
qe.Customer = ce;
WCIVertexTaxRequest.LineItem_element le = new WCIVertexTaxRequest.LineItem_element();
WCIVertexTaxRequest.Product_element pre = new WCIVertexTaxRequest.Product_element();
pre.productClass = 'ProductClassCode';
le.Product = pre;
le.Quantity = 2.0;
le.Freight = 100;
le.UnitPrice = 1000.00;
le.lineItemNumber = 1;
qe.LineItem = le;
qe.documentDate = Date.newInstance( 2008, 7, 24 );
qe.documentNumber = 'QU-01';
qe.returnAssistedParametersIndicator = true;
qe.transactionType = 'SALE';
system.debug('===QR=====' + qe );
stub.WS_Provider(cv,qe);
system.debug('....'+stub.WS_Provider(cv,qe)); */

list<Opportunitylineitem> oppplineList = [Select id,UnitPrice,TotalPrice,PS_Product_ID__c, OpportunityId, Opportunity.Start_Date__c, Opportunity.End_Date__c, Opportunity.Name, Opportunity.Amount from Opportunitylineitem Where OpportunityId =: '0067000000YpjkG'];
VertexQWsdl.WS_ProviderPort stub = new VertexQWsdl.WS_ProviderPort();
VertexQRequest.Login_element cv = new VertexQRequest.Login_element();
cv.UserName = 'bbapi';
cv.Password = 'An0nymou$';
VertexQRequest.QuotationRequest_element qe = new VertexQRequest.QuotationRequest_element();
qe.documentDate = system.today();
qe.transactionType = 'SALE';
VertexQRequest.Seller_element se = new VertexQRequest.Seller_element();
se.Company = '00000';
se.Division = '10000';
qe.Seller = se;
VertexQRequest.Customer_element  ce = new VertexQRequest.Customer_element();
VertexQRequest.Destination_element  de = new VertexQRequest.Destination_element();
VertexQRequest.CustomerCode_element  cce = new VertexQRequest.CustomerCode_element();
cce.CustomerCodeValue = '447142';
de.PostalCode = '78249';
de.Country = 'USA';
ce.Destination = de;
ce.CustomerCode = cce;
qe.Customer = ce;
 
//list<VertexQRequest.LineItem_element> le = new list<VertexQRequest.LineItem_element>();
Integer Size = oppplineList.size();
//VertexQRequest.LineItem_element[] le = new list<VertexQRequest.LineItem_element>();
 
List<VertexQRequest.LineItem_element> le = new VertexQRequest.LineItem_element[Size];
 
for(Integer i=0 ;i< Size;i++){
le[i] = new VertexQRequest.LineItem_element();
le[i].lineItemNumber = i +1;
le[i].lineItemId = oppplineList[i].Id;
VertexQRequest.ExtendedPrice_element ee = new VertexQRequest.ExtendedPrice_element();
ee.ExtendedPriceValue = Integer.valueOf(oppplineList[i].UnitPrice);
VertexQRequest.Product_element  pe = new VertexQRequest.Product_element();
pe.productClass = 'SOFTWARE';
pe.productValue = 'Product';
le[i].ExtendedPrice = ee;
le[i].Product = pe;
 
}
qe.LineItem = le;
VertexQRequest.QuotationResponse_element  qr = new VertexQRequest.QuotationResponse_element();
system.debug('$$$$$$'+ cv);
system.debug('$$$$$$'+ qe);
VertexQResponse.VertexEnvelope_element ve = stub.WS_Provider(cv,qe,qr);
Integer vqrSize = ve.QuotationResponse.lineitem.size();
system.debug('.....'+ vqrSize);
//List []  vqrL= ve.QuotationResponse.lineitem;
for(Integer i=0 ;i< vqrSize;i++){
system.debug('.....Line Item Number '+ ve.QuotationResponse.lineitem[i].lineItemNumber);
system.debug('.....Line Item Id '+ ve.QuotationResponse.lineitem[i].lineItemId);
system.debug('....Tax Value '+ ve.QuotationResponse.lineitem[i].TotalTax.TotalTaxValue);
}

}

public void latefeelogic(){

Opportunity oppU = [Select id, Late_Fee_Override_Code__c from Opportunity Where id =:OppId]; 

if(oppU.Late_Fee_Override_Code__c == latevaluestring){
    latefeevalue = 0;
    latevaluestring='';
    errorString='';

}
else{
errorString = 'Wrong Override Code, Please try again!';
}

}

public pageReference doContinue(){


string cc;
string wpo;
string wopo;

if(isPaymentTypeSelected == 'Credit Card'){

         

//HTTP POST CODE FOR PAYMENT GATEAY INTEGRATION

        cc= 'Yes';
        wpo= 'No';
        wopo='No';
        
        string totalv = ApexPages.currentPage().getParameters().get('totlv');
        string totaloliv = ApexPages.currentPage().getParameters().get('totloliv');
        string totaltaxv = ApexPages.currentPage().getParameters().get('totltaxv');
        string secolivalues = ApexPages.currentPage().getParameters().get('secolivalues');
        string olipricelist = ApexPages.currentPage().getParameters().get('olipricelist');
        string hppsecolivalues = ApexPages.currentPage().getParameters().get('hppsecolivalues');
        id OpportunityID = ApexPages.currentPage().getParameters().get('Id');
        
      system.debug('The hppsecolivalues are:'+hppsecolivalues);  
      system.debug('The secolivalues are:'+secolivalues);
      /*string[] part;
      part = secolivalues.split('\\$');
      string parta;
      parta = part[1];
      string[] partb = parta.split('\\(');
      string partc = partb[1];
      string[] partd = partc.split('\\)');
      string parte = partd[0];
      system.debug('Value of PART E IS:'+parte);
      string partf = parte.replace(',', '<br>'); */
      
      string[] part1;
      part1 = olipricelist.split('\\(');
      string parta1;
      parta1 = part1[1];
      string[] partb1 = parta1.split('\\)');
      string partc1 = partb1[0];
      string partf1 = partc1.replace(',', '<br>');
      

       
        
        
        system.debug('The secolivalues are:'+secolivalues);
        
        system.debug('The totalv is:'+totalv);
        
        string totalvchange = totalv.replace('.', '');
        totalvchange = totalvchange.replace('$', '');
        
        system.debug('The totalv is:'+totalvchange);
        
        string totaltaxchange = totaltaxv.replace('.', '');
        totaltaxchange = totaltaxchange.replace('$', '');
        
        
        
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(Hppendpoint);
        //req.setEndpoint('https://testcapture.bbpaygate.com/PaymentPage/auth');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

       
        req.setHeader('Authorization','Basic '+EncodingUtil.base64Encode(Blob.valueOf('username:password')));       
        
        
        
        
      
        Map<String, String> stringMap = new Map<String, String>();
        //stringMap.put('header_logo_url','https://secure.blackboard.com/resources/PaymentGatewayHostCapture.png');
        //stringMap.put('header_logo_url','https://blackboard--qax.cs30.my.salesforce.com/resource/1423862963000/Hpplogo');
        //stringMap.put('footer_logo_url','https://blackboard--qax.cs30.my.salesforce.com/resource/1424643419000/HPPFooterLogo');
        
        //stringMap.put('header_logo_url','https://qax-blackboard.cs30.force.com/resource/1423862963000/Hpplogo');
        stringMap.put('header_logo_url',header_logo_url);
        
        //stringMap.put('footer_logo_url','https://qax-blackboard.cs30.force.com/resource/1424643419000/HPPFooterLogo');
        stringMap.put('footer_logo_url',footer_logo_url);
        
        //stringMap.put('return_url','https://qax-blackboard.cs30.force.com/apex/OrderStatus?id='+OppId +'/'+' totalv='+totalv+'/'+'totaloliv='+totaloliv+'/'+'totaltaxv='+totaltaxv+'/'+secolivalues);
        //stringMap.put('style_url','https://secure.blackboard.com/HostCapture/stylesheets/style.css');
        //stringMap.put('notification_url','https://secure.blackboard.com/opcat_hpp_notification/relay_to_sfdc.aspx');
        
        stringMap.put('return_url',return_url +'/apex/OrderStatus?id='+OppId +'/'+' totalv='+totalv+'/'+'totaloliv='+totaloliv+'/'+'totaltaxv='+totaltaxv+'/'+secolivalues);
        stringMap.put('style_url',style_url);
        stringMap.put('notification_url',notofication_url);
        
        stringMap.put('http_user_name','hppuser');
        //stringMap.put('http_user_password',EncodingUtil.urlEncode('hppu$er1', 'UTF-8'));
        stringMap.put('http_user_password','hppuser1');
        
        /*stringMap.put('user_id','TestAPI');
        stringMap.put('password','P@ssword12345');*/
        
        stringMap.put('user_id',Hppusername);
        stringMap.put('password',Hpppassword);
        
        stringMap.put('order_id','BBDN-'+oderidstring);
        //stringMap.put('mode','Y');
        stringMap.put('mode',Hppmode);
        stringMap.put('client_id','80953');
        stringMap.put('merchant_data','Tuition Payment');
        stringMap.put('receipt_txt','Thank you for your online tuition payment!');
        stringMap.put('header_text','Please review and enter your payment information below.');
        stringMap.put('tran_amount',totalvchange);
        stringMap.put('pipeline','Payment');
        stringMap.put('currency_cd','840');
       
        stringMap.put('billto_company',opp.Account.Name);
        
        stringMap.put('tran_type',trantype);
        stringMap.put('copyright_text','Copyright 1997-2015.');
        stringMap.put('powered_by_text','Blackboard Inc. All Rights Reserved.');
        stringMap.put('merchant_data', u[0].Contact.Email+'/'+'User Name='+u[0].Name);
        stringMap.put('state_tax',totaltaxchange );
        stringMap.put('help_url','https://billpointe.clearcommerce.com');
        stringMap.put('tran_attempt_count','3');
       
        
        hppvalueslist = [Select Id, Name, Unit_Price__c, Opportunity__c from HppFieldValueStorage__c Where Opportunity__c =: OpportunityID];
        
        
        integer x = 1;
        for (HppFieldValueStorage__c hppval: hppvalueslist )
        {
             //stringMap.put('field_'+x,hppval.Name);
             //stringMap.put('field_'+y,hppval.Unit_Price__c);

             stringMap.put('item_' + x + '_id',hppval.id);
             stringMap.put('item_' + x + '_item_number', string.valueof(x));
             stringMap.put('item_' + x + '_desc',hppval.Name);
             stringMap.put('item_' + x + '_subtotal',hppval.Unit_Price__c);
             stringMap.put('item_' + x + '_total',hppval.Unit_Price__c);
             stringMap.put('item_' + x + '_price',hppval.Unit_Price__c);
             stringMap.put('item_' + x + '_qty','1');

             x++;
             //y = y + 2;
        }
        
        
        
        
        
        
        
        
        
        stringMap.put('field_1','BUILDING BLOCKS PARTNERSHIP RENEWAL PAYMENT');
        
        
        
        
        
        
        
        stringMap.put('field_2','Customer Number:');
        stringMap.put('field_3',oppaccpscompanyid);
        
        stringMap.put('field_4','Total Product Line Value:');
        stringMap.put('field_5',totaloliv);
        
        /*stringMap.put('field_6','Invoice Number:');
        stringMap.put('field_7','Bb000000009'); */
        
        
        stringMap.put('field_8','Total Tax Value:');
        stringMap.put('field_9',totaltaxv);
        
        if(latevalueemailstring != '$0'){
        stringMap.put('field_12','Late Fee Value:');
        stringMap.put('field_13',latevalueemailstring);
        }
        
        stringMap.put('field_20','Grand Total:');
        stringMap.put('field_21',totalv);
        
        stringMap.put('field_22',oppaccname+ ' - Online Renewal Payment');
        
        
        string m ='';
        
        for(String s:StringMap.keySet()){
           if(m!=''){
           m = m +'&'+ s +'='+ StringMap.get(s);
           }
           else{
           if(m==''){
            m = s +'='+ StringMap.get(s);
           }
          } 
        }
         
        

        //req.setBody(EncodingUtil.urlEncode(m, 'UTF-8')); //encoding the body
        req.setBody(m);
        Http http = new Http();
        try {
                 
        HTTPResponse res = http.send(req);   
        System.debug(res.toString());
        System.debug('STATUS:'+res.getStatus());
        System.debug('STATUS_CODE:'+res.getStatusCode());
        System.debug('RESPONSE BODY:'+res.getBody());
        
        
        getBodyvalue = res.getBody();
        
        system.debug('The body value is: '+getBodyvalue);
        
        //token=32428c2b-99b3-441e-ac87-aa60ca7bca42&consumer_url=https://testcapture.bbpaygate.com:443/PaymentPage/payment/32428c2b-99b3-441e-ac87-aa60ca7bca42
        //&response_code=1&response_msg=Success
        
        string[] splitval = getBodyvalue.split('\\&');
        system.debug('splitval val is: '+splitval);
        for(String s: splitval){
          
        
        }
        
        
        //redirectURL = getBodyvalue.substring(getBodyvalue.indexOf('&consumer_url=')+14, getBodyvalue.indexOf('&response_msg')-16);
        redirectURL= getBodyvalue.split('consumer_url=')[1].split('&response')[0];
        system.debug('SSS%%%:'+redirectURL);
        
        
        
        } 
        
        catch(System.CalloutException e) {
        system.debug('NIKHIL Test'); 
        system.debug('NIKHIL'+e);    
     
        }
        
        
        Opportunity RestResourcesFieldUpdate = [Select id, MyRestResource_Name__c,Sec_Oli_Values__c, MyRestResource_Email__c, MyRestResource_totalv__c, MyRestResource_totaloliv__c, MyRestResource_totataxv__c from Opportunity Where id=: OpportunityID];
        
        opportunity myRestUpdate = new opportunity();
        myRestUpdate.Id = RestResourcesFieldUpdate.Id;
        myRestUpdate.MyRestResource_totalv__c = totalv;
        myRestUpdate.MyRestResource_totaloliv__c = totaloliv;
        myRestUpdate.MyRestResource_totataxv__c = totaltaxv;
        myRestUpdate.Sec_Oli_Values__c = partf1;
        myRestUpdate.MyRestResource_Email__c = u[0].Contact.Email;
        myRestUpdate.MyRestResource_Name__c = u[0].Name;
        update myRestUpdate;       
        
        
        //PageReference pageRef = new PageReference(redirectURL);
        //return pageRef;
        
        PageReference pageRef = new PageReference('/apex/HPPRedirect');
        pageRef.getParameters().put('weblink',redirectURL);
        pageRef.setRedirect(true);
        return pageRef;
        
        
        
        
        
      
        
        
        
        
        
        

}

else if(isPaymentTypeSelected == 'Invoice without a Purchase Order'){

        
        cc= 'No';
        wpo= 'No';
        wopo='Yes';
        
        string totalv = ApexPages.currentPage().getParameters().get('totlv');
        string totaloliv = ApexPages.currentPage().getParameters().get('totloliv');
        string totaltaxv = ApexPages.currentPage().getParameters().get('totltaxv');
        string secolivalues = ApexPages.currentPage().getParameters().get('secolivalues');
        string olipricelist = ApexPages.currentPage().getParameters().get('olipricelist');
        
        
        Opportunity opptoUpdate = new Opportunity();
        opptoUpdate.Id = OppId;
        opptoUpdate.CPQ_PO_Required__c = 'No';
        opptoUpdate.CPQ_Approval_to_Invoice_wo_PO_Attached__c = true;
        //opptoUpdate.BbDN_Renewal_Processed__c = true;
        update opptoUpdate;
        
        PageReference pageRef = new pagereference('/apex/ThankYou?Id='+OppId);
        pageRef.getParameters().put('totlv', totalv);
        pageRef.getParameters().put('totloliv', totaloliv);
        pageRef.getParameters().put('totltaxv', totaltaxv);
        pageRef.getParameters().put('secolivalues', secolivalues);
        pageRef.getParameters().put('ccvalue', cc);
        pageRef.getParameters().put('wpovalue', wpo);
        pageRef.getParameters().put('wopovalue', wopo);
        pageRef.getParameters().put('olipricelist', olipricelist);
       
        
        pageRef.setRedirect(true);
        return pageRef;


}

else if(isPaymentTypeSelected == 'Invoice with a Purchase Order'){

        cc= 'No';
        wpo= 'Yes';
        wopo='No';
        
        
        string totalv = ApexPages.currentPage().getParameters().get('totlv');
        string totaloliv = ApexPages.currentPage().getParameters().get('totloliv');
        string totaltaxv = ApexPages.currentPage().getParameters().get('totltaxv');
        string secolivalues = ApexPages.currentPage().getParameters().get('secolivalues');
        string olipricelist = ApexPages.currentPage().getParameters().get('olipricelist');
        
        
        Opportunity opptoUpdate = new Opportunity();
        opptoUpdate.Id = OppId;
        opptoUpdate.CPQ_PO_Required__c = 'Yes';
        //opptoUpdate.BbDN_Renewal_Processed__c = true;  

        update opptoUpdate;
       
       
        PageReference pageRef = new pagereference('/apex/ThankYou?Id='+OppId);
        pageRef.getParameters().put('totlv', totalv);
        pageRef.getParameters().put('totloliv', totaloliv);
        pageRef.getParameters().put('totltaxv', totaltaxv);
        pageRef.getParameters().put('secolivalues', secolivalues);
        pageRef.getParameters().put('ccvalue', cc);
        pageRef.getParameters().put('wpovalue', wpo);
        pageRef.getParameters().put('wopovalue', wopo);
        pageRef.getParameters().put('olipricelist', olipricelist);
        pageRef.setRedirect(true);
        return pageRef;
      


}

else{
return null;

}

}


public PageReference sendEmail() {
   
   
   
   
OppIdvalue = ApexPages.currentPage().getParameters().get('id');
system.debug('OPPID IS'+OppIdvalue);



oppvalue = [Select id, AccountId, Sec_Oli_Dropped_Values__c, Account.Fax, Account.BillingStreet, BbDN_Renewal_Processed__c, Account.BillingCity, Account.BillingState, Account.BillingCountry,
                   Account.BillingPostalCode, Account.Name, Account.PS_Company_Id__c, Name from Opportunity Where Id =: OppIdvalue];
system.debug('Opp Value IS'+Opp); 
   

   
     
     
     
     
      string totalv = ApexPages.currentPage().getParameters().get('totlv');
      string totaloliv = ApexPages.currentPage().getParameters().get('totloliv');
      string totaltaxv = ApexPages.currentPage().getParameters().get('totltaxv');
      string secolivalues = ApexPages.currentPage().getParameters().get('secolivalues');
      string olipricelist = ApexPages.currentPage().getParameters().get('olipricelist');
      string ccvalue = ApexPages.currentPage().getParameters().get('ccvalue');
      string wpovalue = ApexPages.currentPage().getParameters().get('wpovalue');
      string wopovalue = ApexPages.currentPage().getParameters().get('wopovalue');
      
      system.debug('The olipricelist are:'+olipricelist);
      system.debug('The secolivalues are:'+secolivalues);
      string[] part;
      part = secolivalues.split('\\$');
      string parta;
      parta = part[1];
      string[] partb = parta.split('\\(');
      string partc = partb[1];
      string[] partd = partc.split('\\)');
      string parte = partd[0];
      system.debug('Value of PART E IS:'+parte);
      string partf = parte.replace(',', '<br>');
      
      
      
      
      string[] part1;
      part1 = olipricelist.split('\\(');
      string parta1;
      parta1 = part1[1];
      string[] partb1 = parta1.split('\\)');
      string partc1 = partb1[0];
      string partf1 = partc1.replace(',', '<br>');
      
      
      string part2d;
      
      if(oppvalue.Sec_Oli_Dropped_Values__c != null){
      string[] part2 = oppvalue.Sec_Oli_Dropped_Values__c.split('\\(');
      string part2a;
      part2a = part2[1];
      string[] part2b = part2a.split('\\)');
      string part2c = part2b[0];
      
      part2d = part2c.replace(',', '<br>');
      
      
      
      }
      
      
      
     
      
     
     //renew();
     
      att = [SELECT id, Name, Body, BodyLength FROM Attachment WHERE ParentID =: OppId LIMIT 1];
            system.debug('The size is: '+att.size());
            system.debug('The att name is:'+att);
            
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('BbDN_Aggrement.pdf');
            efa.setBody(att[0].Body);
            fileAttachments.add(efa);
     
     
     
     
     
     List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
     
       // if (Email!= null ) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();
            sendTo.add('BbPartnerRenewals@Blackboard.com');
            //sendTo.add('murugappan.alagappan@gmail.com');
            
            mail.setToAddresses(sendTo);
            mail.setReplyTo('BbPartnerRenewals@Blackboard.com');
            mail.setCcAddresses(new String[] {'Nicole.Kindle@Blackboard.com', 'Lloyd.Boateng@Blackboard.com','murugappan.alagappan@blackboard.com'});
            mail.setSenderDisplayName('BbPartnerRenewals@Blackboard.com');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            mail.setSubject('Internal Copy: Blackboard Building Blocks Partnership Renewal – '+oppaccname);
            String body = '';
            body += '<b>Blackboard Building Blocks Partnership Renewal – </b>'+ oppaccname+ '<br/>'+ '<br/>'; 
            body += '<b><u>Company Information:</u></b>'+'<br/>'+ '<br/>';
            body += 'Company Name:'+' '+ oppaccname  +'<br/>'+'<br/>';
            body += 'Address:'+' '+ oppaccountbillingstreet  +'<br/>'+'<br/>';
            body += 'Country:'+' '+ oppaccountbillingcountry  +'<br/>'+'<br/>';
            body += 'City:'+' '+ oppaccountbillingcity  +'<br/>'+'<br/>';
            body += 'State/Province:'+' '+ oppaccountbiillingstate  +'<br/>'+'<br/>';
            body += 'Postal Code:'+' '+ oppaccountbillingpostalcode +'<br/>'+'<br/>';
            body += 'E-Mail:'+' '+u[0].Contact.Email+ '<br/>'+'<br/>';
            body += '<b><u>Subscription Options:</u></b>'+ '<br/>'+ '<br/>';
            system.debug('$$$$'+oliList);
            /*for(OpportunityLineItem o: oliList){
            body += ''+ o.Product2.Name +'<br/>'+ '<br/>';  
            }*/
            //body += ''+ partf +'<br/>'+ '<br/>';
            //body += ''+ partf +'<br/>'+ '<br/>';
            body += ''+ partf1 +'<br/>'+ '<br/>';
            
            if(oppvalue.Sec_Oli_Dropped_Values__c != null){
                body += ''+ part2d +'<br/>'+ '<br/>'; 
            }
      
            
            body += '<b><u>Billing Information:</u></b>'+ '<br/>'+ '<br/>';
            body += '<b><u>Payment Method Selected: </u></b>'+ '<br/>'+ '<br/>';
            body += 'Pay by Credit Card:'+' '+ ccvalue + '<br/>'+ '<br/>';
            body += 'Pay by Check without a PO:'+' '+ wopovalue + '<br/>'+ '<br/>';
            body += 'Pay by Check requires a PO:'+' ' +wpovalue + '<br/>'+ '<br/>';
            body += 'Renewal Fees:'+ ''+ totaloliv +'<br/>'+ '<br/>';
            body += 'Taxes:' + ''+totaltaxv + '<br/>' + '<br/>';
            if(latevalueemailstring != '$0'){
            body += 'Late Fee:'+'' + latevalueemailstring  + '<br/>'+ '<br/>';
            }
            body += 'Total Amount:' +''+ totalv +'<br/>'+ '<br/>';
            
            
            
            body += 'Payment has been submitted from Behind the Blackboard and a receipt has been sent to '+u[0].Contact.Email+'.';
                   
            mail.setHtmlBody(body);
            
            mails.add(mail);
       //  }
         
          Messaging.sendEmail(mails); 
          
            /*PageReference ref = Page.BbDN_ExportToPDF;
            ref.getParameters().put('Id',OppId);  
            Blob b = ref.getContentAsPDF();
            
            

            Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
            efa1.setFileName('BbDN_Aggrement.pdf');
            efa1.setBody(b);*/
            
            
            /*att = [SELECT id, Name, Body, BodyLength FROM Attachment WHERE ParentID =: OppId LIMIT 1];
            system.debug('The size is: '+att.size());
            system.debug('The att name is:'+att);
            
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName('BbDN_Aggrement.pdf');
            efa.setBody(att[0].Body);
            fileAttachments.add(efa); */
          
          List<Messaging.SingleEmailMessage> mails2 = new List<Messaging.SingleEmailMessage>();
     
       // if (Email!= null ) {
            Messaging.SingleEmailMessage mail2 = new Messaging.SingleEmailMessage();
            List<String> sendTo2 = new List<String>();
            sendTo2.add(u[0].Contact.Email);
            //sendTo2.add('murugappan.alagappan@gmail.com');
            
            mail2.setToAddresses(sendTo2);
            mail2.setReplyTo('BbPartnerRenewals@Blackboard.com');
            mail2.setCcAddresses(new String[] {'Nicole.Kindle@Blackboard.com', 'Lloyd.Boateng@Blackboard.com','murugappan.alagappan@blackboard.com'});
            mail2.setSenderDisplayName('BbPartnerRenewals@Blackboard.com');
            mail2.setSubject('Your Blackboard Building Blocks Partnership Renewal');
            mail2.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
            String body2 = 'Date' + ' ' + system.today().format() +'<br/>'+'<br/>';
            body2 += 'Dear ' + u[0].Name +'<br/>'+'<br/>';
            body2 += 'Thank you for renewing your Blackboard Building Blocks™ partnership and developer license(s). Attached are the terms and conditions that govern your participation in the Blackboard Building Blocks partnership program and your use of the developer license(s). You will receive an email with your license(s) and installation instructions in 3-5 business days. Please find your order summary below.'+ '<br/>'+ '<br/>'; 
            body2 += '<b><u>Ordered Products</u></b>'+'<br/>'+ '<br/>';
            system.debug('$$$$'+oliList);
            /*for(OpportunityLineItem o: oliList){
            body2 += ''+ o.Product2.Name +'<br/>'+ '<br/>';  
            }*/
            //body2 += ''+ partf +'<br/>'+ '<br/>';
            body2 += ''+ partf1 +'<br/>'+ '<br/>';
            
            if(oppvalue.Sec_Oli_Dropped_Values__c != null){
                body2 += ''+ part2d +'<br/>'+ '<br/>'; 
            }
      
            
            body2 += '<b> <u>Order Summary</u> </b>'+ '<br/>'+ '<br/>';
            body2 += 'Order Amount:' +''+ totaloliv +'<br/>'+ '<br/>';
            body2 += 'Taxes (if applicable):'+'' + totaltaxv  + '<br/>'+ '<br/>';
            if(latevalueemailstring != '$0'){
            body2 += 'Late Fee:'+'' + latevalueemailstring  + '<br/>'+ '<br/>';
            }
            body2 += 'Total Amount Paid:' +''+ totalv +'<br/>'+ '<br/>';
            body2 += 'Membership Expiration:'+ ' '+oppplineList[0].Opportunity.End_Date__c.format() +'<br/>'+ '<br/>';
            
            body2 += 'Please contact us at BbPartnerRenewals@blackboard.com, with any questions.' +'<br/>'+'<br/>';
            
            body2 += 'Best regards,' + '<br/>';
            body2 += 'Blackboard Partnerships' + '<br/>';
            body2 += 'BbPartnerRenewals@blackboard.com';
            
            
                   
            mail2.setHtmlBody(body2);
            
            mails2.add(mail2);
       //  }
         
           Messaging.sendEmail(mails2);
          
Note noteval = new Note();
noteval.Title = 'Transaction Details';
noteval.ParentId = OppIdvalue;

string prodvala = partf1.replace(',', '<br>');
string prodval = partf1.replace('<br>', '\r\n');

string prodval1;
if(oppvalue.Sec_Oli_Dropped_Values__c != null){
string prodvala1 = part2d.replace(',', '<br>');
prodval1 = part2d.replace('<br>', '\r\n');
}

system.debug('%%%'+prodval);

            String body1 = '';
            body1 += 'Blackboard Building Blocks Partnership Renewal – '+ oppaccname + '\r\n'; 
            body1 += 'Company Information:' + '\r\n'; 
            body1 += 'Company Name:'+' '+ oppaccname + '\r\n';
            body1 += 'Address:'+' '+ oppaccountbillingstreet + '\r\n';
            body1 += 'Country:'+' '+ oppaccountbillingcountry + '\r\n';
            body1 += 'City:'+' '+ oppaccountbillingcity + '\r\n';
            body1 += 'State/Province:'+' '+ oppaccountbiillingstate + '\r\n';
            body1 += 'Postal Code:'+' '+ oppaccountbillingpostalcode + '\r\n';
            body1 += 'E-Mail:'+' '+u[0].Contact.Email + '\r\n';
            body1 += 'Subscription Options:' + '\r\n';
            
            body1 += ''+ prodval + '\r\n';
            
            if(oppvalue.Sec_Oli_Dropped_Values__c != null){
                body1 += ''+ prodval1 + '\r\n';
            }
            
            
            body1 += 'Billing Information:' + '\r\n';
            body1 += 'Payment Method Selected:' + '\r\n';
            body1 += 'Pay by Credit Card:'+' '+ ccvalue + '\r\n' ;
            body1 += 'Pay by Check without a PO:'+' '+ wopovalue + '\r\n';
            body1 += 'Pay by Check requires a PO:'+' ' + wpovalue + '\r\n';
            body1 += 'Renewal Fees:'+ ''+ totaloliv + '\r\n';
            body1 += 'Taxes:' + ''+totaltaxv + '\r\n';
            if(latevalueemailstring != '$0'){
            body1 += 'Late Fee:'+'' + latevalueemailstring  + '\r\n';
            }
            body1 += 'Total Amount:' +''+ totalv  + '\r\n';
            
            
            
            body1+= 'Payment has been submitted from Behind the Blackboard and a receipt has been sent to '+u[0].Contact.Email+'.';
            noteval.Body = body1;
            insert noteval;          
          
          
          
opportunity opp = new opportunity();
opp.Id= OppIdvalue;
opp.BbDN_Renewal_Processed__c = true;
update opp;

   return null;
    
 }

}