open Chatgptocaml
open ReqConsumer
open ReqProducer
open Types
open Lwt

let main () = 
  let endpoint = "https://api.openai.com/v1/" ^ Endpoint.chatgpt in
  let api_key = Sys.getenv "OPENAI_API_KEY" in
  let data_post = "application/json" in
  let body = {
    model = GPT_3_5_TURBO;
    messages = [{role = User; content = "ça va ?"}]
  } in
  let body = Yojson.Safe.to_string (chat_completion_body_to_yojson body) in

  Lwt_main.run (
    let req_res = ReqProducer.make_post api_key endpoint data_post body in
    let body = ReqConsumer.get_body_to_consume req_res in
    body >|= print_string
  )

let () = main ()