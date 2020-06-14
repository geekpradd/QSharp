namespace Solution {
     open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Extensions.Diagnostics;
 
    operation Solve (qs : Qubit[]) : Unit
    {
      
        X(qs[0]); X(qs[1]);
        mutable result = Zero;
        repeat {
            X(qs[0]); X(qs[1]);
            H(qs[0]); H(qs[1]);
            using (q = Qubit()){
                Controlled X([qs[0], qs[1]], q);
                   
                set result = M(q);
               
                Reset(q);
            }
 
        }
        until (result == Zero);
        X(qs[0]); X(qs[1]);
        
    }
   operation Main(): Unit {
        using (qs = Qubit[2]){
            Solve(qs);
            DumpMachine();
            ResetAll(qs);
        }
    }
   
 
}