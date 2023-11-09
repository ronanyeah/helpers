module Example exposing (suite)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Helpers.Http
import Helpers.View
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "describe"
        [ test "test" <|
            \_ ->
                Expect.equal 1 1
        ]
