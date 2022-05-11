port module Qcm exposing (..)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Browser
import Dict as Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Encode as E
import Markdown
import Random


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }


type alias QCM =
    { nbQuestions : Int
    , niveauCandidat : Float
    , note : Int
    , range : Int
    }


type alias Model =
    { qcm : QCM
    , simulations : Dict.Dict Int Int
    }


type Msg
    = ChangeNbQuestions String
    | ChangeNiveau String
    | Simulate
    | ShowHistogram (Dict.Dict Int Int)
    | ChangeNote String
    | ComputeP
    | ChangeRange String


init : () -> ( Model, Cmd Msg )
init _ =
    ( { qcm = QCM 20 0.5 13 100, simulations = Dict.empty }, Cmd.batch [ Random.generate ShowHistogram <| lotSimulations 20 0.5, renderPlot2 <| encodePlot [ encodeHP 20 13 100 ] ] )


view : Model -> Html Msg
view model =
    div []
        [ CDN.stylesheet
        , description1
        , form1 model
        , distribution1
        , description2
        , form2 model
        , distribution2
        ]


description1 : Html msg
description1 =
    Markdown.toHtml [] <|
        """
# Exemple : un QCM


Un QCM, constitué de *N* questions est proposé à un candidat. On suppose les questions indépendantes et de même difficulté. Pour chaque question, 2 réponses sont proposées dont une et une seule est correcte.

Si le candidat connait la réponse, il répond correctement. Sinon il choisit au hasard une réponse. On note *p* la probabilité que le candidat connaisse la réponse.


## Le point de vue du candidat

On conduit ci-dessous cette expérience un grand nombre de fois informatiquement et on répertorie la distribution de la note finale (1 point par bonne réponse, 0 pour une mauvaise réponse.)
        """


form1 : Model -> Html Msg
form1 model =
    Form.form []
        [ Form.row []
            [ Form.col []
                [ Form.group []
                    [ Form.label [] [ text "Nombre de questions" ]
                    , Input.text [ Input.onInput ChangeNbQuestions, Input.value <| String.fromInt model.qcm.nbQuestions ]
                    ]
                ]
            , Form.col []
                [ Form.group []
                    [ Form.label [] [ text "Niveau du candidat" ]
                    , Input.number
                        [ Input.onInput ChangeNiveau
                        , if model.qcm.niveauCandidat <= 1 && model.qcm.niveauCandidat >= 0 then
                            Input.success

                          else
                            Input.danger
                        , Input.value <| String.fromFloat model.qcm.niveauCandidat
                        ]
                    ]
                ]
            ]
        , Button.button [ Button.onClick Simulate, Button.primary, Button.block ]
            [ text "Lancer les simulations"
            ]
        ]


distribution1 : Html msg
distribution1 =
    div [ id "distribution" ] []


description2 : Html Msg
description2 =
    div []
        [ Markdown.toHtml [] """
## Le point de vue du professeur

Du point de vue du professeur, c'est la quantité inconnue *p* qui est intérssante : elle représente le niveau du candidat. Il s'agit donc d'estimer *p* à partir de la note obtenue au QCM.

On peut utiliser le théorème de Bayes pour y parvenir : pour se ramener dans le cadre des probabilités finies, on suppose que le paramètre *p* ne prend qu'un nombre fini de valeurs : $$p = \\frac{k}{n} \\text{ pour } k \\in \\{0,1,\\dots,n\\}$$ et on fait l'hypothèse qu' *a priori* ces valeurs sont équiprobables. (Il est tout à fait possible de tester d'autres distributions !)

En notant *N* la note obtenue, *t* le nombre total de questions, la formule de Bayes donne alors
"""
        , text """
$$ \\forall k, P_{N=x}(p=k/n) = \\frac{1}{\\sum_{j=0}^n \\binom{t}{x} \\left(\\frac{n+j}{2n}\\right)^x \\left(1-\\frac{n+j}{2n}\\right)^{t-x}   } \\binom{t}{x} \\left(\\frac{n+k}{2n}\\right)^x \\left(1-\\frac{n+k}{2n}\\right)^{t-x}.$$

Le graphique ci-dessous représente ces différentes probabilités.
        """
        ]


form2 : Model -> Html Msg
form2 model =
    Form.form []
        [ Form.row []
            [ Form.col []
                [ Form.group []
                    [ Form.label [] [ text "Nombre de questions" ]
                    , Input.number [ Input.onInput ChangeNbQuestions, Input.value <| String.fromInt model.qcm.nbQuestions ]
                    ]
                ]
            , Form.col []
                [ Form.group []
                    [ Form.label [] [ text "Note du candidat" ]
                    , Input.number [ Input.onInput ChangeNote, Input.value <| String.fromInt model.qcm.note ]
                    ]
                ]
            , Form.col []
                [ Form.group []
                    [ Form.label [] [ text "Nombre de valeurs que peur prendre p" ]
                    , Input.number [ Input.onInput ChangeRange, Input.value <| String.fromInt model.qcm.range ]
                    ]
                ]
            ]
        , Button.button [ Button.onClick ComputeP, Button.primary, Button.block ] [ text "Afficher la distribution de p" ]
        ]


