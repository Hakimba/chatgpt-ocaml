open Cohttp
open Cohttp_lwt_unix
open Lwt

(** Removing the first pair of quote, those \ before quote, and replace the \\n by \n for interpreting newlines **)
let cleanup_api_data s =
  String.sub s 1 (String.length s - 2) |> Str.global_replace (Str.regexp "\\\\n") "\n"
  |> Str.global_replace (Str.regexp "\\\\\"") "\""


let make_post_request api_key endpoint data_post body =
  let uri = Uri.of_string endpoint in
  let headers = Header.init_with "Content-Type" data_post in
  let headers = Header.add headers "Authorization" ("Bearer " ^ api_key) in
  Client.post ~headers ~body:(Cohttp_lwt.Body.of_string body) uri


let handle_body body =
  body |> Cohttp_lwt.Body.to_string >|= fun body ->
    let json_body = Yojson.Basic.from_string body in
    json_body |> Yojson.Basic.Util.member "choices" |>
    Yojson.Basic.Util.index 0 |> Yojson.Basic.Util.member "message" |>
    Yojson.Basic.Util.member "content" |>
    Yojson.Basic.to_string |> cleanup_api_data |> print_endline

let handle_request_response api_key endpoint data_post body =
  make_post_request api_key endpoint data_post body >>=
  fun (_, body) -> handle_body body