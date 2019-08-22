module Helpers exposing (when, whenJust)

{-| Use at will.

@docs when, whenJust

-}

import Element exposing (Element, none)
import Maybe.Extra


{-| Conditional display.
-}
when : Bool -> Element msg -> Element msg
when b elem =
    if b then
        elem

    else
        none


{-| Maybe display.
-}
whenJust : (a -> Element msg) -> Maybe a -> Element msg
whenJust =
    Maybe.Extra.unwrap none
