public class AssignQueuestoAccount {

    public ID AccountID;
    public boolean learnassignuser {get;set;}
    public boolean learnassignqueue {get;set;}
    public boolean learnhostedassignuser {get;set;} 
    public boolean learnhostedassignqueue {get;set;}
    public boolean learncompassignuser {get;set;}
    public boolean learncompassignqueue {get;set;} 
    public boolean learnsaasassignqueue{get;set;}
    public boolean learnsaasassignuser{get;set;}
    public boolean cevistassignuser {get;set;}
    public boolean cevistassignqueue {get;set;}
    public boolean cevistahostedassignuser {get;set;}
    public boolean cevistahostedassignqueue {get;set;}
    public boolean angelassignuser {get;set;}
    public boolean angelassignqueue {get;set;}
    public boolean transassignuser {get;set;}
    public boolean transassignqueue {get;set;}
    public boolean xythosassignuser {get;set;} 
    public boolean collabassignuser  {get;set;}
    public boolean collabassignqueue {get;set;}
    public boolean xythosassignqueue {get;set;}
    public boolean complexhosting    {get;set;}
    public boolean Moodleroomsassignuser {get;set;}
    public boolean Moodleroomsassignqueue {get;set;} 
    public boolean Analyticsassignuser {get;set;}
    public boolean Analyticsassignqueue {get;set;} 
    public boolean xplorassignuser {get;set;}
    public boolean xplorassignqueue {get;set;} 



    
     Set<ID> qID = new Set<ID>();                // added for TP2724    
        Set<String> uname = new Set<String>();   // added for TP2724     
        Set<String> qname = new Set<String>();   // added for TP2724
    public AssignQueuestoAccount(ApexPages.StandardController controller) {
        AccountId = controller.getId();
        Account a = [select ID,Complex_Hosting__c,Learn_Queue__c,Transact_Queue__c,xpLor_Queue__c,Learn_Hosted_Queue__c,Learn_Complex_Queue__c,CE_Vista_Hosted__c,CE_Vista_Queue__c,Xythos_Queue__c, Collaborate_Queue__c, Moodlerooms_Queue__c,Analytics_Queue__c,Angel_Queue__c,Learn_SaaS_Queue__c 
            from Account where ID =: AccountID];
        learnq = a.Learn_Queue__c;
        transq = a.Transact_Queue__c;
        xythosq = a.Xythos_Queue__c;
        collabq = a.Collaborate_Queue__c;
        angelq = a.Angel_Queue__c;
        learnhq = a.Learn_Hosted_Queue__c;
        learncq = a.Learn_Complex_Queue__c;
        learnsaasq=a.Learn_SaaS_Queue__c;
        cevistaq = a.CE_Vista_Queue__c;
        cevistah = a.CE_Vista_Hosted__c;
        complexhosting= a.Complex_Hosting__c;
        Moodleroomsq = a.Moodlerooms_Queue__c;
        Analyticsq = a.Analytics_Queue__c;
        xpLorq=a.xpLor_Queue__c;
    
        learnclist.add(new SelectOption('','-None-'));
        learnlist.add(new SelectOption('','-None-'));
        learnhlist.add(new SelectOption('','-None-'));
        learnsaaslist.add(new SelectOption('','-None-'));
        angellist.add(new SelectOption('','-None-'));
        celist.add(new SelectOption('','-None-'));
        cehlist.add(new SelectOption('','-None-'));        
        translist.add(new SelectOption('','-None-'));                
        xythoslist.add(new SelectOption('','-None-'));
        Collablist.add(new SelectOption('','-None-'));  
        Moodleroomslist.add(new SelectOption('','-None-'));                      
        AnalyticsList.add(new SelectOption('','-None-'));
        xpLorList.add(new SelectOption('','-None-'));
        
        for(List<QueueSobject> qs : [select SobjectType,QueueId from QueueSobject where SobjectType = 'Case']){
            for(QueueSobject qs1 : qs){
               qId.add(qs1.QueueId);
            }
        }
        for(List<Group> grp  : [select Name,Type from Group where ID IN: qID Order By Name]){
            for(Group g1 : grp){
                 qname.add(g1.Name);
                 if(g1.Name.contains('Learn') && g1.Name.contains('Complex') && !g1.Name.contains('Unassigned'))
                 {
                      learnclist.add(new SelectOption(g1.Name,g1.Name));
                      learncset.add(g1.Name);
                 }
                 else if(g1.Name.contains('Learn') && ((g1.Name.contains('Managed') && g1.Name.contains('Hosting')) || g1.Name.contains('MH')) && !g1.Name.contains('Unassigned'))
                 {    
                      learnhlist.add(new SelectOption(g1.Name,g1.Name));
                      learnhset.add(g1.Name);
                      learnsaaslist.add(new SelectOption(g1.Name,g1.Name));
                      learnsaasset.add(g1.Name);
                 }
                
                 else if(g1.Name.contains('Learn') && !g1.Name.contains('Unassigned'))
                 {
                      learnlist.add(new SelectOption(g1.Name,g1.Name));
                      learnset.add(g1.Name);
                      learnsaaslist.add(new SelectOption(g1.Name,g1.Name));
                      learnsaasset.add(g1.Name);
                      xpLorList.add(new SelectOption(g1.Name,g1.Name));
                      xpLorset.add(g1.Name);
                 }

                 else if(g1.Name.contains('ANGEL') && !g1.Name.contains('Unassigned'))  
                 {
                      angellist.add(new SelectOption(g1.Name,g1.Name));
                      angelset.add(g1.Name);
                      
                 }  
                 else if(g1.Name.contains('Transact') && !g1.Name.contains('Unassigned'))  
                 {
                      translist.add(new SelectOption(g1.Name,g1.Name));
                      transset.add(g1.Name);
                 }  
                 else if(g1.Name.contains('Xythos') && !g1.Name.contains('Unassigned'))   
                 {
                      xythoslist.add(new SelectOption(g1.Name,g1.Name));
                      xythosset.add(g1.Name);
                      
                 } 
                 else if(g1.Name.contains('Collaborate') && !g1.Name.contains('Unassigned'))   
                 {
                      collablist.add(new SelectOption(g1.Name,g1.Name));
                      collabset.add(g1.Name);
                      
                 } 
                 else if(g1.Name.contains('Analytics') && !g1.Name.contains('Unassigned'))   
                 {
                      AnalyticsList.add(new SelectOption(g1.Name,g1.Name));
                      Analyticsset.add(g1.Name);
                      
                 } 
                 else if(g1.Name.contains('Moodlerooms') && !g1.Name.contains('Unassigned'))   
                 {
                      Moodleroomslist.add(new SelectOption(g1.Name,g1.Name));
                      Moodleroomsset.add(g1.Name);
                      xpLorList.add(new SelectOption(g1.Name,g1.Name));
                      xpLorset.add(g1.Name);
                      
                 } 
                 else if(g1.Name.contains('CE/Vista') && g1.Name.contains('Managed') && g1.Name.contains('Hosting') && !g1.Name.contains('Unassigned')) 
                 {
                      cehlist.add(new SelectOption(g1.Name,g1.Name));
                      cehset.add(g1.Name);
                      
                 } 
                 else if(g1.Name.contains('CE/Vista') && !g1.Name.contains('Unassigned'))   
                 {
                      celist.add(new SelectOption(g1.Name,g1.Name));
                      ceset.add(g1.Name);
                 }                                 
            }
        }
        
      if(a.Learn_Queue__c != null && !learnset.contains(a.Learn_Queue__c))  
           learnlist.add(new SelectOption(a.Learn_Queue__c,a.Learn_Queue__c));
      if(a.Learn_SaaS_Queue__c != null && !learnsaasset.contains(a.Learn_SaaS_Queue__c))  
           learnsaaslist.add(new SelectOption(a.Learn_SaaS_Queue__c,a.Learn_SaaS_Queue__c));    
      if(a.Learn_Hosted_Queue__c != null && !learnhset.contains(a.Learn_Hosted_Queue__c))  
            learnhlist.add(new SelectOption(a.Learn_Hosted_Queue__c,a.Learn_Hosted_Queue__c));
      if(a.Learn_Complex_Queue__c != null && !learncset.contains(a.Learn_Complex_Queue__c))  
           learnclist.add(new SelectOption(a.Learn_Complex_Queue__c,a.Learn_Complex_Queue__c));      
      if(a.Xythos_Queue__c != null && !xythosset.contains(a.Xythos_Queue__c))  
           xythoslist.add(new SelectOption(a.Xythos_Queue__c,a.Xythos_Queue__c));
      if(a.Collaborate_Queue__c != null && !collabset.contains(a.Collaborate_Queue__c))  
           collablist.add(new SelectOption(a.Collaborate_Queue__c,a.Collaborate_Queue__c));
      if(a.Moodlerooms_Queue__c != null && !Moodleroomsset.contains(a.Moodlerooms_Queue__c))  
           Moodleroomslist.add(new SelectOption(a.Moodlerooms_Queue__c,a.Moodlerooms_Queue__c));
      if(a.Analytics_Queue__c != null && !Analyticsset.contains(a.Analytics_Queue__c))  
           AnalyticsList.add(new SelectOption(a.Analytics_Queue__c,a.Analytics_Queue__c));
      if(a.xpLor_Queue__c != null && !xpLorset.contains(a.xpLor_Queue__c))  
           xpLorList.add(new SelectOption(a.xpLor_Queue__c,a.xpLor_Queue__c));     

      if(a.Transact_Queue__c != null && !transset.contains(a.Transact_Queue__c))  
           translist.add(new SelectOption(a.Transact_Queue__c,a.Transact_Queue__c));
      if(a.Angel_Queue__c != null && !angelset.contains(a.Angel_Queue__c))  
           angellist.add(new SelectOption(a.Angel_Queue__c,a.Angel_Queue__c));
      if(a.CE_Vista_Queue__c != null && !ceset.contains(a.CE_Vista_Queue__c))  
           celist.add(new SelectOption(a.CE_Vista_Queue__c,a.CE_Vista_Queue__c));
      if(a.CE_Vista_Hosted__c != null && !cehset.contains(a.CE_Vista_Hosted__c))  
           cehlist.add(new SelectOption(a.CE_Vista_Hosted__c,a.CE_Vista_Hosted__c));               
                     
           
        
        ulist.add(new SelectOption('-None-','-None-'));
        
        Set<ID> profid = new Set<ID>();
        for(Profile p : [select ID,Name from Profile where Name LIKE '%SRV%' AND Name != 'SRV - BTBB User' ]){
            profid.add(p.ID);
        }
        
        for(List<User> u : [select ID,Name from User where IsActive = true AND ProfileID IN: profid ORDER By Name]){
            for(User u1 : u){
                ulist.add(new SelectOption(u1.Name,u1.Name));
                uname.add(u1.Name);
            }
        }
        
        if(a.Learn_Queue__c != null && uname.contains(a.Learn_Queue__c)){
             learnassignuser = false;
             learnassignqueue = true;
        }else{
             learnassignuser = true;
             learnassignqueue = false;
        }
        if(a.Learn_SaaS_Queue__c != null && uname.contains(a.Learn_SaaS_Queue__c)){
             learnsaasassignuser = false;
             learnsaasassignqueue = true;
        }else{
             learnsaasassignuser = true;
             learnsaasassignqueue = false;
        }
        
        if(a.Learn_Hosted_Queue__c != null && uname.contains(a.Learn_Hosted_Queue__c)){
             learnhostedassignuser = false;
             learnhostedassignqueue = true;
        }else{
             learnhostedassignuser = true;
             learnhostedassignqueue = false;
        }
        
        if(a.Learn_Complex_Queue__c != null && uname.contains(a.Learn_Complex_Queue__c)){
             learncompassignuser = false;
             learncompassignqueue = true;
        }else{
             learncompassignuser = true;
             learncompassignqueue = false;
        }
        
        if(a.CE_Vista_Queue__c != null && uname.contains(a.CE_Vista_Queue__c)){
             cevistassignuser = false;
             cevistassignqueue = true;
        }else{
             cevistassignuser = true;
             cevistassignqueue = false;
        }
        
         if(a.CE_Vista_Hosted__c != null && uname.contains(a.CE_Vista_Hosted__c)){
             cevistahostedassignuser = false;
             cevistahostedassignqueue = true;
        }else{
             cevistahostedassignuser = true;
             cevistahostedassignqueue = false;
        }
        
        if(a.Transact_Queue__c != null && uname.contains(a.Transact_Queue__c)){
             transassignuser = false;
             transassignqueue = true;
        }else{
             transassignuser = true;
             transassignqueue = false;
        }
        
        if(a.Xythos_Queue__c != null && uname.contains(a.Xythos_Queue__c)){
            xythosassignuser = false;
            xythosassignqueue = true;
        }else{
            xythosassignuser = true;
            xythosassignqueue = false;
        }
        
        if(a.Collaborate_Queue__c != null && uname.contains(a.Collaborate_Queue__c)){
            collabassignuser = false;
            collabassignqueue = true;
        }else{
            collabassignuser = true;
            collabassignqueue = false;
        }
        
        if(a.Moodlerooms_Queue__c != null && uname.contains(a.Moodlerooms_Queue__c)){
            Moodleroomsassignuser = false;
            Moodleroomsassignqueue = true;
        }else{
            Moodleroomsassignuser = true;
            Moodleroomsassignqueue = false;
        }


        if(a.Analytics_Queue__c != null && uname.contains(a.Analytics_Queue__c)){
            Analyticsassignuser = false;
            Analyticsassignqueue = true;
        }else{
            Analyticsassignuser = true;
            Analyticsassignqueue = false;
        }

        if(a.xpLor_Queue__c != null && uname.contains(a.xpLor_Queue__c)){
            xplorassignuser = false;
            xplorassignqueue = true;
        }else{
            xplorassignuser = true;
            xplorassignqueue = false;
        }
        
        if(a.Angel_Queue__c != null && uname.contains(a.Angel_Queue__c)){
            angelassignuser = false;
            angelassignqueue = true;
        }else{
            angelassignuser = true;
            angelassignqueue = false;
        }
    
    }
    
