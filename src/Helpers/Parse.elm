module Helpers.Parse exposing (httpError, gqlHttpError, gqlError)

{-| Use at will.

@docs httpError, gqlHttpError, gqlError

-}

import Graphql.Http
import Graphql.Http.GraphqlError exposing (GraphqlError)
import Http
import Json.Decode


{-| TBA.
-}
gqlError : (List GraphqlError -> String) -> Graphql.Http.Error a -> String
gqlError fn err =
    case err of
        Graphql.Http.GraphqlError _ es ->
            fn es

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
