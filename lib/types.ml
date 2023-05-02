(** Precisly, those models are the ones which are compatible for the endpint /chat/completions only **)

type audio_transcription_model = Whisper_1

let string_of_audio_transcription_model = function
  | Whisper_1 -> {|"whisper-1"|}

let audio_transcription_model_of_yojson = function
  | `String "whisper-1" -> Ok Whisper_1
  | json -> Error (Yojson.Safe.to_string json)

let yojson_of_audio_transcription_model v = v |> string_of_audio_transcription_model |> Yojson.Safe.from_string

type chat_completion_model =
  | GPT_4
  | GPT_4_0314
  | GPT_4_32K
  | GPT_4_32K_0314
  | GPT_3_5_TURBO
  | GPT_3_5_TURBO_0301

let string_of_chat_completion_model = function
  | GPT_4 -> {|"gpt-4"|}
  | GPT_4_0314 -> {|"gpt-4-0314"|}
  | GPT_4_32K -> {|"gpt-4-32k"|}
  | GPT_4_32K_0314 -> {|"gpt-4-32k-0314"|}
  | GPT_3_5_TURBO -> {|"gpt-3.5-turbo"|}
  | GPT_3_5_TURBO_0301 -> {|"gpt-3.5-turbo-0301"|}

let chat_completion_model_of_yojson = function
  | `String "gpt-4" -> Ok GPT_4
  | `String "gpt-4-0314" -> Ok GPT_4_0314
  | `String "gpt-4-32k" -> Ok GPT_4_32K
  | `String "gpt-4-32k-0314" -> Ok GPT_4_32K_0314
  | `String "gpt-3.5-turbo" -> Ok GPT_3_5_TURBO
  | `String "gpt-3.5-turbo-0301" -> Ok GPT_3_5_TURBO_0301
  | json -> Error (Yojson.Safe.to_string json)

let yojson_of_chat_completion_model v = v |> string_of_chat_completion_model |> Yojson.Safe.from_string

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

type chat_completion_body = {
  model : chat_completion_model [@to_yojson yojson_of_chat_completion_model] [@of_yojson chat_completion_model_of_yojson];
  messages : messages list [@default []]
} [@@deriving yojson]

type audio_transcription_body = {
  file : string;
  model : audio_transcription_model [@to_yojson yojson_of_audio_transcription_model] [@of_yojson audio_transcription_model_of_yojson]
} [@@deriving yojson]