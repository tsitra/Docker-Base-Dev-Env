# Ought to be some Debian distribution
FROM golang:bookworm

# Rest of this should be boilerplate
ENV RUNNING_IN_DOCKER true

RUN apt-get update -y && apt-get upgrade -y
RUN useradd -ms /bin/zsh tsitra
RUN echo "ALL   ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /app \
    && chown -R tsitra:tsitra /app
# Set up ZSH and our preferred terminal environment for containers
RUN apt-get install -y zsh curl git
RUN mkdir -p /home/tsitra/.antigen
RUN curl -L git.io/antigen > /home/tsitra/.antigen/antigen.zsh
# Use my starter Docker ZSH config file for this, or your own ZSH configuration file (https://gist.github.com/arctic-hen7/bbfcc3021f7592d2013ee70470fee60b)
COPY .zshrc /home/tsitra/.zshrc

RUN chown -R tsitra:tsitra /home/tsitra/.antigen /home/tsitra/.zshrc
# Set up ZSH as the unprivileged user (we just need to start it, it'll initialise our setup itself)
USER tsitra
RUN /usr/bin/zsh /home/tsitra/.zshrc

ENTRYPOINT [ "/bin/zsh" ]
