namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
 
    operation Solve (qs : Qubit[], bits0 : Bool[], bits1 : Bool[]) : ()
    {
        body
        {
            mutable start = -1;
            mutable starter = -1;
            for (i in 0..Length(qs) - 1) {
                if (bits0[i] && bits1[i] ) {
                    X(qs[i]);
                }
                elif (bits0[i]){
                    if (start == -1){
                        H(qs[i]);
                        X(qs[i]);
                        set start = i;
                        set starter = 0;
                    }
                    else {
                        if (starter == 0){
                            CNOT(qs[start], qs[i]);
                        }
                        else {
                            X(qs[start]);
                            CNOT(qs[start], qs[i]);
                            X(qs[start]);
                        }
                    }
                }
                elif(bits1[i]){
                    if (start == -1){
                        H(qs[i]);
                        set start = i;
                        set starter = 1;
                    }
                    else {
                        if (starter == 0){
                            X(qs[start]);
                            CNOT(qs[start], qs[i]);
                            X(qs[start]);
                        }
                        else {
                            CNOT(qs[start], qs[i]);
                        }
                        
                    }
                }
            }
        }
    }

    operation Main(): () {
        body 
        {
            
        }
    }
}