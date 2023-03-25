open Lwt

module ReqConsumer = struct

  let getBodyToConsume req_res = req_res >>=
    fun (_, body) ->
      Cohttp_lwt.Body.to_string body

  let getStatusCodeToConsume req_res = req_res >>=
    fun (resp, _) ->
      Lwt.return (Cohttp.Response.status resp)
  
  (**  By default, consuming a chatgpt request is -> print the answer in a beautiful way *)
  let chatgptDefaultConsumer req_res = req_res >>=
      fun (_, body) ->
        body |> Cohttp_lwt.Body.to_string >|= fun body ->
          let json_body = Yojson.Basic.from_string body in
          json_body |> Yojson.Basic.Util.member "choices" |>
          Yojson.Basic.Util.index 0 |> Yojson.Basic.Util.member "message" |>
          Yojson.Basic.Util.member "content" |>
          Yojson.Basic.to_string |> Utils.cleanup_api_data
end