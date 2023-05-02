open Cohttp
open Cohttp_lwt_unix
open Types
open Utils

module ReqProducer = struct
  let make_post api_key endpoint data_post body =
    let uri = Uri.of_string endpoint in
    let headers = Header.init_with "Content-Type" data_post in
    let headers = Header.add headers "Authorization" ("Bearer " ^ api_key) in
    Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) uri

  let chatgpt_basic_request api_key prompt model =
    let endpoint = Endpoint.base ^ Endpoint.chatgpt in
    let uri = Uri.of_string endpoint in
    let headers = Header.init_with "Content-Type" "application/json" in
    let headers = Header.add headers "Authorization" ("Bearer " ^ api_key) in
    let body = {
      model = model;
      messages = [{role = User; content = prompt}]
    } in
    let body = Yojson.Safe.to_string (chat_completion_body_to_yojson body) in
    Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) uri

  let whisper_transcription_basic_request api_key file _model =
    let endpoint = Endpoint.base ^ Endpoint.whisper in
    let uri = Uri.of_string endpoint in
    let ch = open_in file in
    let fileContent = really_input_string ch (in_channel_length ch) in
    close_in ch;
    let open Multipart_form in
    let part0 =
      part
        ~disposition:(Content_disposition.v ~filename: (Filename.basename file) "file")
        ~encoding:`Binary
        (stream_of_string fileContent)
    in
    let part1 =
      part
        ~disposition:(Content_disposition.v "model")
        (stream_of_string "whisper-1") in
    let t = multipart ~rng:(fun ?g:_ len -> random_string len) [ part1; part0 ] in
    let headers, body = Multipart_form_cohttp.Client.multipart_form t in
    let headers = Cohttp.Header.add headers "Authorization" ("Bearer " ^ api_key) in

    Client.post ~headers:headers ~body:body uri

end