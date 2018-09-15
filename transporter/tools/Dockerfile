FROM alpine:3.7

MAINTAINER aolei <ca_lei@live.cn>

RUN mkdir -p /app

WORKDIR /app

COPY . /app

# 安装bash 、bash文档、bash自动补全、安装curl、获取sh文件的执行权限
RUN apk update \
&& apk upgrade \
&& apk add bash \
&& apk add bash-doc \
&& apk add bash-completion \
&& apk add curl \
&& chmod a+x /app/startup.sh \

# 下载Tranposter 、需要放到/usr/local/bin/ 否则报错：transporter command no found 、获取transporter的执行权限
ENV TRANSPORTER_VERSION 0.5.2
ENV TRANSPORTER_TAG v${TRANSPORTER_VERSION}
RUN curl --verbose -SLO "https://github.com/compose/transporter/releases/download/${TRANSPORTER_TAG}/transporter-${TRANSPORTER_VERSION}-linux-amd64" \
&& mv transporter-${TRANSPORTER_VERSION}-linux-amd64 /usr/local/bin/transporter \
&& chmod +x /usr/local/bin/transporter

# /bin/bash以shell的方式来运行启动命令
ENTRYPOINT ["/bin/bash", "-c", "/app/startup.sh"]
