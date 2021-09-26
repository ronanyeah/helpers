module Helpers.Http exposing (parseError, parseGqlError, parseGqlHttpError, jsonResolver)

{-| Use at will.

@docs parseError, parseGqlError, parseGqlHttpError, jsonResolver

-}

import Dict
import Graphql.Http
import Http
import Json.Decode exposing (Decoder)
import Json.Encode


{-| TBA.
-}
parseGqlError : Graphql.Http.Error a -> String
parseGqlError err =
    case err of
        Graphql.Http.GraphqlError _ es ->
            es
                |> List.map
                    (\{ message, locations, details } ->
                        [ Just message
                        , locations
                            |> Maybe.andThen
                                (\xs ->
                                    if List.isEmpty xs then
                                        Nothing

                                    else
                                        xs
                                            |> List.map
                                                (\loc ->
                                                    [ "Line: " ++ String.fromInt loc.line
                                                    , "Column: " ++ String.fromInt loc.column
                                                    ]
                                                        |> String.join ", "
                                                )
                                            |> String.join "\n"
                                            |> Just
                                )
                        , if Dict.isEmpty details then
                            Nothing

                          else
                            details
                                |> Dict.toList
                                |> List.map
                                    (\( k, v ) ->
                                        k ++ ", " ++ Json.Encode.encode 0 v
                                    )
                                |> String.join "\n"
                                |> Just
                        ]
                            |> List.filterMap identity
                            |> String.join "\n"
                    )
                |> String.join "\n\n"

        Graphql.Http.HttpError e ->
            parseGqlHttpError e


{-| TBA.
-}
parseGqlHttpError : Graphql.Http.HttpError -> String
parseGqlHttpError =
    convertGqlHttpError >> parseError


convertGqlHttpError : Graphql.Http.HttpError -> Http.Error
convertGqlHttpError err =
    case err of
        Graphql.Http.BadUrl u ->
            Http.BadUrl u

        Graphql.Http.Timeout ->
            Http.Timeout

        Graphql.Http.NetworkError ->
            Http.NetworkError

        Graphql.Http.BadStatus { statusCode } _ ->
            Http.BadStatus statusCode

        Graphql.Http.BadPayload e ->
            Json.Decode.errorToString e
                |> Http.BadBody


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
