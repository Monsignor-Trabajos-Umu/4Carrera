from keras.models import Sequential
from keras.layers import Dense, Conv2D, MaxPool2D, Dropout, Flatten
import os
from .matcher import MatCher
import numpy as np


class ConvMatcher(MatCher):
    def __init__(self, recalculate=False):
        # Carga mnist y xl, yl, xt, yt
        super().__init__()
        # Inicializamos keras

        os.environ['TF_FORCE_GPU_ALLOW_GROWTH'] = 'true'
        model = Sequential()
        model.add(Conv2D(input_shape=(28, 28, 1), filters=32, kernel_size=(5, 5), strides=1,
                         padding='same', use_bias=True, activation='relu'))
        model.add(MaxPool2D(pool_size=(2, 2)))
        model.add(Conv2D(filters=64, kernel_size=(5, 5), strides=1,
                         padding='same', use_bias=True, activation='relu'))
        model.add(MaxPool2D(pool_size=(2, 2)))
        model.add(Flatten())
        model.add(Dense(1024, activation='relu'))
        model.add(Dropout(rate=0.5))
        model.add(Dense(10, activation='softmax'))

        model.compile(loss='categorical_crossentropy',
                      optimizer='sgd',
                      metrics=['accuracy'])
        if recalculate:
            model.fit(self.xl.reshape(-1, 28, 28, 1), self.yl, epochs=50, batch_size=500)
            model.save('data/digits.keras')
        else:
            # wget https://robot.inf.um.es/material/va/digits.keras
            model.load_weights('data/digits.keras')

        self.model = model

    def predict(self):
        return self.model.predict_classes(np.array(self.ok).reshape(-1, 28, 28, 1))
