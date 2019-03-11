type defaultTypeRequest:void{
  .data:any
  .userAgent:string
  .requestUri:string
  .operation:string
  .cookies:undefined
}

type defaultTypeResponse:any{
   .format? :string
   .mime? : string
}

type checkETagRequest:void{
  .operation:string
}

type checkETagResponse:void{
  .ETag:string
}
interface HTTPInterface {
  RequestResponse:
  checkResoucesByEtag(checkETagRequest)(checkETagResponse),
  default(defaultTypeRequest)(defaultTypeResponse)
}
