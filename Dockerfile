FROM crystallang/crystal:0.21.0
EXPOSE 3000
ADD shard.yml /opt/murder/
ADD lib /opt/murder/lib
ADD src /opt/murder/src
ADD run.sh /opt/murder/
CMD ["/bin/bash", "/opt/murder/run.sh"]