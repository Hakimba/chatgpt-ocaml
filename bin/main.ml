open Chatgptocaml

let api_key = "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";;

let endpoint = "https://api.openai.com/v1/" ^ Endpoint.chatgpt;;

let data_post = "application/json";;

let content = "Comment s'initier a l'étude morphologique des contes merveilleux";;

let body = Printf.sprintf {|{
      "model" : "gpt-4",
      "messages" : [{"role" : "user", "content" : "%s"}]
    }|} content |> Yojson.Safe.from_string |> Yojson.Safe.to_string;;

let main () = Lwt_main.run (Request.handle_request_response api_key endpoint data_post body)

let _ = main ()