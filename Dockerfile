FROM centos:centos7
MAINTAINER rawait

#设置entrypoint和letsencrypt映射到www文件夹下持久化
COPY entrypoint.sh /entrypoint.sh
COPY btdefault.py /btdefault.py

RUN mkdir -p /www/letsencrypt \
    && ln -s /www/letsencrypt /etc/letsencrypt \
    && rm -f /etc/init.d \
    && mkdir /www/init.d \
    && ln -s /www/init.d /etc/init.d \
    && chmod +x /entrypoint.sh \
    && mkdir /www/wwwroot
    
#更新系统 安装依赖 安装宝塔面板
RUN cd /home \
    && yum -y install wget openssh-server \
    && echo 'Port 63322' > /etc/ssh/sshd_config \
    && wget -O install.sh http://download.bt.cn/install/install_6.0.sh \
    && echo y | bash install.sh \
    && python /btdefault.py \
    && echo '["linuxsys", "webssh"]' > /www/server/panel/config/index.json \
    && yum -y update \
    && yum clean all

WORKDIR /www/wwwroot
CMD /entrypoint.sh
EXPOSE 80 443 63322 8888 888

HEALTHCHECK --interval=5s --timeout=3s CMD curl -fs http://localhost:8888/ && curl -fs http://localhost/ || exit 1