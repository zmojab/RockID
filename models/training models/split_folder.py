#spilts image datasets to traing validation and testing sets
import splitfolders
input_folder = "C:/Users/wadea/Rock Gemstone/Rocks"
output = "C:/Users/wadea/Rock Gemstone/training and val and test 3"
splitfolders.ratio(input_folder, output=output, seed=42, ratio=(.8, .1,.1))

