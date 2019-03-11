include "string_utils.iol"
include "console.iol"
include "./public/interfaces/HttpInterface.iol"



interface ControlInterface {
  RequestResponse:

  check(undefined)(undefined)
}

outputPort Frontend {
Location: "local"
Protocol: http
Interfaces: HTTPInterface
}


type EtagTypeRequest:void{
    .IfNoneMatch:any
}
interface extender ETagInterface {
    RequestResponse:
        default(EtagTypeRequest)(any)
}

inputPort HttpPort {
Location: "socket://localhost:8081"
Protocol: http{
  .debug= false;
  .debug.showContent = false;
  .statusCode -> statusCode;
  .debug.showContent= true;
  .default ="default";
  .headers.If_None_Match = "IfNoneMatch";
  .format -> format;
  .contentType -> mime;
  .addHeader.header[0] = "ETag";
  .addHeader.header[0].value -> ETag;
  .compression = false

}
Interfaces: ControlInterface
Aggregates: Frontend with ETagInterface
}

type EtagTypeRequest:void{
    .IfNoneMatch:any
}
interface extender ETagInterface {
    RequestResponse:
        default(EtagTypeRequest)(any)
}

embedded {
  Jolie: "Frontend.ol" in  Frontend
}

courier HttpPort {
    [interface HTTPInterface( request )(response)]{
           checkResoucesByEtagRequest.operation = request.operation;
           checkResoucesByEtag@Frontend(checkResoucesByEtagRequest)(checkResoucesByEtagResponse);
           if (request.IfNoneMatch == checkResoucesByEtagResponse.ETag){
               statusCode = 304;
               response ="";
               ETag = checkResoucesByEtagResponse.ETag
           }else{

             forward( request )( responseForward );
             format =  responseForward.format;
             mime =  responseForward.mime;
             ETag = checkResoucesByEtagResponse.ETag;
             response = responseForward

           }
    }
}


execution{ concurrent }

main{
 [check(request)(response){
    nullProcess
   }]
}
