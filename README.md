# mtl-uplift

[![Hackage](https://img.shields.io/hackage/v/mtl-uplift.svg)](https://hackage.haskell.org/package/mtl-uplift)

Uplift entire substacks of monad transformer stacks, boilerplate free!

Many industry Haskell programmers are all too familiar with code like:
```haskell
lift . lift . lift . lift . lift . lift . lift . lift . lift . lift . lift . lift . lift $ do
  blah
```
This may or may not be an exaggeration. Now, we can just write the much less
visually annoying:
```haskell
uplift @TopOfSubstackT $ do
  blah
```
This relieves the programmer from having to do any bookkeeping about what
level of their greater stack their substack lives at, but just to know which monad tops it.
Beyond that, if we transform our stack, with the old code we would potentially have to modify the number of
calls to `lift`, but now, as long as we still want to `uplift` a substack with
the same top, we don't have to. Isn't that uplifting?

Here is a more complete example from the tests:

```haskell
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
```
