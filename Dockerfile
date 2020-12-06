FROM amazonlinux

RUN yum install -y curl unzip jq less

RUN curl "https://d1vvhvl2y92vvt.cloudfront.net/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN amazon-linux-extras install docker


# RUN bash -c 'echo complete -C '/usr/bin/aws_completer' aws  >> $HOME/.bashrc'
# ENV PS1="awscliv2> "

WORKDIR /root