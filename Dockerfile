FROM ubuntu:xenial
WORKDIR /app
COPY entry/google_linux_signing_key.pub /tmp
RUN apt-key add /tmp/google_linux_signing_key.pub
# sourse
RUN { \
		echo 'deb http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse'; \
		echo 'deb http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse'; \
		echo 'deb-src http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse'; \
		echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'; \
	} > /etc/apt/sources.list

RUN set -ex; \
    apt-get update; \
    apt-get install -y apt-utils; \
    apt-get install -y ca-certificates; \
    apt-get install -y libvips; \
    apt-get install -y libvips-tools;

RUN set -ex; \
    apt-get install -y google-chrome-stable;

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN set -ex; \
    apt-get install -y tzdata;
RUN dpkg-reconfigure -f noninteractive tzdata

VOLUME /app
VOLUME /temp

CMD ["./run.sh"]

# docker build -t wingao/goweb:latest .
