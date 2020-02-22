{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Foreign.ALPM.Internal.Types
       ( module Foreign.ALPM.Types.Foreign
       , module Control.Monad.IO.Class
       , module Control.Monad.Reader
       , module Control.Monad.Except
       , AlpmError (..)
       , AlpmM     (..)
       , Trace
       , AlpmList  (..)
       ) where

import           Foreign.ALPM.Types.Foreign
import           Foreign
import           Control.Monad.IO.Class
import           Control.Monad.Reader
import           Control.Monad.Except
import           Control.Exception
import           Data.Dynamic


type Trace = [String]

data AlpmError = AlpmError Trace (Maybe AlpmErrno) deriving (Typeable, Show)

instance Exception AlpmError where

newtype AlpmM a
    = AlpmM (ReaderT AlpmHandle (ExceptT AlpmError IO) a)
    deriving (Functor, Applicative, Monad, MonadIO)

deriving instance MonadError AlpmError AlpmM
deriving instance MonadReader AlpmHandle AlpmM

newtype AlpmList a = AlpmList { unAlpmList :: AlpmListPtr }
