open Chatgptocaml
open ReqConsumer
open ReqProducer

type prompt_object = {
  prompt : string
} [@@deriving yojson]

let chatgpt_correct_request prompt =
  let api_key = Sys.getenv "OPENAI_API_KEY" in
  let prefix = "Réecrit seulement ce texte sans fautes : \n" in
  let req_res = ReqProducer.chatgpt_basic_request api_key (prefix^prompt) in
  ReqConsumer.chatgpt_basic_consumer req_res


let cors_middleware inner_handler req =
  let new_headers =
    [
      ("Allow", "OPTIONS, POST");
      ("Access-Control-Allow-Origin", "*");
      ("Access-Control-Allow-Headers", "*");
    ]
  in
  let%lwt res = inner_handler req in
  new_headers
  |> List.map (fun (key, value) -> Dream.add_header res key value)
  |> ignore;
  Lwt.return res

let () =
  Dream.run
  @@ Dream.logger
  @@ cors_middleware
  @@ Dream.router [

    Dream.options "/correct"
      (fun _request ->
        Dream.respond  ~headers:[ ("Allow", "OPTIONS, POST") ] "");

    Dream.post "/correct"
      (fun request ->
        let%lwt body = Dream.body request in

        let prompt_object =
          body
          |> Yojson.Safe.from_string
          |> prompt_object_of_yojson
        in

        let%lwt res = chatgpt_correct_request prompt_object.prompt in
        `String res
        |> Yojson.Safe.to_string
        |> Dream.json);

  ]