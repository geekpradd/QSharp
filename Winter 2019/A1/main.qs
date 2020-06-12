namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
 
    operation Solve (qs : Qubit[]) : Unit
    {
        body
        {
            X(qs[0]); X(qs[1]);
            mutable result = Zero;
            repeat {
                X(qs[0]); X(qs[1]);
                H(qs[0]); H(qs[1]);
                using (q = Qubit()){
                    Controlled X([qs[0], qs[1]], q);
                       
                    set result = M(q);
                   
                }
            }
            until (result == Zero);
            
        }
    }
    operation Main(): Unit {
        body {

        }
    }

}