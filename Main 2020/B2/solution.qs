namespace Solution {
	open Microsoft.Quantum.Primitive;
	open Microsoft.Quantum.Canon;
	operation AddBitsMod3 (queryRegister : Qubit[], ancillaRegister : Qubit[]) : Unit is Adj+Ctl {
		let sum = ancillaRegister[0];
		let carry = ancillaRegister[1];
		let n = Length(queryRegister);
		for (j in 0..n-1) {
			let i = n-1-j;
			// we need to implement addition mod 3:
			// bit sum carry | sum carry
			// 1 0 0 | 1 0
			// 1 1 0 | 0 1
			// 1 0 1 | 0 0
			// compute sum bit
			(ControlledOnBitString([true, false], X))([queryRegister[i], carry], sum);
			(ControlledOnBitString([true, false], X))([queryRegister[i], sum], carry);
			if (j%2 == 0){
				(ControlledOnBitString([true, false], X))([queryRegister[i], carry], sum);
				(ControlledOnBitString([true, false], X))([queryRegister[i], sum], carry);
			}
			
		}
	}

	operation Solve (x : Qubit[], y : Qubit) : Unit is Adj+Ctl{
		using (anc = Qubit[2]){
			AddBitsMod3(x, anc);
			(ControlledOnBitString([false, false], X))(anc, y);
			Adjoint AddBitsMod3(x, anc);
		}
	}

	operation Main(): Unit {
		using ((qs, q) = (Qubit[3], Qubit())){
			X(qs[0]); X(qs[1]); X(qs[2]);
			Solve(qs, q);
			let r = M(q);
			if (r == One){
				Message("Divisible");
			}
			else {
				Message("Nope");
			}
			ResetAll(qs);
			Reset(q);
		}
	}
}
