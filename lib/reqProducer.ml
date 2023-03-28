open Cohttp
open Cohttp_lwt_unix
open Types

module ReqProducer = struct
  let make_post api_key endpoint data_post body =
    let uri = Uri.of_string endpoint in
    let headers = Header.init_with "Content-Type" data_post in
    let headers = Header.add headers "Authorization" ("Bearer " ^ api_key) in
    Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) uri

  let chatgpt_basic_request api_key prompt =
    let endpoint = "https://api.openai.com/v1/" ^ Endpoint.chatgpt in
    let uri = Uri.of_string endpoint in
    let headers = Header.init_with "Content-Type" "application/json" in
    let headers = Header.add headers "Authorization" ("Bearer " ^ api_key) in
    let body = {
      model = GPT_3_5_TURBO;
      messages = [{role = User; content = prompt}]
    } in
    let body = Yojson.Safe.to_string (chat_completions_body_to_yojson body) in
    Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) uri
end