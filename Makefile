#!/usr/bin/make -f
.PHONY: build-base build-cp1

default: build-base build-cp1 build-invariants

build-base:
	docker build -t brass:base .

build-cp1: build-base
	docker build -t brass:cp1 cp1

build-invariants: build-base
	docker build -t brass:invariants invariants
