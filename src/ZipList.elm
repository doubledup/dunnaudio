module ZipList exposing
    ( ZipList
    , getNext
    , getPrevious
    , selectNext
    , selectPrevious
    )


type alias ZipList a =
    { beforeReversed : List a
    , current : a
    , after : List a
    }


selectNext : ZipList a -> ZipList a
selectNext { beforeReversed, current, after } =
    case ( beforeReversed, current, after ) of
        ( beforeList, selected, afterHead :: afterRest ) ->
            { beforeReversed = selected :: beforeList
            , current = afterHead
            , after = afterRest
            }

        ( beforeList, selected, [] ) ->
            let
                beforeListInOrder =
                    List.reverse beforeList
            in
            case beforeListInOrder of
                beforeFirst :: beforeRest ->
                    { beforeReversed = []
                    , current = beforeFirst
                    , after = beforeRest ++ [ selected ]
                    }

                [] ->
                    { beforeReversed = []
                    , current = selected
                    , after = []
                    }


selectPrevious : ZipList a -> ZipList a
selectPrevious { beforeReversed, current, after } =
    case ( beforeReversed, current, after ) of
        ( beforeHead :: beforeRest, selected, afterList ) ->
            { beforeReversed = beforeRest
            , current = beforeHead
            , after = selected :: afterList
            }

        ( [], selected, afterList ) ->
            let
                afterListReversed =
                    List.reverse afterList
            in
            case afterListReversed of
                lastItem :: afterRestReversed ->
                    { beforeReversed = afterRestReversed ++ [ selected ]
                    , current = lastItem
                    , after = []
                    }

                [] ->
                    { beforeReversed = []
                    , current = selected
                    , after = []
                    }


getNext : ZipList a -> a
getNext { beforeReversed, current, after } =
    case after of
        afterHead :: _ ->
            afterHead

        [] ->
            let
                beforeFirst =
                    beforeReversed |> List.reverse |> List.head
            in
            case beforeFirst of
                Just first ->
                    first

                Nothing ->
                    current


getPrevious : ZipList a -> a
getPrevious { beforeReversed, current, after } =
    case beforeReversed of
        beforeHead :: _ ->
            beforeHead

        [] ->
            let
                afterLast =
                    after |> List.reverse |> List.head
            in
            case afterLast of
                Just last ->
                    last

                Nothing ->
                    current
