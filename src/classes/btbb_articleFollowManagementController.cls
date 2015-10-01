public without sharing class btbb_articleFollowManagementController
{
        public class FollowWrapper
        {
                public Knowledge_Follow__c followObj {get; set;}
                public Boolean isFollowed {get; set;}
                public String linkDisplay
                {
                        get
                        {
                                if (isFollowed) return 'Yes';
                                else return 'No';
                        } private set;
                }
                public string styleclass
                {
                        get
                        {
                                if (isFollowed) return 'check on';
                                else return 'check';
                        } private set;
                }
                public string tooltip
                {
                        get
                        {
                                if (isFollowed) return 'click to Unsubscribe';
                                else return 'click to Subscribe';
                        } private set;
                }
                public FollowWrapper(Knowledge_Follow__c f, Boolean flag)
                {
                        followObj = f;
                        isFollowed = flag;
                }
                
                public PageReference updateFollow()
                {
                        Knowledge_Follow__c kf;
                        
                        if (followObj != null && followObj.Id != null)
                        {
                                kf = followObj.clone();
                                delete followObj;
                                followObj = kf;
                        }
                        else
                        {
                            try{
                                insert followObj;
                            }
                            catch(exception e){

                            }
                            
                        }
                        isFollowed = !isFollowed;
                        return null;
                }
        }
        
        public class ArticleFollowWrapper
        {
                public Knowledge_Follow__c followObj {get; set;}
                public KnowledgeArticleVersion kav{get;set;}
                public Boolean isFollowed {get; set;}
                public String linkDisplay
                {
                        get
                        {
                                if (isFollowed) return 'Unsubscribe';
                                else return 'Subscribe';
                        } private set;
                }
                public string styleclass
                {
                        get
                        {
                                if (isFollowed) return 'check on';
                                else return 'check';
                        } private set;
                }
                public string tooltip
                {
                        get
                        {
                                if (isFollowed) return 'click to stop following this article';
                                else return 'click to follow this article';
                        } private set;
                }
                public ArticleFollowWrapper(Knowledge_Follow__c f, knowledgearticleversion kv)
                {
                        followObj = f;
                        kav=kv;
                        isFollowed = true;
                }
                
                public PageReference updateFollow()
                {
                        Knowledge_Follow__c kf;
                        
                        if (followObj != null && followObj.Id != null)
                        {
                                kf = followObj.clone();
                                delete followObj;
                                followObj = kf;
                        }
                        else
                        {
                                insert followObj;
                        }
                        isFollowed = !isFollowed;
                        return null;
                }
        }
        public class followlistwrapper
        {
                public string articletype{get;set;}
                public list<FollowWrapper> followlist{get;set;}
                public followlistwrapper(string s,list<followwrapper> f)
                {
                        articletype=s;
                        followlist=f;
                }
        }
        public list<followlistwrapper> followList {get; set;}
        public list<ArticleFollowWrapper> articlefollowlist{get;set;}
        private list<String> articleTypeList;
        public list<string> productlist{get;set;}
        
        public btbb_articleFollowManagementController()
        {
                loadArticleTypes();
                loadproducts();
                loadFollows();
                loadarticles();
        }
        
        public btbb_articlefollowManagementController(ApexPages.StandardController sc)
        {
                loadArticleTypes();
                loadproducts();
                loadFollows();
                loadarticles();
        }
        private void loadArticleTypes()
        {
                map<String,Schema.SOBjectType> globalDescribeMap = Schema.getGlobalDescribe();
                list<String> articleTypeNameList = new list<String>();
        articleTypeList = new list<String>();
        
        for (String s : globalDescribeMap.keySet()) 
        {
                if (s.endswith('__ka')) 
                {
                        if(!s.contains('Process_Procedure__ka')&&!s.contains('process_procedure__ka'))
                        articleTypeNameList.add(s);
                }
        }
        
        articleTypeNameList.sort();
        
        for (String s : articleTypeNameList)
        {
                Schema.DescribeSObjectResult r = globalDescribeMap.get(s).getDescribe();
                articleTypeList.add(r.getLabel());
        }
        }

    private void loadproducts()
    {
        Set<string> buaccpro_name = new Set<string>();
                 List<User> u = new List<User>([select ID,ContactID, Name, BTBB_KB_Default_Prod__c from User where ID =: Userinfo.getUserID()]);

                 
        for(List<Contact_Role__c> cr : [Select c.Role__c, c.Code__c,c.Contact__c, c.Account__c,c.BusinessUnit__c,c.accesscode__c From Contact_Role__c c where Contact__c =: u[0].ContactID AND Expire_Role__c = false and role__c != null AND Contact__c!= NULL])
             {
                for(contact_role__c c : cr)
                   {
                   if((integer.valueOf(c.accesscode__c) & 1) > 0)
                       {
                         for(string s: c.BusinessUnit__c.split(','))
                           {
                           
                                 s= s.replace('ANGEL LMS','ANGEL');
                                 system.debug('value pro'+s);
                                 buaccpro_name.add(s);
                                 system.debug('Splitted string'+s);                      
                         
                           }
                      
                              }
                   }
                
             system.debug('SETPro--'+buaccpro_name);
        productlist=new list<string>();
    //  Schema.DescribeFieldResult F = Knowledge_Follow__c.sObjectType.getDescribe().fields.getmap().get('Product__c').getdescribe();
        Schema.DescribeFieldResult F = Knowledge_Follow__c.Product__c.getDescribe();
        for(Schema.PicklistEntry s:F.getPicklistValues())
        {
                if(buaccpro_name.contains(s.getvalue()))
                {
                productlist.add(s.getvalue());
                system.debug('Prd1--'+productlist);
        
                }
        }
        
       system.debug('Prd--'+productlist);       
    } 
    }
    
    private void loadarticles()
    {
        articlefollowlist= new list<ArticleFollowWrapper>();
        map<id,knowledge_follow__c> articleidfollowmap=new map<id,knowledge_follow__c>();
        map<id,knowledgearticleversion> articleidmap= new map<id,knowledgearticleversion>();
        list<knowledge_follow__c>articlelist=new list<knowledge_follow__c>([Select Id, Following_Key__c, User__c, Type__c,product__c 
                                                                           From Knowledge_Follow__c
                                                                           Where User__c =: UserInfo.getUserId()
                                                                           And Type__c = 'Knowledge Article' order by createddate desc nulls last ]);
         for(knowledge_follow__c kf:articlelist)
                        {
                                articleidfollowmap.put(kf.Following_Key__c,kf);
                        }
             map<id,knowledgearticleversion> KAidKAVmap=new map<id,knowledgearticleversion>(); 
             for(knowledgearticleversion ka: [Select articlenumber,title,lastpublisheddate,knowledgearticleid from knowledgearticleversion where KnowledgeArticleId in:articleidfollowmap.keyset() and 
                                          IsVisibleInCsp = true And PublishStatus = 'Online' And Language = 'en_US' order by lastpublisheddate ])
                {
                  KAidKAVmap.put(ka.knowledgearticleid,ka);
                }
         for(knowledge_follow__c kf:articlelist)        
           {
                if(KAidKAVmap != null && KAidKAVmap.get(kf.Following_Key__c) != null)
                articlefollowlist.add(new articlefollowwrapper(kf,KAidKAVmap.get(kf.Following_Key__c)));
           }                                                                       
                                                                           
    }
        private void loadFollows()
        {
                map<String, Knowledge_Follow__c> followMap = new map<String, Knowledge_Follow__c>();
                followList = new list<followlistwrapper>();
                Knowledge_Follow__c kFollow;
                
                for (Knowledge_Follow__c kf : [Select Id, Following_Key__c, User__c, Type__c,product__c 
                                                                           From Knowledge_Follow__c
                                                                           Where User__c =: UserInfo.getUserId()
                                                                           And Type__c = 'Article Type'])
                {
                        if (kf.Following_Key__c != null && kf.product__c!=null)
                        {
                                followMap.put(kf.Following_Key__c+kf.product__c, kf);
                        }
                }
                
                for (String s : articleTypeList)
                {
                        
                        list<FollowWrapper> followrow=new list<FollowWrapper>();
                        for(string p: productlist)
                        {
                          system.debug('propick'+p);
                          if (followmap != null && followMap.containsKey(s+p))
                           {            
                                followrow.add(new FollowWrapper(followMap.get(s+p), true));
                           }
                          else
                          {
                                
                                kFollow = new Knowledge_Follow__c();
                                kFollow.User__c = UserInfo.getUserId();
                                kFollow.Type__c = 'Article Type';
                                kFollow.Following_Key__c = s;
                                kfollow.Product__c=p;
                                followrow.add(new FollowWrapper(kFollow, false));
                                system.debug('elsepro'+p);
                         }
                  }
                  followList.add(new followlistwrapper(s,followrow));
                }         
         }
}