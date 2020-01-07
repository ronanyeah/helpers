module Helpers.Parse exposing (httpError, gqlHttpError, gqlError)

{-| Use at will.

@docs httpError, gqlHttpError, gqlError

-}

import Dict
import Graphql.Http
import Http
import Json.Decode
import Json.Encode


{-| TBA.
-}
gqlError : Graphql.Http.Error a -> String
gqlError err =
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
            gqlHttpError e


{-| TBA.
-}
gqlHttpError : Graphql.Http.HttpError -> String
gqlHttpError err =
    case err of
        Graphql.Http.BadUrl _ ->
            "Bad Url"

        Graphql.Http.Timeout ->
            "Timeout"

        Graphql.Http.NetworkError ->
            "Network Error"

        Graphql.Http.BadStatus { statusCode } body ->
            "Status Code: "
                ++ String.fromInt statusCode
                ++ "\n"
                ++ body

        Graphql.Http.BadPayload e ->
            Json.Decode.errorToString e


{-| TBA.
-}
httpError : Http.Error -> String
httpError err =
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
