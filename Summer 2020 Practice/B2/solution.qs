namespace Solution {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Extensions.Diagnostics;
    open Microsoft.Quantum.Convert;
 
    operation Auxillary (register : LittleEndian) : Unit is Adj+Ctl  {
        let array = register!;
        let n = Length(array);
        for (i in 0..n-2){
            let j = n-2-i;
            Controlled X(array[0..j], array[j+1]);
        }
        X(array[0]);
    }
    operation Solve (register : LittleEndian) : Unit is Adj+Ctl  {
        Adjoint Auxillary(register);
    }
    
   // operation Main(): Unit {
   //      using (qs = Qubit[2]){
   //          X(qs[0]);
   //          X(qs[1]);
   //          let vs = LittleEndian(qs);
   //          Solve(vs);
   //          let zs = MeasureInteger(vs);
   //          let outtts = IntAsString(zs);
   //          Message(outtts);
   //          // DumpMachine();
   //          ResetAll(qs);
   //      }
   //  }
   
 
}