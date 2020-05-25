FROM rawait/btserver
MAINTAINER rawait

RUN bash /www/server/panel/install/install_soft.sh 0 install apache 2.4
RUN bash /www/server/panel/install/install_soft.sh 0 install mysql 5.6
RUN bash /www/server/panel/install/install_soft.sh 0 install php 7.3 || echo 'Ignore Error'
RUN bash /www/server/panel/install/install_soft.sh 0 install php 5.6 || echo 'Ignore Error'
RUN bash /www/server/panel/install/install_soft.sh 0 install phpmyadmin 4.9 || echo 'Ignore Error'
RUN echo '["linuxsys", "webssh", "apache", "mysql", "php-7.3", "php-5.6", "phpmyadmin"]' > /www/server/panel/config/index.json

VOLUME ["/www", "/www/wwwroot"]