    public String learnq {get;set;}
    public String learnsaasq{get;set;}
    public String Collabq {get;set;}
    public String learnhq {get;set;}
    public String learncq {get;set;}
    public String cevistaq {get;set;}
    public String cevistah {get;set;}
    public String transq {get;set;}
    public String xythosq {get;set;}
    public String Moodleroomsq {get;set;}
    public String Analyticsq{get;set;}
    public String xpLorq{get;set;}
    public String angelq {get;set;}
     
    public List<SelectOption> learnlist = new List<SelectOption>();
    public List<SelectOption> learnsaaslist= new List<SelectOption>();
    public List<SelectOption> learnhlist = new List<SelectOption>();
    public List<SelectOption> learnclist = new List<SelectOption>();
    public List<SelectOption> angellist = new List<SelectOption>();
    public List<SelectOption> celist = new List<SelectOption>();
    public List<SelectOption> cehlist = new List<SelectOption>();
    public List<SelectOption> xythoslist = new List<SelectOption>();
    public List<SelectOption> Collablist = new List<SelectOption>();
    public List<SelectOption> Moodleroomslist = new List<SelectOption>();
    public List<SelectOption> AnalyticsList = new List<SelectOption>();
    public List<SelectOption> xpLorList = new List<SelectOption>(); 
    public List<SelectOption> translist = new List<SelectOption>();
    public List<SelectOption> ulist = new List<SelectOption>();
    
