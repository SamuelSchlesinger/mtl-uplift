# mtl-uplift

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
level of their greater stack their substack lives at when they do this, but
just to know what the monad at the top is. Beyond that, if we transform our
stack, with the old code we would potentially have to modify the number of
calls to `lift`, but now, as long as we still want to `uplift` a substack with
the same top, we don't have to. Isn't that uplifting?
