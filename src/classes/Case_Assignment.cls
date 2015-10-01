public class Case_Assignment{ 
    
    // These booleans values are for testclass coverage 
    public static Boolean MOODLEROOMSEMEA {get;set;}
    public static Boolean MOODLEROOMSAPAC {get;set;} 
    public static Boolean MOODLEROOMSTERRITORY {get;set;}
    public static Boolean MOODLEROOMSWEEKENDSEV1CASE {get;set;}
    public static Boolean MOODLEROOMSNORMALASSIGN {get;set;}

    Set<ID> aid = new Set<ID>();
    Map<String,String> learnmap = new Map<String,String>();
    Map<String,String> learnhmap = new Map<String,String>();
    Map<String,String> learncmap = new Map<String,String>();
    Map<String,String> transmap = new Map<String,String>();
    Map<String,String> xythomap = new Map<String,String>();
    Map<String,String> angelmap = new Map<String,String>();
    Map<String,String> queuemap = new Map<String,String>();
    Map<String,String> cevistamap = new Map<String,String>();
    Map<String,String> cevistahmap = new Map<String,String>();
    Map<String,String> moodleroommap= new Map<String,String>();
    Map<String,String> analyticsmap= new Map<String,String>();
    Map<String,String> CollaborateMap= new Map<String,String>(); //comment added
    Map<String,String> LearnSAASMap = new Map<String,String>(); 
    Map<String,String> usrPrmGrp = new Map<String,String>();
     Map<String,String> xpLormap= new Map<String,String>();
    Map<String,String> usrmap = new Map<String,String>();
    set<id> categoryids= new set<id>();
    Map<id,category__c> categorymap= new Map<id,category__c>();
    List<Case> c1 = new List<Case>();


    public void changeowner(List<Case> clist,Set<ID> accID){
        system.debug('Case List---'+clist+'--Accset--'+accID);

        Map<string,Account> accmap = new Map<string,Account>();

        aid.addAll(accId);
        map<id,Core_License__c>coreMap=new map<id,Core_License__c>([Select id,name,product__c from Core_License__c]);
        Set<ID> profid = new Set<ID>();
        for(Profile p : [select ID,Name from Profile where Name LIKE '%SRV%' AND Name != 'SRV - BTBB User']){
            profid.add(p.ID);
        }

        for(List<User> u : [select ID,Name,Primary_Group__c from User where IsActive = true AND ProfileID IN: profid ORDER By Name]){
            for(User u1 : u){
                usrPrmGrp.put(u1.Name,u1.Primary_Group__c);
                usrmap.put(u1.Name,u1.ID);
            }
        }


        for(List<Account> alist : [select ID,Complex_Hosting__c,Managed_Hosting__c,PS_Company_Id__c,Type,Learn_Queue__c,CE_Vista_Hosted__c,CE_Vista_Queue__c,Learn_Complex_Queue__c,Learn_Hosted_Queue__c,Angel_Queue__c,Xythos_Queue__c,Transact_Queue__c,Moodlerooms_Queue__c,Collaborate_Queue__c,Analytics_Queue__c,Learn_SaaS_Queue__c,xpLor_Queue__c from Account where ID IN: aid]){
            for(Account a1 : alist){
                String aID1 = a1.Id;//String.valueof(a1.ID).substring(0,15);
                if(a1.Learn_Queue__c != null && a1.Learn_Queue__c.contains('K12'))
                    learnmap.put(aID1,'Angel K12');
                else if(a1.Learn_Queue__c != null && a1.Learn_Queue__c.contains('South') && a1.Learn_Queue__c.contains('West'))
                    learnmap.put(aID1,'Angel South West');
                else
                    learnmap.put(aID1,a1.Learn_Queue__c);
                transmap.put(aID1,a1.Transact_Queue__c);
                xythomap.put(aID1,a1.Xythos_Queue__c);
                if(a1.Angel_Queue__c != null && a1.Angel_Queue__c.contains('K12'))
                    angelmap.put(aID1,'Angel K12');
                else if(a1.Angel_Queue__c != null && a1.Angel_Queue__c.contains('South') && a1.Angel_Queue__c.contains('West'))
                    angelmap.put(aID1,'Angel South West');
                else
                    angelmap.put(aID1,a1.Angel_Queue__c);
                learncmap.put(aID1,a1.Learn_Complex_Queue__c);
                if(a1.Learn_Hosted_Queue__c != null && a1.Learn_Hosted_Queue__c.contains('K12'))
                    learnhmap.put(aID1,'Angel K12');
                else if(a1.Learn_Hosted_Queue__c != null && a1.Learn_Hosted_Queue__c.contains('South') && a1.Learn_Hosted_Queue__c.contains('West'))
                    learnhmap.put(aID1,'Angel South West');
                else
                    learnhmap.put(aID1,a1.Learn_Hosted_Queue__c);
                cevistamap.put(aID1,a1.CE_Vista_Queue__c);
                cevistahmap.put(aID1,a1.CE_Vista_Hosted__c);
                moodleroommap.put(aID1,a1.Moodlerooms_Queue__c);
                analyticsmap.put(aID1,a1.Analytics_Queue__c);
                xpLormap.put(aID1,a1.xpLor_Queue__c);
                collaboratemap.put(aID1,a1.Collaborate_Queue__c);
                LearnSAASMap.put(aID1,a1.Learn_SaaS_Queue__c);
                accmap.put(aID1,a1);
            }
        }
        
        for(List<Group> g : [select ID,Name from Group where Type = 'Queue']){
            for(Group g1 : g){
                if(g1.Name != null && g1.Name.contains('K12') && g1.Name.contains('Corp'))
                    queuemap.put('Angel K12',g1.ID); 
                else if(g1.Name != null && g1.Name.contains('ANGEL - Northeast Engagement Team'))     
                    queuemap.put('ANGEL - Northeast Engagement Team',g1.ID);
                else if(g1.Name != null && g1.Name.contains('South') && g1.Name.contains('West'))     
                    queuemap.put('Angel South West',g1.ID);
                else
                    queuemap.put(g1.Name,g1.ID);
            }
        }
        System.debug(queuemap);
        
        for(case c:CList)
        {
            categoryids.add(c.category__c);
        }
        categorymap=new map<id,category__c>([Select id,Name from category__c where id in :categoryids]);
        for(Case c : clist){
            system.debug('Account---'+ accmap + '--AccID--'+c.AccountID);
            //  string acc_id=c.Account_ID__c.substring(0,15);
            Account a;
            if(c.AccountID != null)
            {
                a = accmap.get(c.AccountID);
            }
            else if(c.Account_ID__c != null)
            {
                string acc_id=[select id from account where id =:c.Account_ID__c limit 1].id;
                a=accmap.get(acc_id);
                c.AccountID=acc_id;
                system.debug('+++acc+++'+a+'---'+acc_id);
            }
            
            
            
        /*   if(c.recordtypeid==Case.sObjectType.getdescribe().getRecordTypeInfosByName().get('Collaborate End User Open').getRecordTypeId() && c.Module_Name__c == 'Technical Services Request (ICM)')
            {
                        c.OwnerID = queuemap.get('Collaborate: Technical Services');
                        c.Primary_Group_Name__c = 'Collaborate: Technical Services';
                        c.Initial_Case_Owner__c = 'Collaborate: Technical Services';  
                
            }
            
            else if(c.recordtypeid==Case.sObjectType.getdescribe().getRecordTypeInfosByName().get('Collaborate End User Open').getRecordTypeId() && c.Module_Name__c.equalsignorecase('Request Upgrade'))
            {
                        c.OwnerID = queuemap.get('Collaborate: Orders Fulfillment');
                        c.Primary_Group_Name__c = 'Collaborate: Orders Fulfillment';
                        c.Initial_Case_Owner__c = 'Collaborate: Orders Fulfillment';
                
            }
            
            else if(c.recordtypeid==Case.sObjectType.getdescribe().getRecordTypeInfosByName().get('Collaborate End User Open').getRecordTypeId() && (categorymap.get(c.category__c) != null  && categorymap.get(c.category__c).Name.equalsignorecase('Request integration credentials')))
            {
                        c.OwnerID = queuemap.get('Collaborate: Orders Fulfillment');
                        c.Primary_Group_Name__c = 'Collaborate: Orders Fulfillment';
                        c.Initial_Case_Owner__c = 'Collaborate: Orders Fulfillment';
                
            } 
            
           else */
               if(c.recordtypeid==Case.sObjectType.getdescribe().getRecordTypeInfosByName().get('Collaborate End User Open').getRecordTypeId() && c.Module_Name__c.equalsignorecase('Large Event Request'))
               {
                c.OwnerID = queuemap.get('Collaborate: Tier 2 Support');
                c.Primary_Group_Name__c = 'Collaborate: Tier 2 Support';
                c.Initial_Case_Owner__c =  'Collaborate: Tier 2 Support';
               }
               else if(c.recordtypeid==Case.sObjectType.getdescribe().getRecordTypeInfosByName().get('Collaborate End User Open').getRecordTypeId())
                {
                 c.OwnerID = queuemap.get('Collaborate: Tier 1 Support');
                 c.Primary_Group_Name__c = 'Collaborate: Tier 1 Support';
                 c.Initial_Case_Owner__c =  'Collaborate: Tier 1 Support';
                }
                 
              
               else if(c.Case_Record__c != null){
                if(c.Case_Record__c.contains('ANGEL')){
                    System.debug(c.AccountID);
                    System.debug(c.Managed_Hosting__c);

                    if((c.Managed_Hosting__c == 'ANGEL - Managed Hosting' || c.Managed_Hosting__c == 'Angel - Managed Hosting' ) && c.Case_Severity__c == '1' && (a.Type == 'Partner' || a.Type == 'Customer')){
                        c.OwnerID = queuemap.get('ANGEL - Managed Hosting');
                        c.Primary_Group_Name__c = 'ANGEL - Managed Hosting';
                        c.Initial_Case_Owner__c =  'ANGEL - Managed Hosting';
                    }else if(a.Type == 'Partner' && (/*a.PS_Company_Id__c == '162455' || TP3480*/a.PS_Company_Id__c == '101198' || a.PS_Company_Id__c == '101085' || a.PS_Company_Id__c == '309154')){
                        c.OwnerID = queuemap.get('ANGEL - Northeast Engagement Team');
                        c.Primary_Group_Name__c = 'ANGEL - Northeast Engagement Team';
                        c.Initial_Case_Owner__c = 'ANGEL - Northeast Engagement Team';
                    }else if(a.Type == 'Partner' && a.PS_Company_Id__c == '162455' /*TP3480*/ ){
                        c.OwnerID = queuemap.get('Angel South West');
                        c.Primary_Group_Name__c = 'ANGEL - South/West Engagement Team';
                        c.Initial_Case_Owner__c = 'ANGEL - South/West Engagement Team';
                    }else if(a.Type == 'Partner' || (a.Type == 'Partner' && a.PS_Company_Id__c == '332018')){
                        c.OwnerID = queuemap.get('ANGEL - Software Solutions');
                        c.Primary_Group_Name__c = 'ANGEL - Software Solutions';
                        c.Initial_Case_Owner__c = 'ANGEL - Software Solutions';
                    }else{
                        System.debug(queuemap.get(angelmap.get(c.AccountID)));
                        if((queuemap.get(angelmap.get(c.AccountID)) != null && String.valueof(queuemap.get(angelmap.get(c.AccountID))).substring(0,3) == '00G') || (angelmap.get(c.AccountID) != null && angelmap.get(c.AccountID).contains('K12'))){
                            if(angelmap.get(c.AccountID) != null && angelmap.get(c.AccountID).contains('K12')){
                                c.OwnerID = queuemap.get('Angel K12');
                                c.Primary_Group_Name__c = 'ANGEL - K12/Corp Engagement Team';
                                c.Initial_Case_Owner__c = 'ANGEL - K12/Corp Engagement Team';
                            }else if(angelmap.get(c.AccountID) != null && angelmap.get(c.AccountID).contains('South') && angelmap.get(c.AccountID).contains('West')){
                                c.OwnerID = queuemap.get('Angel South West');
                                c.Primary_Group_Name__c = 'ANGEL - South/West Engagement Team';
                                c.Initial_Case_Owner__c = 'ANGEL - South/West Engagement Team';
                            }else{
                                c.OwnerID = queuemap.get(angelmap.get(c.AccountID));
                                c.Primary_Group_Name__c = angelmap.get(c.AccountID);
                                c.Initial_Case_Owner__c = angelmap.get(c.AccountID);
                            }
                        }else if((angelmap.get(c.AccountID) != null && usrmap.get(angelmap.get(c.AccountID)) != null && String.valueof(usrmap.get(angelmap.get(c.AccountID))).substring(0,3) == '005')){
                            c.OwnerID = usrmap.get(angelmap.get(c.AccountID));
                            c.Primary_Group_Name__c = usrPrmGrp.get(angelmap.get(c.AccountID));
                            c.Initial_Case_Owner__c = usrPrmGrp.get(angelmap.get(c.AccountID));
                        }
                    }
                }
                //Modified for Moodleroom
                else if(c.Case_Record__c=='Moodlerooms')
                {
                    if(c.Case_Severity__c=='1' || c.Case_Severity__c=='2')
                    {
                       system.debug('$everity' +c.Case_Severity__c); 
                       Integer H1 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                       Integer M1 = Integer.valueof(Datetime.now().format('m', 'America/New_York'));
                       String day = Datetime.now().format('EEE','America/New_York');
                       string queue;
                            
                       if( (day == 'Sat' || (day == 'Fri' && (H1 > 17 || (H1 == 17 && M1 >= 30))) || (day == 'Sun' && ((H1 < 17)||(H1==17 && M1<=30)))) || (MOODLEROOMSWEEKENDSEV1CASE == true && test.isrunningtest()) )
                       { 
                         system.debug('dayajith' +day);
                         c.OwnerID = queuemap.get(moodleroommap.get(C.accountid));
                         c.Primary_Group_Name__c = moodleroommap.get(C.accountid);
                         c.Initial_Case_Owner__c = moodleroommap.get(C.accountid);
                       }
                       else 
                       if( ((H1 > 17 || (H1 == 17 && M1 >= 30)) || (H1 >= 0 && H1 < 3) || (H1 == 3 && M1 < 30)) || (MOODLEROOMSAPAC == True && test.isrunningtest()) )
                       {
                        system.debug('Loop1' +H1);
                        c.OwnerID = queuemap.get('Moodlerooms: APAC');
                        c.Primary_Group_Name__c = 'Moodlerooms: APAC'; 
                        c.Follow_the_Sun__c = true;                                       
                        c.Initial_Case_Owner__c = 'Moodlerooms: APAC'; 
                       }
                       else if( ((H1 >8) && ((H1 < 17) || (H1 == 17 && M1 < 30)) && moodleroommap.get(c.AccountID).contains('Territory')) || (MOODLEROOMSNORMALASSIGN == True && test.isrunningtest()) )
                       {
                         c.OwnerID = queuemap.get(moodleroommap.get(C.accountid));
                         c.Primary_Group_Name__c = moodleroommap.get(C.accountid);
                         c.Initial_Case_Owner__c = moodleroommap.get(C.accountid); 
                       }
                       else if( ((H1 > 3 || (H1 == 3 && M1 >= 30)) && (H1 < 12)) || (MOODLEROOMSEMEA == True && test.isrunningtest()) )
                       {
                        system.debug('Loop2' +H1);
                        c.OwnerID = queuemap.get('Moodlerooms: EMEA');
                        c.Primary_Group_Name__c = 'Moodlerooms: EMEA'; 
                        c.Follow_the_Sun__c = true;                                       
                        c.Initial_Case_Owner__c = 'Moodlerooms: EMEA';
                       }
                       else if( (((H1 >= 12) && ((H1 < 17) || (H1 == 17 && M1 < 30))) && (moodleroommap.get(c.AccountID).contains('Moodlerooms: EMEA') || moodleroommap.get(c.AccountID).contains('Moodlerooms: APAC'))) || (MOODLEROOMSTERRITORY == True && test.isrunningtest()) )
                       {
                        system.debug('Loop3' +H1);
                        c.OwnerID = queuemap.get('Moodlerooms: Territory 2 Engagement Team');
                        c.Primary_Group_Name__c = 'Moodlerooms: Territory 2 Engagement Team'; 
                        c.Follow_the_Sun__c = true;                                       
                        c.Initial_Case_Owner__c = 'Moodlerooms: Territory 2 Engagement Team';
                       } 
                       
                    }
                    else
                    {  
                       system.debug('noraml assign' +c.Case_Severity__c); 
                       c.OwnerID = queuemap.get(moodleroommap.get(C.accountid));
                       c.Primary_Group_Name__c = moodleroommap.get(C.accountid);
                       c.Initial_Case_Owner__c = moodleroommap.get(C.accountid);
                     }  
                }
                //Modified for Analytics
                else if(c.Case_Record__c=='Analytics'){
                   c.OwnerID = queuemap.get(analyticsmap.get(C.accountid));
                    c.Primary_Group_Name__c = analyticsmap.get(C.accountid);
                    c.Initial_Case_Owner__c = analyticsmap.get(C.accountid);
                }
                //xpLor
                else if(c.Case_Record__c.containsignorecase('xpLor')){
                   c.OwnerID = queuemap.get(xpLormap.get(C.accountid));
                    c.Primary_Group_Name__c = xpLormap.get(C.accountid);
                    c.Initial_Case_Owner__c = xpLormap.get(C.accountid);
                }
                //xpLor end
               // LearnSAAS
               
                else if(c.Case_Record__c=='Learn' && coreMap.get(c.Core_License__c) != null && coreMap.get(c.Core_License__c).Product__c == 'Learn SAAS' && coreMap.get(c.Core_License__c).name =='Learn')
                {   
                    system.debug('@@@@@@@@@@@@@' + (c.Core_License__c));
                    if(a.Complex_Hosting__c ==true && c.Managed_Hosting__c == 'Learn - SaaS')
                    { 
                       if(queuemap.get(learncmap.get(c.AccountID)) != null && String.valueof(queuemap.get(learncmap.get(c.AccountID))).substring(0,3) == '00G'){
                                c.OwnerID = queuemap.get(learncmap.get(c.AccountID));
                                c.Primary_Group_Name__c = learncmap.get(c.AccountID);
                                c.Initial_Case_Owner__c = learncmap.get(c.AccountID);
                            }else if(learncmap.get(c.AccountID) != null && usrmap.get(learncmap.get(c.AccountID)) != null && String.valueof(usrmap.get(learncmap.get(c.AccountID))).substring(0,3) == '005'){
                                c.OwnerID = usrmap.get(learncmap.get(c.AccountID));
                                c.Primary_Group_Name__c = usrPrmGrp.get(learncmap.get(c.AccountID));
                                c.Initial_Case_Owner__c = usrPrmGrp.get(learncmap.get(c.AccountID));
                            }
                    }
                    else if(c.Managed_Hosting__c == 'Learn - SaaS' && (c.Case_severity__c == '1' || c.Case_severity__c == '2'))
                    {
                       FTShosting(c,a);
                    }
                    else
                    {
                    c.OwnerID = queuemap.get(LearnSAASMap.get(C.accountid));
                    c.Primary_Group_Name__c = LearnSAASMap.get(C.accountid);
                    c.Initial_Case_Owner__c = LearnSAASMap.get(C.accountid);
                    }
                }
                else if(c.Case_Record__c.containsignorecase('Collaborate'))
                {
                    if(c.Module_Name__c == 'Technical Services Request (ICM)')
                    {
                        c.OwnerID = queuemap.get('Collaborate: Technical Services');
                        c.Primary_Group_Name__c = 'Collaborate: Technical Services';
                        c.Initial_Case_Owner__c = 'Collaborate: Technical Services';    
                    }
                    else if(c.Module_Name__c.equalsignorecase('Request Upgrade'))
                    {
                        c.OwnerID = queuemap.get('Collaborate: Orders Fulfillment');
                        c.Primary_Group_Name__c = 'Collaborate: Orders Fulfillment';
                        c.Initial_Case_Owner__c = 'Collaborate: Orders Fulfillment';
                    }
                    else if(c.Module_Name__c == 'Large Event Request')
                    {
                        c.OwnerID = queuemap.get('Collaborate: Tier 2 Support');
                        c.Primary_Group_Name__c = 'Collaborate: Tier 2 Support';
                        c.Initial_Case_Owner__c = 'Collaborate: Tier 2 Support';
                    }
                    
                    else if((categorymap.get(c.category__c) != null  && categorymap.get(c.category__c).Name.equalsignorecase('Request integration credentials')))
                    {
                    
                        c.OwnerID = queuemap.get('Collaborate: Orders Fulfillment');
                        c.Primary_Group_Name__c = 'Collaborate: Orders Fulfillment';
                        c.Initial_Case_Owner__c = 'Collaborate: Orders Fulfillment';
                    
                    }
                    else
                    {
                    c.OwnerID = queuemap.get(collaboratemap.get(C.accountid));
                    c.Primary_Group_Name__c = collaboratemap.get(C.accountid);
                    c.Initial_Case_Owner__c = collaboratemap.get(C.accountid);
                    }
                }
                else if(c.Case_Record__c.contains('Transact')){
                    if(queuemap.get(transmap.get(c.AccountID)) != null && String.valueof(queuemap.get(transmap.get(c.AccountID))).substring(0,3) == '00G'){
                        c.OwnerID = queuemap.get(transmap.get(c.AccountID));
                        c.Primary_Group_Name__c = transmap.get(c.AccountID);
                        c.Initial_Case_Owner__c = transmap.get(c.AccountID);
                    }else if(transmap.get(c.AccountID) != null && usrmap.get(transmap.get(c.AccountID)) != null && String.valueof(usrmap.get(transmap.get(c.AccountID))).substring(0,3) == '005'){
                        c.OwnerID = usrmap.get(transmap.get(c.AccountID));
                        c.Primary_Group_Name__c = usrPrmGrp.get(transmap.get(c.AccountID));
                        c.Initial_Case_Owner__c = usrPrmGrp.get(transmap.get(c.AccountID));
                    }
                }else if(c.Case_Record__c.contains('Learn') || c.Case_Record__c.contains('CE')){
                    system.debug('--!Debug1--');
                    system.debug('--!Learnmap--'+learnmap);
                    if(((a.Complex_Hosting__c ==true && c.Case_Record__c.contains('Learn')) || (c.Managed_Hosting__c != null && c.Managed_Hosting__c == 'Learn - Managed Hosting'))&&(c.Module_Name__c != 'ICM Support' /*TP2935*/)){
                        system.debug('--!Debug2--');
                        if(a.Complex_Hosting__c == true &&  c.Case_Record__c.contains('Learn')){
                            if(queuemap.get(learncmap.get(c.AccountID)) != null && String.valueof(queuemap.get(learncmap.get(c.AccountID))).substring(0,3) == '00G'){
                                c.OwnerID = queuemap.get(learncmap.get(c.AccountID));
                                c.Primary_Group_Name__c = learncmap.get(c.AccountID);
                                c.Initial_Case_Owner__c = learncmap.get(c.AccountID);
                            }else if(learncmap.get(c.AccountID) != null && usrmap.get(learncmap.get(c.AccountID)) != null && String.valueof(usrmap.get(learncmap.get(c.AccountID))).substring(0,3) == '005'){
                                c.OwnerID = usrmap.get(learncmap.get(c.AccountID));
                                c.Primary_Group_Name__c = usrPrmGrp.get(learncmap.get(c.AccountID));
                                c.Initial_Case_Owner__c = usrPrmGrp.get(learncmap.get(c.AccountID));
                            }
                        }else if(c.Managed_Hosting__c == 'Learn - Managed Hosting'){
                            if(c.Case_Record__c.contains('Learn')){
                                if(queuemap.get(learnhmap.get(c.AccountID)) != null && String.valueof(queuemap.get(learnhmap.get(c.AccountID))).substring(0,3) == '00G'){
                                    if(learnhmap.get(c.AccountID) != null && learnhmap.get(c.AccountID).contains('K12')){
                                        c.OwnerID = queuemap.get('Angel K12');
                                        c.Primary_Group_Name__c = 'ANGEL - K12/Corp Engagement Team';
                                        c.Initial_Case_Owner__c = 'ANGEL - K12/Corp Engagement Team';
                                    }else if(learnhmap.get(c.AccountID) != null && learnhmap.get(c.AccountID).contains('South') && learnhmap.get(c.AccountID).contains('West')){
                                        c.OwnerID = queuemap.get('Angel South West');
                                        c.Primary_Group_Name__c = 'ANGEL - South/West Engagement Team';
                                        c.Initial_Case_Owner__c = 'ANGEL - South/West Engagement Team';
                                    }else{
                                        if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                                            FTShosting(c,a);
                                        else
                                            normalhostingassign(c,a);

                                    }
                                }else if(learnhmap.get(c.AccountID) != null && usrmap.get(learnhmap.get(c.AccountID)) != null && String.valueof(usrmap.get(learnhmap.get(c.AccountID))).substring(0,3) == '005'){
                                    c.OwnerID = usrmap.get(learnhmap.get(c.AccountID));
                                    c.Primary_Group_Name__c = usrPrmGrp.get(learnhmap.get(c.AccountID));
                                    c.Initial_Case_Owner__c = usrPrmGrp.get(learnhmap.get(c.AccountID));
                                }
                            }else if(c.Case_Record__c.contains('CE')){
                                if(c.Module_Name__c == 'Server/System Administration' && c.Functional_Area_Name__c == 'Security'){ 
                                    c.OwnerID = queuemap.get('CE/Vista - L2 - Managed Hosting');
                                    c.Primary_Group_Name__c = 'CE/Vista - L2 - Managed Hosting';
                                    c.Initial_Case_Owner__c = 'CE/Vista - L2 - Managed Hosting';
                                }else if(queuemap.get(cevistahmap.get(c.AccountID)) != null && String.valueof(queuemap.get(cevistahmap.get(c.AccountID))).substring(0,3) == '00G'){
                                    if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2')
                                        FTShosting(c,a);
                                    else
                                        normalhostingassign(c,a);
                                }else if(cevistahmap.get(c.AccountID) != null && usrmap.get(cevistahmap.get(c.AccountID)) != null && String.valueof(usrmap.get(cevistahmap.get(c.AccountID))).substring(0,3) == '005'){
                                    c.OwnerID = usrmap.get(cevistahmap.get(c.AccountID));
                                    c.Primary_Group_Name__c = usrPrmGrp.get(cevistahmap.get(c.AccountID));
                                    c.Initial_Case_Owner__c = usrPrmGrp.get(cevistahmap.get(c.AccountID));
                                }
                            }
                        } 
                     
                        

                    }else if(((a.Complex_Hosting__c ==true && c.Case_Record__c.contains('Learn')) || (c.Managed_Hosting__c != null && c.Managed_Hosting__c == 'Learn - Managed Hosting'))&&(c.Module_Name__c == 'ICM Support' /*TP2935,3212*/)){
                        c.OwnerID = queuemap.get('ICM Support');
                        c.Primary_Group_Name__c = 'ICM Support';
                        c.Initial_Case_Owner__c = 'ICM Support';

                    }else if(c.Case_Severity__c == '3' || c.Case_Severity__c == '4' || c.Case_Severity__c == '5' || c.Case_Severity__c == '6')  {
                        Integer t1 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                        if(t1 > 8 && t1 < 18 && c.Module_Name__c == 'Server/ System Administration' && (c.Functional_Area_Name__c == 'License Key Request' || c.Functional_Area_Name__c == 'Manage Behind the Blackboard Access')){
                            c.OwnerID = queuemap.get('Client Operations');
                            c.Primary_Group_Name__c = 'Client Operations';
                            c.Initial_Case_Owner__c = 'Client Operations';
                        }else if(t1 > 8 && t1 < 18 && c.Case_Severity__c != '1' && (c.Functional_Area_Name__c == 'CE/Vista Authentication/Access' || c.Functional_Area_Name__c == 'License Key Request' || c.Functional_Area_Name__c == 'Manage Behind the Blackboard Access')){
                            c.OwnerID = queuemap.get('Client Operations');
                            c.Primary_Group_Name__c = 'Client Operations';
                            c.Initial_Case_Owner__c = 'Client Operations';
                        }else{
                            normalassign(c,a);
                        }
                    }else if(c.Case_Severity__c == '1' || c.Case_Severity__c == '2'){
                        Integer t3 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                        if(c.Case_Severity__c != '1' && t3 > 8 && t3 < 18  && c.Module_Name__c == 'Server/ System Administration' && (c.Functional_Area_Name__c == 'License Key Request' || c.Functional_Area_Name__c == 'Manage Behind the Blackboard Access')){
                            system.debug('--Pass1--');
                            c.OwnerID = queuemap.get('Client Operations');
                            c.Primary_Group_Name__c = 'Client Operations';
                            c.Initial_Case_Owner__c = 'Client Operations';
                        }else if(c.Case_Severity__c != '1' && t3 > 8 && t3 < 18 && (c.Functional_Area_Name__c == 'CE/Vista Authentication/Access' || c.Functional_Area_Name__c == 'License Key Request' || c.Functional_Area_Name__c == 'Manage Behind the Blackboard Access')){
                            system.debug('--Pass2--');
                            c.OwnerID = queuemap.get('Client Operations');
                            c.Primary_Group_Name__c = 'Client Operations';
                            c.Initial_Case_Owner__c = 'Client Operations';
                        }else if(learnmap.get(c.AccountID) != null && (learnmap.get(c.AccountID).contains('EMEA') || learnmap.get(c.AccountID).contains('Eiffel') || learnmap.get(c.AccountID).contains('AssistMicro'))){
                            system.debug('--Pass3--');
                            Integer t1 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                            String day = Datetime.now().format('EEE','America/New_York');
                            Integer t2 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                            if(day == 'Sat' || (day == 'Fri' && t2 >= 23) || (day == 'Sun' && t2 < 18)){
                                normalassign(c,a);
                            }else{
                                if(t1 >= 11 && t1 < 22){
                                    if(c.Case_Record__c.contains('Learn')||c.Case_record__c.contains('CE'))
                                    {
                                        c.OwnerID = queuemap.get('Learn - L1');      //Added for 2277 & 2213
                                        c.Primary_Group_Name__c = 'Learn - L1';
                                        c.Follow_the_Sun__c = true;
                                        c.Initial_Case_Owner__c =  'Learn - L1';
                                    }

                                }else if(t1  >= 22 || (t1 >= 0 && t1 < 2)){   //changed from 3 to 2 for3077 
                                    c.OwnerID = queuemap.get('Learn - L2 - ANZSEA');
                                    c.Primary_Group_Name__c = 'Learn - L2 - ANZSEA';
                                    c.Follow_the_Sun__c = true;
                                    c.Initial_Case_Owner__c = 'Learn - L2 - ANZSEA';  //Changed from L1 to L2 TP3964
                                }else
                                    normalassign(c,a);                                   
                            }
                        }else if(learnmap.get(c.AccountID) != null &&( learnmap.get(c.AccountID).contains('ANZSEA') || learnmap.get(c.AccountID).contains('BEENET') || learnmap.get(c.AccountID).contains('BMEHolding'))){
                            Integer t1 = Integer.valueof(Datetime.now().format('H', 'Australia/Sydney'));
                            String day = Datetime.now().format('EEE','America/New_York');
                            Integer t2 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                            if(day == 'Sat' || (day == 'Fri' && t2 >= 23) || (day == 'Sun' && t2 < 18)){
                                normalassign(c,a);
                            }else{
                                if(t1 >= 17 && t1  < 23){    
                                    c.OwnerID = queuemap.get('Learn - L1 - EMEA');
                                    c.Primary_Group_Name__c = 'Learn - L1 - EMEA';
                                    c.Follow_the_Sun__c = true;
                                    c.Initial_Case_Owner__c = 'Learn - L1 - EMEA';
                                }else if(t1 >= 23 || (t1 >= 0 && t1 < 9)){
                                    if(c.Case_Record__c.contains('Learn')||c.Case_record__c.contains('CE'))
                                    {
                                        c.OwnerID = queuemap.get('Learn - L1');    //Added for 2277 & 2213
                                        c.Primary_Group_Name__c = 'Learn - L1';
                                        c.Follow_the_Sun__c = true;
                                        c.Initial_Case_Owner__c =  'Learn - L1';
                                    }

                                }else
                                    normalassign(c,a);
                            }
                        }else if(learnmap.get(c.AccountID) == null || (learnmap.get(c.AccountID) != null && !learnmap.get(c.AccountID).contains('ANZSEA') && !learnmap.get(c.AccountID).contains('EMEA'))){
                            Integer t1 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                            String day = Datetime.now().format('EEE','America/New_York');
                            if(day == 'Sat' || (day == 'Fri' && t1 >= 22) || (day == 'Sun' && t1 < 18)){
                                normalassign(c,a);
                            }else{                                 
                                if((t1 >= 2 && t1 < 8)){    //modified from 4 to 3 for TP2484
                                    c.OwnerID = queuemap.get('Learn - L1 - EMEA');
                                    c.Primary_Group_Name__c = 'Learn - L1 - EMEA';
                                    c.Follow_the_Sun__c = true;
                                    c.Initial_Case_Owner__c = 'Learn - L1 - EMEA';
                                }else if((t1 >= 22 && t1 <= 23) || (t1 >= 0 && t1 < 2)){   //modified from 4 to 3 for TP2484
                                    c.OwnerID = queuemap.get('Learn - L2 - ANZSEA');
                                    c.Primary_Group_Name__c = 'Learn - L2 - ANZSEA';
                                    c.Follow_the_Sun__c = true;
                                    c.Initial_Case_Owner__c = 'Learn - L2 - ANZSEA';      //Changed from L1 to L2 TP3964
                                }else
                                    normalassign(c,a);
                            }
                        }   
                    }

                }else if(c.Case_Record__c.contains('Xythos')){
                    if(c.Case_Severity__c == '1'){
                        c.OwnerID = queuemap.get('Xythos');
                        c.Primary_Group_Name__c = 'Xythos';
                        c.Initial_Case_Owner__c = 'Xythos';
                    }else{
                        Integer t3 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
                        if(t3 > 8 && t3 < 18 && c.Module_Name__c == 'Administrator' && (c.Functional_Area_Name__c == 'Xythos Authentication' || c.Functional_Area_Name__c == 'License Key Request' || c.Functional_Area_Name__c == 'Manage Behind the Blackboard Access')){
                            c.OwnerID = queuemap.get('Client Operations');
                            c.Primary_Group_Name__c = 'Client Operations';
                            c.Initial_Case_Owner__c = 'Client Operations';
                        }else{
                            c.OwnerID = queuemap.get('Xythos');
                            c.Primary_Group_Name__c = 'Xythos';
                            c.Initial_Case_Owner__c = 'Xythos';
                        }
                    }
                }
            }
            if(c.OwnerID == null || (c.OwnerID == Userinfo.getUserID() && (c.Primary_Group_Name__c == null || c.Primary_Group_Name__c == ''))){
                c.OwnerID = queuemap.get('Unassigned Case Queue');
                c.Primary_Group_Name__c = 'Unassigned Case Queue';
                c.Initial_Case_Owner__c = 'Unassigned Case Queue';
            }

        }
    }

    
    public void normalassign(Case c,Account a){

        if(c.Case_Record__c.contains('Learn')){
            if(c.Module_Name__c == 'Managed Hosting Request' && a.Complex_Hosting__c  == false && c.Functional_Area_Name__c == 'Production Inaccessible'){
                c.OwnerID = queuemap.get('Learn - L1 - Managed Hosting');
                c.Primary_Group_Name__c = 'Learn - L1 - Managed Hosting';
                c.Initial_Case_Owner__c = 'Learn - L1 - Managed Hosting';

            }else if(c.Module_Name__c == 'ICM Support'){
                c.OwnerID = queuemap.get('ICM Support');
                c.Primary_Group_Name__c = 'ICM Support';
                c.Initial_Case_Owner__c = 'ICM Support';
            }
            else{
                if(queuemap.get(learnmap.get(c.AccountID)) != null && String.valueof(queuemap.get(learnmap.get(c.AccountID))).substring(0,3) == '00G'){
                    if(learnmap.get(c.AccountID) != null && learnmap.get(c.AccountID).contains('K12')){
                        c.OwnerID = queuemap.get('Angel K12');
                        c.Primary_Group_Name__c = 'ANGEL - K12/Corp Engagement Team';
                        c.Initial_Case_Owner__c = 'ANGEL - K12/Corp Engagement Team';
                    }else if(learnmap.get(c.AccountID) != null && learnmap.get(c.AccountID).contains('South') && learnmap.get(c.AccountID).contains('West')){
                        c.OwnerID = queuemap.get('Angel South West');
                        c.Primary_Group_Name__c = 'ANGEL - South/West Engagement Team';
                        c.Initial_Case_Owner__c = 'ANGEL - South/West Engagement Team';
                    }else{
                        c.OwnerID = queuemap.get(learnmap.get(c.AccountID));
                        c.Primary_Group_Name__c = learnmap.get(c.AccountID);
                        c.Initial_Case_Owner__c = learnmap.get(c.AccountID);
                    }
                }else if(learnmap.get(c.AccountID) != null && usrmap.get(learnmap.get(c.AccountID)) != null && String.valueof(usrmap.get(learnmap.get(c.AccountID))).substring(0,3) == '005'){
                    c.OwnerID = usrmap.get(learnmap.get(c.AccountID));
                    c.Primary_Group_Name__c = usrPrmGrp.get(learnmap.get(c.AccountID));
                    c.Initial_Case_Owner__c = usrPrmGrp.get(learnmap.get(c.AccountID));
                }
            }
        }else if(c.Case_Record__c.contains('CE')){ 
            if(queuemap.get(cevistamap.get(c.AccountID)) != null && String.valueof(queuemap.get(cevistamap.get(c.AccountID))).substring(0,3) == '00G'){
                c.OwnerID = queuemap.get(cevistamap.get(c.AccountID));
                c.Primary_Group_Name__c = cevistamap.get(c.AccountID);
                c.Initial_Case_Owner__c = cevistamap.get(c.AccountID);
            }else if(cevistamap.get(c.AccountID) != null && usrmap.get(cevistamap.get(c.AccountID)) != null && String.valueof(usrmap.get(cevistamap.get(c.AccountID))).substring(0,3) == '005'){
                c.OwnerID = usrmap.get(cevistamap.get(c.AccountID));
                c.Primary_Group_Name__c = usrPrmGrp.get(cevistamap.get(c.AccountID));
                c.Initial_Case_Owner__c = usrPrmGrp.get(cevistamap.get(c.AccountID));
            }
        }
    }  

    public void normalhostingassign(Case c,Account a){   //added by Varghese
        if(c.Case_Record__c.contains('Learn')){
            c.OwnerID = queuemap.get(learnhmap.get(c.AccountID));
            c.Primary_Group_Name__c = learnhmap.get(c.AccountID);
            c.Initial_Case_Owner__c = learnhmap.get(c.AccountID);
        }
        else if(c.Case_Record__c.contains('CE'))
        {
            c.OwnerID = queuemap.get(cevistahmap.get(c.AccountID));
            c.Primary_Group_Name__c = cevistahmap.get(c.AccountID);
            c.Initial_Case_Owner__c = cevistahmap.get(c.AccountID);
        }
    }

    public void FTShosting(Case c,Account a)
    {
        Integer H1 = Integer.valueof(Datetime.now().format('H', 'America/New_York'));
        Integer M1 = Integer.valueof(Datetime.now().format('m', 'America/New_York'));
        String day = Datetime.now().format('EEE','America/New_York');
        string mhqueue;
        map<id,Core_License__c>coreMap=new map<id,Core_License__c>([Select id,name,product__c from Core_License__c]);
        if(coreMap.get(c.Core_License__c)!=null && coreMap.get(c.Core_License__c).name == 'Learn' && coreMap.get(c.Core_License__c).Product__c=='Learn SAAS')
        {
            if(LearnSAASMap.get(c.AccountID) != null)
            {
                mhqueue = LearnSAASMap.get(c.AccountID);
            }
        }
        else if(c.Case_Record__c.contains('Learn'))
        {
            if(learnhmap.get(c.AccountID) != null)
            {
                mhqueue= learnhmap.get(c.AccountID);
            }   
        }
        else if(c.Case_Record__c.contains('CE'))
        {
            if(cevistahmap.get(c.AccountID) != null)
            {
                mhqueue= cevistahmap.get(c.AccountID);
            }
        }        
          if(MHqueue != null && !MHqueue.contains('Slash') && !MHqueue.contains('EMEA')){              //North America Queue

            if(day == 'Sat' || (day == 'Fri' && H1 >= 22) || (day == 'Sun' && ((H1 < 17)||(H1==17&&M1<=30)))){
                normalhostingassign(c,a);
            }else{                                 
                if(((H1 >= 3)||(H1==2&&M1>45)) && (H1 < 8)) {    //modified from 4 to 3 for TP2772
                    c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting - EMEA');
                    c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - EMEA'; 
                    c.Follow_the_Sun__c = true;                                       
                    c.Initial_Case_Owner__c = 'Learn - L2 - Managed Hosting - EMEA';                                                                               
                }else if((((H1== 22 && M1>45)||H1>22) && H1 <= 23) || (H1 >= 0 && ((H1 < 2)||(H1==2&&M1<45)))){   //modified from 4 to 3 for TP2772
                    c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting - Slash');
                    c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - Slash';
                    c.Follow_the_Sun__c = true;
                    c.Initial_Case_Owner__c = 'Learn - L2 - Managed Hosting - Slash';
                }else
                    normalhostingassign(c,a);
            }

        }else if(MHqueue!= null && MHqueue.contains('EMEA'))             //EMEA Queue
        {
            if(day == 'Sat' || (day == 'Fri' && H1 >= 23) || (day == 'Sun' && H1 < 18)){
                normalhostingassign(c,a);
            }else{
                if(((H1>11)||(H1==11&&M1>30) )&& ((H1 < 22)||(H1==22&&M1<45))){
                    if(MHqueue.contains('L2'))
                    {
                        c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting');      //Added for 2898
                        c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting';
                        c.Follow_the_Sun__c = true;
                        c.Initial_Case_Owner__c =  'Learn - L2 - Managed Hosting';
                    }
                    else
                    {
                        c.OwnerID = queuemap.get('Learn - L1 - Managed Hosting');      //Added for 3092
                        c.Primary_Group_Name__c = 'Learn - L1 - Managed Hosting';
                        c.Follow_the_Sun__c = true;
                        c.Initial_Case_Owner__c =  'Learn - L1 - Managed Hosting';
                    }     
                }

                else if(((H1>22)||(H1==22&&M1>45)) || (H1 >= 0 && ((H1<2)||(H1==2&&M1<45)))){
                    c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting - Slash');
                    c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - Slash';
                    c.Follow_the_Sun__c = true;
                    c.Initial_Case_Owner__c = 'Learn - L2 - Managed Hosting - Slash';
                }else
                    normalhostingassign(c,a);                                   
            }   
        }
        else if(MHqueue != null && MHqueue.contains('Slash'))
        {
            if(day == 'Sat' || (day == 'Fri' && H1 >= 23) || (day == 'Sun' && H1 < 18)){
                normalhostingassign(c,a);
            }else{
                if((H1>2||(H1==2&&M1>45)) && ((H1<11)||(H1==11&&M1<30))){    
                    c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting - EMEA');
                    c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting - EMEA';
                    c.Follow_the_Sun__c = true;
                    c.Initial_Case_Owner__c = 'Learn - L2 - Managed Hosting - EMEA';
                }else if(((H1>11)||(H1==11&&M1>30)) && (H1 >= 0 && H1 < 19)){                                                        
                    c.OwnerID = queuemap.get('Learn - L2 - Managed Hosting');    //Added for 2898
                    c.Primary_Group_Name__c = 'Learn - L2 - Managed Hosting';
                    c.Follow_the_Sun__c = true;
                    c.Initial_Case_Owner__c =  'Learn - L2 - Managed Hosting';
                }else
                    normalhostingassign(c,a);
            }
        }
        else{
            normalhostingassign(c,a);
        } 
    }
}