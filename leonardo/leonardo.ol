include "string_utils.iol"

interface HTTPInterface {
  RequestResponse:
  checkResoucesByEtag(undefined)(undefined),
  default(undefined)(undefined)
}


interface ControlInterface {
  RequestResponse:

  check(undefined)(undefined)
}

outputPort Frontend {
Location: "local"
Protocol: http
Interfaces: HTTPInterface
}

inputPort HttpPort {
Location: "socket://localhost:8081"
Protocol: http{
  .debug= true;
  .statusCode -> statusCode;
  .debug.showContent= true;
  .default ="default";
  .headers.If_None_Match = "IfNoneMatch";
  .format -> format;
  .contentType -> mime;
  .addHeader.header[0] = "ETag";
  .addHeader.header[0].value -> ETag

}
Interfaces: ControlInterface
Aggregates: Frontend
}

embedded {
  Jolie: "Frontend.ol" in  Frontend
}

courier HttpPort {
    [interface HTTPInterface( request )(response)]{
           checkResoucesByEtagRequest.operation = request.operation;
           checkResoucesByEtag@Frontend(checkResoucesByEtagRequest)(checkResoucesByEtagResponse);
           if (request.IfNoneMatch == checkResoucesByEtagResponse.ETag){
               statusCode = 304
           }else{
             forward( request )( responseForward );
             response = responseForward;
             format =  responseForward.format;
             mime =  responseForward.mime
           }
    }
}


execution{ concurrent }

main{
 [check(request)(response){
    nullProcess
   }]
}
