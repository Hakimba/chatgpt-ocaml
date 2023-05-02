(** 
    Removing the first pair of quote, those \ before quote, and replace the \\n by \n for interpreting newlines.
    Useful if we want to consume the body returned by a request and print only the answer in a beautiful/formatted way
**)
let cleanup_api_data s =
  String.sub s 1 (String.length s - 2) |> Str.global_replace (Str.regexp "\\\\n") "\n"
  |> Str.global_replace (Str.regexp "\\\\\"") "\""


let stream_of_string x =
  let once = ref false in
  let go () =
    if !once
    then None
    else (
      once := true ;
      Some (x, 0, String.length x)) in
  go

let random_string len =
  let res = Bytes.create len in
  for i = 0 to len - 1 do
    let code = Random.int (10 + 26 + 26) in
    if code < 10
    then Bytes.set res i (Char.chr (Char.code '0' + code))
    else if code < 10 + 16
    then Bytes.set res i (Char.chr (Char.code 'a' + code - 10))
    else Bytes.set res i (Char.chr (Char.code 'A' + code - (10 + 26)))
  done ;
  Bytes.unsafe_to_string res