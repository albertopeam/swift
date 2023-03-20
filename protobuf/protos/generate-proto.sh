#!/bin/bash

protoc --swift_out=. BookInfo.proto
mv BookInfo.pb.swift ../Protobuf