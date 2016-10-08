CURDIR := $(shell pwd)
path_to_add := $(addsuffix /bin,$(subst :,/bin:,$(CURDIR)/vendor:$(GOPATH)))
export PATH := $(path_to_add):$(PATH)

GO        := GO15VENDOREXPERIMENT="1" go

.PHONY: build importer syncer checker test check deps

build: importer syncer checker check test

importer:
	$(GO) build -o bin/importer ./importer

syncer:
	$(GO) build -o bin/syncer ./syncer

checker:
	$(GO) build -o bin/checker ./checker

test:

check:
	$(GO) get github.com/golang/lint/golint

	$(GO) tool vet . 2>&1 | grep -vE 'vendor' | awk '{print} END{if(NR>0) {exit 1}}'
	$(GO) tool vet --shadow . 2>&1 | grep -vE 'vendor' | awk '{print} END{if(NR>0) {exit 1}}'
	golint ./... 2>&1 | grep -vE 'vendor' | awk '{print} END{if(NR>0) {exit 1}}'
	gofmt -s -l . 2>&1 | grep -vE 'vendor' | awk '{print} END{if(NR>0) {exit 1}}'
	
deps:
	$(GO) list -f '{{range .Deps}}{{printf "%s\n" .}}{{end}}{{range .TestImports}}{{printf "%s\n" .}}{{end}}' ./... | \
		sort | uniq | grep -E '[^/]+\.[^/]+/' | \
		awk 'BEGIN{print "#!/bin/bash"}{ printf("go get -u %s\n", $$1) }' > deps.sh
	chmod +x deps.sh
