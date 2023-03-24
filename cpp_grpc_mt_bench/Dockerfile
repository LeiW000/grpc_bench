FROM gcc:12.2.0

RUN apt-get update && apt-get install -y build-essential autoconf libtool pkg-config libsystemd-dev cmake

WORKDIR /app
COPY cpp_grpc_mt_bench /app
COPY proto /app/proto

RUN git clone --recurse-submodules -b v1.52.1 --depth 1 --shallow-submodules https://github.com/grpc/grpc && \
    patch -d grpc -p1<server.cc.patch && \
    mkdir grpc/cmake/build && \
    cd grpc/cmake/build && \
    cmake -DBUILD_SHARED_LIBS=ON -DgRPC_INSTALL=ON -DgRPC_BUILD_TESTS=OFF ../.. && \
    make -j 4 && \
    make install

RUN mkdir gen && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib && \
    protoc --proto_path=/app/proto/helloworld --cpp_out=gen helloworld.proto && \
    protoc --proto_path=/app/proto/helloworld --grpc_out=gen --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` helloworld.proto

RUN g++ --std=c++20 -O3 -flto main.cpp gen/helloworld.grpc.pb.cc gen/helloworld.pb.cc -Igen `pkg-config --libs grpc++` -lprotobuf -lpthread

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"

ENTRYPOINT /app/a.out
