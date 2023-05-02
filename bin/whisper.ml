open Chatgptocaml
open ReqConsumer
open ReqProducer
open Lwt
open Types

let main () =
  let file = Sys.argv.(1) in
  let api_key = Sys.getenv "OPENAI_API_KEY" in

  Lwt_main.run (
    let req_res = ReqProducer.whisper_transcription_basic_request api_key file Whisper_1 in
    ReqConsumer.whisper_transcription_basic_consumer req_res >|= print_endline
  )

let () = main ()