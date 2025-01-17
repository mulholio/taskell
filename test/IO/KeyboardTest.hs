{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE OverloadedLists #-}

module IO.KeyboardTest
    ( test_keyboard
    ) where

import ClassyPrelude

import Test.Tasty
import Test.Tasty.HUnit

import Control.Lens ((.~))

import Data.Time.Clock (secondsToDiffTime)

import Data.Taskell.Lists.Internal (initial)
import Events.Actions.Types        as A
import Events.State                (create, quit)
import Events.State.Types          (State, Stateful, mode)
import Events.State.Types.Mode     (Mode (Shutdown))
import Graphics.Vty.Input.Events   (Event (..), Key (..))
import IO.Keyboard                 (generate)
import IO.Keyboard.Types

mockTime :: UTCTime
mockTime = UTCTime (ModifiedJulianDay 20) (secondsToDiffTime 0)

tester :: BoundActions -> Event -> Stateful
tester actions ev state = lookup ev actions >>= ($ state)

cleanState :: State
cleanState = create mockTime "taskell.md" initial

basicBindings :: Bindings
basicBindings = [(BChar 'q', A.Quit)]

basicActions :: Actions
basicActions = [(A.Quit, quit)]

basicResult :: Maybe State
basicResult = Just $ (mode .~ Shutdown) cleanState

test_keyboard :: TestTree
test_keyboard =
    testGroup
        "IO.Keyboard"
        [ testCase
              "generate"
              (assertEqual
                   "Parses basic"
                   basicResult
                   (tester (generate basicBindings basicActions) (EvKey (KChar 'q') []) cleanState))
        ]
