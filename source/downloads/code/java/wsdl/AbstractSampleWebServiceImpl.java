import javax.jws.WebService;

@WebService(endpointInterface = "SampleWebService", serviceName = "SampleWebService", targetNamespace = "http:/sample.de/sample-web-service/")
abstract public class AbstractSampleWebServiceImpl implements SampleWebService {
}