     public set<string> learnset = new set<String>();
     public set<string> learnsaasset = new set<String>();
     public set<string> learnhset = new set<String>();
     public set<string> learncset = new set<String>();
     public set<string> angelset = new set<String>();
     public set<string> ceset = new set<String>();
     public set<string> cehset = new set<String>();
     public set<string> xythosset = new set<String>();
     public set<string> Moodleroomsset = new set<String>();
     public set<string> Analyticsset = new set<String>();
     public set<string> xpLorset = new set<String>();
     public set<string> transset = new set<String>();
     public set<string> collabset = new set<String>();
     public set<string> uset = new set<String>();
    


    public List<SelectOption> getLearnList(){
        return learnlist;
    }

    public List<SelectOption> getLearnSaaSList(){
        return learnsaaslist;
    }
    
    public List<SelectOption> getLearnHList(){
        return learnhlist;
    }
    
    public List<SelectOption> getLearnCList(){
        return learnclist;
    }
    
    public List<SelectOption> getAngelList(){
        return angellist;
    }
    
    public List<SelectOption> getCEList(){
        return celist ;
    }
    
    public List<SelectOption> getCEHList(){
        return cehlist;
    }
    
    public List<SelectOption> getXythosList(){
        return xythoslist;
    }
    public List<SelectOption> getCollabList(){
        return collablist;
    }
    public List<SelectOption> getMoodleroomsList(){
        return MoodleroomsList ;
    }
    public List<SelectOption> getAnalyticsList(){
        return AnalyticsList ;
    }
    public List<SelectOption> getxpLorList(){
        return xpLorList ;
    }
   public List<SelectOption> getTransList(){
        return translist ;
    }
    
