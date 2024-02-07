FROM python:3.9
RUN pip install mkdocs-material mkdocs-git-revision-date-localized-plugin
WORKDIR /docs
COPY . /docs
EXPOSE 8080
CMD [ "mkdocs", "serve", "--dev-addr=0.0.0.0:8080" ]