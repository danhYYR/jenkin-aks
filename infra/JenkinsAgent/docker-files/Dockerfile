FROM ubuntu:22.04

COPY ./scripts/setup.sh ./

# Change permissions of setup.sh to make it executable
RUN chmod +x setup.sh

# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

RUN ["./setup.sh"]
