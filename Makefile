run:
	docker build -t gobuilder .
	docker run -it -v $(PROJECT):/subject -v /tmp/test/:/test/ gobuilder /bin/sh
push:
	docker build -t adrianbrad/gobuilder:0.0.1 -t adrianbrad/gobuilder:latest .
	docker push adrianbrad/gobuilder