    public List<SelectOption> getUsers(){
        return ulist;
    }
    
    public Pagereference assigntoAccount(){
        Account a = [select ID,Complex_Hosting__c,Learn_Queue__c,Transact_Queue__c,Learn_Hosted_Queue__c,Learn_Complex_Queue__c,CE_Vista_Hosted__c,CE_Vista_Queue__c,Collaborate_Queue__c,Xythos_Queue__c,Angel_Queue__c,Moodlerooms_Queue__c,Learn_SaaS_Queue__c,Analytics_Queue__c,xpLor_Queue__c from Account where ID =: AccountID];
        if((learnq != null && learnq != '')||(a.Learn_Queue__c != null && (learnset.contains(a.Learn_Queue__c) || uname.contains(a.Learn_Queue__c)) ))
        a.Learn_Queue__c =  learnq;
        if((learnsaasq != null && learnsaasq != '')||(a.Learn_SaaS_Queue__c != null && (learnsaasset.contains(a.Learn_SaaS_Queue__c) || uname.contains(a.Learn_SaaS_Queue__c)) ))
        a.Learn_SaaS_Queue__c =  learnsaasq;
        if((transq != null && transq != '') ||(a.Transact_Queue__c!= null && (transset.contains(a.Transact_Queue__c) || uname.contains(a.Transact_Queue__c))))
        a.Transact_Queue__c = transq;
        if((xythosq != null && xythosq != '') ||(a.Xythos_Queue__c != null && (xythosset.contains(a.Xythos_Queue__c)|| uname.contains(a.Xythos_Queue__c))))
        a.Xythos_Queue__c = xythosq;
        if((collabq != null && collabq != '') ||(a.Collaborate_Queue__c != null && (collabset.contains(a.Collaborate_Queue__c)|| uname.contains(a.Collaborate_Queue__c))))
        a.Collaborate_Queue__c = collabq;
        if((Moodleroomsq != null && Moodleroomsq != '') ||(a.Moodlerooms_Queue__c != null && (Moodleroomsset.contains(a.Moodlerooms_Queue__c)|| uname.contains(a.Moodlerooms_Queue__c))))
        a.Moodlerooms_Queue__c = Moodleroomsq;

        if((Analyticsq!= null && Analyticsq != '') ||(a.Analytics_Queue__c != null && (Analyticsset.contains(a.Analytics_Queue__c)|| uname.contains(a.Analytics_Queue__c))))
        a.Analytics_Queue__c = Analyticsq;

        if((xpLorq!= null && xpLorq != '') ||(a.xpLor_Queue__c != null && (xpLorset.contains(a.xpLor_Queue__c)|| uname.contains(a.xpLor_Queue__c))))
        a.xpLor_Queue__c = xpLorq;


        if((angelq != null && angelq != '') ||(a.Angel_Queue__c != null && (angelset.contains(a.Angel_Queue__c)|| uname.contains(a.Angel_Queue__c))))
        a.Angel_Queue__c  = angelq;
        if((learnhq != null && learnhq != '') ||(a.Learn_Hosted_Queue__c != null && (learnhset.contains(a.Learn_Hosted_Queue__c)|| uname.contains(a.Learn_Hosted_Queue__c))))
        a.Learn_Hosted_Queue__c = learnhq; 
        if((learncq != null && learncq != '' )||(a.Learn_Complex_Queue__c != null && (learncset.contains(a.Learn_Complex_Queue__c)|| uname.contains(a.Learn_Complex_Queue__c))))
        a.Learn_Complex_Queue__c = learncq;
        if((cevistaq != null && cevistaq != '') ||(a.CE_Vista_Queue__c != null && (ceset.contains(a.CE_Vista_Queue__c)|| uname.contains(a.CE_Vista_Queue__c))))
        a.CE_Vista_Queue__c = cevistaq;
        if((cevistah != null && cevistah != '') ||(a.CE_Vista_Hosted__c != null && (cehset.contains(a.CE_Vista_Hosted__c)|| uname.contains(a.CE_Vista_Hosted__c))))
        a.CE_Vista_Hosted__c = cevistah;
        a.Complex_Hosting__c=complexhosting;
        update a;
        
        Pagereference p = new Pagereference('/'+AccountID);
        p.setredirect(true);
        return p;
    }
    
