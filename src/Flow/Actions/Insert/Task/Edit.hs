module Flow.Actions.Insert.Task.Edit (event) where

import Graphics.Vty.Input.Events
import Flow.State

event :: Event -> Stateful
event (EvKey KEnter _) = (write =<<) . normalMode
event _ = return
