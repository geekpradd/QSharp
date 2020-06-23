// namespace trial {

// 	open Microsoft.Quantum.Measurement;
//     open Microsoft.Quantum.Arrays;
//     open Microsoft.Quantum.Arithmetic;
//     open Microsoft.Quantum.Convert;
//     open Microsoft.Quantum.Math;
//     open Microsoft.Quantum.Diagnostics;
//     open Microsoft.Quantum.Intrinsic;
//     open Microsoft.Quantum.Canon;

//     operation prepareUniform(qs: Qubit[]): Unit{
//     	for (q in qs){
//     		H(q);
//     	}
//     }
//     operation lets(qs: Qubit): Unit is Adj+Ctl {

//     	using (anc = Qubit()){
//     		prepareUniform([anc]);

//     		prepareUniform([anc]);

//     		Reset(anc);
//     	}
//     }
// 	operation Main(): Unit {
//         using (q = Qubit()){
//             lets(q);
//             DumpMachine();
//             Reset(q);
//         }
//     }
// }