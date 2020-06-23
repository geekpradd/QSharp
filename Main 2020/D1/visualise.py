import json
import numpy as np
import matplotlib.pyplot as plt


with open('data2.json') as f:
        data = json.load(f)

array = list(zip(data["Features"], data["Labels"]))
red = list(filter(lambda x: x[1] == 1, array))
red_x = [x[0][0] for x in red]
red_y = [x[0][1] for x in red]
blue = list(filter(lambda x: x[1] == 0, array))
blue_x = [x[0][0] for x in blue]
blue_y = [x[0][1] for x in blue]

plt.scatter(red_x, red_y, color='r')
plt.scatter(blue_x, blue_y, color='b')
plt.show()