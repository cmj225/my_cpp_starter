# Base image Ubuntu 20.04
FROM ubuntu:20.04

# Update Package
RUN apt update
RUN apt upgrade

# Install Git
RUN apt install git -y

# Some Working Environment Setting

# Clone Project Repository
WORKDIR /Users
RUN sudo git clone https://github.com/cmj225/MediaMagic 
WORKDIR /Users/MediaMagic

# Build Project
RUN cmake . -B build
RUN cmake --build build
