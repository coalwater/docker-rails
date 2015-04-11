FROM debian:jessie
RUN echo 'Updating and upgrading the system'
RUN apt update
RUN apt upgrade -y

RUN echo 'Installing build essentials'
RUN apt install build-essential

RUN echo 'Installing curl and wget'
RUN apt install -y curl wget

RUN echo 'installing fish shell'
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/2/Debian_7.0/ /' >> /etc/apt/sources.list.d/fish.list
curl -Ls http://download.opensuse.org/repositories/shells:fish:release:2/Debian_7.0/Release.key | apt-key add -
RUN apt update
RUN apt install -y fish
RUN chsh -s /usr/bin/fish

RUN echo 'installing ruby install'
curl -Ls https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz | tar -xz -C /tmp
make -C /tmp/ruby-install-0.5.0/ install

RUN echo 'installing chruby'
curl -Ls https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz | tar -xz -C /tmp
make -C /tmp/chruby-0.3.9/ install

RUN echo 'installing chruby fish'
curl -Ls https://github.com/JeanMertz/chruby-fish/archive/v0.6.0.tar.gz | tar -xz -C /tmp
make -C /tmp/chruby-fish-0.6.0/ install
RUN echo 'source /usr/local/share/chruby/chruby.fish' >> /etc/fish/config.fish
RUN echo 'source /usr/local/share/chruby/auto.fish' >> /etc/fish/config.fish

RUN echo 'Creating dev user'
RUN useradd -m -p dev -s /usr/bin/fish dev

RUN echo 'Installing ruby dependencies'
RUN apt install zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev

RUN echo 'Installing ruby 2.2.1 under dev user'
RUN su -l dev -c 'ruby-install ruby 2.2.1 --no-install-deps'
RUN sc -l dev -c "echo '2.2.1' > ~/.ruby-version"

# install pg lib
RUN apt install -y libpq-dev

