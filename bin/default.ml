open Chatgptocaml
open ReqConsumer
open ReqProducer
open Lwt

let main () =
  let prompt = Sys.argv.(1) in
  let api_key = Sys.getenv "OPENAI_API_KEY" in

  Lwt_main.run (
    let req_res = ReqProducer.chatgpt_basic_request api_key prompt GPT_4 in
    ReqConsumer.get_body_to_consume req_res >|= print_endline
  )

let () = main ()

