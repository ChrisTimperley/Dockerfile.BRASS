#!/usr/bin/make -f
build-base:
	docker build -t brass:base .

build-cp1: build-base
	docker build -t brass:cp1 cp1

.PHONY: build-base build-cp1
