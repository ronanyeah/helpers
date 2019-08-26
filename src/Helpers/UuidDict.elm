module Helpers.UuidDict exposing (insert, remove, map, fromList, empty, size, values, isEmpty, get, union, UuidDict)

{-| Use at will.

@docs insert, remove, map, fromList, empty, size, values, isEmpty, get, union, UuidDict

-}

import Dict exposing (Dict)
import Uuid exposing (Uuid)


{-| TBA.
-}
type UuidDict a
    = UuidDict (Dict String a)


apply : (Dict String a -> Dict String a) -> UuidDict a -> UuidDict a
apply fn (UuidDict d) =
    d
        |> fn
        |> UuidDict


{-| TBA.
-}
insert : Uuid -> a -> UuidDict a -> UuidDict a
insert i a =
    Dict.insert (Uuid.toString i) a
        |> apply


{-| TBA.
-}
remove : Uuid -> UuidDict a -> UuidDict a
remove i =
    Dict.remove (Uuid.toString i)
        |> apply


{-| TBA.
-}
map : Uuid -> (a -> a) -> UuidDict a -> UuidDict a
map i fn =
    Dict.update (Uuid.toString i) (Maybe.map fn)
        |> apply


{-| TBA.
-}
union : UuidDict a -> UuidDict a -> UuidDict a
union (UuidDict a) (UuidDict b) =
    Dict.union a b
        |> UuidDict


{-| TBA.
-}
fromList : List { a | id : Uuid } -> UuidDict { a | id : Uuid }
fromList =
    List.map (\a -> ( Uuid.toString a.id, a ))
        >> Dict.fromList
        >> UuidDict


{-| TBA.
-}
empty : UuidDict a
empty =
    UuidDict Dict.empty


{-| TBA.
-}
size : UuidDict a -> Int
size (UuidDict d) =
    Dict.size d


{-| TBA.
-}
values : UuidDict a -> List a
values (UuidDict d) =
    Dict.values d


{-| TBA.
-}
isEmpty : UuidDict a -> Bool
isEmpty =
    size >> (==) 0


{-| TBA.
-}
get : Uuid -> UuidDict a -> Maybe a
get i (UuidDict d) =
    Dict.get (Uuid.toString i) d
