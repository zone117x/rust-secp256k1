FROM ubuntu:bionic as build

WORKDIR /build

RUN apt-get update
RUN apt-get install -y build-essential git curl pkg-config libssl-dev
RUN apt-get install -y clang-9

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=$PATH:/root/.cargo/bin

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN nodejs --version
RUN cargo --version

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/clang-9 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-9 100
RUN cc -v

RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
# RUN cargo install --verbose --force wasm-pack

RUN git init && \
    git remote add origin https://github.com/rust-bitcoin/rust-secp256k1.git && \
    git fetch origin d31dcf20b0db4768f5ca5345ec4508434eac0b02 --depth=1 && \
    git reset --hard FETCH_HEAD

RUN rustup target add wasm32-unknown-unknown

RUN printf '\n[lib]\ncrate-type = ["cdylib", "rlib"]\n' >> Cargo.toml
RUN CC=clang-9 wasm-pack build --out-dir /out \
    # --target nodejs \
    --target bundler \
    --out-name secp256k1-wasm
# RUN CC=clang-9 wasm-pack build
# RUN wasm-pack test --node

RUN ls -lh -R /out
# RUN mkdir /out && cp -R out/. /out

FROM scratch AS export-stage
COPY --from=build /out/ /
# COPY --from=build /out/libsecp256k1.so /
# COPY --from=build /out/secp256k1.html /out/secp256k1.js /out/secp256k1.wasm /
