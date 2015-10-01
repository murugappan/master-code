public with sharing class kiarticlecreate {
public learnJIRA__c store {get;set;}


public kiarticlecreate(ApexPages.Standardcontroller stdcontroller){
store = [Select id, Summary__c,Name,Workaround__c,Steps_to_Replicate_HTML__c,Cause__c,Article_Title__c,Article_Version_Id__c,Article_Id__c,Product_ID__c,Symptoms__c,Client_Facing_Description_HTML__c from learnJIRA__c WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
}

public void create(){}

public pagereference autorun(){
if(store.Summary__c != null && store.Article_Version_Id__c == null){
String urlName = store.Summary__c;

                    urlname += string.valueof(system.now());
                    urlName = urlName.replace(' ', '-');
                    urlName = urlName.replace('.', '-');
                    urlName = urlName.replace('\\', '-');
                    urlName = urlName.replace('\'', '-');
                    urlName = urlName.replace(':', '-');
                    urlName = urlName.replace('_', '-');
                    urlName = urlName.replace(')', '-');
                    urlName = urlName.replace('()', '-');
                    urlName = urlName.replace('(', '-');
                    urlName = urlName.replace('^', '-');
                    urlName = urlName.replace('%', '-');
                    urlName = urlName.replace('$', '-');
                    urlName = urlName.replace('!', '-');
                    urlName = urlName.replace('@', '-');
                    urlName = urlName.replace('#', '-');
                    urlName = urlName.replace('~', '-');
                    urlName = urlName.replace('/', '-');
                    urlName = urlName.replace('[]', '-');
                    urlName = urlName.replace('[', '-');
                    urlName = urlName.replace(']', '-');
                    urlName = urlName.replace('>', '-');
                    urlName = urlName.replace('<', '-');
                    urlName = urlName.replace(',', '-');
                    urlName = urlName.replace('?', '-');
                    urlName = urlName.replace('"', '-');
                    urlName = urlName.replace('}', '-');
                    urlName = urlName.replace('{', '-');
                    urlName = urlName.replace('{}', '-');
                    urlName = urlName.replace('|', '-');
                    urlName = urlName.replace('||', '-');
                    urlName = urlName.replace('&', '-');
                    urlName = urlName.replace('`', '-');
                    urlName = urlName.replace('*', '-');
                    urlName = urlName.replace('+', '-');
                    urlName = urlName.replace('=', '-');
                    urlName = urlName.replace(';', '-');

Known_Issue__kav article = new Known_Issue__kav();


article.Support_Incident__c = store.Id;
article.SI_ID__c = store.Name;
article.Title = store.Summary__c;
article.UrlName = urlName;
article.Steps_to_Replicate__c = store.Steps_to_Replicate_HTML__c + '' + store.Client_Facing_Description_HTML__c;
article.Resolution_Workaround__c = store.Workaround__c;
article.Cause__c = store.Cause__c;
article.Symptoms__c =  store.Symptoms__c;
article.Product__c = store.Product_ID__c;
insert article;

for (KnowledgeArticleVersion kav : [Select k.VersionNumber, k.ValidationStatus, k.UrlName, k.Title, k.SystemModstamp, k.Summary, k.SourceId, k.PublishStatus, k.OwnerId, 
                                                       k.LastPublishedDate, k.LastModifiedDate, k.LastModifiedById, k.Language, k.KnowledgeArticleId, k.IsVisibleInPrm, 
                                                       k.IsVisibleInPkb, k.IsVisibleInCsp, k.IsVisibleInApp, k.IsDeleted, k.Id, k.FirstPublishedDate, k.CurrencyIsoCode, k.CreatedDate, 
                                                       k.CreatedById, k.ArticleNumber, k.ArchivedDate, k.ArchivedById 
                                                From KnowledgeArticleVersion k Where Id =:article.id])
            {
                
                   
                    store.Article_Id__c = kav.KnowledgeArticleId;
                    store.Article_Version_Id__c = kav.Id;
                    store.Article_Number__c = kav.ArticleNumber;
                    store.Article_Title__c = kav.Title; 
                    store.Article_Published_Status__c = kav.PublishStatus;
                    store.Article_First_Published_Date__c = kav.FirstPublishedDate;
                    store.Version_Number__c = string.valueOf(kav.VersionNumber);
                
            } 
update store;




system.debug('Murugappan');
}
return new pagereference('/'+store.id).setredirect(true);
}


}