    public void learnselectuser(){
        learnassignuser = false;
        learnassignqueue = true;
    }

    
    public void learnselectqueue(){
        learnassignuser = true;
        learnassignqueue = false;
    }

    public void learnsaasselectuser(){
        learnsaasassignuser = false;
        learnsaasassignqueue = true;
    }

    public void learnsaasselectqueue(){
        learnsaasassignuser = true;
        learnsaasassignqueue = false;
    }
    
    public void learnhostedselectuser(){
        learnhostedassignuser = false;
        learnhostedassignqueue = true;
    }
    
    public void learnhostedselectqueue(){
        learnhostedassignuser = true;
        learnhostedassignqueue = false;
    }
    
    public void learncompselectuser(){
        learncompassignuser = false;
        learncompassignqueue = true;
    }
    
    public void learncompselectqueue(){
        learncompassignuser = true;
        learncompassignqueue = false;
    }
    
    public void cevistaselectuser(){
        cevistassignuser = false;
        cevistassignqueue = true;
    }
    
    public void cevistaselectqueue(){
        cevistassignuser = true;
        cevistassignqueue = false;
    }
    
    public void cevistahostedselectuser(){
        cevistahostedassignuser = false;
        cevistahostedassignqueue = true;
    }
    
    public void cevistahostedselectqueue(){
        cevistahostedassignuser = true;
        cevistahostedassignqueue = false;
    }
    
