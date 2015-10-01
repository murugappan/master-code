global class NotifyKnowledgeFollowersBatch implements Database.Batchable<sObject>
{
    public string InstanceURL = URL.getSalesforceBaseUrl().toExternalForm();
    public string SiteURL;
    public Id batchId {get; set;} 
    public String className {get; set;}
    public Datetime now = system.now();
    public Datetime lastEmail = now.addDays(-1);
    public String query = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true AND LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
    public String LearnQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c ';
    public String AngelQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW ANGEL__c ';
    public String CEVistaQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true And  LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c ';
    public String XythosQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c ';
    public String CollaborateQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Collaborate__c ';     
    public String MoodleroomsQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Moodlerooms__c ';  
    public String AnalyticsQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Analytics__c '; 
    public String xpLorQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
    lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW xpLor__c ';               
    private map<String, String> prefixLabelMap;
    private map<String,Schema.SOBjectType> globalDescribeMap = Schema.getGlobalDescribe();
    map<String, KnowledgeArticleWrapper> kavMap = new map<string, KnowledgeArticleWrapper>();
    map<String, list<articleproductwrapper>> articleMap = new map<String, list<articleproductwrapper>>();
    map<id,KnowledgeArticleVersion> kavlistmap = new map<id,KnowledgeArticleVersion>();
    public class articleproductwrapper
    {
        public knowledgearticleversion kv;
        public string prd;
        public knowledgearticlewrapper kw;
        public articleproductwrapper(string product,knowledgearticlewrapper kaw,knowledgearticleversion kav)
        {
            prd=product;
            kv=kav;
            kw=kaw;
        }
    }
    private void loadArticleTypes()
    {
        list<String> articleTypeNameList = new list<String>();
        prefixLabelMap = new map<String, String>();

        for (String s : globalDescribeMap.keySet()) 
        {
            if (s.endswith('__ka')) 
            {
                articleTypeNameList.add(s);
            }
        }

        articleTypeNameList.sort();

        for (String s : articleTypeNameList)
        {
            Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
            prefixLabelMap.put(r.getKeyPrefix(), r.getLabel());
        }
    }
    global NotifyKnowledgeFollowersBatch(integer n)
    {
        lastEmail = now.addDays(-n);
        system.debug(lastemail);
        query = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true AND LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
        LearnQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Learn__c ';
        AngelQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW ANGEL__c ';
        CEVistaQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\' And IsVisibleInCsp=true And  LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW CE_Vista__c ';
        XythosQuery = 'Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Xythos__c ';
        CollaborateQuery='Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Collaborate__c';
        MoodleroomsQuery='Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Moodlerooms__c '; 
        AnalyticsQuery='Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW Analytics__c '; 
        xpLorQuery='Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus = \'Online\' And Language = \'en_US\'And IsVisibleInCsp=true  And LastPublishedDate >= ' + 
        lastEmail.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')+' WITH DATA CATEGORY Version__c ABOVE_OR_BELOW xpLor__c ';   

        if(InstanceURL.contains('na5') || InstanceURL.contains('http://blackboard.force.com') || InstanceURL.contains('https://blackboard.secure.force.com') ||InstanceURL.containsignorecase('blackboard.my.salesforce'))
            SiteURL = 'https://blackboard.secure.force.com';
        else if(InstanceURL.contains('cs1') || InstanceURL.contains('blackboard.qax') || InstanceURL.contains('qax-blackboard'))
            SiteURL = 'http://blackboard.qax.cs1.force.com';
        else if(InstanceURL.contains('cs12') || InstanceURL.contains('blackboard.dvx')|| InstanceURL.contains('dvx-blackboard'))
            SiteURL = 'http://blackboard.dvx.cs1.force.com';
        else
            SiteURL = 'http://blackboard.force.com';
        loadArticleTypes();
        map<string,list<KnowledgeArticleWrapper>> scopemap = new map<string,list<KnowledgeArticleWrapper>>();
        map<string,set<id>> ProductArticlemap= new map<string,set<id>>();
        list<KnowledgeArticleVersion> ArticleList= new list<KnowledgeArticleVersion>();
        //Individual Articles by Product
        list<KnowledgeArticleVersion> Learnscope= Database.query(Learnquery);
        ProductArticlemap.put('Learn',new map<id,KnowledgeArticleVersion>(Learnscope).keyset());
        ArticleList.addall(Learnscope);
        Learnscope.clear();

        list<KnowledgeArticleVersion> Angelscope= Database.query(Angelquery);
        ProductArticlemap.put('ANGEL',new map<id,KnowledgeArticleVersion>(Angelscope).keyset());
        ArticleList.addall(Angelscope);
        Angelscope.clear();

        list<KnowledgeArticleVersion> CEVistascope= Database.query(CEVistaquery);
        ProductArticlemap.put('CE/Vista',new map<id,KnowledgeArticleVersion>(CEVistascope).keyset());
        ArticleList.addall(CEVistascope);
        CEVistascope.clear();

        list<KnowledgeArticleVersion> Xythosscope= Database.query(Xythosquery);
        ProductArticlemap.put('Xythos',new map<id,KnowledgeArticleVersion>(Xythosscope).keyset());
        ArticleList.addall(Xythosscope);
        Xythosscope.clear();


        list<KnowledgeArticleVersion> Collaboratescope= Database.query(Collaboratequery);
        ProductArticlemap.put('Collaborate',new map<id,KnowledgeArticleVersion>(Collaboratescope).keyset());
        ArticleList.addall(Collaboratescope);
        Collaboratescope.clear();

        list<KnowledgeArticleVersion> Moodleroomsscope= Database.query(Moodleroomsquery);
        ProductArticlemap.put('Moodlerooms',new map<id,KnowledgeArticleVersion>(Moodleroomsscope).keyset());
        ArticleList.addall(Moodleroomsscope);
        Moodleroomsscope.clear();

        list<KnowledgeArticleVersion> Analyticsscope= Database.query(Analyticsquery);
        ProductArticlemap.put('Analytics',new map<id,KnowledgeArticleVersion>(Analyticsscope).keyset());
        ArticleList.addall(Analyticsscope);
        Analyticsscope.clear();

        list<KnowledgeArticleVersion> xpLorscope= Database.query(xpLorQuery);
        ProductArticlemap.put('xpLor',new map<id,KnowledgeArticleVersion>(xpLorscope).keyset());
        ArticleList.addall(xpLorscope);
        xpLorscope.clear();
         kavlistmap = new map<id,KnowledgeArticleVersion>([Select Id, Title,lastpublisheddate, KnowledgeArticleId,ArticleNumber,Summary  From KnowledgeArticleVersion Where PublishStatus ='Online' And Language ='en_US' and (Id IN:ArticleList) ]);
        list<KnowledgeArticleWrapper> ArticleListWrapper= QueryKnowledgeArticleListUtility.createlist(kavlistmap.values(),null);
   
       
        String prefix;

        for(KnowledgeArticleWrapper kaw:ArticleListWrapper)
        {
            if (kaw.KnowledgeArticleId != null)
            {
                if(kavMap!=null && !kavMap.containsKey(kaw.KnowledgeArticleId))
                    kavMap.put(kaw.KnowledgeArticleId, kaw);
                for( string product: ProductArticlemap.keyset())
                {
                     if(ProductArticlemap.get(product).contains(kaw.articleId))
                     {
                        if (prefixLabelMap != null)
                        {
                            prefix = kaw.KnowledgeArticleId;
                            prefix = prefix.substring(0, 3);
                            if (prefixLabelMap.containsKey(prefix))
                            {
                                if (articleMap.containsKey(prefixLabelMap.get(prefix)))
                                {
                                    articleMap.get(prefixLabelMap.get(prefix)).add(new articleproductwrapper(product,kaw,kavlistmap.get(kaw.articleid)));
                                }
                                else
                                {
                                    articleMap.put(prefixLabelMap.get(prefix), new articleproductwrapper[]{new articleproductwrapper(product,kaw,kavlistmap.get(kaw.articleid))});
                                }
                            }
                        }
                     }
                }
            }
        }
        



    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {

        //string followersquery='Select Id, Type__c, Following_Key__c, User__c,product__c From Knowledge_Follow__c Where Following_Key__c IN :kavMap.keySet() OR Following_Key__c IN :articleMap.keySet()';
        if(test.isrunningtest())
        {
            return Database.getQueryLocator([Select Id, Type__c, Following_Key__c, User__c,product__c,Last_Email_Time__c From Knowledge_Follow__c Where Following_Key__c IN :kavMap.keySet() OR Following_Key__c IN :articleMap.keySet() limit 50]);
        }
        else
        {
            return Database.getQueryLocator([Select Id, Type__c, Following_Key__c, User__c,product__c,Last_Email_Time__c From Knowledge_Follow__c Where Following_Key__c IN :kavMap.keySet() OR Following_Key__c IN :articleMap.keySet()]);
        }
    }


    // The executeBatch method is called for each chunk of records returned from start.   
    // This method must be global. 
    global void execute(Database.BatchableContext BC,List<Knowledge_Follow__c> followersscope)
    {
        system.debug( 'knowledgefollow---'+followersscope);
        system.debug( 'kavmap---'+kavmap);
        system.debug( 'articlemap---'+articleMap);
        //     try{
        Email__c newEmail;
        list<Email__c> sendEmailList = new list<Email__c>();
        for (Knowledge_Follow__c kf:followersscope)
        {
            if (articleMap.containsKey(kf.Following_Key__c))
            {
                newEmail = new Email__c();
                newEmail.User__c = kf.User__c;
                newEmail.Subject__c = 'New or Updated '+ kf.product__c+' '+ kf.Following_Key__c+' Article(s)';
                newEmail.Body__c = ''; 
                if(articleMap.get(kf.Following_Key__c)!=null && !articleMap.get(kf.Following_Key__c).isempty())
                {

                    for (articleproductwrapper ap : articleMap.get(kf.Following_Key__c))
                    {
                        if(ap.prd== kf.product__c)
                        {

                            if(kf.Last_Email_Time__c == null || ap.kv.lastpublisheddate > kf.Last_Email_Time__c)
                            {   
                                if(newEmail.body__c==null||newEmail.body__c=='')
                                    newEmail.Body__c='You are receiving this message because the following '+kf.product__c +' '+kf.Following_Key__c+' articles have been created or updated:<br/><br/>';

                                newEmail.Body__c += 'Article #: '+ap.kv.ArticleNumber+'<br/>'+ 
                                        'Article Title: '+ap.kv.Title+'<br/>'+ 
                                        'Article Summary: '+ap.kv.Summary+'<br/>'+
                                        'Relevant Version(s):'+'<br/>'+
                                         ap.kw.versions.replace(',','<br/>')+'<br/>'+
                                        'Link to Article: '+'<a href="'+SiteURL+'/btbb_articleview?id='+ap.kv.KnowledgeArticleId+'" >Article Link </a><br/><br/>';
                            }                    
                        }                   
                    }

                }

                if(newEmail.Body__c !=null && newEmail.Body__c!= '')
                {
                    newEmail.Body__c+='<br/><br/><span style="font-size:1em">If you wish to unsubscribe or manage your subscriptions, please <a href="'+SiteURL+'/btbb_mysubscriptions">click here</a></span>';
                    kf.Last_Email_Time__c=system.now();
                    sendEmailList.add(newEmail);
                }
            }
            else if (kavMap.containsKey(kf.Following_Key__c))
            {
                if(kf.Last_Email_Time__c == null|| kavMap.get(kf.Following_Key__c).lastpublisheddate>kf.Last_Email_Time__c  )
                {
                    newEmail = new Email__c();
                    newEmail.User__c = kf.User__c;
                    newEmail.Subject__c = 'Update to Article #'+kavMap.get(kf.Following_Key__c).ArticleNumber+': '+kavlistmap.get(kavMap.get(kf.Following_Key__c).articleid).title;
                    newEmail.Body__c = 'You are receiving this message because the following article to which you have subscribed has been updated:<br/><br/>' +
                            'Article #: '+kavMap.get(kf.Following_Key__c).ArticleNumber+'<br/>'+ 
                            'Article Title: '+kavlistmap.get(kavMap.get(kf.Following_Key__c).articleid).title+'<br/>'+
                            'Article Summary: '+kavlistmap.get(kavMap.get(kf.Following_Key__c).articleid).Summary+'<br/>'+
                            'Relevant Version(s):'+'<br/>'+
                             kavMap.get(kf.Following_Key__c).versions.replace(',','<br/>')+'<br/>'+
                            'Link to Article: '+'<a href="'+SiteURL+'/btbb_articleview?id='+kavMap.get(kf.Following_Key__c).KnowledgeArticleId+'" >Article Link </a><br/><br/>';
                    newEmail.Body__c+='<br/><br/><span style="font-size:1em">If you wish to unsubscribe or manage your subscriptions, please <a href="'+SiteURL+'/btbb_mysubscriptions">click here</a></span>';
                    sendEmailList.add(newEmail);
                    kf.Last_Email_Time__c=system.now();
                }
            }


        }

        system.debug('sendmaillist--'+sendEmailList);
        insert sendEmailList;
        update followersscope;
        /*      }
        catch(exception e)
        {
            system.debug( 'error---'+e);
        }*/
    }

    global void finish(Database.BatchableContext BC){

        // Get the ID of the AsyncApexJob representing this batch job 
        // from Database.BatchableContext.         
        // Query the AsyncApexJob object to retrieve the current job's information. 
        AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email From AsyncApexJob Where Id =: BC.getJobId()];

        // Send an email to the Apex job's submitter notifying of job completion.
        if (a.NumberOfErrors > 0 ||test.isRunningTest())
        { 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            list<String> toAddresses = new String[]{a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Batch Apex NotifyKnowledgeFollowersBatch ' + a.Status);
            mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
                    ' batches with '+ a.NumberOfErrors + ' failures.');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    }
}