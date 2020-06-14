import json

import qsharp
qsharp.packages.add("Microsoft.Quantum.MachineLearning::0.11.2004.2825")
qsharp.reload()

from Microsoft.Quantum.Samples import (
    TrainModel, TrainHalfMoonModel, ValidateHalfMoonModel, ClassifyHalfMoonModel
)

if __name__ == "__main__":
    with open('data2.json') as f:
        data = json.load(f)
    parameter_starting_points = [
        [1.0],
        [2.0]
     ]

    (parameters, bias) = TrainModel.simulate(
        trainingVectors=data['Features'],
        trainingLabels=data['Labels'],
        initialParameters=parameter_starting_points
    )
    print (parameters)
    print (bias)


    miss_rate = ValidateHalfMoonModel.simulate(
        validationVectors=data['Features'],
        validationLabels=data['Labels'],
        parameters=parameters, bias=bias
    )

    print(f"Miss rate: {miss_rate:0.2%}")