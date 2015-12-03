#!/bin/bash
#set -e

sudo apt-get update -y
# packages necessary for riak and erlang
sudo apt-get install git build-essential ncurses-dev libssl-dev openjdk-6-jdk xsltproc fop libxml2-utils libpam-dev autoconf -y

# install OTP/erlang 17 from source
erl_bin=`which erl`
if [ -z "$erl_bin" ]; then
    git clone https://github.com/erlang/otp.git
    working_dir=`pwd`
    erlang_dir=$working_dir"/otp"
    mkdir -p $erlang_dir
    pushd otp/
    git checkout maint-17
    ./otp_build autoconf
    ./configure --prefix=$erlang_dir
    sudo make
    sudo make install
    PATH=$PATH:$erlang_dir"/bin"
    popd
fi

# install latest riak from source
riak_bin=`which riak`
if [ -z "$riak_bin" ]; then
    git clone git://github.com/basho/riak.git
    pushd riak
    make locked-deps
    make rel
    popd
    riak_dir=$working_dir"/riak/rel/riak/bin/"
    PATH=$PATH:$riak_dir
fi
#riak start
#riak ping
#riak-admin test

# now you have erlc and riak binaries in your path, ready to use