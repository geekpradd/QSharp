namespace Solution {
    open Microsoft.Quantum.MachineLearning;
 
    operation Solve () : ((Int, Double[]), ControlledRotation[], (Double[], Double)){
        // your code here
        return ((1, [1.04]), [
        			ControlledRotation((0, new Int[0]), PauliX, 4),
            ControlledRotation((0, new Int[0]), PauliZ, 5),
            ControlledRotation((1, new Int[0]), PauliX, 6),
            ControlledRotation((1, new Int[0]), PauliZ, 7),
            ControlledRotation((0, [1]), PauliX, 0),
            ControlledRotation((1, [0]), PauliX, 1),
            ControlledRotation((1, new Int[0]), PauliZ, 2),
            ControlledRotation((1, new Int[0]), PauliX, 3)
                    ], ([0.05, 3.01, 2.2428, 0.7227999999999998, 1.0527999999999997, 1.2128, 4.2128000000000005, 5.8128]
, 0.1996403532281084
));
    }         
}