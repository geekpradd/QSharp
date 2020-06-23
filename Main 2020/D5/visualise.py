import json
import numpy as np
import matplotlib.pyplot as plt
import statistics

def our_data():
	with open('data3.json') as f:
	        data = json.load(f)

	array = list(zip(data["Features"], data["Labels"]))
	red = list(filter(lambda x: x[1] == 1, array))

	red_x = [x[0][0] for x in red]
	red_y = [x[0][1] for x in red]
	blue = list(filter(lambda x: x[1] == 0, array))
	blue_x = [x[0][0] for x in blue]
	blue_y = [x[0][1] for x in blue]

	# all_x = red_x + blue_x
	# all_y = red_y + blue_y
	# mean_x = statistics.mean(all_x) 
	# mean_y = statistics.mean(all_y)
	# std_x = statistics.stdev(all_x)
	# std_y = statistics.stdev(all_y)
	# red_x = [(x-mean_x)/std_x for x in red_x]
	# blue_x = [(x-mean_x)/std_x for x in blue_x]
	# red_y = [(y-mean_y)/std_y for y in red_y]
	# blue_y = [(y-mean_y)/std_y for y in blue_y]

	data_x = list(range(-20, 11))
	data_x = [x/10 for x in data_x]
	data_y = [3.25 - (3.25**2 -(x+2)*(x+2))**(0.5) for x in data_x]

	print (len(red_x) + len(red_y))
	plt.scatter(red_x, red_y, color='r')
	plt.scatter(blue_x, blue_y, color='b')
	plt.scatter(data_x, data_y, color='g')
	plt.show()

def half_moon():
	with open('halfmoon.json') as f:
	        data = json.load(f)

	array = list(zip(data["TrainingData"]["Features"], data["TrainingData"]["Labels"]))
	red = list(filter(lambda x: x[1] == 1, array))
	red_x = [x[0][0] for x in red]
	red_y = [x[0][1] for x in red]
	blue = list(filter(lambda x: x[1] == 0, array))
	blue_x = [x[0][0] for x in blue]
	blue_y = [x[0][1] for x in blue]

	plt.scatter(red_x, red_y, color='r')
	plt.scatter(blue_x, blue_y, color='b')
	plt.show()

our_data()