import json
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as colors
import matplotlib.cm as cmx
plt.style.use('ggplot')
import qsharp
qsharp.packages.add("Microsoft.Quantum.MachineLearning::0.11.2004.2825")
qsharp.reload()

from Microsoft.Quantum.Samples import (
    TrainModel, TrainHalfMoonModel, ValidateHalfMoonModel, ClassifyHalfMoonModel
)

if __name__ == "__main__":
    with open('data3.json') as f:
        data = json.load(f)
    parameter_starting_points = [
        [0.05, 3.01, 2.2428, 0.7227999999999998, 1.0527999999999997, 1.2128, 4.2128000000000005, 5.8128]
     ]

    (parameters, bias) = TrainHalfMoonModel.simulate(
        trainingVectors=data['Features'],
        trainingLabels=data['Labels'],
        initialParameters=parameter_starting_points
    )

    
    # parameters = [0.7853981633974483];
    # bias = 0;
    print (parameters)
    print (bias)


    miss_rate = ValidateHalfMoonModel.simulate(
        validationVectors=data['Features'],
        validationLabels=data['Labels'],
        parameters=parameters, bias=bias
    )

    print(f"Miss rate: {miss_rate:0.2%}")

    actual_labels = data['Labels']
    classified_labels = ClassifyHalfMoonModel.simulate(
        samples=data['Features'],
        parameters=parameters, bias=bias,
        tolerance=0.005, nMeasurements=10_000
    )


    # To plot samples, it's helpful to have colors for each.
    # We'll plot four cases:
    # - actually 0, classified as 0
    # - actually 0, classified as 1
    # - actually 1, classified as 1
    # - actually 1, classified as 0
    cases = [
        (0, 0),
        (0, 1),
        (1, 1),
        (1, 0)
    ]
    # We can use these cases to define markers and colormaps for plotting.
    markers = [
        '.' if actual == classified else 'x'
        for (actual, classified) in cases
    ]
    colormap = cmx.ScalarMappable(colors.Normalize(vmin=0, vmax=len(cases) - 1))
    colors = [colormap.to_rgba(idx_case) for (idx_case, case) in enumerate(cases)]

    # It's also really helpful to have the samples as a NumPy array so that we
    # can find masks for each of the four cases.
    samples = np.array(data['Features'])

    # Finally, we loop over the cases above and plot the samples that match
    # each.
    for (idx_case, ((actual, classified), marker, color)) in enumerate(zip(cases, markers, colors)):
        mask = np.logical_and(
            np.equal(actual_labels, actual),
            np.equal(classified_labels, classified)
        )
        if not np.any(mask):
            continue
        plt.scatter(
            samples[mask, 0],
            samples[mask, 1],
            c=[color],
            label=f"Was {actual}, classified {classified}",
            marker=marker
        )
    plt.legend()
    plt.show()