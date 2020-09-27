{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE BlockArguments #-}
module Main where

import Control.Monad.Trans.Uplift

import Control.Monad.State
import Control.Monad.Writer
import Control.Monad.Reader

type Stack = StateT Bool (WriterT [String] (ReaderT Char IO))

runStack :: Stack a -> IO (a, [String])
runStack stack = runReaderT (runWriterT (evalStateT stack True)) 'X'

main :: IO ()
main = do
  (a, xs) <- runStack do
    uplift @(WriterT [String]) do
      tell ["One", "Two"]
      c <- uplift @(ReaderT Char) ask
      if c == 'X' then tell ["One, Two, Three, Four"]
      else pure ()
  guard (xs == ["One", "Two", "One, Two, Three, Four"])
