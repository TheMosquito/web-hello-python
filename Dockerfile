FROM python:3.7-slim

# Grab Flask, the most extremely awesome Python module ever!
RUN pip install  --trusted-host=pypi.python.org --trusted-host=pypi.org --trusted-host=files.pythonhosted.org Flask

# Dev tools (can be removed for production)
# RUN apt update && apt install -y vim curl jq

# Copy in the source file
COPY ./web-hello.py /

WORKDIR /
CMD python3 web-hello.py


