(** Precisly, those models are the ones which are compatible for the endpint /chat/completions only **)
type model =
  | GPT_4
  | GPT_4_0314
  | GPT_4_32K
  | GPT_4_32K_0314
  | GPT_3_5_TURBO
  | GPT_3_5_TURBO_0301

let string_of_model = function
  | GPT_4 -> {|"gpt-4"|}
  | GPT_4_0314 -> {|"gpt-4-0314"|}
  | GPT_4_32K -> {|"gpt-4-32k"|}
  | GPT_4_32K_0314 -> {|"gpt-4-32k-0314"|}
  | GPT_3_5_TURBO -> {|"gpt-3.5-turbo"|}
  | GPT_3_5_TURBO_0301 -> {|"gpt-3.5-turbo-0301"|}

let model_of_yojson = function
  | `String "gpt-4" -> Ok GPT_4
  | `String "gpt-4-0314" -> Ok GPT_4_0314
  | `String "gpt-4-32k" -> Ok GPT_4_32K
  | `String "gpt-4-32k-0314" -> Ok GPT_4_32K_0314
  | `String "gpt-3.5-turbo" -> Ok GPT_3_5_TURBO
  | `String "gpt-3.5-turbo-0301" -> Ok GPT_3_5_TURBO_0301
  | json -> Error (Yojson.Safe.to_string json)

let yojson_of_model v = v |> string_of_model |> Yojson.Safe.from_string

type role =
  | User
  | Assistant
  | System

let string_of_role = function
  | User -> {|"user"|}
  | Assistant -> {|"assistant"|}
  | System -> {|"system"|}

let role_of_yojson = function
  | `String "user" -> Ok User
  | `String "assistant" -> Ok Assistant
  | `String "system" -> Ok System
  | json -> Error (Yojson.Safe.to_string json)

let yojson_of_role v = v |> string_of_role |> Yojson.Safe.from_string
type messages = {
  role : role [@to_yojson yojson_of_role] [@of_yojson role_of_yojson];
  content : string 
} [@@deriving yojson]

type chat_completions_body = {
  model : model [@to_yojson yojson_of_model] [@of_yojson model_of_yojson];
  messages : messages list [@default []]
} [@@deriving yojson]
