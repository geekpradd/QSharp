namespace Solution {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Diagnostics; 

    function toBit(num:Int) : Bool[] {
        mutable n = num;
        mutable array = new Bool[3];            
        for (index in 0 .. 2) {
            let checker = n%2;                    
            set array w/= index <-                    
                checker == 1 ? true | false;    
            set n = n/2;     
        }    
        return array;
    }

    operation Adder(array: Qubit[]): Unit is Adj+Ctl{
        let n = Length(array);
        for (i in 0..n-2){
            let j = n-2-i;
            Controlled X(array[0..j], array[j+1]);
        }
        X(array[0]);
    }
    operation Solve (inputs : Qubit[], output : Qubit) : Unit is Adj+Ctl {
        // your code here
        let req = Length(inputs)/2;
        let n = Length(inputs);
        using (anc = Qubit[3]){
            for (i in 0..n-1){
                Controlled Adder([inputs[i]], anc);
            }
            
            let bitrep = toBit(req);

            (ControlledOnBitString(bitrep, X))(anc, output);
            for (i in 0..n-1){
                let j = n-1-i;
                Adjoint Controlled Adder([inputs[j]], anc);
            }
        }
    }

    operation Main(): Unit {
        using ((q, v) = (Qubit[6], Qubit())){
            X(q[0]); X(q[1]); X(q[4]);
            Solve(q, v);
            let r = M(v);
            if (r == One){
                Message("Yes");
            }
            else {
                Message("No");
            }
            ResetAll(q);
            Reset(v);
        }
    }

}