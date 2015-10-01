public with sharing class vfKeywordSearchController {
//Page Size
private Static Final Integer PAGE_NUMBER = 10;
//Search String used in ArticleList tag
public String searchstring { get; set; }
public integer ssize {get;set;}
public boolean showsize{get; set;}
public vfKeywordSearchController() {
// String qryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
String qryString = 'FIND \'' + searchstring + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id,ArticleNumber where PublishStatus =\'online\' and Language = \'en_US\')';
list<list<SObject>>searchList = search.query(qryString);
List<KnowledgeArticleVersion> articleList = (list<KnowledgeArticleVersion>)searchList[0];
system.debug('List@@@' + articleList );
//List<KnowledgeArticleVersion> articleList= Database.query(qryString);
maxSize = articleList.size() ;
system.debug('@@@@@@@@'+ maxSize );
showsize = false;
}
//Keeps track of current page & max size of article list
Integer currentPage = 1;
Integer maxSize = 1;
// Returns whether we need to see previous button or not
public boolean getPrevRequired() {
return currentPage > 1;
}
// Returns whether we need to see next button or not
public boolean getNextRequired() {
return currentPage * PAGE_NUMBER < maxSize ;
}
//Returns current page number
public Decimal getCurrentPageNumber() {
return this.currentPage;
}
public integer getmaxSize(){
return maxSize ;
}

//action for next click
public PageReference next() {
if(maxSize > this.currentPage * PAGE_NUMBER) {
this.currentPage = this.currentPage + 1;
}
return null;
}
//action for previous click
public PageReference previous() {
if(this.currentPage > 1)
this.currentPage = this.currentPage - 1;
return null;
}
//action for go button
public void Go(){
showsize = true;
String qryString = 'FIND \'*' + searchstring + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id,ArticleNumber where PublishStatus =\'online\' and Language = \'en_US\')';
list<list<SObject>>searchList = search.query(qryString);
List<KnowledgeArticleVersion> articleList = (list<KnowledgeArticleVersion>)searchList[0];
maxSize = articleList.size();
system.debug('$ize@@' + maxSize);
system.debug('List@@@' + articleList );
}
}