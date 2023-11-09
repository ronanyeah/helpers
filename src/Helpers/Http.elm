module Helpers.Http exposing (parseError, jsonResolver)

{-| Use at will.

@docs parseError, jsonResolver

-}

import Http
import Json.Decode exposing (Decoder)


{-| TBA.
-}
parseError : Http.Error -> String
parseError err =
    case err of
        Http.BadUrl _ ->
            "Bad Url"

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network Error"

        Http.BadStatus statusCode ->
            "Status Code: " ++ String.fromInt statusCode

        Http.BadBody e ->
            e


{-| TBA.
-}
jsonResolver : Decoder a -> Http.Resolver Http.Error a
jsonResolver decoder =
    Http.stringResolver
        (\response ->
            case response of
                Http.BadUrl_ u ->
                    Http.BadUrl u
                        |> Err

                Http.Timeout_ ->
                    Http.Timeout
                        |> Err

                Http.NetworkError_ ->
                    Http.NetworkError
                        |> Err

                Http.BadStatus_ metadata _ ->
                    Http.BadStatus metadata.statusCode
                        |> Err

                Http.GoodStatus_ _ body_ ->
                    body_
                        |> Json.Decode.decodeString decoder
                        |> Result.mapError (Json.Decode.errorToString >> Http.BadBody)
        )
