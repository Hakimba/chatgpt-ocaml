open Cohttp
open Cohttp_lwt_unix

module ReqProducer = struct
  let make_post api_key endpoint data_post body =
    let uri = Uri.of_string endpoint in
    let headers = Header.init_with "Content-Type" data_post in
    let headers = Header.add headers "Authorization" ("Bearer " ^ api_key) in
    Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) uri
end