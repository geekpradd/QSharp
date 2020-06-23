namespace Solution {
    open Microsoft.Quantum.MachineLearning;
 
    operation Solve () : ((Int, Double[]), ControlledRotation[], (Double[], Double)){
        // your code here
        return ((4, [1.0, 1.0]), [
            ControlledRotation((1, new Int[0]), PauliZ, 2),
            ControlledRotation((0, [1]), PauliX, 0),
            ControlledRotation((1, [0]), PauliX, 1)
        ], ( [1.0, 0.5, 3.355650000000001]
, 0.32409680706456223
));
    }         
}