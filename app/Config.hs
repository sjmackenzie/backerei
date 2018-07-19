module Config where

import qualified Data.Aeson       as A
import qualified Data.Aeson.Types as A
import           Data.Char        (isLower, toLower)
import qualified Data.Text        as T
import qualified Data.Yaml        as Y
import           Foundation
import           GHC.Generics
import qualified Prelude          as P

data Config = Config {
  configBakerAddress :: T.Text
} deriving (Generic)

loadConfig ∷ P.FilePath → IO (Maybe Config)
loadConfig = Y.decodeFile

writeConfig ∷ P.FilePath → Config → IO ()
writeConfig = Y.encodeFile

instance Y.FromJSON Config where
  parseJSON = customParseJSON

instance Y.ToJSON Config where
  toJSON = customToJSON
  toEncoding = customToEncoding

jsonOptions ∷ A.Options
jsonOptions = A.defaultOptions {
  A.fieldLabelModifier = (\(h:t) -> toLower h : t) . dropWhile isLower,
  A.omitNothingFields  = True,
  A.sumEncoding        = A.ObjectWithSingleField
}

customParseJSON :: (Generic a, A.GFromJSON A.Zero (Rep a)) => Y.Value -> Y.Parser a
customParseJSON = A.genericParseJSON jsonOptions

customToJSON = A.genericToJSON jsonOptions

customToEncoding = A.genericToEncoding jsonOptions