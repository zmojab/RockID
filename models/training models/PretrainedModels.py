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
from keras.preprocessing.image import ImageDataGenerator


def resnet50(height,width,NumOfclasses):
    model = Sequential()

    pretrained_model = tf.keras.applications.ResNet50(
    include_top=False,
    input_shape=(height,width, 3),
    pooling='avg',
    classes=NumOfclasses,
    weights='imagenet'
    )

    for layer in pretrained_model.layers:
        layer.trainable = False

    model.add(pretrained_model)
    model.add(Flatten())
    model.add(Dense(1024, activation='relu'))  # Increase the number of neurons
    model.add(Dense(512, activation='relu'))
    model.add(Dense(NumOfclasses, activation='softmax'))
    model.summary()
    model.compile(optimizer=Adam(learning_rate=0.001), 
              loss='categorical_crossentropy', 
              metrics =['accuracy'])
    return model


def vgg16(height,width,NumOfclasses):
    data_augment=Sequential([
      layers.RandomFlip("horizontal_and_vertical"),
      layers.RandomRotation(0.2)
      ])
    
    model=Sequential()
    pretrained_model=tf.keras.applications.vgg16.VGG16(include_top=False,
                     weights='imagenet', 
                     input_shape=(height,width,3))
    for layer in pretrained_model.layers:
        layer.trainable = False
  
    model.add(pretrained_model)
    model.add(Flatten())
    model.add(Dense(1024, activation='relu'))  # Increase the number of neurons
    model.add(Dense(512, activation='relu'))
    model.add(Dense(NumOfclasses, activation='softmax'))
    model.summary()
    model.compile(optimizer=Adam(learning_rate=0.001), 
              loss='categorical_crossentropy', 
              metrics =['accuracy'])
    return model
  
  
  
def main():
    img_width=80; img_height=80
    batch_size=32

    TRAIN_DIR = "C:/Users/wadea/Rock Gemstone/training and val2/train"
    VAL_DIR = "C:/Users/wadea/Rock Gemstone/training and val2/val"
    #TRAIN_DIR = "C:/Users/wadea/Load data/Rock training and val sets/train"
    #VAL_DIR = "C:/Users/wadea/Load data/Rock training and val sets/val"


    train_data = ImageDataGenerator( 
                                    rescale=1./255,
                                    shear_range=0.2,
                                    zoom_range=0.2,
                                    horizontal_flip=True,
                                    
                                    vertical_flip=False  )
    
    val_data = ImageDataGenerator(rescale=1./255,
                                   
                                  )
    
    train_gen = train_data.flow_from_directory(TRAIN_DIR,
                                                    batch_size=batch_size,
                                                    class_mode='categorical',
                                                    shuffle=True,
                                                    target_size=(img_height, img_width))



    

    val_gen = val_data.flow_from_directory(VAL_DIR,
                                                    batch_size=batch_size,
                                                    class_mode='categorical',
                                                    shuffle=True,
                                                    target_size=(img_height, img_width)
                                                                )
    #line to choose and create model 
    model=vgg16(img_height,img_width,144)
    
    #fit model
    history = model.fit(train_gen,
                                epochs=10,
                                verbose=1,
                                validation_data=val_gen,
                                
                                )

    print("Evaluate")
   
    model.save("test.h5")
    #Plot accuracy
    plt.plot(history.history['accuracy'], label='Training Accuracy')
    plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
    plt.title('Accuracy')
    plt.xlabel('Epochs')
    plt.ylabel('Accuracy')
    plt.legend()
    plt.show()

    # Plot loss
    plt.plot(history.history['loss'], label='Training Loss')
    plt.plot(history.history['val_loss'], label='Validation Loss')
    plt.title('Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.show()

 
                                                

  
  

main()
