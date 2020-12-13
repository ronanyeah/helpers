module Helpers.View exposing (when, whenJust, cappedHeight, cappedWidth, style, whenAttr, dataAttr)

{-| Use at will.

@docs when, whenJust, cappedHeight, cappedWidth, style, whenAttr, dataAttr

-}

import Element exposing (Attribute, Element, none)
import Html.Attributes


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
        Element.below Element.none
            |> always


{-| Maybe display.
-}
whenJust : (a -> Element msg) -> Maybe a -> Element msg
whenJust fn =
    Maybe.map fn >> Maybe.withDefault none


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


{-| Data attribute.
-}
dataAttr : String -> String -> Attribute msg
dataAttr key =
    Html.Attributes.attribute ("data-" ++ key)
        >> Element.htmlAttribute
