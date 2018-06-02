PROGRAM = nvidia-docker

build:
	$(PROGRAM) build -t srgan .

run:
	$(PROGRAM) run -it --device /dev/dri -e DISPLAY=$$DISPLAY -e QT_X11_NO_MITSHM=1 -v /home/kusano/.Xauthority:/home/kusano/.Xauthority:rw -v /tmp/.X11-unix:/tmp/.X11-unix:rw srgan:latest /bin/bash
clean:
	$(PROGRAM) rm `$(PROGRAM) ps -aq`
