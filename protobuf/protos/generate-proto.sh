#!/bin/bash

protoc --swift_out=. Example.proto
mv Example.pb.swift ../Protobuf