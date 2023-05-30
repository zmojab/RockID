import keras
import tensorflow as tf
import numpy as np
from keras.preprocessing import image
import matplotlib.pyplot as plt
import cv2
import os
from keras import layers
from keras.layers import Dense, Flatten
from keras.models import Sequential
from keras.optimizers import Adam

path = "C:/Users/wadea/Rock Gemstone/Rocks"
print(path)
img_height = 180
img_width = 180
batch_size = 32

trainData = tf.keras.preprocessing.image_dataset_from_directory(
  path,
  validation_split=0.2,
  subset="training",
  seed=123,
  label_mode='categorical',
  image_size=(img_height, img_width),
  batch_size=batch_size
)

valData = tf.keras.preprocessing.image_dataset_from_directory(
  path,
  validation_split=0.2,
  subset="validation",
  seed=123,
  label_mode='categorical',
  image_size=(img_height, img_width),
  batch_size=batch_size
)

classes = trainData.class_names

resnetModel = Sequential()

pretrained_model = tf.keras.applications.ResNet50(
  include_top=False,
  input_shape=(180, 180, 3),
  pooling='avg',
  classes=144,
  weights='imagenet'
)

for layer in pretrained_model.layers:
    layer.trainable = False

resnetModel.add(pretrained_model)
resnetModel.add(Flatten())
resnetModel.add(Dense(1024, activation='relu'))  # Increase the number of neurons
resnetModel.add(Dense(512, activation='relu'))
resnetModel.add(Dense(144, activation='softmax'))

resnetModel.summary()

resnetModel.compile(
  optimizer=Adam(learning_rate=0.001),
  loss='categorical_crossentropy',
  metrics=['accuracy']
)

epochs = 20  # Increase the number of epochs
history = resnetModel.fit(
  trainData,
  validation_data=valData,
  epochs=epochs
)
