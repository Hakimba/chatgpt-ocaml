(** 
    Removing the first pair of quote, those \ before quote, and replace the \\n by \n for interpreting newlines.
    Useful if we want to consume the body returned by a request and print only the answer in a beautiful/formatted way
**)
let cleanup_api_data s =
  String.sub s 1 (String.length s - 2) |> Str.global_replace (Str.regexp "\\\\n") "\n"
  |> Str.global_replace (Str.regexp "\\\\\"") "\""