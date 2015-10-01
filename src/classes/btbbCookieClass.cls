public without sharing class btbbCookieClass {
	
	public class AauthCookie{
		public string product;
		public string sessionid;
		public string userid;
	    public void createcookie()
    	{ 
    		string privatekey='b3h!ndBlackB0ard';
    		sessionid=Userinfo.getsessionid();
            userid=userinfo.getuserid();
    		string strUrlUTF8 = EncodingUtil.urlEncode(JSON.serialize(this), 'UTF-8');
    		blob cryptkey= crypto.encryptWithManagedIV('AES128', Blob.valueof(privateKey), Blob.valueof(strUrlUTF8));
    		cookie authcookie;
    		string cookievalue=EncodingUtil.base64Encode(cryptkey);
    		if(cookievalue!=null)
    		{
    			authcookie = new Cookie('btbbauth',cookievalue,null,-1,false);
    			ApexPages.currentPage().setCookies(new Cookie[]{authcookie});
    		}
    	}
    	public void loadcookie()
    	{
    		string privatekey='b3h!ndBlackB0ard';
    		cookie authcookie=ApexPages.currentPage().getCookies().get('btbbauth');
    		if(authcookie != null)
    		{	
	    		blob decodedblob=EncodingUtil.base64decode(authcookie.getvalue());
	    		blob decryptedMessage=crypto.decryptWithManagedIV('AES128',Blob.valueof(privateKey),decodedblob);
	    		string strUrlUTF8 = decryptedMessage.tostring();
		    		if(authcookie != null)
		    		{
		    			btbbCookieClass.AauthCookie temp=(btbbCookieClass.AauthCookie)JSON.deserialize(EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'),btbbCookieClass.AauthCookie.class);
		    			if(temp.sessionid == USerinfo.getsessionid())
		    			{
			    			this.product=temp.product;
			    			this.sessionid=temp.sessionid;
		    			}
		    			else
		    			{
		    				this.product=null;
		    			}
		    		}
    		}
    	}
	}
	
    public class UnAuthCookie{
		public string product;

		public void createcookie()
    	{ 
    		
    		string strUrlUTF8 = EncodingUtil.urlEncode(JSON.serialize(this), 'UTF-8');
    		cookie unauthcookie;
    		if(strUrlUTF8!=null)
    		{
    			unauthcookie = new Cookie('btbbunauth',strUrlUTF8,null,-1,false);
    			ApexPages.currentPage().setCookies(new Cookie[]{unauthcookie});
    		}
    	}
    	public void loadcookie()
    	{
    		
    		cookie unauthcookie=ApexPages.currentPage().getCookies().get('btbbunauth');
    		if(unauthcookie != null)
    		{	
	    		
	    		string strUrlUTF8 = unauthcookie.getvalue();
		    		if(unauthcookie != null)
		    		{
		    			btbbCookieClass.UnAuthCookie temp=(btbbCookieClass.UnAuthCookie)JSON.deserialize(EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'),btbbCookieClass.UnAuthCookie.class);
		    			
			    			this.product=temp.product;
		    			
		    		}
    		}
    	}	
	}
	
 public class AnnouncementCookie	{
 	public string announcementNo;
 	public string Corelicense;
 	public datetime datetimestamp;
 	public string portal;
 	public  void createanouncementcookie(map<string,btbbCookieClass.AnnouncementCookie> cookielist)
    	{ 
    		
    		string strUrlUTF8 = EncodingUtil.urlEncode(JSON.serialize(new AnnouncementCookieMap(cookielist)), 'UTF-8');
    		cookie anncmentcookie;
    		if(strUrlUTF8!=null)
    		{
    			anncmentcookie = new Cookie('btbbancmnt',strUrlUTF8,null,2592000,false);
    			ApexPages.currentPage().setCookies(new Cookie[]{anncmentcookie});
    		}
    	}
   public map<string,btbbCookieClass.AnnouncementCookie> loadcookie()
    	{
    		
    		cookie anncmentcookie=ApexPages.currentPage().getCookies().get('btbbancmnt');
    		if(anncmentcookie != null)
    		{	
	    		
	    		string strUrlUTF8 = anncmentcookie.getvalue();
		    		if(anncmentcookie != null)
		    		{
		    			map<string,btbbCookieClass.AnnouncementCookie> cookiemap= new map<string,btbbCookieClass.AnnouncementCookie> ();
		    			btbbCookieClass.AnnouncementCookieMap temp=(btbbCookieClass.AnnouncementCookieMap)JSON.deserialize(EncodingUtil.urlDecode(strUrlUTF8, 'UTF-8'),btbbCookieClass.AnnouncementCookieMap.class);
		    			
			    			return temp.cookiemap;
		    			
		    		}
		    		else
		    		{
		    			return null;
		    		}
    		}
    		else
    		{
    			return null;
    		}
    	}	 	
 }

	public class AnnouncementCookieMap{
		map<string,AnnouncementCookie> cookiemap{get;set;}
		public AnnouncementCookieMap(map<string,AnnouncementCookie> c)
		{
			this.cookiemap= c;
		}
		
	}
 	 
}