    public void angelselectuser(){
        angelassignuser = false;
        angelassignqueue = true;
    }
    
    public void angelselectqueue(){
        angelassignuser = true;
        angelassignqueue = false;
    }

    public void transselectuser(){
        transassignuser = false;
        transassignqueue = true;
    }
    
    public void transselectqueue(){
        transassignuser = true;
        transassignqueue = false;
    }    
    
   
    public void xythoselectuser(){
        xythosassignuser = false;
        xythosassignqueue = true;
    }
    
    public void xythoselectqueue(){
        xythosassignuser = true;
        xythosassignqueue = false;
    } 
    
    public void collabselectuser(){
        collabassignuser = false;
        collabassignqueue = true;
    }
    
    public void collabselectqueue(){
        collabassignuser = true;
        collabassignqueue = false;
    } 
    
    
    public void Moodleroomsselectuser(){
        Moodleroomsassignuser = false;
        Moodleroomsassignqueue = true;
    }
    
    public void Moodleroomsselectqueue(){
        Moodleroomsassignuser = true;
        Moodleroomsassignqueue = false;
    }

    public void Analyticsselectuser(){
        Analyticsassignuser = false;
        Analyticsassignqueue = true;
    }
    
    public void Analyticsselectqueue(){
        Analyticsassignuser = true;
        Analyticsassignqueue = false;
    }

    public void xpLorselectuser(){
        xplorassignuser = false;
        xplorassignqueue = true;
    }
    
    public void xpLorselectqueue(){
        xplorassignuser = true;
        xplorassignqueue = false;
    }
    
    private static testmethod void AssignQueuestoAccountTest(){
        Account ac = TestMethodUtility.createAccount();
        insert ac;
        
        ApexPages.CurrentPage().getParameters().Put('id',ac.ID);

        ApexPages.StandardController controller = new ApexPages.StandardController(ac);
        AssignQueuestoAccount aq = new AssignQueuestoAccount(controller);
        aq.getLearnList();
        aq.getLearnHList();
        aq.getLearnSaaSList();
        aq.getLearnCList();
        aq.getAngelList();
        aq.getCEList();
        aq.getCEHList();
        aq.getXythosList();
        aq.getMoodleroomsList();
        aq.getAnalyticsList();
        aq.getxpLorList();
        aq.getTransList();
        aq.getUsers();
        aq.learnselectuser();
        aq.learnselectqueue();
        aq.learnsaasselectuser();
        aq.learnsaasselectqueue();
        aq.cevistaselectuser();
        aq.cevistaselectqueue();
        aq.cevistahostedselectuser();
        aq.cevistahostedselectqueue();
        aq.angelselectuser();
        aq.angelselectqueue();
        aq.transselectuser();
        aq.transselectqueue();
        aq.xythoselectuser();
        aq.xythoselectqueue();
        aq.collabselectuser();
        aq.collabselectqueue();
        aq.Moodleroomsselectuser();
        aq.Moodleroomsselectqueue();
        aq.Analyticsselectuser();
        aq.Analyticsselectqueue();
        aq.xpLorselectuser();
        aq.xpLorselectqueue();
        aq.learnhostedselectuser();
        aq.learnhostedselectqueue();
        aq.learncompselectuser();
        aq.learncompselectqueue();
        aq.assigntoAccount();
        
        
    }  
}