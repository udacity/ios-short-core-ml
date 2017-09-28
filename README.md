# Core ML Mini-Course

Resources for Udacity's Core ML mini-course. This repository contains the iOS image classification app (SmartGroceryList) in various formats including its integration with and without Vision framework. A custom Core ML model is also included.

## Convert-food101-model

Converting the Food 101 custom machine learning model to .mlmodel format utilizes several Python tools that have been  packaged into a Docker image. To run the docker image:

```bash
$ cd Convert-food101-model
$ docker build -t convert-coreml .
$ docker run --rm -it -p 8888:8888 -v "$(pwd)/notebook:/workspace/notebook" convert-coreml
```

If you don't have Docker installed, you can find instructions on installing [here](https://docs.docker.com/docker-for-mac/install/).
