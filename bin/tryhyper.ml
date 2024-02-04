open Lwt
open Cohttp_lwt_unix

let _get_default_hyper () = 
  Hyper.get "http://google.com"

let post_default_hyper () =
  let json = {|"prompt": "caca"|} in
  Hyper.post ~headers:[("Content-Type","application/json")] "http://localhost:8080/tryhyper" json


let _get_default_cohttp () = 
  Client.get (Uri.of_string "https://github.com/dinosaure/multipart_form")
  >>= fun (_,body) -> body |> Cohttp_lwt.Body.to_string


let () = post_default_hyper () |> print_endline
