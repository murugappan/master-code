public with sharing class QueryKnowledgeArticleListUtilityPDF {
    
    public static list<KnowledgeArticleWrapperPDF> createList(list<KnowledgeArticleVersion> kavList, String selectedArticleTypes)
    {
        list<KnowledgeArticleWrapperPDF> wrapperList = new list<KnowledgeArticleWrapperPDF>();
        if (kavList != null && !kavList.isEmpty())
        {
            map<Id, KnowledgeArticleVersion> kavMap = new map<Id, KnowledgeArticleVersion>(kavList);
            
            if (selectedArticleTypes != null && selectedArticleTypes != '')
            {
                if (selectedArticleTypes.contains('announcement'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryAnnouncement('Announcement', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('blackboard_client_program'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryBlackboardClientProgram('Blackboard Client Program', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('general_article'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryGeneralArticle('General Article', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('known_issue'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryKnownIssue('Known Issue', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('maintenance_release'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryMaintenanceRelease('Maintenance Release', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('other_resource'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryOtherResource('Other Resource', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('product_documentation'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryProductDocumentation('Product Documentation', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('question_answer'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryQuestionAnswer('Question/Answer', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('release'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryRelease('Release', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('support_bulletin'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.querySupportBulletin('Support Bulletin', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('supported_technology'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.querySupportedTechnology('Supported Technology', kavMap.keySet()));
                }
                if (selectedArticleTypes.contains('troubleshooting_information'))
                {
                    wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryTroubleshootingInformation('Troubleshooting Information', kavMap.keySet()));
                }
            }
            else
            {
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryAnnouncement('Announcement', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryBlackboardClientProgram('Blackboard Client Program', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryGeneralArticle('General Article', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryKnownIssue('Known Issue', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryMaintenanceRelease('Maintenance Release', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryOtherResource('Other Resource', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryProductDocumentation('Product Documentation', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryQuestionAnswer('Question/Answer', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryRelease('Release', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.querySupportBulletin('Support Bulletin', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.querySupportedTechnology('Supported Technology', kavMap.keySet()));
                wrapperList.addAll(QueryKnowledgeArticleListUtilityPDF.queryTroubleshootingInformation('Troubleshooting Information', kavMap.keySet()));
            }
        }
        return wrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryAnnouncement(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Announcement__kav> kavMap = new map<Id, Announcement__kav>([Select a.Title, a.LastPublishedDate,a.Solution_Published_Date__c, 
                                                                                   a.KnowledgeArticleId, a.Id, a.ArticleNumber
                                                                            From Announcement__kav a
                                                                            Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Announcement__DataCategorySelection>> dcsMap = new map<Id, list<Announcement__DataCategorySelection>>();
            
            for (Announcement__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                            From Announcement__DataCategorySelection a
                                                            Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Announcement__DataCategorySelection[]{dcs});
                }
            }
            
            for (Announcement__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Announcement__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryKnownIssue(String articleType, set<Id> kavIdSet)
    {
        transient list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Known_Issue__kav> kavMap = new map<Id, Known_Issue__kav>([Select k.Title, k.Target_Release__c,k.Release__c,k.Patch_Available__c, k.LastPublishedDate, k.KnowledgeArticleId, 
                                                                                 k.Id, k.ArticleNumber,
                                                                                 k.Solution_Published_Date__c
                                                                          From Known_Issue__kav k 
                                                                          Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Known_Issue__DataCategorySelection>> dcsMap = new map<Id, list<Known_Issue__DataCategorySelection>>();
            
            for (Known_Issue__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                           From Known_Issue__DataCategorySelection a
                                                           Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Known_Issue__DataCategorySelection[]{dcs});
                }
            }
            
            for (Known_Issue__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Known_Issue__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                mainArticle.targetRelease = k.Target_Release__c;
                mainArticle.patchAvailable = k.Patch_Available__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryOtherResource(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Other_Resource__kav> kavMap = new map<Id, Other_Resource__kav>([Select o.Title,o.LastPublishedDate, o.KnowledgeArticleId,o.Id, 
                                                                                       o.FirstPublishedDate,o.ArticleNumber,o.Solution_Published_Date__c
                                                                                From Other_Resource__kav o
                                                                                Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Other_Resource__DataCategorySelection>> dcsMap = new map<Id, list<Other_Resource__DataCategorySelection>>();
            
            for (Other_Resource__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                              From Other_Resource__DataCategorySelection a
                                                              Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Other_Resource__DataCategorySelection[]{dcs});
                }
            }
            
            for (Other_Resource__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Other_Resource__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryProductDocumentation(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Product_Documentation__kav> kavMap = new map<Id, Product_Documentation__kav>([Select p.Title, p.Solution_Published_Date__c,p.Release__c,p.LastPublishedDate, p.KnowledgeArticleId, p.Id, 
                                                                                                     p.ArticleNumber
                                                                                              From Product_Documentation__kav p 
                                                                                              Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Product_Documentation__DataCategorySelection>> dcsMap = new map<Id, list<Product_Documentation__DataCategorySelection>>();
            
            for (Product_Documentation__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                                     From Product_Documentation__DataCategorySelection a 
                                                                     Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Product_Documentation__DataCategorySelection[]{dcs});
                }
            }
            
            for (Product_Documentation__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Product_Documentation__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryQuestionAnswer(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Question_Answer__kav> kavMap = new map<Id, Question_Answer__kav>([Select q.Title,  q.Solution_Published_Date__c, q.Release__c, 
                                                                                         q.LastPublishedDate, q.KnowledgeArticleId, q.Id, q.ArticleNumber, 
                                                                                         q.Answer__c 
                                                                                  From Question_Answer__kav q 
                                                                                  Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Question_Answer__DataCategorySelection>> dcsMap = new map<Id, list<Question_Answer__DataCategorySelection>>();
            
            for (Question_Answer__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                               From Question_Answer__DataCategorySelection a 
                                                               Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Question_Answer__DataCategorySelection[]{dcs});
                }
            }
            
            for (Question_Answer__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Question_Answer__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryRelease(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Release__kav> kavMap = new map<Id, Release__kav>([Select r.Title,r.Solution_Published_Date__c, 
                                                                         r.Release__c, r.LastPublishedDate, 
                                                                         r.KnowledgeArticleId, r.Id,r.ArticleNumber 
                                                                  From Release__kav r 
                                                                  Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Release__DataCategorySelection>> dcsMap = new map<Id, list<Release__DataCategorySelection>>();
            
            for (Release__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                       From Release__DataCategorySelection a 
                                                       Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Release__DataCategorySelection[]{dcs});
                }
            }
            
            for (Release__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Release__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryMaintenanceRelease(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Maintenance_Release__kav> kavMap = new map<Id, Maintenance_Release__kav>([Select m.Title,m.Solution_Published_Date__c, 
                                                                                                  m.Release__c, m.LastPublishedDate, m.KnowledgeArticleId, m.Id, 
                                                                                                 m.ArticleNumber  
                                                                                          From Maintenance_Release__kav m 
                                                                                          Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Maintenance_Release__DataCategorySelection>> dcsMap = new map<Id, list<Maintenance_Release__DataCategorySelection>>();
            
            for (Maintenance_Release__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                                   From Maintenance_Release__DataCategorySelection a 
                                                                   Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Maintenance_Release__DataCategorySelection[]{dcs});
                }
            }
            
            for (Maintenance_Release__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Maintenance_Release__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryGeneralArticle(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, General_Article__kav> kavMap = new map<Id, General_Article__kav>([Select g.Title, g.Target_Release__c, g.Solution_Published_Date__c,
                                                                                         g.Release__c, g.Product__c, g.Patch_Available__c, g.LastPublishedDate, g.KnowledgeArticleId, 
                                                                                         g.Id,
                                                                                         g.ArticleNumber
                                                                                  From General_Article__kav g 
                                                                                  Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<General_Article__DataCategorySelection>> dcsMap = new map<Id, list<General_Article__DataCategorySelection>>();
            
            for (General_Article__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                               From General_Article__DataCategorySelection a
                                                               Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new General_Article__DataCategorySelection[]{dcs});
                }
            }
            
            for (General_Article__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (General_Article__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                mainArticle.targetRelease = k.Target_Release__c;
                mainArticle.patchAvailable = k.Patch_Available__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> querySupportBulletin(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Support_Bulletin_Security_Advisory__kav> kavMap = new map<Id, Support_Bulletin_Security_Advisory__kav>([Select s.Title,s.Solution_Published_Date__c, 
                                                                                                                               s.Patch_Available__c, s.LastPublishedDate, s.KnowledgeArticleId, 
                                                                                                                               s.Id,s.ArticleNumber
                                                                                                                        From Support_Bulletin_Security_Advisory__kav s 
                                                                                                                        Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Support_Bulletin_Security_Advisory__DataCategorySelection>> dcsMap = new map<Id, list<Support_Bulletin_Security_Advisory__DataCategorySelection>>();
            
            for (Support_Bulletin_Security_Advisory__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                                                  From Support_Bulletin_Security_Advisory__DataCategorySelection a 
                                                                                  Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Support_Bulletin_Security_Advisory__DataCategorySelection[]{dcs});
                }
            }
            
            for (Support_Bulletin_Security_Advisory__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Support_Bulletin_Security_Advisory__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                
                mainArticle.patchAvailable = k.Patch_Available__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> querySupportedTechnology(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Supported_Technologies__kav> kavMap = new map<Id, Supported_Technologies__kav>([Select s.Title, s.Solution_Published_Date__c, 
                                                                                                        s.Release__c,s.LastPublishedDate, s.KnowledgeArticleId, s.Id, 
                                                                                                       s.ArticleNumber
                                                                                                From Supported_Technologies__kav s 
                                                                                                Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Supported_Technologies__DataCategorySelection>> dcsMap = new map<Id, list<Supported_Technologies__DataCategorySelection>>();
            
            for (Supported_Technologies__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                                      From Supported_Technologies__DataCategorySelection a 
                                                                      Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Supported_Technologies__DataCategorySelection[]{dcs});
                }
            }
            
            for (Supported_Technologies__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Supported_Technologies__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryTroubleshootingInformation(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Troubleshooting_Informational__kav> kavMap = new map<Id, Troubleshooting_Informational__kav>([Select t.Title, t.Solution_Published_Date__c, 
                                                                                                                     t.Release__c, t.LastPublishedDate, t.KnowledgeArticleId,t.id,
                                                                                                                     t.ArticleNumber
                                                                                                              From Troubleshooting_Informational__kav t 
                                                                                                              Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Troubleshooting_Informational__DataCategorySelection>> dcsMap = new map<Id, list<Troubleshooting_Informational__DataCategorySelection>>();
            
            for (Troubleshooting_Informational__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                                             From Troubleshooting_Informational__DataCategorySelection a 
                                                                             Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Troubleshooting_Informational__DataCategorySelection[]{dcs});
                }
            }
            
            for (Troubleshooting_Informational__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Troubleshooting_Informational__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                mainArticle.release = k.Release__c;
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryBlackboardClientProgram(String articleType, set<Id> kavIdSet)
    {
        list<KnowledgeArticleWrapperPDF> kavWrapperList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        map<Id, Blackboard_Client_Program__kav> kavMap = new map<Id, Blackboard_Client_Program__kav>([Select b.Title,b.Solution_Published_Date__c, 
                                                                                                             b.LastPublishedDate, b.KnowledgeArticleId, b.Id, 
                                                                                                             b.ArticleNumber 
                                                                                                      From Blackboard_Client_Program__kav b 
                                                                                                      Where Id IN : kavIdSet]);
                                     
        if (kavMap != null && !kavMap.isEmpty())
        {
            map<Id, list<Blackboard_Client_Program__DataCategorySelection>> dcsMap = new map<Id, list<Blackboard_Client_Program__DataCategorySelection>>();
            
            for (Blackboard_Client_Program__DataCategorySelection dcs : [Select a.ParentId, a.Id, a.DataCategoryName, a.DataCategoryGroupName
                                                                         From Blackboard_Client_Program__DataCategorySelection a 
                                                                         Where ParentId =: kavMap.keySet()])
            {
                if (dcsMap.containsKey(dcs.ParentId))
                {
                    dcsMap.get(dcs.ParentId).add(dcs);
                }
                else
                {
                    dcsMap.put(dcs.ParentId, new Blackboard_Client_Program__DataCategorySelection[]{dcs});
                }
            }
            
            for (Blackboard_Client_Program__kav k : kavMap.values())
            {
                mainArticle = new KnowledgeArticleWrapperPDF(k.Id, k.Title, k.ArticleNumber, k.KnowledgeArticleId);
                mainArticle.articleType = articleType;
                mainArticle.lastKnowledgePublishedDate = k.LastPublishedDate;
                if (k.Solution_Published_Date__c != null)
                {
                    Date solDate = k.Solution_Published_Date__c;
                    mainArticle.lastSolutionPublishedDate = Datetime.newInstance(solDate.year(), solDate.month(), solDate.day());
                }
                mainArticle.dataCategoryMap = new map<String, list<String>>();
            
                if (dcsMap.containsKey(k.Id))
                {
                    for (Blackboard_Client_Program__DataCategorySelection dcs : dcsMap.get(k.Id))
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
                }
                
                
                kavWrapperList.add(mainArticle);
                kavMap.remove(mainarticle.articleId);
            }
        }
        
        return kavWrapperList;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryRelatedKnownIssueList(KnowledgeArticleWrapperPDF kaw)
    {
        String categoryFilter = '';
        list<KnowledgeArticleWrapperPDF> kawList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        if (kaw.dataCategoryMap != null && !kaw.dataCategoryMap.isEmpty())
        {
            for (String s : kaw.dataCategoryMap.keySet())
            {
                for (String s1 : kaw.dataCategoryMap.get(s))
                {
                    if (categoryFilter == '')
                    {
                        categoryFilter = s + '__c AT ' + s1 +'__c';
                    } 
                    else 
                    {
                        categoryFilter = categoryFilter + ' AND ' + s + '__c AT ' + s1  +'__c';
                    }
                }
            }
            
            try
            {
                String qryString = 'SELECT Id, title, UrlName, ArticleNumber, KnowledgeArticleId, LastPublishedDate, LastModifiedById FROM Known_Issue__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY '+categoryFilter; 
                list<Known_Issue__kav> articleList = Database.query(qryString);
                if (articleList != null && !articleList.isEmpty())
                {
                    for (Known_Issue__kav ki : articleList)
                    {
                        mainArticle = new KnowledgeArticleWrapperPDF(ki.Id, ki.Title, ki.ArticleNumber, ki.KnowledgeArticleId);
                        mainArticle.lastPublishedDate = ki.LastPublishedDate;
                        kawList.add(mainArticle);
                    }
                }
                else
                {
                    return null;
                }
                
                return kawList;
            }
            catch (Queryexception e)
            {
                return null;
            }
        }
        
        return null;
    }
    
    public static list<KnowledgeArticleWrapperPDF> queryServicePackArticleList(KnowledgeArticleWrapperPDF kaw)
    {
        String categoryFilter = '';
        list<KnowledgeArticleWrapperPDF> kawList = new list<KnowledgeArticleWrapperPDF>();
        KnowledgeArticleWrapperPDF mainArticle;
        
        if (kaw.dataCategoryMap != null && !kaw.dataCategoryMap.isEmpty())
        {
            for (String s : kaw.dataCategoryMap.keySet())
            {
                for (String s1 : kaw.dataCategoryMap.get(s))
                {
                    if (categoryFilter == '')
                    {
                        categoryFilter = s + '__c AT ' + s1 +'__c';
                    } 
                    else 
                    {
                        categoryFilter = categoryFilter + ' AND ' + s + '__c AT ' + s1  +'__c';
                    }
                }
            }
            
            try
            {
                String qryString = 'SELECT Id, title, UrlName, ArticleNumber, KnowledgeArticleId, LastPublishedDate, LastModifiedById FROM Maintenance_Release__kav WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY ' + 
                    categoryFilter + 'Order by LastPublishedDate desc'; 
                list<Maintenance_Release__kav> articleList = Database.query(qryString);
                if (articleList != null && !articleList.isEmpty())
                {
                    for (Maintenance_Release__kav mr : articleList)
                    {
                        mainArticle = new KnowledgeArticleWrapperPDF(mr.Id, mr.Title, mr.ArticleNumber, mr.KnowledgeArticleId);
                        mainArticle.lastPublishedDate = mr.LastPublishedDate;
                        kawList.add(mainArticle);
                    }
                }
                else
                {
                    return null;
                }
                
                return kawList;
            }
            catch (Queryexception e)
            {
                return null;
            }
        }
        return null;
    }

}