module Helpers.Parse exposing (httpError, gqlHttpError)

{-| Use at will.

@docs httpError, gqlHttpError

-}

import Graphql.Http
import Http
import Json.Decode


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
