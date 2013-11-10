https://groups.google.com/forum/#!searchin/littleproxy/chained/littleproxy/ZZkIgk9TPTE/5WbSvUEd-GUJ

Rakesh Sinha 

for a specific use case, we are following the flow mentioned below ,
in terms of chaining multiple proxies:
client -> littleproxy -> external-auth-proxy -> external world

the proxyip of the external-auth-proxy is given by the
ChainProxyManager ( 0.5-snapshot ) and the connection is made, but the
authorization process fails. The necessary http headers (proxy-
authorization) is all set before the connect happens:
( HttpRequestHandler :: newChannelFuture(httpRequest,
browserToProxyChannel, hostAndPort)   and it gets the
relayPipelineFactory, to do the same ).

Is there an additional pipeline handler that I need to add to the
relayPipelineFactory, to handle the proxy-authentication as well ?
('Basic ') to begin with.

What else should be looked into to look for issues with the
authentication ( the base64 encoding of username/password is correct)
and the proxy-authorization field is set.  Any comments would be much
appreciated.

---
Julien HENRY 

Hi,

I just tried to add a RequestFilter to handle authentication for my corporate proxy and it works fine:

                proxyServer = new DefaultHttpProxyServer(port, new HttpResponseFilters() {
                    public HttpFilter getFilter(String hostAndPort) {
                        return null;
                    }
                }, new ChainProxyManager() {
                    public void onCommunicationError(String hostAndPort) {
                        // TODO Auto-generated method stub
                    }
                    public String getChainProxy(HttpRequest httpRequest) {
                        return "proxy.mycompany.org:3128";
                    }
                }, null, new HttpRequestFilter() {
                    
                    public void filter(HttpRequest httpRequest) {
                        httpRequest.addHeader("Proxy-Authorization", "Basic XYZ1234==");                        
                    }
                });

Hope that help,

Regards,

Julien

P.S. : Would be good to have an API to set proxy authentication...

---

Bhaswanth Gattineni 	
03.10.12
Nachricht auf Deutsch übersetzen  

Hi,
    Greetings!! I tried this. It is working fine with normal http requests. But I am facing problems for CONNECT request with chaining proxy and authentication for it. Any sort of help would be greatly appreciated.

Thanks,
Bhaswanth Gattineni.

---

kmel ildirawi 	
03.10.12
Nachricht auf Deutsch übersetzen  

Greetings,

I was indeed looking for a littleproxy and i am glad to have found this one. I need to go thru our corporate internet proxy server which require username & password too.
Where do i specifiy these info and in which java code do i insert the code that Juilien.Henry provided below.

Thank you very much for answers. Best Regards.
--
Kmel.

---

Bhaswanth Gattineni 	
05.10.12
Nachricht auf Deutsch übersetzen  

Hi Kmel,
             Mr Henry has given the complete code on how to create the server. That is the way to create proxy server using API. Ofcourse there is a launcher to start the server, you can use that also depending on your requirement. If you want to modify the launcher, 

go to Launcher.java -> navigate to main-> look for   
final HttpProxyServer server = new DefaultHttpProxyServer(port);
replace the line with what Mr henry has given and change the details as per your network. and launch it.

-
Bhaswanth Gattineni
- zitierten Text einblenden -

----

	Phu Nguyen Anh 	
06.12.12
Nachricht auf Deutsch übersetzen  

I got the same problem, chain proxy (with BASIC authentication) doesnot work with CONNECT request. Anyone can help?

Thanks,
Phu
- zitierten Text einblenden -

----

Dharmaraj Parmar 	
18. Mär
Nachricht auf Deutsch übersetzen  

I used the following workaround to overcome this.

           @Override
            public String getChainProxy(HttpRequest request) {
                if (needAuthentication && request.getMethod().equals(HttpMethod.CONNECT)) {
                    requestFilter.filter(request);
                }
                return hostAndPort;
            }


Regards,
Dharmaraj Parmar
- zitierten Text einblenden -
