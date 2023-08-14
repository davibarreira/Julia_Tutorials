import Control.Monad.Trans.Free (Free, liftF)
 
data CommandLineInstruction next =
    ReadLine (String -> next)
  | WriteLine String next
  deriving (Functor)
 
type CommandLineProgram = Free CommandLineInstruction
 
readLine :: CommandLineProgram String
readLine = liftF (ReadLine id)
 
writeLine :: String -> CommandLineProgram ()
writeLine s = liftF (WriteLine s ())
