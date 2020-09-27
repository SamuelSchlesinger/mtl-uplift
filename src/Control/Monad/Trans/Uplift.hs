{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE PolyKinds #-}
{- |
Module: Control.Monad.Trans.Uplift
Description: Uplift substacks of monad transformer stacks
Copyright: (c) Samuel Schlesinger 2020
Maintainer: sgschlesinger@gmail.com
Stability: experimental
Portability: POSIX, Windows
-}
module Control.Monad.Trans.Uplift
  ( uplift
  , Substack(..)
  , Uplift
  , IndexOf
  , N(..)
  ) where

import Control.Monad.Trans (MonadTrans(lift))

-- | Type level natural numbers
data N = S N | Z

-- | A type family for computing the substack of a monad transformer stack,
-- dropping the top n transformers.
type family Substack n f where
  Substack 'Z f = f
  Substack ('S n) (t f) = Substack n f

-- | A class for lifting arbitrary substacks of our transformer stack.
class Uplift n f where
  liftSubstack :: Substack n f a -> f a

instance Uplift 'Z f where
  liftSubstack = id

instance (Monad f, MonadTrans t, Uplift n f) => Uplift ('S n) (t f) where
  liftSubstack = lift . liftSubstack @n

-- | A type family for computing the index of a particular transformer in
-- a stack.
type family IndexOf t f where
  IndexOf t (t f) = 'Z
  IndexOf t (t' f) = 'S (IndexOf t f)

-- | Uplift the substack starting with the given transformer into the full
-- stack. This function is expected to be used with type applications when
-- working with polymorphic code.
uplift :: forall t f a. Uplift (IndexOf t f) f => Substack (IndexOf t f) f a -> f a
uplift = liftSubstack @(IndexOf t f)
