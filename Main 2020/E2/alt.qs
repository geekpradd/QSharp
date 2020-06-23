namespace Solut {
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

     operation makeBell(qs: Qubit[]): Unit is Adj+Ctl{
        X(qs[0]);
        H(qs[0]);
        CNOT(qs[0], qs[1]);
        // X(qs[0]);
    }

     operation GetPhase( anc: Qubit[], inputRegister: LittleEndian): Unit is Adj+Ctl{
        H(anc[0]); 
        H(anc[1]);

        Controlled QFTLE([anc[1]], inputRegister);
        Controlled QFTLE([anc[0]], inputRegister);
        Controlled QFTLE([anc[0]], inputRegister);
        let reg = LittleEndian(anc);
        
        Adjoint QFTLE(reg);
    }
    operation Solve (p : Int, inputRegister : LittleEndian) : Unit is Adj+Ctl {
        //let inp = inputRegister!;
        using (qs = Qubit[2]) {
            GetPhase(qs, inputRegister);
           R1(PI()/IntAsDouble(p), qs[1]);
            R1(PI()/IntAsDouble(2*p), qs[0]);
            Adjoint GetPhase(qs, inputRegister);
        }
    }


    operation Main(): Unit {
        using (qs = Qubit[2]){
            makeBell(qs);
            //X(qs[0]);
            // H(qs[0]);
            let reg = LittleEndian(qs);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            Solve(7, reg);
            // QFTLE(reg);
            // QuantumFourierTransform_Reference(qs, 1);
            // QuantumFourierTransform_Reference(qs, 1);
            DumpMachine();
            ResetAll(qs);
        }
    }
}