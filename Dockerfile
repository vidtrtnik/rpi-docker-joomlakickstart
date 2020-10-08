FROM ubuntu:latest

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update 
RUN apt-get install -y unzip wget curl apache2 php7.4 php7.4-pgsql php7.4-mysql php7.4-xml php7.4-zip

RUN mkdir akeeba_kickstart
WORKDIR /akeeba_kickstart
RUN latest_version=$(curl https://www.akeeba.com/download/official/akeeba-kickstart.html | grep '/download/official/akeeba-kickstart/' | grep -oP '(?<=kickstart/).*?(?=.html)' | head -n 1) \
 && echo "Latest version: $latest_version" \
 && wget -O kickstart-core.zip https://www.akeeba.com/download/akeeba-kickstart/$latest_version/kickstart-core-$latest_version-zip.zip

RUN unzip kickstart-core.zip -d /var/www/html

RUN mkdir /var/www/html/archives
RUN chmod 0755 /var/www/html/archives && chown www-data:www-data /var/www/html/archives

RUN chmod 0755 /var/www/html && chown www-data:www-data /var/www/html
WORKDIR /var/www/html

EXPOSE 80
CMD ["apachectl", "-D", "FOREGROUND"]
