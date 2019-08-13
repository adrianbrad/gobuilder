run:
	docker build -t gobuilder .
	docker run -it -v $(PROJECT):/subject -v /tmp/test/:/test/ gobuilder