include "string_utils.iol"
include "message_digest.iol"
include "file.iol"
include "console.iol"


interface HTTPInterface {
  RequestResponse:
  checkResoucesByEtag(undefined)(undefined),
  default(undefined)(undefined)
}


inputPort Frontend {
  Location: "local"
  Protocol: http
  Interfaces: HTTPInterface
}



execution{ concurrent}

main{
  [checkResoucesByEtag(request)(response){
     readRequest.filename = "./resources/"+ request.operation;
     readRequest.format = "binary";
     readFile@File(readRequest)(readResponse);
     convertFromBinaryToBase64Value@File( readResponse )( convertResponse );
     md5Request = convertResponse;
     md5Request.radix = 12;
     md5@MessageDigest(md5Request)(response.ETag)

  }]
  [default(request)(response){
    scope( s ) {
     install( FileNotFound => println@Console( "File not found: " + file.filename )() );

     s = request.operation;
     s.regex = "\\?";
     split@StringUtils( s )( s );


     file.filename = "./resources/" + s.result[0];

     getMimeType@File( file.filename )( mime );
     response.mime = mime ;
     mime.regex = "/";
     split@StringUtils( mime )( s );
     if ( s.result[0] == "text" ) {
       file.format = "text";
        response.format = "html"
     } else {
       file.format = response.format = "binary"
     };

     readFile@File( file )( response );
     response.format = file.format;
    response.mime = mime 

   }
    }]
}
