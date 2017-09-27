# ios-short-core-ml
iOS image classification app using Core ML and MobileNet

## Convert-food101-model

Converting the Food 101 custom machine learning model to .mlmodel format utilizes several Python tools that have been  packaged into a Docker image. To run the docker image:

1. `cd Convert-food101-model`
2. `docker build -t convert-coreml .`
3. `docker run --rm -it -p 8888:8888 -v "$(pwd)/notebook:/workspace/" convert-coreml`

If you don't have Docker installed, you can find instructions on installing [here](https://docs.docker.com/docker-for-mac/install/)