distribution2 : Html msg
distribution2 =
    div [ id "distribution2" ] []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeNbQuestions n ->
            case String.toInt n of
                Just nb ->
                    let
                        qcm =
                            model.qcm
                    in
                    ( { model | qcm = { qcm | nbQuestions = nb } }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeNiveau p ->
            case String.toFloat p of
                Just pr ->
                    let
                        qcm =
                            model.qcm
                    in
                    ( { model | qcm = { qcm | niveauCandidat = pr } }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeNote n ->
            case String.toInt n of
                Just note ->
                    let
                        qcm =
                            model.qcm
                    in
                    ( { model | qcm = { qcm | note = note } }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        ChangeRange n ->
            case String.toInt n of
                Just note ->
                    let
                        qcm =
                            model.qcm
                    in
                    ( { model | qcm = { qcm | range = note } }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )

        Simulate ->
            ( model, Random.generate ShowHistogram <| lotSimulations model.qcm.nbQuestions model.qcm.niveauCandidat )

        ShowHistogram d ->
            -- ( { model | simulations = d }, renderPlot <| encodePlot [ encodeTheorie model.qcm.nbQuestions ((1 + model.qcm.niveauCandidat) / 2) ] )
            ( { model | simulations = d }, renderPlot <| encodePlot [ encodeH d ] )

        -- ShowHistogram2 d ->
        --     ( { model | simulations = d }, renderPlot2 <| encodePlot <| encodeH d )
        ComputeP ->
            ( model, renderPlot2 <| encodePlot [ encodeHP model.qcm.nbQuestions model.qcm.note model.qcm.range ] )


encodeHP : Int -> Int -> Int -> E.Value
encodeHP nbQ note precision =
    E.object
        [ ( "x", E.list E.float <| List.map (\k -> toFloat k / toFloat precision) <| List.range 0 precision )
        , ( "y", E.list E.float <| List.map (\k -> computePr precision nbQ k precision note) (List.range 0 precision) )
        , ( "type", E.string "bar" )
        ]


computeBinomial : Int -> Int -> Int -> Int -> Float
computeBinomial t k n s =
    toFloat (binom t s) * (List.product <| List.repeat s (toFloat (n + k) / toFloat (2 * n))) * (List.product <| List.repeat (t - s) (toFloat (n - k) / toFloat (2 * n)))


computePr : Int -> Int -> Int -> Int -> Int -> Float
computePr precision nbQ k n note =
    let
        x =
            computeBinomial nbQ k n note

        norm =
            List.sum <| List.map (\j -> computeBinomial nbQ j n note) <| List.range 0 precision
    in
    x / norm


binom : Int -> Int -> Int
binom n k =
    if k < n // 2 then
        let
            num =
                List.product <| List.range (n - k + 1) n

            den =
                List.product <| List.range 1 k
        in
        num // den

    else
        binom n (n - k)


bernoulli : Float -> Random.Generator Int
bernoulli p =
    Random.map
        (\x ->
            if x <= p then
                1

            else
                0
        )
    <|
        Random.float 0 1


binomiale : Int -> Float -> Random.Generator Int
binomiale n p =
    Random.map List.sum (Random.list n <| bernoulli p)


oneAnswer : Float -> Random.Generator Int
oneAnswer p =
    Random.andThen
        (\b ->
            if b == 1 then
                Random.constant 1

            else
                bernoulli 0.5
        )
        (bernoulli p)


simulation : Int -> Float -> Random.Generator Int
simulation n p =
    Random.map List.sum (Random.list n <| oneAnswer p)


lotSimulations : Int -> Float -> Random.Generator (Dict.Dict Int Int)
lotSimulations n p =
    Random.map histogram (Random.list nbSimulations <| simulation n p)


histogram : List Int -> Dict.Dict Int Int
histogram notes =
    List.foldl
        (\n d ->
            Dict.update n
                (\x ->
                    case x of
                        Nothing ->
                            Just 1

                        Just xx ->
                            Just (xx + 1)
                )
                d
        )
        Dict.empty
        notes


encodeH : Dict.Dict Int Int -> E.Value
encodeH d =
    E.object
        [ ( "x", E.list (\( a, _ ) -> E.int a) <| Dict.toList d )
        , ( "y", E.list (\( _, a ) -> E.int a) <| Dict.toList d )
        , ( "type", E.string "bar" )
        ]


encodeTheorie : Int -> Float -> E.Value
encodeTheorie n p =
    E.object
        [ ( "x", E.list E.int <| List.range 0 n )
        , ( "y", E.list E.float <| List.map (\k -> toFloat nbSimulations * (toFloat <| binom n k) * (List.product <| List.repeat k p) * (List.product <| List.repeat (n - k) (1 - p))) <| List.range 0 n )
        , ( "type", E.string "scatter" )
        ]


encodePlot : List E.Value -> E.Value
encodePlot vs =
    E.object [ ( "data", E.list identity vs ) ]


port renderPlot : E.Value -> Cmd msg


port renderPlot2 : E.Value -> Cmd msg


nbSimulations =
    5000
