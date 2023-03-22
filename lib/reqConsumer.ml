open Lwt

module ReqConsumer = struct

  (** Faudras se servir de la réponse de cette fonction avec un >|= et une fonction qui traite le body **)
  let getBodyToConsume req_res = req_res >>=
    fun (_, body) ->
      Cohttp_lwt.Body.to_string body

  (** Faudras se servir de la réponse de cette fonction avec un >|= et une fonction qui traite le status code **)
  let getStatusCodeToConsume req_res = req_res >>=
    fun (resp, _) ->
      Lwt.return (Cohttp.Response.status resp)
end