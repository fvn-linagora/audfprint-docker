FROM alpine:3

WORKDIR /usr/src

ENV LLVM_CONFIG /usr/bin/llvm-config

RUN apk add --no-cache python python-dev lapack-dev libpng-dev freetype-dev \
        libstdc++ llvm-dev libffi-dev ffmpeg && \
    python -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    ln -s locale.h /usr/include/xlocale.h  && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        gfortran alpine-sdk

RUN pip install --upgrade pip setuptools && \
    pip install psutil && \
    pip install numpy && \
    pip install scipy && \
    pip install matplotlib && \
    pip install --upgrade distribute && \
    pip install docopt && \
    # pip install git+git://github.com/librosa/librosa.git && \
    pip install librosa

RUN curl http://www.mega-nerd.com/SRC/libsamplerate-0.1.9.tar.gz --output - | tar xvz && \
    cd libsamplerate-0.1.9 && ./configure && make && make install && \
    pip install scikits.samplerate

RUN git clone https://github.com/dpwe/audfprint.git

RUN rm -fr audfprint/.git && rm -f libsamplerate-0.1.9.tar.gz && rm -fr libsamplerate-0.1.9 66 \
    rm -r /root/.cache && apk del .build-dependencies && rm -rf /var/cache/apk/*

ENTRYPOINT ["python", "audfprint/audfprint.py"]
CMD ["--help"]
