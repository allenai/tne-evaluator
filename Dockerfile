# Evaluator for Break dataset on beaker

FROM allennlp/allennlp:v2.5.0-cuda10.1

ENV PYTHONPATH .

# set the working directory

WORKDIR /tne-evaluator


# add in the readme and evaluation scripts

ADD README.md .
COPY evaluate.py .
COPY mcf1_measure.py .

RUN mkdir results
RUN mkdir input


# define the default command
# in this case a linux shell where we can run the eval script
#CMD ["/bin/bash"]
ENTRYPOINT [ "/bin/bash" ]
