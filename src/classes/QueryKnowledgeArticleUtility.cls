public with sharing class QueryKnowledgeArticleUtility 
{
    public static KnowledgeArticleWrapper queryAnnouncement(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Announcement__kav ann = [Select a.UrlName, a.Title, a.Summary, a.SourceId, /*a.Solution_Published_Date__c,*/ a.Solution_Number__c, a.SolutionID__c, a.Related_Link_s__c, 
                                            a.PublishStatus, a.Public_URL__c, a.Product__c, a.OwnerId, a.LastPublishedDate, a.LastModifiedDate, a.LastModifiedById, a.Language, 
                                            a.KnowledgeArticleId, a.Id, a.FirstPublishedDate, a.CreatedDate, a.CreatedById, a.ArticleNumber, a.ArchivedDate, a.ArchivedById, 
                                            a.Announcement_Details__c 
                                     From Announcement__kav a
                                     Where Id =: kav.Id];
            
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(ann.Id, ann.Title, ann.ArticleNumber, ann.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = ann.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(ann.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            
            for (Announcement__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Announcement__DataCategorySelection a
                                                            Where ParentId =: ann.Id])
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
            mainArticle.product = ann.Product__c;
            mainArticle.detail = ann.Announcement_Details__c;
            mainArticle.relatedLinks = ann.Related_Link_s__c;
            
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
        catch (Exception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryKnownIssue(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Known_Issue__kav ki = [Select k.UrlName, k.Title, k.Target_Release__c, k.Symptoms__c, k.Support_Incident__c, k.Summary, k.Steps_to_Replicate__c, k.SourceId, 
                                          /*k.Solution_Published_Date__c,*/ k.Solution_Number__c, k.SolutionID__c, k.Service_Packs__c, k.Resolution_Workaround__c, k.Release__c, 
                                          k.PublishStatus, k.Public_URL__c, k.Product__c, k.Patch_Versions__c, k.Patch_Information__c, k.Patch_Available__c, k.OwnerId, 
                                          k.Number_of_Clients_Reporting__c, k.LastPublishedDate, k.LastModifiedDate, k.LastModifiedById, k.Language, k.KnowledgeArticleId, 
                                          k.Issue_Description__c, k.Internal_Only_Notes__c, k.Id, k.FirstPublishedDate, k.CreatedDate, k.CreatedById, k.Cause__c, 
                                          k.Best_Practice_Information__c, k.ArticleNumber, k.ArchivedDate, k.ArchivedById 
                                   From Known_Issue__kav k
                                   Where Id =: kav.Id];
                                   
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(ki.Id, ki.Title, ki.ArticleNumber, ki.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = ki.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(ki.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            
            for (Known_Issue__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Known_Issue__DataCategorySelection a
                                                            Where ParentId =: ki.Id])
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
            mainArticle.product = ki.Product__c;
            mainArticle.release = ki.Release__c;
            mainArticle.versions = ki.Service_Packs__c;
            mainArticle.issueDescription = ki.Issue_Description__c;
            mainArticle.stepsToReproduce = ki.Steps_to_Replicate__c;
            mainArticle.symptoms = ki.Symptoms__c;
            mainArticle.cause = ki.Cause__c;
            mainArticle.resolutionWorkaround = ki.Resolution_Workaround__c;
            mainArticle.bestPracticeInformation = ki.Best_Practice_Information__c;
            mainArticle.targetRelease = ki.Target_Release__c;
            mainArticle.patchAvailable = ki.Patch_Available__c;
            mainArticle.patchVersions = ki.Patch_Versions__c;
            mainArticle.patchComments = ki.Patch_Information__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryOtherResource(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Other_Resource__kav other = [Select o.UrlName, o.Title, o.Summary, o.SourceId, /*o.Solution_Published_Date__c,*/ o.Solution_Number__c, o.SolutionID__c, o.Resource_Type__c, 
                                                o.Resource_Link__c, o.Resource_Description__c, o.Public_URL__c, o.Product__c, o.LastPublishedDate, o.LastModifiedDate, o.LastModifiedById, 
                                                o.Language, o.KnowledgeArticleId, o.Important_Information__c, o.Id, o.FirstPublishedDate, o.Download__c, o.CreatedDate, o.CreatedById, 
                                                o.ArticleNumber, o.ArchivedDate, o.ArchivedById 
                                         From Other_Resource__kav o
                                         Where Id =: kav.Id];
                                         
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(other.Id, other.Title, other.ArticleNumber, other.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = other.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(other.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Other_Resource__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Other_Resource__DataCategorySelection a
                                                            Where ParentId =: other.Id])
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
            mainArticle.product = other.Product__c;
            mainArticle.resourceType = other.Resource_Type__c;
            mainArticle.resourceDescription = other.Resource_Description__c;
            mainArticle.importantInformation = other.Important_Information__c;
            mainArticle.resourceLink = other.Resource_Link__c;
            mainArticle.download = other.Download__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryProductDocumentation(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Product_Documentation__kav pd = [Select p.UrlName, p.Title, p.Summary, p.SourceId, /*p.Solution_Published_Date__c,*/ p.Solution_Number__c, p.SolutionID__c, p.Service_Pack_s__c, 
                                                    p.Resource_Type__c, p.Release__c, p.Public_URL__c, p.Product__c, p.Patch_Versions__c, p.Patch_Available__c, p.LastPublishedDate, 
                                                    p.LastModifiedDate, p.LastModifiedById, p.Language, p.KnowledgeArticleId, p.Id, p.FirstPublishedDate, p.Document_Type__c, 
                                                    p.Document_Summary__c, p.Document_Link__c, p.Document_Details__c, p.CreatedDate, p.CreatedById, p.ArticleNumber, p.ArchivedDate, 
                                                    p.ArchivedById 
                                             From Product_Documentation__kav p
                                             Where Id =: kav.Id];
            
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(pd.Id, pd.Title, pd.ArticleNumber, pd.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = pd.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(pd.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Product_Documentation__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Product_Documentation__DataCategorySelection a
                                                            Where ParentId =: pd.Id])
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
            mainArticle.product = pd.Product__c;
            mainArticle.release = pd.Release__c;
            mainArticle.servicePacks = pd.Service_Pack_s__c;
            mainArticle.documentType = pd.Document_Type__c;
            mainArticle.documentSummary = pd.Document_Summary__c;
            mainArticle.documentDetail = pd.Document_Details__c;
            mainArticle.documentLink = pd.Document_Link__c;              
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryQuestionAnswer(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Question_Answer__kav qa = [Select q.UrlName, q.Title, q.Support_Incident__c, q.Summary, q.SourceId, /*q.Solution_Published_Date__c,*/ q.Solution_Number__c, q.SolutionID__c, 
                                              q.Service_Pack_s__c, q.Release__c, q.Question__c, q.Public_URL__c, q.Product__c, q.LastPublishedDate, q.LastModifiedDate, 
                                              q.LastModifiedById, q.Language, q.KnowledgeArticleId, q.Id, q.FirstPublishedDate, q.CreatedDate, q.CreatedById, q.ArticleNumber, 
                                              q.ArchivedDate, q.ArchivedById, q.Answer__c 
                                       From Question_Answer__kav q
                                       Where Id =: kav.Id];
                                       
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(qa.Id, qa.Title, qa.ArticleNumber, qa.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = qa.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(qa.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Question_Answer__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Question_Answer__DataCategorySelection a
                                                            Where ParentId =: qa.Id])
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
            mainArticle.product = qa.Product__c;
            mainArticle.release = qa.Release__c;
            mainArticle.servicePacks = qa.Service_Pack_s__c;
            mainArticle.question = qa.Question__c;
            mainArticle.answer = qa.Answer__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryRelease(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Release__kav r = [Select r.UrlName,  r.Upgrade_Paths__c, r.Title, r.Support_Policy__c, r.Summary, r.SourceId, /*r.Solution_Published_Date__c,*/ r.Solution_Number__c, 
                                     r.SolutionID__c, r.Release__c, r.Reference_Material__c, r.Public_URL__c, r.Product__c, r.OwnerId, r.Other_Information__c, r.LastPublishedDate, 
                                     r.LastModifiedDate, r.LastModifiedById, r.Language, r.KnowledgeArticleId, r.Id, r.Highlights__c, r.FirstPublishedDate, r.Download__c, r.CreatedDate, 
                                     r.CreatedById, r.ArticleNumber, r.ArchivedDate, r.ArchivedById, r.About__c 
                              From Release__kav r
                              Where Id =: kav.Id];
                              
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(r.Id, r.Title, r.ArticleNumber, r.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = r.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(r.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Release__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Release__DataCategorySelection a
                                                            Where ParentId =: r.Id])
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
            mainArticle.product = r.Product__c;
            mainArticle.release = r.Release__c;
            // Missing field mainArticle.servicePacks
            // Missing field mainArticle.upgradeInformation
            mainArticle.upgradePaths = r.Upgrade_Paths__c;
            // This field is missing mainArticle.productDocumentation
            mainArticle.productDocumentation = r.Highlights__c;
            mainArticle.referenceMaterial = r.Reference_Material__c;
            mainArticle.otherInformation = r.Other_Information__c;
            mainArticle.download = r.Download__c;
            mainArticle.upgradeInformation = r.About__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryMaintenanceRelease(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Maintenance_Release__kav mr = [Select m.UrlName, m.Upgrade_Paths__c, m.Title, m.Summary, m.SourceId, /*m.Solution_Published_Date__c,*/ m.Solution_Number__c, m.SolutionID__c, 
                                                  m.Service_Pack_s__c, m.Release__c, m.Release_Highlights__c, m.Release_Date__c, m.Related_Resources__c, m.Public_URL__c, m.Product__c, 
                                                  m.LastPublishedDate, m.LastModifiedDate, m.LastModifiedById, m.Language, m.KnowledgeArticleId, m.Id, m.FirstPublishedDate, m.CreatedDate, 
                                                  m.CreatedById, m.ArticleNumber, m.ArchivedDate, m.ArchivedById, m.Announcing__c, m.Accessing_the_Build__c 
                                           From Maintenance_Release__kav m
                                           Where Id =: kav.Id];
            
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(mr.Id, mr.Title, mr.ArticleNumber, mr.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = mr.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(mr.Solution_Published_Date__c);
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
            mainArticle.product = mr.Product__c;
            mainArticle.release = mr.Release__c;
            mainArticle.servicePacks = mr.Service_Pack_s__c;
            mainArticle.releaseDate = mr.Release_Date__c;
            mainArticle.announcing = mr.Announcing__c;
            mainArticle.releaseHighlights = mr.Release_Highlights__c;
            mainArticle.upgradePaths = mr.Upgrade_Paths__c;
            mainArticle.releaseResources = mr.Related_Resources__c;
            mainArticle.accessingTheBuild = mr.Accessing_the_Build__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryGeneralArticle(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            General_Article__kav ga = [Select g.UrlName, g.Title, g.Target_Release__c, g.Symptoms__c, g.Support_Incident__c, g.Summary, g.SourceId, /*g.Solution_Published_Date__c,*/ 
                                              g.Solution_Number__c, g.SolutionID__c, g.Service_Pack_s__c, g.Resolution_Workaround__c, g.Release__c, g.Public_URL__c, g.Product__c, 
                                              g.Patch_Versions__c, g.Patch_Information__c, g.Patch_Available__c, g.Number_of_Clients_Reporting__c, g.LastPublishedDate, g.LastModifiedDate, 
                                              g.LastModifiedById, g.Language, g.KnowledgeArticleId, g.Issue_Description__c, g.Id, g.FirstPublishedDate, g.CreatedDate, g.CreatedById, 
                                              g.Cause__c, g.Best_Practice_Information__c, g.ArticleNumber, g.ArchivedDate, g.ArchivedById 
                                       From General_Article__kav g
                                       Where Id =: kav.Id];
                                       
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(ga.Id, ga.Title, ga.ArticleNumber, ga.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = ga.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(ga.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (General_Article__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From General_Article__DataCategorySelection a
                                                            Where ParentId =: ga.Id])
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
            mainArticle.product = ga.Product__c;
            mainArticle.release = ga.Release__c;
            mainArticle.servicePacks = ga.Service_Pack_s__c;
            mainArticle.issueDescription = ga.Issue_Description__c;
            mainArticle.symptoms = ga.Symptoms__c;
            mainArticle.cause = ga.Cause__c;
            mainArticle.resolutionWorkaround = ga.Resolution_Workaround__c;
            mainArticle.bestPracticeInformation = ga.Best_Practice_Information__c;
            mainArticle.targetRelease = ga.Target_Release__c;
            mainArticle.patchAvailable = ga.Patch_Available__c;
            mainArticle.patchVersions = ga.Patch_Versions__c;
            mainArticle.patchComments = ga.Patch_Information__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper querySupportBulletin(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Support_Bulletin_Security_Advisory__kav sbsa = [Select s.UrlName, s.Type__c, s.Title, s.Summary, s.SourceId, /*s.Solution_Published_Date__c,*/ s.Solution_Number__c, 
                                                                   s.SolutionID__c, s.Public_URL__c, s.Product__c, s.Patch_Versions__c, s.Patch_Information__c, s.Patch_Available__c, 
                                                                   s.LastPublishedDate, s.LastModifiedDate, s.LastModifiedById, s.Language, s.KnowledgeArticleId, s.Id, 
                                                                   s.FirstPublishedDate, s.CreatedDate, s.CreatedById, s.Bulletin_Advisory_Information__c, s.ArticleNumber, s.ArchivedDate, 
                                                                   s.ArchivedById 
                                                            From Support_Bulletin_Security_Advisory__kav s
                                                            Where Id =: kav.Id];
                                                            
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(sbsa.Id, sbsa.Title, sbsa.ArticleNumber, sbsa.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = sbsa.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(sbsa.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Support_Bulletin_Security_Advisory__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Support_Bulletin_Security_Advisory__DataCategorySelection a
                                                            Where ParentId =: sbsa.Id])
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
            mainArticle.product = sbsa.Product__c;
            mainArticle.bulletinAdvisoryInformation = sbsa.Bulletin_Advisory_Information__c;
            mainarticle.typeC = sbsa.Type__c;
            mainArticle.patchAvailable = sbsa.Patch_Available__c;
            mainArticle.patchVersions = sbsa.Patch_Versions__c;
            mainArticle.patchComments = sbsa.Patch_Information__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper querySupportedTechnology(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Supported_Technologies__kav st = [Select s.UrlName, s.Upgrade_Paths__c, s.Title, s.Summary, s.SourceId, /*s.Solution_Published_Date__c,*/ s.Solution_Number__c, s.SolutionID__c, 
                                                     s.Service_Pack_s__c, s.Release__c, s.Public_URL__c, s.Product__c, s.Platform_Technologies__c, s.LastPublishedDate, s.LastModifiedDate, 
                                                     s.LastModifiedById, s.Language, s.KnowledgeArticleId, s.Id, s.FirstPublishedDate, s.CreatedDate, s.CreatedById, 
                                                     s.Client_Technologies__c, s.ArticleNumber, s.ArchivedDate, s.ArchivedById 
                                              From Supported_Technologies__kav s
                                              Where Id =: kav.Id];
                                              
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(st.Id, st.Title, st.ArticleNumber, st.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = st.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(st.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Supported_Technologies__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Supported_Technologies__DataCategorySelection a
                                                            Where ParentId =: st.Id])
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
            mainArticle.product = st.Product__c;
            mainArticle.release = st.Release__c;
            mainArticle.servicePacks = st.Service_Pack_s__c;
            mainArticle.platformTechnologies = st.Platform_Technologies__c;
            mainArticle.clientTechnologies = st.Client_Technologies__c;
            mainArticle.upgradePaths = st.Upgrade_Paths__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryTroubleshootingInformation(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Troubleshooting_Informational__kav ti = [Select t.UrlName, t.Title, t.Summary, t.SourceId, /*t.Solution_Published_Date__c,*/ t.Solution_Number__c, t.SolutionID__c, 
                                                            t.Service_Pack_s__c, t.Release__c, t.Related_System_Information__c, t.Public_URL__c, t.Product__c, t.LastPublishedDate, 
                                                            t.LastModifiedDate, t.LastModifiedById, t.Language, t.KnowledgeArticleId, t.Introduction__c, t.Functionality__c, 
                                                            t.FirstPublishedDate, t.Evaluating_Related_System_Info__c, t.CreatedDate, t.CreatedById, t.Common_Issues__c, t.ArticleNumber, 
                                                            t.ArchivedDate, t.ArchivedById 
                                                     From Troubleshooting_Informational__kav t
                                                     Where Id =: kav.Id];
                                                     
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(ti.Id, ti.Title, ti.ArticleNumber, ti.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = ti.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(ti.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Troubleshooting_Informational__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Troubleshooting_Informational__DataCategorySelection a
                                                            Where ParentId =: ti.Id])
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
            mainArticle.product = ti.Product__c;
            mainArticle.release = ti.Release__c;
            mainArticle.servicePacks = ti.Service_Pack_s__c;
            mainArticle.introduction = ti.Introduction__c;
            mainArticle.functionality = ti.Functionality__c;
            mainArticle.relatedSystemInformation = ti.Related_System_Information__c;
            mainArticle.evaluatingRelatedSystemInfo = ti.Evaluating_Related_System_Info__c;
            mainArticle.commonIssues = ti.Common_Issues__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static KnowledgeArticleWrapper queryBlackboardClientProgram(String articleType, KnowledgeArticleVersion kav)
    {
        try
        {
            Blackboard_Client_Program__kav bcp = [Select b.UrlName, b.Title, b.Summary, b.SourceId, /*b.Solution_Published_Date__c,*/ b.Solution_Number__c, b.SolutionID__c, b.Section_4__c, 
                                                         b.Section_3__c, b.Section_2__c, b.Section_1__c, b.Public_URL__c, b.Product__c, b.LastPublishedDate, b.LastModifiedDate, 
                                                         b.LastModifiedById, b.Language, b.KnowledgeArticleId, b.Id, b.FirstPublishedDate, b.CreatedDate, b.CreatedById, b.ArticleNumber, 
                                                         b.ArchivedDate, b.ArchivedById 
                                                  From Blackboard_Client_Program__kav b
                                                  Where Id =: kav.Id];
            
            KnowledgeArticleWrapper mainArticle = new KnowledgeArticleWrapper(bcp.Id, bcp.Title, bcp.ArticleNumber, bcp.KnowledgeArticleId);
            mainArticle.articleType = articleType;
            mainArticle.lastKnowledgePublishedDate = bcp.LastPublishedDate;
            //mainArticle.lastSolutionPublishedDate = Datetime.valueOf(bcb.Solution_Published_Date__c);
            mainArticle.dataCategoryMap = new map<String, list<String>>();
            for (Blackboard_Client_Program__DataCategorySelection dcs : [Select a.SystemModstamp, a.ParentId, a.IsDeleted, a.Id, a.DataCategoryName, a.DataCategoryGroupName, a.CreatedDate, a.CreatedById 
                                                            From Blackboard_Client_Program__DataCategorySelection a
                                                            Where ParentId =: bcp.Id])
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
            mainArticle.product = bcp.Product__c;
            mainArticle.field1 = bcp.Section_1__c;
            mainArticle.field2 = bcp.Section_2__c;
            mainArticle.field3 = bcp.Section_3__c;
            mainArticle.field4 = bcp.Section_4__c;
            return mainArticle;
        }
        catch (Queryexception e)
        {
            return null;
        }
    }
    
    public static list<KnowledgeArticleWrapper> queryRelatedKnownIssueList(KnowledgeArticleWrapper kaw)
    {
        String categoryFilter = '';
        list<KnowledgeArticleWrapper> kawList;
        KnowledgeArticleWrapper mainArticle;
        
        if (kaw.dataCategoryMap != null && !kaw.dataCategoryMap.isEmpty())
        {
            for (String s : kaw.dataCategoryMap.keySet())
            {
                for (String s1 : kaw.dataCategoryMap.get(s))
                {
                    if (s == 'Version')
                    {
                        if (categoryFilter == '')
                        {
                            categoryFilter = s + '__c BELOW ' + s1 +'__c';
                        } 
                        else 
                        {
                            categoryFilter = categoryFilter + ' AND ' + s + '__c BELOW ' + s1  +'__c';
                        }
                        break;
                    }
                }
            }
            
            kawList = QueryKnowledgeArticleTypeUtility.queryKnownIssue(null, categoryFilter);
            system.debug(kawList);
        }
        
        return kawList;
    }
    
    public static list<KnowledgeArticleWrapper> queryResolvedIssuesList(KnowledgeArticleWrapper kaw)
    {
        String categoryFilter = '';
        list<KnowledgeArticleWrapper> kawList;
        KnowledgeArticleWrapper mainArticle;
        String tempCatName, tempName;
        system.debug('Here');
        if (kaw.versions != null)
        {
            system.debug(LoggingLevel.INFO, 'There');
            for (String s : kaw.versions.split(','))
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
                categoryFilter = 'Planned_First_Fix_Release__c AT ' + tempName + '__c';
                break;
            }
            
            kawList = QueryKnowledgeArticleTypeUtility.queryKnownIssue(null, categoryFilter);
            system.debug(kawList);
        }
        
        return kawList;
    }
    
    public static list<KnowledgeArticleWrapper> queryServicePackArticleList(KnowledgeArticleWrapper kaw)
    {
        String categoryFilter = '';
        list<KnowledgeArticleWrapper> kawList;
        
        if (kaw.dataCategoryMap != null && !kaw.dataCategoryMap.isEmpty())
        {
            for (String s : kaw.dataCategoryMap.keySet())
            {
                for (String s1 : kaw.dataCategoryMap.get(s))
                {
                    if (s == 'Version')
                    {
                        if (categoryFilter == '')
                        {
                            categoryFilter = s + '__c BELOW ' + s1 +'__c';
                        } 
                        else 
                        {
                            categoryFilter = categoryFilter + ' AND ' + s + '__c BELOW ' + s1  +'__c';
                        }
                        break;
                    }
                }
            }
            
            kawList = QueryKnowledgeArticleTypeUtility.queryMaintenanceRelease(null, categoryFilter);
        }
        return kawList;
    }
}