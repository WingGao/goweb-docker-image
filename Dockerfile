FROM ubuntu:xenial
WORKDIR /app
COPY entry/* /tmp/
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

# 安装Elasticsearch
ENV DEBIAN_FRONTEND noninteractive
RUN { \
	apt install -y software-properties-common vim apt-transport-https; \
	add-apt-repository -y ppa:linuxuprising/java; \
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -; \
	echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list; \
	apt-get update; \
	echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
	echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections; \
}
RUN apt install -y oracle-java10-installer elasticsearch
# 中文分词ik插件
RUN { \
	/usr/share/elasticsearch/bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.3.0/elasticsearch-analysis-ik-6.3.0.zip; \
}
RUN cp -f /tmp/elasticsearch.yml /etc/elasticsearch
# RUN service elasticsearch stop

ENV DEBIAN_FRONTEND=

VOLUME /app
VOLUME /temp
VOLUME /wdata

CMD ["./run.sh"]

# docker build -t wingao/goweb:latest .
