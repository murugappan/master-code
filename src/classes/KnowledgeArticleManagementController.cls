public with sharing class KnowledgeArticleManagementController
{
    public class AttachmentWrapper
    {
        public Case_Attachment__c attachment {get; set;}
        
        public AttachmentWrapper(Case_Attachment__c ca)
        {
            attachment = ca;
        }
        
        public PageReference doDelete()
        {
            delete attachment;
            return null;
        }
    }
    
    public String articleTitle {get; set;}
    public String articlenumber{get;set;} 
    public KnowledgeArticleWrapper kavWrapper {get; set;}
    public list<AttachmentWrapper> attachmentList {get; set;}
    
    public KnowledgeArticleManagementController()
    {
        loadKnowledgeArticle();
        if (kavWrapper != null)
        {
            loadAttachmentList();
        }
    }
    
    private void loadKnowledgeArticle()
    {
        try
        {
            KnowledgeArticleVersion kav = [Select Id, Title, Summary, KnowledgeArticleId 
                                           From KnowledgeArticleVersion 
                                           Where Id =: ApexPages.currentPage().getParameters().get('articleVersionId')];
                   
            kavWrapper = new KnowledgeArticleWrapper(kav.KnowledgeArticleId, kav.Title, '1', kav.KnowledgeArticleId);   // modified TP2880
        }
        catch (Queryexception e)
        {
            
        }
    }
    
    private void loadAttachmentList()
    {
        attachmentList = new list<AttachmentWrapper>();
        
        for (Case_Attachment__c ca : [Select Id, Name,File_Name__c From Case_Attachment__c Where Article_Id__c =: kavWrapper.KnowledgeArticleId])  // modified TP2880
        {
            attachmentList.add(new AttachmentWrapper(ca));
        }
    }
    
    public PageReference doSearch()
    {       
        if ((articleTitle != null && articleTitle != '')||(articlenumber != null && articlenumber != ''))
        {
            if(articleTitle != null && articleTitle != '')
            articleTitle = articleTitle.normalizeSpace();    
            list<KnowledgeArticleVersion> kavList = [Select Id,ArticleNumber, Title, Summary, KnowledgeArticleId 
                                                     From KnowledgeArticleVersion 
                                                     Where PublishStatus = 'Online' 
                                                     And Language = 'en_US'
                                                     And Title =: articleTitle];
            
            if (kavList == null || kavList.isEmpty())
            {
                kavList = [Select Id, ArticleNumber, Title, Summary, KnowledgeArticleId 
                                                         From KnowledgeArticleVersion 
                                                         Where PublishStatus = 'Draft' 
                                                         And Language = 'en_US'
                                                         And Title =: articleTitle];
                                                         
                if (kavList == null || kavList.isEmpty())
                {
                    if(articlenumber !=null && articlenumber!= '')
                    {
                         articlenumber = articlenumber.normalizeSpace();
                        if(articlenumber.length()<9)
                        {
                        string temp='0';
                        temp=temp.repeat(9-articlenumber.length());
                        articlenumber=temp+articlenumber;
                        }
                        kavlist= queryArticleByNumber(articlenumber);
                    }
                    if(kavList == null || kavList.isEmpty())
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There were no results for the entered title/number. Please check the title/number'));
                }
            }
            if (kavList != null && kavList.size() == 1)
            {
                KnowledgeArticleVersion kav = kavList[0];
                kavWrapper = new KnowledgeArticleWrapper(kav.Id, kav.Title, '1', kav.KnowledgeArticleId);
                kavWrapper.ArticleNumber=kav.articlenumber;
            }
            else if(kavList != null && kavList.size() > 1)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There are two articles for your title.'));
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter an article title or article number.'));
        }
        
        if (kavWrapper != null)
        {
            loadAttachmentList();
        }
        
        return null;
    }
    
    public PageReference redirectToAttachment()
    {
        PageReference pageRef = Page.ArticleAttachment;
        pageRef.getParameters().put('articleVersionId', kavWrapper.articleId);
        pageRef.getParameters().put('articleId', kavWrapper.KnowledgeArticleId);
        String urlUsed = URL.getCurrentRequestUrl().toExternalForm();
        if(urlUsed.contains('isdtp')) 
        {
            pageRef.getParameters().put('console', 'true');
        }           
        else
        { 
            pageRef.getParameters().put('console', 'false');
        }           
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    public list<knowledgearticleversion> queryArticleByNumber(string articleno)
    {
        try
        {
        list<KnowledgeArticleVersion> kavList = [Select Id,ArticleNumber, Title, Summary, KnowledgeArticleId 
                                                     From KnowledgeArticleVersion 
                                                     Where PublishStatus = 'Online' 
                                                     And Language = 'en_US'
                                                     And articlenumber =:articleno];
        
        if (kavList == null || kavList.isEmpty())
            {
                kavList = [Select Id, ArticleNumber, Title, Summary, KnowledgeArticleId 
                                                         From KnowledgeArticleVersion 
                                                         Where PublishStatus = 'Draft' 
                                                         And Language = 'en_US'
                                                         And Title =: articleno];                                    
                                                     
        }
        return kavlist;
        }
        catch (Queryexception e)
        {
        return null ;
        }                                                
                                                     

    }
}