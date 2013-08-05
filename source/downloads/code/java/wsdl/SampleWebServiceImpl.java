import javax.jws.WebService;

@WebService(endpointInterface = "SampleWebService", serviceName = "SampleWebService", targetNamespace = "http:/sample.de/sample-web-service/")
public class SampleWebServiceImpl implements SampleWebService {
   public String echo(String msg) {
       return "Echo: "+msg;
   }
}
