import keras
import tensorflow as tf
import numpy as np
from keras.preprocessing import image
import matplotlib.pyplot as plt
import cv2
import os
from keras import layers
from keras.layers import Dense, Flatten,Conv2D, MaxPooling2D,Dropout,BatchNormalization
from keras.models import Sequential
from keras.optimizers import Adam
from keras.preprocessing.image import ImageDataGenerator


def simplemodel1(height,width,classes):
    model=Sequential()
    model.add(Conv2D(32,(3,3),activation='relu',input_shape=(height,width,3)))
    model.add(MaxPooling2D(pool_size=(2,2)))

    model.add(Conv2D(32,(3,3),activation='relu'))
    model.add(MaxPooling2D(pool_size=(2,2)))

    model.add(Flatten())
    model.add(Dense(128,activation=tf.nn.relu))
    model.add(Dense(classes,activation=tf.nn.softmax))
    model.summary()
    model.compile(optimizer=Adam(learning_rate=0.001), 
              loss='categorical_crossentropy', 
              metrics =['accuracy'])
    return model

def ModelWithBatchNormalization(height,width,classes):
    model=Sequential()
    model.add(Conv2D(64,3,activation='sigmoid',padding='same',input_shape=(height,width,3),kernel_initializer='he_uniform'))
    model.add(BatchNormalization())

    model.add(Conv2D(64,3,activation='sigmoid',padding='same',kernel_initializer='he_uniform'))
    model.add(BatchNormalization())
    model.add(MaxPooling2D())

    model.add(Conv2D(128,3,activation='sigmoid',padding='same',kernel_initializer='he_uniform'))
    model.add(BatchNormalization())

    model.add(Conv2D(128,3,activation='sigmoid',padding='same',kernel_initializer='he_uniform'))
    model.add(BatchNormalization())
    model.add(MaxPooling2D())

    model.add(Flatten())
    model.add(Dense(128,activation='sigmoid',kernel_initializer='he_uniform'))
    model.add(Dense(classes,activation='softmax'))
    model.summary()
    model.compile(optimizer="rmsprop", 
              loss='categorical_crossentropy', 
              metrics =['accuracy'])
    
    return model


def simpleModel2(height,width):
    input_shape=(height,width,3)
    #accuracy=57% val accuracy=43%
    model = keras.Sequential(
        [
            keras.Input(shape=input_shape),
            layers.Conv2D(32, kernel_size=(3, 3), activation="relu"),
            layers.MaxPooling2D(pool_size=(2, 2)),
            layers.Conv2D(64, kernel_size=(3, 3), activation="relu"),
            layers.MaxPooling2D(pool_size=(2, 2)),
            layers.Flatten(),
            layers.Dropout(0.5),
            layers.Dense(144, activation="softmax"),
            
        ]
    )
    
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
                                    rotation_range=30,
                                    zoom_range=0.2,
                                    horizontal_flip=True,
                                    width_shift_range=0.1,  
                                    height_shift_range=0.1, 
                                    fill_mode="nearest",
                                    vertical_flip=False  )
    
    val_data = ImageDataGenerator(rescale=1./255 )
    
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
    model=simplemodel1(img_height,img_width,144)
    
    #fit model
    history = model.fit(train_gen,
                                epochs=20,
                                verbose=1,
                                validation_data=val_gen,
                                
                                )

    print("Evaluate")
    #model.evaluate(test_gen,verbose=2)
    model.save("rockModel.h5")
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


