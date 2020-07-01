FROM docker.elastic.co/elasticsearch/elasticsearch:6.1.1

WORKDIR /usr/share/elasticsearch
ENV JAVA_TOOL_OPTIONS="-Dfile.encoding=UTF8"
RUN yum update -y && yum install -y gcc-c++ make java-1.8.0-openjdk-devel

COPY compose/es/mecab/mecab-0.996-ko-0.9.2.tar.gz ./
COPY compose/es/mecab/mecab-ko-dic-2.1.1-20180720.tar.gz ./
COPY compose/es/mecab/mecab-java-0.996.tar.gz ./
COPY compose/es/seunjeon/elasticsearch-analysis-seunjeon-6.1.1.1.zip ./

RUN tar zxfv mecab-0.996-ko-0.9.2.tar.gz
RUN tar zxfv mecab-ko-dic-2.1.1-20180720.tar.gz
RUN tar zxfv mecab-java-0.996.tar.gz

COPY compose/es/mecab/Makefile ./mecab-java-0.996/

RUN if [ ! -d ./plugins/analysis-smartcn ]; then ./bin/elasticsearch-plugin install analysis-smartcn ; fi

RUN cd mecab-0.996-ko-0.9.2 && ./configure && make && make check && make install && cd ..
RUN cd mecab-ko-dic-2.1.1-20180720 && ./configure && make && make install && cd ..
RUN cd mecab-java-0.996 && make && cp -f libMeCab.so /usr/local/lib && cp -f MeCab.jar /usr/local/lib && cd ..

RUN if [ ! -d ./plugins/analysis-seunjeon ]; then ./bin/elasticsearch-plugin install file:///usr/share/elasticsearch/elasticsearch-analysis-seunjeon-6.1.1.1.zip ; fi
