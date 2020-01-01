module Helpers.View exposing (when, whenJust, cappedHeight, cappedWidth, style, whenAttr)

{-| Use at will.

@docs when, whenJust, cappedHeight, cappedWidth, style, whenAttr

-}

import Element exposing (Attribute, Element, none)
import Html.Attributes
import Maybe.Extra


{-| Conditional display.
-}
when : Bool -> Element msg -> Element msg
when b elem =
    if b then
        elem

    else
        none


{-| Conditional attribute.
-}
whenAttr : Bool -> Attribute msg -> Attribute msg
whenAttr bool =
    if bool then
        identity

    else
        Html.Attributes.classList []
            |> Element.htmlAttribute
            |> always


{-| Maybe display.
-}
whenJust : (a -> Element msg) -> Maybe a -> Element msg
whenJust =
    Maybe.Extra.unwrap none


{-| Restrict width.
-}
cappedWidth : Int -> Attribute msg
cappedWidth n =
    Element.fill |> Element.maximum n |> Element.width


{-| Restrict height.
-}
cappedHeight : Int -> Attribute msg
cappedHeight n =
    Element.fill |> Element.maximum n |> Element.height


{-| Inline style.
-}
style : String -> String -> Attribute msg
style k v =
    Html.Attributes.style k v
        |> Element.htmlAttribute
