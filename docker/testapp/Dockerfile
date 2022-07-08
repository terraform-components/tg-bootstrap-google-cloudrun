FROM google/cloud-sdk:alpine
RUN apk --no-cache --upgrade add postgresql14-client bash
WORKDIR /opt
ADD test.sh /opt/
RUN chmod +x test.sh

RUN wget https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 -O cloud_sql_proxy
RUN chmod +x cloud_sql_proxy

CMD [ "./test.sh" ]