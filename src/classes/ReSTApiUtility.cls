public without sharing class ReSTApiUtility {
	
	Public Token responseToken{get;set;}

	Public Class Token
	{
		Public String id{get;set;}
		Public String issued_at{get;set;}
		Public String token_type{get;set;}
		Public String instance_url{get;set;}
		Public String signature{get;set;}
		Public String access_token{get;set;}
	}
	
	Public Class QueryResult
	{
		Public String status{get;set;}
		Public String errormessage{get;set;}
		Public List<SObject> records{get;set;}
		Public QueryResult(String status,String errormessage,List<SObject> records )
		{
			this.status=status;
			this.errormessage=errormessage;
			this.records=records;
		}
	}
	Public String Login(String username,String password,String url, String clientkey, String  clientsecret)
	 {
	 	//string key='3MVG9Nc1qcZ7BbZ2l4KH.8nRfOR1lvFdGPvF0i94P2UdmoAZJ8prCGr00cGIf40LvY64NfeARexD0oIEzv7dY';
		//string secret='4163843976214368231';
		HttpRequest req= new HttpRequest();
		req.setendpoint(url);
		req.setMethod('POST');
		string uname=EncodingUtil.urlEncode(username,'UTF-8');
		string pword=EncodingUtil.urlEncode(password,'UTF-8');
		string body='grant_type=password&client_id='+clientkey+'&client_secret='+clientsecret+'&username='+uname+'&password='+pword;
		system.debug('body--'+body);
		req.setBody(body);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		System.debug('body--'+res.getBody());
		System.debug('Code--'+res.getStatusCode());
		if(res.getBody().contains('instance_url'))
		{
			responseToken=(ReSTApiUtility.Token)JSON.deserializeStrict(res.getBody(),ReSTApiUtility.Token.class);
			return 'SUCCESS';
		}
		else
		{
			return res.getBody(); 
		}
	 }

	 Public QueryResult QueryRecords(string Query)
	 {
	 	String URL=responseToken.instance_url+'/services/data/v29.0/query/?q=';
	 	//String URL='https://test.salesforce.com/services/data/v29.0/query/?q=';
	 	String QueryString=Query.replaceAll(' ','+');
	 	URL=URL+QueryString;
	 	HttpRequest req= new HttpRequest();
		req.setendpoint(URL);
		req.setMethod('GET');
		req.setHeader('Authorization','Bearer '+responseToken.access_token);
		Http http = new Http();
		HTTPResponse res = http.send(req);
		if(res.getbody()!= null && res.getbody().contains('records'))
		{	
			List<SObject> sobjects= new List<SObject>();
			string records =res.getbody();
			JSONParser parser =JSON.createParser(records);
			system.debug('parser--'+parser.getCurrentToken());
			While(parser.nextToken()!=null)
			{
				system.debug('current--'+parser.getCurrentName());
				if(parser.getCurrentName()=='records')
				{
					sobjects=(List<Sobject>)parser.readvalueas(List<Sobject>.class);
					return new QueryResult('SUCCESS','',sobjects);
					break;
				}
				parser.nextToken();
			}
			return new QueryResult('ERROR',res.getbody(),null);
		}
		else
		{
			return new QueryResult('ERROR',res.getbody(),null);
		}
		

	 }
}